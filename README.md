# Blue Village Residence — Gestão 2027

Plataforma web interna de gestão do condomínio **Blue Village Residence** (Torres **Jurerê**, **Gunga** e **Itacaré**).

O sistema é um único arquivo (`index.html`) publicado pelo **GitHub Pages**. Os dados ficam em um banco de dados online (**Supabase**), então tudo que é feito no notebook aparece no celular e vice-versa, em tempo real.

🔗 **Acesso:** https://saulosilva85.github.io/bluevillage/

---

## 🔐 Acesso inicial

| Usuário | Senha |
|---------|-------|
| `admin` | `Blue@2027!` |

> ⚠️ O link é público. **Troque a senha no primeiro acesso** em *Gestão de Usuários → Alterar Minha Senha*.
> O primeiro login com `admin` / `Blue@2027!` cria o administrador no banco online. Faça isso logo depois de configurar o Supabase.

- Todos os campos de senha têm o botão de **olho**. 👁️‍🗨️ Olho riscado: senha oculta. 👁️ Olho aberto: senha visível.
- Nos campos de **senha nova** (Novo Usuário, Nova senha e Redefinir senha), o navegador não sugere "senha forte" nem pede para salvar a senha. A pessoa escolhe a senha que quiser, com no mínimo 6 caracteres.
- Depois do login, ou ao recarregar a página, o sistema **sempre abre no Dashboard & Torres**.
- Ao clicar em **Sair**, o sistema pede confirmação.
- O usuário logado (nome e perfil) e o botão **Sair** ficam no **final do menu lateral**.

---

## 📋 Módulos

### Dashboard & Torres
- **Indicadores:** Saldo em Conta, Total de Despesas do Mês, Fundo de Reserva, **Salão de Festa** e Contratos Ativos. Todos começam zerados e mudam conforme os cadastros.
- **Salão de Festa:** mostra o saldo da conta do salão (créditos − débitos) e, logo abaixo, o total de créditos e de débitos.
- **Alerta de teto de gastos.** O teto é o salário mínimo × multiplicador (padrão: R$ 1.518,00 × 5 = R$ 7.590,00).
  - 🟢 Orçamento sob controle
  - 🟡 Atenção: despesas do mês a partir de 80% do teto
  - 🔴 Teto ultrapassado
- **Relatório por torre:** quantidade de manutenções e ocorrências (em aberto e concluídas).
- **Últimos lançamentos financeiros.**

### Financeiro
Cada lançamento tem **Data, Tipo, Categoria, Torre, Descrição e Valor**.

| Tipo | Efeito |
|------|--------|
| Receita | Soma no saldo |
| Despesa | Subtrai do saldo e conta no teto de gastos |
| Fundo de Reserva | Soma no Fundo de Reserva |
| Resgate do Fundo | Subtrai do Fundo de Reserva |
| Salão de Festa | Conta separada: **Crédito** soma e **Débito** subtrai do saldo do Salão de Festa. Não altera o Saldo em Conta nem o teto de gastos |

- **Descrição:** lista de seleção com **Crédito** ou **Débito**.
- **Categorias:** Taxa Condominial, Água, Energia, Folha de Pagamento, Manutenção, Limpeza, Segurança, Administrativo e Outros.
- O topo da tela Financeiro mostra o resumo: Saldo, Fundo e Salão.
- **Calendário próprio** em todos os campos de data, no visual do sistema e no formato dd/mm/aaaa. Ele tem setas e listas próprias de mês e ano (iguais no computador e no celular; anos de 1950 até 50 anos à frente do ano atual) para ir rápido a outra data, além dos botões **Hoje** e **Limpar**. Hoje fica com contorno azul e fins de semana em azul-claro. No celular, abre no centro da tela com botões grandes. O calendário fecha sozinho ao tocar fora dele, ao abrir o menu, ao trocar de tela ou com a tecla Esc.
- **Filtros da lista de lançamentos:**
  - Período **De / Até**. O calendário destaca a faixa escolhida.
  - Atalhos: **Hoje, Últimos 7 dias, Este mês, Mês passado, Este ano e Tudo**.
  - **Tipo** e **Torre**.
  - Abaixo dos filtros aparecem as **Entradas, Saídas e o Resultado** do que está filtrado.
  - **Limpar filtros** volta a mostrar tudo.
