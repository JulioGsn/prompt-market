# ADR-009: Containerização local com Docker Compose

## Status

Aceita para a Wave 7A

## Contexto

Antes de configurar uma VPS, precisamos provar que a aplicação pode ser construída e executada de forma reproduzível fora do ambiente Ruby local. O MVP usa SQLite, portanto o arquivo de dados precisa sobreviver ao ciclo de vida do container.

## Decisão

Usaremos uma imagem Docker multi-stage e Docker Compose para o ambiente local.

A imagem:

- usa Ruby 3.4.10;
- instala somente dependências de runtime na imagem final;
- instala gems em uma etapa de build;
- executa como usuário não-root;
- expõe a porta 3000;
- executa `db:prepare` e `db:seed` no entrypoint;
- usa `storage/` como volume persistente;
- possui health check em `/health/live`.

O Compose recebe segredos por variáveis de ambiente obrigatórias e não contém credenciais padrão versionadas.

## Consequências

- o build local se aproxima do futuro ambiente de deploy;
- o SQLite sobrevive à recriação do container enquanto o volume for preservado;
- `docker compose down -v` apaga o volume local e os dados do MVP;
- a imagem ainda não tem proxy HTTPS, backup externo ou rollback automatizado;
- a Wave 7B deverá configurar Caddy, domínio, TLS e operação na Hetzner.

## Validação

O incremento será validado com `docker compose up --build`, health check do Compose, acesso autenticado ao site e execução do fluxo de preparação do banco dentro do container.
