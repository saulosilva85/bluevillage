-- =====================================================================
--  Blue Village Residence — estrutura do banco no Supabase
--  Cole TODO este arquivo em: Supabase > SQL Editor > New query > Run
--  Pode ser executado mais de uma vez sem problema.
--  A senha inicial do admin NÃO fica neste arquivo (veja o README, passo 3.1).
-- =====================================================================

create extension if not exists pgcrypto with schema extensions;

-- ---------- Remove a estrutura da versão anterior do sistema ----------
drop table if exists public.lanc   cascade;
drop table if exists public.manut  cascade;
drop table if exists public.forn   cascade;
drop table if exists public.logs   cascade;
do $$ begin
  if exists (select 1 from information_schema.columns
             where table_schema = 'public' and table_name = 'perfis' and column_name = 'perfil') then
    drop table public.perfis cascade;
  end if;
end $$;
drop function if exists public.eh_admin() cascade;
drop function if exists public.bootstrap_admin() cascade;
drop function if exists public.admin_definir_senha(uuid, text) cascade;
drop function if exists public.admin_excluir_usuario(uuid) cascade;
drop function if exists public.admin_remover_orfao(text) cascade;
drop function if exists public.admin_zerar_banco() cascade;
drop function if exists public.admin_zerar_banco(text) cascade;
drop function if exists public.bv_travar_concluida() cascade;
drop function if exists public.bv_proteger_concluida() cascade;

-- ---------- Tabelas ----------
create table if not exists public.perfis (
  id        uuid primary key references auth.users(id) on delete cascade,
  usuario   text not null unique,
  nome      text not null,
  funcao    text not null default 'Administrativo',
  criado_em timestamptz not null default now()
);

create table if not exists public.transactions (
  id          bigint generated always as identity primary key,
  description text not null,
  category    text not null,
  type        text not null check (type in ('entrada', 'saida')),
  account     text not null default 'Conta Principal',
  amount      numeric(14,2) not null default 0,
  date        date not null,
  tower       text not null default 'Geral',
  created_by  text,
  created_at  timestamptz not null default now()
);

-- Conta de cada movimentação: Conta Principal, Fundo de Reserva ou Salão de Festa
alter table public.transactions add column if not exists account text not null default 'Conta Principal';

create table if not exists public.suppliers (
  id              bigint generated always as identity primary key,
  name            text not null,
  service         text not null,
  contact_name    text,
  contact_phone   text,
  contract_status text not null default 'Ativo',
  monthly_value   numeric(14,2) not null default 0,
  expiry_date     date,
  contract_link   text
);

create table if not exists public.maintenance (
  id         bigint generated always as identity primary key,
  tower      text not null,
  item       text not null,
  status     text not null default 'Pendente',
  priority   text not null default 'Média',
  due_date   date,
  notes      text,
  created_by text,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id        bigint generated always as identity primary key,
  action    text not null,
  details   text,
  timestamp timestamptz not null default now()
);
create index if not exists audit_logs_ts_idx on public.audit_logs (timestamp desc);

-- Parâmetros do sistema (salário mínimo usado no teto de gastos: 5x por mês)
create table if not exists public.config (
  id      text primary key default 'main',
  salario numeric(14,2) not null default 1518
);
-- Se existir a tabela config da versão antiga (sem a coluna salario), ela é recriada
do $$ begin
  if not exists (select 1 from information_schema.columns where table_schema='public' and table_name='config' and column_name='salario') then
    drop table public.config cascade;
    create table public.config (id text primary key default 'main', salario numeric(14,2) not null default 1518);
  end if;
end $$;
insert into public.config (id) values ('main') on conflict (id) do nothing;

-- Senha inicial do admin: guardada só como hash, numa tabela que o site não consegue ler
create table if not exists public.bv_privado (chave text primary key, valor text not null);
alter table public.bv_privado enable row level security;
revoke all on public.bv_privado from anon, authenticated;

-- ---------- Permissão: usuário logado e cadastrado ----------
create or replace function public.eh_ativo() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis where id = auth.uid());
$$;

-- ---------- Segurança por linha (RLS) ----------
alter table public.perfis       enable row level security;
alter table public.transactions enable row level security;
alter table public.suppliers    enable row level security;
alter table public.maintenance  enable row level security;
alter table public.audit_logs   enable row level security;
alter table public.config       enable row level security;

drop policy if exists ativos on public.transactions;
drop policy if exists ativos on public.suppliers;
drop policy if exists ativos on public.maintenance;
drop policy if exists ativos on public.config;
create policy ativos on public.config for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());
create policy ativos on public.transactions for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());
create policy ativos on public.suppliers    for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());
create policy ativos on public.maintenance  for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());

drop policy if exists logs_ler on public.audit_logs;
drop policy if exists logs_criar on public.audit_logs;
create policy logs_ler   on public.audit_logs for select to authenticated using (public.eh_ativo());
create policy logs_criar on public.audit_logs for insert to authenticated with check (public.eh_ativo());

drop policy if exists perfis_ler on public.perfis;
drop policy if exists perfis_criar on public.perfis;
drop policy if exists perfis_alterar on public.perfis;
drop policy if exists perfis_apagar on public.perfis;
create policy perfis_ler    on public.perfis for select to authenticated using (public.eh_ativo() or id = auth.uid());
create policy perfis_criar  on public.perfis for insert to authenticated with check (public.eh_ativo() and usuario <> 'admin');
create policy perfis_alterar on public.perfis for update to authenticated using (public.eh_ativo()) with check (public.eh_ativo());

-- ---------- Primeiro acesso do admin ----------
create or replace function public.precisa_bootstrap() returns boolean
language sql stable security definer set search_path = public as $$
  select not exists (select 1 from public.perfis);
