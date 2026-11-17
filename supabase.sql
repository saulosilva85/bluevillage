-- =====================================================================
--  Blue Village Residence — estrutura do banco no Supabase
--  Cole TODO este arquivo em: Supabase > SQL Editor > New query > Run
--  Pode ser executado mais de uma vez sem problema.
-- =====================================================================

create extension if not exists pgcrypto with schema extensions;

-- ---------- Tabelas ----------
create table if not exists public.perfis (
  id        uuid primary key references auth.users(id) on delete cascade,
  usuario   text not null unique,
  nome      text not null,
  perfil    text not null default 'Operador',
  ativo     boolean not null default true,
  criado_em timestamptz not null default now()
);

create table if not exists public.lanc (
  id        text primary key,
  data      date not null,
  tipo      text not null,
  categoria text,
  torre     text default '',
  descricao text,
  valor     numeric(14,2) not null default 0,
  criado_em timestamptz not null default now()
);

create table if not exists public.manut (
  id         text primary key,
  data       date not null,
  torre      text,
  tipo       text,
  prioridade text,
  titulo     text not null,
  resp       text default '',
  custo      numeric(14,2) not null default 0,
  status     text not null default 'Aberta',
  criado_em  timestamptz not null default now()
);

create table if not exists public.forn (
  id        text primary key,
  nome      text not null,
  doc       text default '',
  servico   text,
  contato   text default '',
  inicio    date,
  fim       date,
  valor     numeric(14,2) not null default 0,
  status    text not null default 'Ativo',
  criado_em timestamptz not null default now()
);

create table if not exists public.config (
  id      text primary key default 'main',
  salario numeric(14,2) not null default 1518,
  mult    numeric(6,2)  not null default 5
);
insert into public.config (id) values ('main') on conflict (id) do nothing;

create table if not exists public.logs (
  id      bigint generated always as identity primary key,
  ts      timestamptz not null default now(),
  usuario text,
  acao    text
);
create index if not exists logs_ts_idx on public.logs (ts desc);

-- ---------- Funções de permissão ----------
create or replace function public.eh_ativo() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis where id = auth.uid() and ativo);
$$;

create or replace function public.eh_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis where id = auth.uid() and ativo and perfil = 'Administrador');
$$;

-- ---------- Segurança por linha (RLS) ----------
alter table public.perfis enable row level security;
alter table public.lanc   enable row level security;
alter table public.manut  enable row level security;
alter table public.forn   enable row level security;
alter table public.config enable row level security;
alter table public.logs   enable row level security;

drop policy if exists ativos on public.lanc;
drop policy if exists ativos on public.manut;
drop policy if exists ativos on public.forn;
drop policy if exists ativos on public.config;
create policy ativos on public.lanc   for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());
create policy ativos on public.manut  for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());
create policy ativos on public.forn   for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());
create policy ativos on public.config for all to authenticated using (public.eh_ativo()) with check (public.eh_ativo());

drop policy if exists logs_ler on public.logs;
drop policy if exists logs_criar on public.logs;
drop policy if exists logs_apagar on public.logs;
create policy logs_ler    on public.logs for select to authenticated using (public.eh_ativo());
create policy logs_criar  on public.logs for insert to authenticated with check (public.eh_ativo());
create policy logs_apagar on public.logs for delete to authenticated using (public.eh_admin());

drop policy if exists perfis_ler on public.perfis;
drop policy if exists perfis_criar on public.perfis;
drop policy if exists perfis_alterar on public.perfis;
drop policy if exists perfis_apagar on public.perfis;
create policy perfis_ler     on public.perfis for select to authenticated using (public.eh_ativo() or id = auth.uid());
create policy perfis_criar   on public.perfis for insert to authenticated with check (public.eh_admin());
create policy perfis_alterar on public.perfis for update to authenticated using (public.eh_admin()) with check (public.eh_admin());
create policy perfis_apagar  on public.perfis for delete to authenticated using (public.eh_admin());

-- ---------- Funções chamadas pelo sistema ----------
-- Indica se ainda não existe nenhum usuário (primeiro acesso)
create or replace function public.precisa_bootstrap() returns boolean
language sql stable security definer set search_path = public as $$
  select not exists (select 1 from public.perfis);
$$;

-- Primeiro acesso: transforma a conta admin@bluevillage.app no Administrador
create or replace function public.bootstrap_admin() returns void
language plpgsql security definer set search_path = public as $$
begin
  if exists (select 1 from public.perfis) then raise exception 'Sistema já inicializado'; end if;
  if auth.uid() is null or (select email from auth.users where id = auth.uid()) <> 'admin@bluevillage.app' then
    raise exception 'Não autorizado';
  end if;
  insert into public.perfis (id, usuario, nome, perfil, ativo) values (auth.uid(), 'admin', 'Admin', 'Administrador', true);
end $$;