- **Parâmetros do teto:** salário mínimo e multiplicador, editáveis nesta tela.

### Manutenção & Torres
- Registro de manutenções, ocorrências e preventivas por torre (ou Área Comum).
- Para cada registro: prioridade (Baixa, Média, Alta, Urgente), responsável/fornecedor e custo estimado.
- Status alterável direto na lista: Aberta, Em andamento ou Concluída. Ao escolher **Concluída**, o sistema pede confirmação. Depois disso o status fica **travado** (🔒 Concluída) e não pode mais voltar para Aberta ou Em andamento, nem pela tela nem direto no banco. O registro concluído também **não pode ser excluído**: a lixeira some da linha e o banco recusa a exclusão. A única exceção é o **Zerar banco** do Administrador.
- **Filtros:** período (De / Até e atalhos), **Torre** e **Status**, com o custo estimado total do que está filtrado.

### Fornecedores & Contratos
- Cadastro com razão social, CNPJ/CPF, serviço, contato, vigência e valor mensal.
- Status: Ativo, Suspenso ou Encerrado.
- 🔔 Aviso quando um contrato ativo vence em até 30 dias.

### Gestão de Usuários
- Perfis: Administrador, Síndico, Subsíndico, Conselho Fiscal e Operador.
- **Somente o Administrador** pode criar, ativar/inativar, redefinir a senha e excluir usuários.
- Qualquer usuário pode alterar a própria senha. Para isso, precisa informar a senha atual.
- O login aceita letras minúsculas, números, ponto, hífen e sublinhado, sem espaços. Digitar `Saulo` ou `saulo` dá no mesmo.
- Depois de criar um usuário ou alterar a senha, os campos são limpos automaticamente.
- Um usuário inativado não consegue entrar. Se estiver usando o sistema naquele momento, é desconectado.

### Banco & Logs
- **Exportar backup** (`.json`), disponível para qualquer usuário. Veja a seção **Backup** abaixo.
- **Importar backup** (somente Administrador): os usuários não são importados.
- **Zerar banco** (somente Administrador, com dupla confirmação): apaga lançamentos, manutenções, contratos e logs de todos os aparelhos e mantém os usuários.
- **Log de atividades:** logins, cadastros, exclusões e alterações, com data, hora e usuário.

---

## 🗄️ Backup

O plano gratuito do Supabase **não oferece backups automáticos** para baixar, então use o backup da plataforma.

**Como fazer:** abra *Banco & Logs* e clique em **Exportar backup (.json)**. O arquivo `bluevillage-backup-AAAA-MM-DD.json` é baixado. No celular, ele vai para Downloads ou Arquivos.

| No arquivo | Fora do arquivo |
|------------|-----------------|
| Lançamentos do Financeiro (incluindo Salão de Festa) | Senhas (nem o sistema tem acesso a elas) |
| Manutenções e ocorrências | Logs de atividade |
| Fornecedores e contratos | |
| Parâmetros do teto de gastos | |
| Lista de usuários (nome, login, perfil e status) | |

**Como restaurar:** em *Banco & Logs → Importar backup* (somente Administrador), escolha o arquivo. Os registros voltam para a nuvem e aparecem em todos os aparelhos. Registros com o mesmo código são substituídos. Os usuários não são recriados, porque o arquivo não tem as senhas: crie-os de novo em *Gestão de Usuários*, se for preciso.

**Recomendações:**
- Faça um backup **por semana** e antes de qualquer mudança grande.
- Guarde o arquivo fora do computador, por exemplo no Google Drive ou no e-mail.
- **Alternativa em planilha:** no Supabase, abra **Table Editor**, escolha a tabela e use **Export → CSV**.

---

## 💾 Onde ficam os dados

