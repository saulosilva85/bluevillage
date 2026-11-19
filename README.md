# Blue Village Residence — Gestão Inteligente

Plataforma web de gestão do condomínio **Blue Village Residence** (Torres **Jurerê**, **Gunga** e **Itacaré**).

O sistema é um único arquivo (`index.html`) publicado pelo **GitHub Pages**. Os dados ficam no **Supabase** (banco de dados online), então tudo que é feito no computador aparece no celular e vice-versa.

🔗 **Acesso:** https://saulosilva85.github.io/bluevillage/

---

## 🔐 Acesso

- O usuário principal é o `admin`. A **senha inicial** foi repassada à gestão e **não fica publicada** neste repositório nem no código do site: ela fica guardada no banco só como *hash* (veja o passo 3.1 da configuração).
- ⚠️ O link é público. **Troque a senha no primeiro acesso** em *Gestão de Usuários → Alterar Minha Senha*.
- O campo de senha tem o botão de **olho** (riscado: senha oculta; aberto: senha visível).
- O login aceita letras minúsculas, números, ponto, hífen e sublinhado. Digitar `Saulo` ou `saulo` dá no mesmo.

---

## 📋 Módulos

### Dashboard & Torres
- **Indicadores:** Conta Principal, Total de Despesas do Mês, Fundo de Reserva, Salão de Festa e Contratos Ativos.
- Cada conta mostra o próprio saldo (entradas − saídas), alimentado pelas movimentações do Financeiro.
- **Alerta de teto de gastos:** pelo regimento, o síndico pode gastar por mês até **5 salários mínimos**. O alerta considera as saídas da **Conta Principal** no mês atual.
- **Salário mínimo:** alterado no **Financeiro**, pelo link discreto ⚙ *Salário mínimo* no fim da tela. O valor fica salvo no banco e o teto (5x) do Dashboard é recalculado na hora, em todos os aparelhos. Essa informação não aparece no PDF. Fica verde, amarelo (a partir de 80%) ou vermelho (acima do teto).
- **Relatório por torre:** quantidade de chamados por torre. Clicando na torre, aparecem os chamados e os lançamentos financeiros dela.

### Financeiro
- Movimentações de **Entrada** e **Saída (Despesa)**, com descrição, categoria, **conta**, torre (ou Condomínio Geral), valor e data.
- **Torre / Setor:** Condomínio Geral, Torre Jurerê, Torre Gunga, Torre Itacaré, Salão de Festa, Academia, Campinho e Bicicletário.
- **Contas:** Conta Principal, Fundo de Reserva e Salão de Festa. Uma entrada soma e uma saída subtrai do card da conta escolhida no Dashboard.
- Clique na linha para ver os detalhes (quem lançou e quando). Botões para **editar** e **excluir**.

### Manutenção & Torres
- Locais: Torre Jurerê, Torre Gunga, Torre Itacaré, Salão de Festa, Academia, Campinho, Bicicletário e Condomínio Geral (também no filtro de locais).
- Chamados por torre com item/equipamento, prioridade (Baixa, Média, Alta), status (Pendente, Em Andamento, Concluído), previsão e observações.
- **Pesquisa** por item ou observação (botão *Pesquisar* ou tecla Enter) e filtros por torre e prioridade.
- Cartões com paginação (6 por página), detalhes, edição e exclusão.
- Ao salvar um chamado como **Concluído**, o sistema pede confirmação. Depois disso o status fica **verde com cadeado** e o chamado **não pode mais ser editado nem excluído** (a trava também está no banco). Só o *Zerar sistema* apaga chamados concluídos.

### Fornecedores & Contratos
- Empresa, categoria (lista ou categoria nova), responsável, telefone, valor mensal, vencimento e **link do contrato** (PDF/Drive).
- Filtro por categoria e edição.

### Gestão de Usuários
- Cadastro de usuários com função: Síndico, Subsíndico, Conselho Fiscal ou Administrativo.
- Exclusão de usuários. O `admin` (Principal) e o próprio usuário logado não podem ser excluídos.
- **Alterar Minha Senha** (pede a senha atual).

### Exportar PDF
- **Financeiro**, **Manutenção & Torres** e **Fornecedores & Contratos** têm o botão **Exportar PDF**.
- O PDF sai em A4 deitado, com título, resumo, tabela completa, número das páginas e data/hora/usuário que gerou.
  - **Financeiro:** todas as movimentações, o saldo de cada conta e o total de entradas e de saídas.
  - **Manutenção:** os chamados conforme a pesquisa e os filtros da tela, com o total por status.
  - **Fornecedores:** conforme a categoria filtrada, com o total mensal dos contratos.
- O PDF é gerado no próprio aparelho, sem serviço externo. No celular, é salvo em Downloads/Arquivos.

### Banco & Logs
- **Fazer backup do banco:** baixa um arquivo `.json` com todos os dados do Supabase (movimentações, fornecedores, manutenções, usuários e logs). As senhas não entram no backup.
- **Zerar sistema:** pede confirmação e a **senha do usuário admin** (conferida no banco). Apaga todos os dados e usuários; só o `admin` permanece, com a senha inicial. Depois volta para a tela de login.
- Últimos 50 registros de atividade: logins, cadastros, edições, exclusões, backups.

