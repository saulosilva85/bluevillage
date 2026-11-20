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
- **Alerta de estoque:** quando algum material está com estoque baixo ou zerado, aparece um aviso amarelo com os itens. Tocando nele, abre o **Estoque** já filtrado.
- **Relatório por torre:** quantidade de chamados por torre. Clicando na torre, aparecem os chamados e os lançamentos financeiros dela.

### Financeiro
- Movimentações de **Entrada** e **Saída (Despesa)**, com descrição, categoria, **conta**, torre (ou Condomínio Geral), valor e data.
- **Torre / Setor:** Condomínio Geral, Torre Jurerê, Torre Gunga, Torre Itacaré, Salão de Festa, Academia, Campinho, Bicicletário, Casa de Lixo, Estacionamento Visitantes, Guarita, Administração, Parquinho, Estacionamento Interno, Áreas Comuns, Churrasqueira Externa e Piscina.
- **Contas:** Conta Principal, Fundo de Reserva e Salão de Festa. Uma entrada soma e uma saída subtrai do card da conta escolhida no Dashboard.
- Clique na linha para ver os detalhes (quem lançou e quando). Botões para **editar** e **excluir**.

### Manutenção & Torres
- Locais: Torre Jurerê, Torre Gunga, Torre Itacaré, Salão de Festa, Academia, Campinho, Bicicletário, Casa de Lixo, Estacionamento Visitantes, Guarita, Administração, Parquinho, Estacionamento Interno, Áreas Comuns, Churrasqueira Externa, Piscina e Condomínio Geral (também no filtro de locais).
- Chamados por torre com item/equipamento, prioridade (Baixa, Média, Alta), status (Pendente, Em Andamento, Concluído), previsão e observações.
- **Pesquisa** por item ou observação (botão *Pesquisar* ou tecla Enter) e filtros por torre e prioridade.
- Cartões com paginação (6 por página), detalhes, edição e exclusão.
- Ao salvar um chamado como **Concluído**, o sistema pede confirmação. Depois disso o status fica **verde com cadeado** e o chamado **não pode mais ser editado nem excluído** (a trava também está no banco). Só o *Zerar sistema* apaga chamados concluídos.

### Fornecedores & Contratos
- Empresa, categoria (lista ou categoria nova), responsável, telefone, valor mensal, vencimento e **link do contrato** (PDF/Drive).
- Filtro por categoria e edição.

### Orçamentos
- O menu **Orçamentos** (abaixo de Fornecedores & Contratos) controla as cotações. Pelo regimento, cada serviço ou manutenção precisa de **3 orçamentos**.
- **Nova Cotação:** informe o serviço, o local/setor, a categoria, a data, a descrição e até 3 orçamentos (empresa, valor, prazo, contato e observações). Dá para salvar com menos de 3 e completar depois.
- **Cartões:** mostram o progresso (ex.: *2 de 3 orçamentos*), o menor valor e o status: *Em cotação*, *Pronta para aprovar*, *Aprovado* ou *Cancelado*.
- **Aprovação:** clique na cotação para ver a comparação lado a lado, com o menor preço destacado. O botão **Aprovar** só aparece com os 3 orçamentos lançados.
  - Se o escolhido **não for o de menor valor**, o sistema pede uma **justificativa**.
  - Depois de aprovada, a cotação fica **travada**: não pode mais ser editada nem excluída. O mesmo vale para cotações **canceladas**. A trava também está no banco.
- **Resumo:** quantas estão em cotação, quantas estão prontas para aprovar, quantas foram aprovadas e o total aprovado.
- **Filtros:** busca por serviço ou empresa, por status e por local.
- **Exportar PDF:** gera a tabela com os 3 orçamentos de cada cotação, o aprovado, quem aprovou e a justificativa, respeitando os filtros.

### Estoque
- O menu **Estoque** (abaixo de Orçamentos) controla as peças e materiais de reposição (lâmpadas, cloro, fita isolante, sifões etc.).
- **Novo Material:** nome, categoria (ou *Outra*), código opcional, unidade (un, peça, caixa, metro, litro, kg...), onde fica guardado, **estoque mínimo**, quantidade atual e custo unitário opcional. Não deixa cadastrar dois materiais com o mesmo nome.
- **Entrada / Saída / Ajuste:** a quantidade nunca é digitada direto. Cada mudança é uma movimentação registrada:
  - **Entrada:** compra ou reposição. Pode informar fornecedor, nota fiscal e custo unitário (o custo do material é atualizado).
  - **Saída:** retirada para uso. Informa onde foi usado (torre/setor), o chamado de manutenção (opcional) e quem retirou. Não deixa retirar mais do que o saldo.
  - **Ajuste de inventário:** depois de contar o estoque, informa a quantidade real. O motivo é obrigatório.
  - Antes de registrar, o sistema mostra como fica o saldo.