$$;

create or replace function public.senha_inicial_hash() returns text
language plpgsql stable security definer set search_path = public as $$
declare h text;
begin
  select valor into h from public.bv_privado where chave = 'senha_inicial_admin';
  if h is null then raise exception 'Senha inicial não configurada'; end if;
  return h;
end $$;

create or replace function public.confere_senha_inicial(senha text) returns boolean
language plpgsql stable security definer set search_path = public, extensions as $$
declare h text;
begin
  if exists (select 1 from public.perfis) then return false; end if;
  h := public.senha_inicial_hash();
  return h = extensions.crypt(coalesce(senha, ''), h);
end $$;

drop function if exists public.bootstrap_admin(text);
create or replace function public.bootstrap_admin(senha text) returns void
language plpgsql security definer set search_path = public, extensions as $$
begin
  if exists (select 1 from public.perfis) then raise exception 'Sistema já inicializado'; end if;
  if not public.confere_senha_inicial(senha) then raise exception 'Não autorizado'; end if;
  if auth.uid() is null or (select email from auth.users where id = auth.uid()) <> 'admin@bluevillage.app' then
    raise exception 'Não autorizado';
  end if;
  insert into public.perfis (id, usuario, nome, funcao) values (auth.uid(), 'admin', 'Anthony Melo', 'Síndico');
end $$;

-- ---------- Usuários ----------
-- Exclui um usuário (login + perfil). O "admin" e o próprio usuário não podem ser excluídos.
create or replace function public.excluir_usuario(alvo uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.eh_ativo() then raise exception 'Não autorizado'; end if;
  if alvo = auth.uid() then raise exception 'Não é possível excluir o próprio usuário'; end if;
  if exists (select 1 from public.perfis where id = alvo and usuario = 'admin') then
    raise exception 'O usuário principal não pode ser excluído';
  end if;
  delete from auth.users where id = alvo;
end $$;

-- Remove um login que ficou sem perfil (ex.: cadastro interrompido)
create or replace function public.remover_login_orfao(email_alvo text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.eh_ativo() then raise exception 'Não autorizado'; end if;
  delete from auth.users u where u.email = lower(email_alvo)
    and not exists (select 1 from public.perfis p where p.id = u.id);
end $$;

-- Zerar o sistema: exige a senha do usuário "admin" (conferida aqui no banco).
-- Apaga todos os dados e usuários; só o "admin" permanece, com a senha inicial.
create or replace function public.zerar_sistema(senha text) returns void
language plpgsql security definer set search_path = public, extensions as $$
declare h text;
begin
  if not public.eh_ativo() then raise exception 'Não autorizado'; end if;
  select encrypted_password into h from auth.users where email = 'admin@bluevillage.app';
  if h is null or h <> extensions.crypt(coalesce(senha, ''), h) then raise exception 'Senha incorreta'; end if;
  truncate table public.transactions, public.suppliers, public.maintenance, public.audit_logs restart identity;
  delete from auth.users where email <> 'admin@bluevillage.app' and email like '%@bluevillage.app';
  -- encerra as sessões abertas (os aparelhos voltam para a tela de login)
  delete from auth.sessions where true;
  update auth.users set encrypted_password = public.senha_inicial_hash(), updated_at = now()
    where email = 'admin@bluevillage.app';
  update public.perfis set nome = 'Anthony Melo', funcao = 'Síndico' where usuario = 'admin';
  insert into public.audit_logs (action, details) values ('ZERAR_SISTEMA', 'Sistema zerado pelo administrador.');
end $$;
revoke execute on function public.zerar_sistema(text)          from public, anon;
grant  execute on function public.zerar_sistema(text)          to authenticated;

revoke execute on function public.senha_inicial_hash()          from public, anon, authenticated;
revoke execute on function public.bootstrap_admin(text)         from public, anon;
revoke execute on function public.excluir_usuario(uuid)         from public, anon;
revoke execute on function public.remover_login_orfao(text)     from public, anon;
grant  execute on function public.precisa_bootstrap()           to anon, authenticated;
grant  execute on function public.confere_senha_inicial(text)   to anon, authenticated;
grant  execute on function public.bootstrap_admin(text)         to authenticated;
grant  execute on function public.excluir_usuario(uuid)         to authenticated;
grant  execute on function public.remover_login_orfao(text)     to authenticated;

-- ---------- Chamado de manutenção concluído fica travado ----------
-- Não pode ser editado nem excluído. (O "Zerar sistema" usa TRUNCATE, que não passa por esta trava.)
create or replace function public.bv_travar_concluido() returns trigger
language plpgsql as $$
begin
  if old.status = 'Concluído' then
    if tg_op = 'DELETE' then raise exception 'Chamado concluído não pode ser excluído'; end if;
    raise exception 'Chamado concluído não pode ser editado';
  end if;
  if tg_op = 'DELETE' then return old; end if;
  return new;
end $$;
drop trigger if exists bv_travar_concluido on public.maintenance;
create trigger bv_travar_concluido before update or delete on public.maintenance
  for each row execute function public.bv_travar_concluido();

-- ---------- Confirmação automática dos logins internos ----------
create or replace function public.bv_autoconfirmar() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.email like '%@bluevillage.app' and new.email_confirmed_at is null then
    new.email_confirmed_at := now();
  end if;
  return new;
end $$;
drop trigger if exists bv_autoconfirmar on auth.users;
create trigger bv_autoconfirmar before insert on auth.users
  for each row execute function public.bv_autoconfirmar();

-- ---------- Tempo real (atualização automática entre aparelhos) ----------
do $$
declare t text;
begin
  foreach t in array array['perfis','transactions','suppliers','maintenance','audit_logs','config'] loop
    if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;