### Calendário
- Todos os campos de data usam o **calendário do próprio sistema** (formato dd/mm/aaaa), com listas de mês e ano (1950 até 50 anos à frente), botão **Hoje** e destaque para hoje e fins de semana.
- No celular, abre no centro da tela com botões grandes.
- Fecha ao escolher a data, ao tocar fora, com Esc, ao fechar a janela ou ao trocar de tela.

---

## 📱 Uso no celular

- Menu pelo botão ☰. Ele fecha ao tocar fora ou ao escolher uma tela.
- Botões, listas e campos com pelo menos 42px de altura, para o toque.
- Campos com fonte de 16px, para o iPhone não dar zoom ao digitar.
- As janelas (cadastros, detalhes, confirmações) têm rolagem própria, e a página de trás fica parada enquanto estão abertas.
- Filtros empilhados e tabelas com rolagem lateral, sem estourar a tela.
- Confirmações em janela do próprio sistema e proteção contra toque duplo nos botões de salvar.

---

## 💾 Onde ficam os dados

- No **Supabase**, com login próprio. As senhas são guardadas com criptografia e ninguém consegue vê-las.
- A **segurança por linha (RLS)** do `supabase.sql` só libera os dados para usuários **logados e cadastrados**.
- As telas se atualizam sozinhas quando alguém lança algo em outro aparelho. Um usuário excluído é desconectado na hora.
- O plano gratuito do Supabase pausa projetos sem uso por 7 dias. A tarefa automática `.github/workflows/supabase-keepalive.yml` consulta o banco a cada 3 dias para evitar isso (aparece em **Actions** como *Manter Supabase ativo*). Se o projeto pausar, clique em **Restore project** no painel do Supabase.
- **Backup:** use o botão *Fazer backup do banco* em **Banco & Logs** (recomendado uma vez por semana). Alternativa: no **Table Editor** do Supabase, abra cada tabela e clique em **Export → CSV**.

---

## 🟢 Configuração do Supabase

> ✅ **Já configurado** para o projeto `nusiftldrfdpfnaghuih`. Os passos abaixo servem para recriar o ambiente, se for preciso.

**1. Criar a conta e o projeto**
1. Acesse https://supabase.com, clique em **Start your project** e entre com o GitHub.
2. Crie o projeto `bluevillage` (plano Free). Guarde a *Database Password* gerada.

**2. Configurar o login**
1. **Authentication → Sign In / Providers**:
   - **Allow new users to sign up:** ligado.
   - **Confirm email:** desligado.
   - Clique em **Save changes**.
2. Em **Auth Providers**, clique em **Email**, ligue **Enable Email provider** e salve. A linha deve mostrar **ENABLED**.

**3. Criar as tabelas**
1. **SQL Editor → + New query**.
2. Cole todo o arquivo [`supabase.sql`](supabase.sql) e clique em **Run**. Deve aparecer **Success**.
3. Em **Table Editor** devem aparecer: `perfis`, `transactions`, `suppliers`, `maintenance`, `audit_logs` e `bv_privado`.

**3.1. Cadastrar a senha inicial do admin**

Em uma nova consulta, troque `SENHA_AQUI` pela senha inicial e clique em **Run**. Depois apague o texto da consulta.
```sql
insert into public.bv_privado (chave, valor)
values ('senha_inicial_admin', extensions.crypt('SENHA_AQUI', extensions.gen_salt('bf')))
on conflict (chave) do update set valor = excluded.valor;
```

**4. Chaves no site**

Em **Project Settings → Data API** (Project URL) e **API Keys → Legacy API Keys** (chave **anon public**). Os dois valores ficam no início do `<script>` do `index.html` (`SUPABASE_URL` e `SUPABASE_ANON_KEY`). Nunca use a chave **service_role** nem a **secret**.

**5. Primeiro acesso**

Abra o site e entre com `admin` e a senha inicial. Esse primeiro login cria o administrador. Depois troque a senha.

---

## 🚀 Publicação (GitHub Pages)

1. **Settings → Pages → Build and deployment:** *Deploy from a branch*, branch `main`, pasta `/ (root)`.
2. Toda alteração no `main` é publicada em 1 a 3 minutos (acompanhe em **Actions**).
3. Se a versão nova não aparecer, recarregue com **Ctrl+F5**.

---

## 🧯 Solução de problemas

| Mensagem ou sintoma | O que fazer |
|---------------------|-------------|
| *Usuário ou senha inválidos* | Confira login e senha. Se esqueceu, peça para outro usuário excluir e recriar o seu acesso. |
| *Senha inicial do admin não configurada* | Faça o passo **3.1**. |
| *Banco não preparado* | Execute o `supabase.sql` no SQL Editor. |
| *Login por e-mail desativado* / *Login não confirmado* | Revise o passo **2**. |
| *Sem conexão com a internet* | Verifique a internet. Se o Supabase estiver pausado, clique em **Restore project**. |
| Versão nova não aparece | Aguarde o ✅ em **Actions** e recarregue com **Ctrl+F5**. |

---

## 🛠️ Estrutura

```
bluevillage/
├── index.html       # sistema completo (telas + ligação com o Supabase; marca d'água do login embutida)
├── supabase.sql     # tabelas, segurança e funções do banco
├── .github/workflows/supabase-keepalive.yml  # mantém o projeto gratuito ativo
└── README.md
```

- Visual: Tailwind CSS e Font Awesome (carregados da internet).
- Banco e login: supabase-js 2.
- Não há servidor, dependências para instalar nem etapa de build. O `server.js` e o `database.sqlite` da versão local foram substituídos pelo Supabase.