- Os dados ficam no **Supabase**: um banco PostgreSQL online com login de usuários.
- Qualquer aparelho (notebook, celular, tablet) vê as mesmas informações, e as telas se atualizam sozinhas quando alguém lança algo.
- As senhas são guardadas pelo Supabase com criptografia. Nem o sistema nem o administrador conseguem vê-las.
- Os logins usam um e-mail interno (`usuario@bluevillage.app`), que fica invisível para quem usa o sistema. Nenhum e-mail é enviado, e o `supabase.sql` confirma esses logins automaticamente.
- A **segurança por linha (RLS)** do `supabase.sql` só libera os dados para usuários **ativos e logados**. Só o **Administrador** cria, altera, exclui e redefine a senha de usuários.
- Um usuário inativado ou excluído é desconectado na hora, em todos os aparelhos.
- O plano gratuito do Supabase é suficiente para o condomínio. Ele pausa projetos sem uso por 7 dias. Para evitar isso, a tarefa automática `.github/workflows/supabase-keepalive.yml` consulta o banco a cada 3 dias. Ela aparece na aba **Actions** do GitHub como *Manter Supabase ativo*.
  - O GitHub desliga tarefas agendadas de repositórios sem alterações há 60 dias. Se isso acontecer, abra **Actions → Manter Supabase ativo → Enable workflow**.
  - Se mesmo assim o projeto pausar, entre no painel do Supabase e clique em **Restore project**. Os dados não são perdidos.
- **Dados da versão anterior:** se algum navegador ainda tiver dados salvos localmente, entre com o admin nele. O Dashboard vai mostrar um aviso. Vá em *Banco & Logs → Enviar para a nuvem*. Os usuários antigos precisam ser recriados.

---

## 🟢 Configuração do Supabase (fazer uma única vez)

> ✅ **Já configurado** para o projeto `nusiftldrfdpfnaghuih` (região East US). Os passos abaixo servem para recriar o ambiente, se um dia for preciso.

O painel do Supabase é em inglês, por isso os nomes dos botões estão em inglês.

**1. Criar a conta**
1. Acesse https://supabase.com e clique em **Start your project**.
2. Clique em **Continue with GitHub** e autorize com a conta `saulosilva85`.

**2. Criar o projeto**
1. Se for pedida uma organização, preencha **Name:** `Blue Village`, **Type:** Personal e **Plan:** Free. Depois clique em **Create organization**.
2. Na tela **Create a new project**:
   - **Project name:** `bluevillage`
   - **Database Password:** clique em **Generate a password** e **guarde essa senha** em lugar seguro. O sistema não usa essa senha, mas ela é a chave mestra do banco.
   - **Region:** se a lista tiver a seção **Specific regions** (role a lista para baixo), escolha **South America (São Paulo)**. Se só aparecerem as regiões gerais, escolha **Americas**.
3. Clique em **Create new project** e aguarde de 1 a 2 minutos, até sumir a mensagem *Setting up project*.

**3. Criar as tabelas**
1. No menu da esquerda, clique em **SQL Editor** (ícone `>_`).
2. Clique em **+ New query**, ou use a área em branco que já aparece.
3. Abra o arquivo [`supabase.sql`](supabase.sql) do repositório e clique em **Copy raw file** (ícone de copiar). Cole no editor.
4. Clique em **Run**, no canto inferior direito, ou aperte Ctrl+Enter.
5. Deve aparecer **Success. No rows returned**. Se aparecer um aviso sobre *destructive operation*, clique em **Run this query**.
6. Para conferir, clique em **Table Editor** no menu da esquerda. Devem aparecer as tabelas `config`, `forn`, `lanc`, `logs`, `manut` e `perfis`.

**4. Configurar o login**
1. No menu da esquerda, clique em **Authentication** e depois em **Sign In / Providers**. Em versões antigas o nome é **Providers**.
2. Na seção **User Signups**:
   - **Allow new users to sign up:** **ligado**. O sistema usa isso para o administrador criar usuários.
   - **Confirm email:** **desligado**. Os logins são internos e nenhum e-mail é enviado.
   - Clique em **Save changes**.
3. Na seção **Auth Providers**, a linha **Email** vem como **DISABLED**. Clique nela, ligue **Enable Email provider** e clique em **Save**. Se o painel tiver outro **Confirm email**, deixe desligado também.
4. Confira se a linha **Email** passou a mostrar **ENABLED**.

