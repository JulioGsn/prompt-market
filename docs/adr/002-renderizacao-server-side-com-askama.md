# ADR-002: Renderização server-side com Askama

## Status

Substituída por ADR-003

## Contexto

O primeiro endpoint já funciona, mas uma resposta de texto não representa a interface de um ecommerce. Precisamos começar a construir a camada visual sem introduzir um segundo projeto, um pipeline JavaScript ou uma aplicação frontend separada antes de existir essa necessidade.

## Opções consideradas

### HTML construído diretamente em strings Rust

É a opção com menos dependências, mas mistura apresentação com código de roteamento e se torna difícil de ler e manter rapidamente.

### Templates server-side com Askama

Askama compila templates HTML junto com a aplicação Rust.

Vantagens:

- mantém frontend e backend no mesmo projeto;
- evita uma etapa de build JavaScript;
- separa markup da lógica do servidor;
- falhas de template tendem a aparecer durante a compilação;
- é suficiente para o catálogo e os fluxos iniciais.

Desvantagens:

- interações ricas exigirão JavaScript adicional ou outra abordagem;
- o template ainda precisa de disciplina de acessibilidade, segurança e design;
- existe uma dependência específica de Rust para templates.

### Frontend separado com React ou outro framework JavaScript

Essa opção oferece um ecossistema amplo para interfaces interativas, mas cria uma segunda aplicação, uma segunda cadeia de build e contratos de API antes de o domínio exigir isso.

### Frontend em Rust com Leptos ou Dioxus

Pode ser uma boa exploração futura, mas adicionaria WebAssembly, hidratação e novos conceitos ao primeiro contato visual.

## Decisão

Usaremos **Askama** para renderizar HTML no servidor. A página inicial será servida pela rota `GET /` e terá CSS local no próprio template enquanto a interface ainda for pequena.

Não adicionaremos JavaScript neste incremento. **HTMX** poderá ser avaliado quando uma interação real do produto justificar atualizações parciais sem transformar o sistema em uma SPA.

## Consequências

- o projeto continua sendo uma única aplicação Rust;
- a camada visual poderá evoluir junto com as rotas e o domínio;
- o HTML será testável por meio da resposta HTTP;
- a aplicação ainda não terá componentes reutilizáveis de frontend nem design system;
- estilos inline serão aceitos temporariamente, mas poderão ser movidos para arquivos estáticos quando houver mais de uma página.

## Validação

O incremento será considerado validado quando:

- a rota retornar `200 OK`;
- o `Content-Type` for HTML;
- a resposta contiver uma estrutura semântica com título e conteúdo visível;
- o teste automatizado verificar parte relevante do HTML;
- a página puder ser aberta no navegador em `http://127.0.0.1:3000/`.
