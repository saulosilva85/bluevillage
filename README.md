# Blue Village Residence — Gestão 2027

Plataforma web interna de gestão do condomínio **Blue Village Residence** (Torres **Jurerê**, **Gunga** e **Itacaré**).

O sistema é um único arquivo (`index.html`) publicado pelo **GitHub Pages**. Os dados ficam em um banco de dados online (**Firebase**), então tudo que é feito no notebook aparece no celular e vice-versa, em tempo real.

🔗 **Acesso:** https://saulosilva85.github.io/bluevillage/

---

## 🔐 Acesso inicial

| Usuário | Senha |
|---------|-------|
| `admin` | `Blue@2027!` |

> ⚠️ O link é público. **Troque a senha no primeiro acesso** em *Gestão de Usuários → Alterar Minha Senha*.
> O primeiro login com `admin` / `Blue@2027!` cria o administrador no banco online. Faça isso logo depois de configurar o Firebase.

- Todos os campos de senha têm o botão de **olho**. 👁️‍🗨️ Olho riscado: senha oculta. 👁️ Olho aberto: senha visível.
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
- **Parâmetros do teto:** salário mínimo e multiplicador, editáveis nesta tela.

### Manutenção & Torres
- Registro de manutenções, ocorrências e preventivas por torre (ou Área Comum).
- Para cada registro: prioridade (Baixa, Média, Alta, Urgente), responsável/fornecedor e custo estimado.
- Status alterável direto na lista: Aberta, Em andamento ou Concluída.

### Fornecedores & Contratos
- Cadastro com razão social, CNPJ/CPF, serviço, contato, vigência e valor mensal.
- Status: Ativo, Suspenso ou Encerrado.
- 🔔 Aviso quando um contrato ativo vence em até 30 dias.

### Gestão de Usuários
- Perfis: Administrador, Síndico, Subsíndico, Conselho Fiscal e Operador.
- **Somente o Administrador** pode criar, ativar/inativar, redefinir a senha e excluir usuários.
- Qualquer usuário pode alterar a própria senha.

### Banco & Logs
- **Exportar backup** (`.json`) com todos os dados.
- **Importar backup** (somente Administrador): os usuários não são importados.
- **Zerar banco** (somente Administrador, com dupla confirmação): apaga lançamentos, manutenções, contratos e logs de todos os aparelhos e mantém os usuários.
- **Log de atividades:** logins, cadastros, exclusões e alterações, com data, hora e usuário.

---

## 💾 Onde ficam os dados

- Os dados ficam no **Firebase (Google)**: banco **Cloud Firestore** e logins pelo **Firebase Authentication**.
- Qualquer aparelho (notebook, celular, tablet) vê as mesmas informações, e as telas se atualizam sozinhas quando alguém lança algo.
- As senhas são guardadas pelo Firebase. Nem o sistema nem o administrador conseguem vê-las.
- As **regras de segurança** (`firestore.rules`) só liberam os dados para usuários **ativos e logados**. Só o **Administrador** pode criar, alterar e excluir usuários.
- Um usuário inativado é desconectado na hora, em todos os aparelhos.
- O plano gratuito do Firebase (Spark) é suficiente para o condomínio.
- **Dados da versão anterior:** se algum navegador ainda tiver dados salvos localmente, entre com o admin nele. O Dashboard vai mostrar um aviso. Vá em *Banco & Logs → Enviar para a nuvem*. Os usuários antigos precisam ser recriados.

---

## 🔥 Configuração do Firebase (fazer uma única vez)

1. Acesse https://console.firebase.google.com e entre com uma conta Google.
2. Clique em **Criar um projeto** (ou *Adicionar projeto*), dê o nome `bluevillage`, desative o Google Analytics e clique em **Criar projeto**.
3. **Authentication:** no menu *Criação* (*Build*), abra **Authentication → Vamos começar**. Na aba **Método de login**, escolha **E-mail/senha**, ative a primeira chave e clique em **Salvar**.
4. **Firestore:** no menu *Criação*, abra **Firestore Database → Criar banco de dados**. Escolha o local **southamerica-east1 (São Paulo)**, marque **modo de produção** e clique em **Criar**.
5. **Regras:** no Firestore, abra a aba **Regras**, apague o conteúdo, cole todo o arquivo [`firestore.rules`](firestore.rules) e clique em **Publicar**.
6. **App da Web:** clique na engrenagem ⚙️ → **Configurações do projeto**. Em *Seus apps*, clique no ícone **`</>`**, dê o apelido `bluevillage-web` e clique em **Registrar app**. Não marque o Firebase Hosting.
7. Copie os valores do bloco `firebaseConfig` (`apiKey`, `authDomain`, `projectId`, `storageBucket`, `messagingSenderId`, `appId`). Cole no início do `<script>` do `index.html`, em `const FIREBASE_CONFIG = {...}`. Essas chaves não são secretas: quem protege os dados são as regras do passo 5.
8. Publique (merge no `main`), abra o site e entre com `admin` / `Blue@2027!` para criar o administrador.

---

## 📱 Uso no celular

- Layout próprio para celular: menu pelo botão ☰ (fecha tocando fora), botões grandes para o toque e campos que não dão zoom no iPhone.
- O campo de valor abre o teclado numérico e aceita vírgula (ex.: `1.250,50`).
- Confirmações em janela própria do sistema, que funcionam em qualquer navegador.
- Se outro aparelho lançar algo enquanto você digita, o que está sendo digitado **não é apagado**.

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
├── firestore.rules  # regras de segurança do banco (colar no Firebase Console)
└── README.md
```

- Banco e login: Firebase Web SDK 10 (carregado da internet).
- Ícones: Font Awesome 6 (via CDN, precisa de internet).
- Não há dependências para instalar nem etapa de build.