**5. Copiar as chaves**
1. Clique na engrenagem **Project Settings**, no fim do menu da esquerda, e depois em **Data API** (ou **API**). Copie a **Project URL**, que tem o formato `https://xxxxxxxx.supabase.co`.
2. Ainda em **Project Settings**, abra **API Keys**. Na aba **Legacy API Keys**, copie a chave **anon** **public**, um texto longo que começa com `eyJ`.
   > A chave *anon* não é secreta: ela fica no site e quem protege os dados é a segurança do passo 3. **Nunca** use nem envie a chave **service_role** nem a **secret**.
3. Coloque os dois valores no início do `<script>` do `index.html`:
   ```js
   const SUPABASE_URL = "https://xxxxxxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJ...";
   ```

**6. Primeiro acesso**
1. Publique (merge no `main`) e aguarde o ✅ na aba **Actions**.
2. Abra o site e entre com `admin` / `Blue@2027!`. Esse primeiro login cria o administrador.
3. Troque a senha em *Gestão de Usuários → Alterar Minha Senha*.

---

## 📱 Uso no celular

- Layout próprio para celular: menu pelo botão ☰ (fecha tocando fora), botões grandes para o toque e campos que não dão zoom no iPhone.
- O campo de valor abre o teclado numérico e aceita vírgula (ex.: `1.250,50`).
- Confirmações em janela própria do sistema, que funcionam em qualquer navegador.
- Se outro aparelho lançar algo enquanto você digita, o que está sendo digitado **não é apagado**.
- Os botões de salvar ficam travados enquanto salvam, então um toque duplo não grava o registro duas vezes.
- Se a conexão do celular oscilar, os dados são atualizados de novo a cada 30 segundos e quando você volta para a aba.

---

## 🧯 Solução de problemas

| Mensagem ou sintoma | O que fazer |
|---------------------|-------------|
| *Login por e-mail desativado no Supabase* | Ative o provedor **Email** (passo 4 da configuração). |
| *Login não confirmado* | Execute de novo o `supabase.sql` no SQL Editor e confira se **Confirm email** está desligado. |
| *Usuário ou senha inválidos* | Confira o login e a senha. Para esquecimento de senha, o Administrador usa **Redefinir senha** (ícone 🔄) em *Gestão de Usuários*. |
| *Usuário inativo* / *Usuário sem acesso* | O Administrador precisa ativar ou recriar o usuário. |
| *Banco não preparado* | Execute o `supabase.sql` no SQL Editor. |
| *Sem conexão com a internet* | Verifique a internet. Se o Supabase estiver pausado, clique em **Restore project** no painel. |
| *Sistema ainda não configurado* | Faltam `SUPABASE_URL` / `SUPABASE_ANON_KEY` no `index.html`. |
| Versão nova não aparece depois do merge | Aguarde o ✅ em **Actions** e recarregue com **Ctrl+F5**. |
| Ícones não aparecem | O navegador não carregou o Font Awesome. Recarregue com **Ctrl+F5**. O sistema continua funcionando sem os ícones. |

---

## 🚀 Publicação (GitHub Pages)

1. No repositório, abra **Settings → Pages**.
2. Em **Build and deployment**, escolha **Source:** *Deploy from a branch*, **Branch:** `main` e a pasta `/ (root)`. Depois clique em **Save**.
3. Acompanhe a publicação na aba **Actions** (tarefa *pages build and deployment*) até ficar ✅.
4. Toda alteração enviada ao branch `main` é publicada automaticamente em 1 a 3 minutos.
5. Se a versão nova não aparecer, recarregue a página com **Ctrl+F5**.

---

## 🛠️ Estrutura

```
bluevillage/
├── index.html       # sistema completo (HTML + CSS + JavaScript, com a marca d'água embutida)
├── supabase.sql     # tabelas, segurança, funções e confirmação automática dos logins (colar no SQL Editor do Supabase)
├── .github/workflows/supabase-keepalive.yml  # mantém o projeto gratuito ativo
└── README.md
```

- Banco e login: supabase-js 2 (carregado da internet).
- Ícones: Font Awesome 6 (via CDN, precisa de internet).
- Não há dependências para instalar nem etapa de build.
