# ADR-001: Serviço HTTP em Axum

## Status

Substituída por ADR-003

## Contexto

O primeiro incremento precisa provar que o projeto Rust executa um serviço HTTP local, reproduzível e testável. Ainda não existem requisitos para banco de dados, autenticação, frontend separado ou deploy.

Precisamos escolher uma base pequena que permita adicionar rotas, estado, erros e testes sem obrigar o projeto a adotar uma arquitetura maior antes da hora.

## Opções consideradas

### Biblioteca padrão de Rust

Seria possível implementar o servidor diretamente com `std::net`.

Vantagens:

- nenhuma dependência externa;
- contato direto com TCP e HTTP de baixo nível.

Desvantagens:

- muito código incidental para um servidor HTTP;
- testes e evolução de rotas ficariam menos representativos de uma aplicação real;
- desviaria o foco do aprendizado para a implementação de protocolo.

### Actix Web

É um framework HTTP maduro e completo para Rust.

Vantagens:

- ecossistema consolidado;
- bom desempenho;
- recursos prontos para aplicações maiores.

Desvantagens:

- oferece mais estrutura do que o primeiro incremento precisa;
- não há uma necessidade atual que justifique escolher uma alternativa mais abrangente.

### Axum

É um framework HTTP baseado no ecossistema Tokio, com roteamento explícito e boa integração com tipos e async de Rust.

Vantagens:

- API pequena para começar;
- rotas explícitas e composição simples;
- integração natural com Tokio;
- facilita testes da aplicação sem iniciar um processo externo;
- pode crescer para estado, autenticação, banco e observabilidade.

Desvantagens:

- adiciona dependências externas;
- abstrai detalhes do protocolo que poderiam ser úteis em um estudo específico de HTTP de baixo nível.

## Decisão

Usaremos **Axum** sobre **Tokio** para o serviço HTTP inicial.

A aplicação será exposta por uma função `app()` que constrói o roteador. O `main` ficará responsável apenas por criar o listener e iniciar o servidor. Essa separação permite testar as rotas diretamente sem abrir uma porta real.

O primeiro endpoint será:

```text
GET /
```

Ele responderá `200 OK` com o texto `Hello, world!`.

O servidor escutará por padrão em `127.0.0.1:3000`, limitando a exposição ao ambiente local neste primeiro incremento.

## Consequências

### Benefícios

- teremos uma aplicação executável com poucas decisões acopladas;
- a função de composição da aplicação será testável;
- a futura camada de domínio poderá ser adicionada sem misturar sua lógica com a inicialização do processo;
- aprendemos o fluxo básico de uma aplicação async em Rust.

### Custos e riscos

- será necessário acompanhar versões de Axum e Tokio;
- o comportamento de rede ainda será validado apenas localmente;
- não há configuração externa, logging estruturado, health check ou tratamento operacional neste estágio;
- o endpoint não representa ainda o domínio do Prompt Store.

## Validação

O incremento será considerado validado quando:

- `cargo fmt --check` passar;
- `cargo clippy --all-targets --all-features -- -D warnings` passar;
- `cargo test` passar;
- o processo iniciar localmente;
- `GET /` retornar `200 OK` e `Hello, world!`.

## Aprendizado esperado

Este incremento ensina a separar a construção da aplicação da inicialização do processo, a declarar dependências Rust, a escrever um teste de rota e a estabelecer uma linha de base verificável antes de adicionar regras de negócio.
