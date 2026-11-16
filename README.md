# Blue Village Residence — Gestão 2027

Plataforma web interna de gestão do condomínio Blue Village (Torres Jurerê, Gunga e Itacaré).

## Como usar
Abra o `index.html` no navegador ou sirva a pasta (ex.: `npx serve -l 3000` ou `python -m http.server 3000`) e acesse `http://127.0.0.1:3000`.

**Acesso inicial:** usuário `admin` / senha `Blue@2027!` (altere em *Gestão de Usuários → Alterar Minha Senha*).

## Módulos
- **Dashboard & Torres** — saldo, despesas do mês, fundo de reserva, contratos ativos, alerta de teto de gastos (salário mínimo × multiplicador) e gráfico por torre.
- **Financeiro** — receitas, despesas, aportes/resgates do fundo de reserva e parâmetros do teto.
- **Manutenção & Torres** — manutenções e ocorrências por torre, com prioridade e status.
- **Fornecedores & Contratos** — cadastro, vigência (alerta de vencimento em 30 dias) e status.
- **Gestão de Usuários** — criação, inativação, redefinição de senha e perfis.
- **Banco & Logs** — backup/restauração em JSON e log de atividades.

Os dados ficam no `localStorage` do navegador (senhas salvas como hash SHA-256). Faça backups pela tela *Banco & Logs*.
