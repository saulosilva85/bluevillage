# Blue Village Residence — Gestão 2027

Plataforma web interna de gestão do condomínio **Blue Village Residence** (Torres **Jurerê**, **Gunga** e **Itacaré**).

O sistema é um único arquivo (`index.html`), sem servidor e sem instalação. Ele é publicado pelo **GitHub Pages**.

🔗 **Acesso:** https://saulosilva85.github.io/bluevillage/

---

## 🔐 Acesso inicial

| Usuário | Senha |
|---------|-------|
| `admin` | `Blue@2027!` |

> ⚠️ O link é público. **Troque a senha no primeiro acesso** em *Gestão de Usuários → Alterar Minha Senha*.

- Todos os campos de senha têm o botão de **olho**. 👁️‍🗨️ Olho riscado: senha oculta. 👁️ Olho aberto: senha visível.
- Depois do login, o sistema **sempre abre no Dashboard & Torres**.
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
- **Importar backup** e **Zerar banco** (somente Administrador). Zerar o banco recria o usuário `admin` padrão.
- **Log de atividades:** logins, cadastros, exclusões e alterações, com data, hora e usuário.

---

## 💾 Onde ficam os dados

- Os dados ficam salvos **no navegador** de cada computador (`localStorage`). **Nada é salvo no GitHub.**
- As senhas são guardadas apenas como hash **SHA-256**.
- Cadastros feitos em um computador ou navegador **não aparecem** em outro.
- Limpar os dados de navegação **apaga tudo**. Faça backups com frequência em *Banco & Logs*.
- Para mudar de computador: exporte o backup no antigo e importe no novo.

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
├── index.html   # sistema completo (HTML + CSS + JavaScript, com a marca d'água embutida)
└── README.md
```

- Ícones: Font Awesome 6 (via CDN, precisa de internet).
- Não há dependências para instalar nem etapa de build.