- **Situação:** *Em dia* (verde), *Estoque baixo* (amarelo, quando chega ao mínimo) ou *Sem estoque* (vermelho).
- **Histórico:** tocando no material, aparecem os dados e todas as movimentações (data, tipo, quantidade, saldo, detalhes e quem registrou). O histórico não pode ser alterado nem apagado; erros se corrigem com um ajuste.
- **Excluir:** só com saldo zero (faça antes um ajuste para zero). O histórico do material é apagado junto, mas a exclusão fica nos logs.
- **Resumo e filtros:** total de materiais, quantos estão baixos ou zerados e o valor estimado em estoque. Busca por nome, código ou local, e filtros por situação e categoria.
- **PDF:** *Exportar PDF* gera a lista do estoque (respeitando os filtros); no histórico, o botão *PDF* gera as movimentações do material.
- As regras do saldo também estão no banco: mesmo que alguém tente mudar a quantidade por fora, o Supabase não aceita.

### Gestão de Usuários
- Cadastro de usuários com função: Síndico, Subsíndico, Conselho Fiscal ou Administrativo.
- Exclusão de usuários. O `admin` (Principal) e o próprio usuário logado não podem ser excluídos.
- **Alterar Minha Senha** (pede a senha atual).

### Exportar PDF
- **Financeiro**, **Manutenção & Torres**, **Fornecedores & Contratos**, **Orçamentos** e **Estoque** têm o botão **Exportar PDF**.
- O PDF sai em A4 deitado, com título, resumo, tabela completa, número das páginas e data/hora/usuário que gerou.
  - **Financeiro:** todas as movimentações, o saldo de cada conta e o total de entradas e de saídas.
  - **Manutenção:** os chamados conforme a pesquisa e os filtros da tela, com o total por status.
  - **Fornecedores:** conforme a categoria filtrada, com o total mensal dos contratos.
- O PDF é gerado no próprio aparelho, sem serviço externo. No celular, é salvo em Downloads/Arquivos.

### Banco & Logs
- **Fazer backup do banco:** baixa um arquivo `.json` com todos os dados do Supabase (movimentações, fornecedores, manutenções, orçamentos, estoque, usuários e logs). As senhas não entram no backup.
- **Zerar sistema:** pede confirmação e a **senha do usuário admin** (conferida no banco). Apaga todos os dados e usuários; só o `admin` permanece, com a senha inicial. Depois volta para a tela de login.
- Últimos 50 registros de atividade: logins, cadastros, edições, exclusões, backups.

### Calendário
- Todos os campos de data usam o **calendário do próprio sistema** (formato dd/mm/aaaa), com listas de mês e ano (1950 até 50 anos à frente), botão **Hoje** e destaque para hoje e fins de semana.
- No celular, abre no centro da tela com botões grandes.
- Fecha ao escolher a data, ao tocar fora, com Esc, ao fechar a janela ou ao trocar de tela.

### Listas de seleção
- Todas as listas (filtros, local/setor, categoria, conta, tipo, prioridade, status, função do usuário) usam a **lista do próprio sistema**, igual no computador e no celular — o celular não abre mais a lista do Android/iPhone em tela cheia.
- A lista abre logo abaixo do campo (ou acima, se não houver espaço), com a opção atual destacada e rolagem própria.
- Fecha ao escolher, ao tocar fora, com Esc, ao rolar a tela ou ao trocar de tela. No computador também funciona pelas setas e Enter.

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
3. Em **Table Editor** devem aparecer: `perfis`, `transactions`, `suppliers`, `maintenance`, `quotes`, `config`, `audit_logs` e `bv_privado`.

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
| *As tabelas do estoque ainda não existem no banco* | Execute o `supabase.sql` atualizado no SQL Editor (pode rodar de novo; não apaga dados). |
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