-- Administrador redefine a senha de outro usuário
create or replace function public.admin_definir_senha(alvo uuid, nova text) returns void
language plpgsql security definer set search_path = public, extensions as $$
begin
  if not public.eh_admin() then raise exception 'Não autorizado'; end if;
  if length(coalesce(nova, '')) < 6 then raise exception 'Senha muito curta'; end if;
  update auth.users set encrypted_password = extensions.crypt(nova, extensions.gen_salt('bf')), updated_at = now() where id = alvo;
end $$;

-- Administrador exclui um usuário (login + perfil)
create or replace function public.admin_excluir_usuario(alvo uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.eh_admin() then raise exception 'Não autorizado'; end if;
  if alvo = auth.uid() then raise exception 'Não é possível excluir o próprio usuário'; end if;
  delete from auth.users where id = alvo;
end $$;

-- Remove um login que ficou sem perfil (ex.: cadastro interrompido)
create or replace function public.admin_remover_orfao(email_alvo text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.eh_admin() then raise exception 'Não autorizado'; end if;
  delete from auth.users u where u.email = lower(email_alvo)
    and not exists (select 1 from public.perfis p where p.id = u.id);
end $$;

revoke execute on function public.bootstrap_admin()                  from public, anon;
revoke execute on function public.admin_definir_senha(uuid, text)    from public, anon;
revoke execute on function public.admin_excluir_usuario(uuid)        from public, anon;
revoke execute on function public.admin_remover_orfao(text)          from public, anon;
grant  execute on function public.precisa_bootstrap()                to anon, authenticated;
grant  execute on function public.bootstrap_admin()                  to authenticated;
grant  execute on function public.admin_definir_senha(uuid, text)    to authenticated;
grant  execute on function public.admin_excluir_usuario(uuid)        to authenticated;
grant  execute on function public.admin_remover_orfao(text)          to authenticated;

-- ---------- Manutenção concluída não pode mudar de status ----------
create or replace function public.bv_travar_concluida() returns trigger
language plpgsql as $$
begin
  if old.status = 'Concluída' and new.status is distinct from old.status then
    raise exception 'Registro concluído: o status não pode mais ser alterado';
  end if;
  return new;
end $$;
drop trigger if exists bv_travar_concluida on public.manut;
create trigger bv_travar_concluida before update on public.manut
  for each row execute function public.bv_travar_concluida();

-- ---------- Manutenção concluída não pode ser excluída ----------
-- (exceto pela opção "Zerar banco" do Administrador)
create or replace function public.bv_proteger_concluida() returns trigger
language plpgsql as $$
begin
  if old.status = 'Concluída' and coalesce(current_setting('bv.zerar', true), '') <> 'sim' then
    raise exception 'Registro concluído não pode ser excluído';
  end if;
  return old;
end $$;
drop trigger if exists bv_proteger_concluida on public.manut;
create trigger bv_proteger_concluida before delete on public.manut
  for each row execute function public.bv_proteger_concluida();

-- Zerar banco (somente Administrador, confirmando a própria senha):
-- apaga lançamentos, manutenções, contratos, logs e todos os usuários, exceto o "admin" (que volta para a senha padrão)
drop function if exists public.admin_zerar_banco();
create or replace function public.admin_zerar_banco(senha text) returns void
language plpgsql security definer set search_path = public, extensions as $$
begin
  if not public.eh_admin() then raise exception 'Não autorizado'; end if;
  if not exists (select 1 from auth.users u where u.id = auth.uid()
                 and u.encrypted_password = extensions.crypt(coalesce(senha, ''), u.encrypted_password)) then
    raise exception 'Senha incorreta';
  end if;
  perform set_config('bv.zerar', 'sim', true);
  -- "where true" é exigido pela proteção do Supabase contra DELETE sem WHERE
  delete from public.lanc  where true;
  delete from public.manut where true;
  delete from public.forn  where true;
  delete from public.logs  where true;
  -- usuários: só o "admin" permanece, ativo e com a senha padrão
  delete from auth.users where email <> 'admin@bluevillage.app';
  update auth.users set encrypted_password = extensions.crypt('Blue@2027!', extensions.gen_salt('bf')), updated_at = now()
    where email = 'admin@bluevillage.app';
  update public.perfis set nome = 'Admin', perfil = 'Administrador', ativo = true where usuario = 'admin';
  insert into public.logs (usuario, acao) values ((select usuario from public.perfis where id = auth.uid()), 'Banco zerado');
end $$;
revoke execute on function public.admin_zerar_banco(text) from public, anon;
grant  execute on function public.admin_zerar_banco(text) to authenticated;

-- ---------- Confirmação automática dos logins internos ----------
-- Os logins do sistema usam e-mails internos (@bluevillage.app) que não recebem mensagens.
-- Esta regra marca esses logins como confirmados no momento em que são criados.
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
update auth.users set email_confirmed_at = now()
  where email like '%@bluevillage.app' and email_confirmed_at is null;

-- ---------- Tempo real (atualização automática entre aparelhos) ----------
do $$
declare t text;
begin
  foreach t in array array['perfis','lanc','manut','forn','config','logs'] loop
    if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;
