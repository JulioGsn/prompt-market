# Contexto para Continuação

Este documento permite que outro agente continue o projeto sem depender do histórico da conversa.

## Produto

O produto é o **Prompt Store**, um ecommerce pequeno de prompts de IA.

O MVP atual possui:

- catálogo de prompts com título, descrição, conteúdo e preço inteiro;
- catálogo versionado em `data/products.json`;
- usuário pré-configurado com 100 créditos;
- aquisição de vários prompts;
- conteúdo completo liberado somente após aquisição;
- rejeição de saldo insuficiente;
- rejeição de aquisição repetida;
- registro do preço efetivamente pago;
- nenhum checkout ou pagamento externo;
- nenhum cadastro de usuário ainda.

O MVP é privado em produção porque ainda existe uma conta compartilhada. Basic Auth é uma proteção temporária, não a autenticação final do produto.

## Stack atual

- Ruby 3.4.10;
- Ruby on Rails 8.1.4.1;
- SQLite;
- Active Record;
- views server-side e CSS local;
- Docker e Docker Compose para execução local;
- Caddy planejado para HTTPS e reverse proxy;
- GitHub Actions para CI inicial;
- GitHub Container Registry planejado para imagens;
- logs JSON, métricas internas e health checks;
- Minitest, RuboCop, Brakeman e Bundler Audit.

Rust, Axum e Askama foram protótipos abandonados. A decisão está registrada em `docs/adr/003-migracao-de-rust-para-rails.md`.

## Waves concluídas

### Wave 1: Fundação Rails

Aplicação Rails, SQLite, página inicial, teste, lint e auditorias.

### Wave 2: Catálogo

Catálogo JSON validado, listagem, detalhes e conteúdo protegido.

### Wave 3: Domínio de aquisição

Regras de compra inicialmente implementadas em memória para isolar o domínio.

### Wave 4: Persistência SQLite

Modelos `User` e `Acquisition`, migrations, constraints, índice único e `PurchaseService` transacional.

### Wave 5: Observabilidade

Logs JSON em produção, request IDs, métricas internas, `/health/live`, `/health/ready` e `/metrics`.

### Wave 6: Segurança

Basic Auth em produção, CSP, headers de segurança, comparação segura de credenciais e `.env.example`.

### Wave 7A: Containerização local

Imagem Docker multi-stage, usuário não-root, volume SQLite, entrypoint com `db:prepare db:seed` e health check do Compose.

## Arquivos importantes

- `README.md`: mapa do projeto e status das waves.
- `AGENTS.md`: método de trabalho pedagógico para agentes.
- `docs/requisitos-mvp.md`: requisitos e critérios de aceitação.
- `docs/adr/`: decisões arquiteturais, incluindo alternativas e consequências.
- `docs/apresentacao.html`: apresentação autocontida do processo.
- `docs/diagramas/`: arquitetura geral, pipeline CI/CD e VPS.
- `data/products.json`: catálogo público e conteúdo protegido.
- `app/services/product_catalog.rb`: carregamento e validação do catálogo.
- `app/services/purchase_service.rb`: aquisição transacional.
- `app/services/application_metrics.rb`: métricas internas.
- `app/services/private_access.rb`: autorização Basic Auth.
- `Dockerfile`: imagem de produção local.
- `docker-compose.yml`: execução containerizada local.
- `bin/docker-entrypoint`: preparação do banco e seeds antes do servidor.

## Comandos locais

Execução Rails direta:

```bash
bin/rails db:prepare db:seed
bin/rails server
```

Execução containerizada:

```bash
SECRET_KEY_BASE=local-container-secret \
PROMPT_STORE_USERNAME=operator \
PROMPT_STORE_PASSWORD=local-password \
docker compose up --build
```

Acesso local containerizado:

- URL: `http://127.0.0.1:3000/`;
- usuário: `operator`;
- senha: `local-password`;
- health: `http://127.0.0.1:3000/health/live`.

Parar sem remover o volume:

```bash
SECRET_KEY_BASE=local-container-secret \
PROMPT_STORE_USERNAME=operator \
PROMPT_STORE_PASSWORD=local-password \
docker compose down
```

Não usar `docker compose down -v` sem intenção de apagar os dados SQLite locais.

Validações:

```bash
bin/rails test
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
```

## Evidências recentes

- Wave 6: 24 testes e 90 assertions, sem falhas;
- Wave 6: RuboCop sem offenses;
- Wave 6: Brakeman sem warnings;
- Wave 6: Bundler Audit sem vulnerabilidades conhecidas;
- Wave 7A: imagem Docker construída com sucesso;
- Wave 7A: container executou como `1000:1000`;
- Wave 7A: Compose reportou `healthy`;
- Wave 7A: health retornou `200`;
- Wave 7A: aplicação sem Basic Auth retornou `401`;
- Wave 7A: aplicação autenticada retornou `200`;
- Wave 7A: métricas autenticadas retornaram `200`;
- Wave 7A: volume SQLite foi preservado após `docker compose down`.

## Próxima wave: 7B

O próximo marco é publicar o MVP na VPS Hetzner usando SSH, Caddy e uma imagem privada do GHCR.

Ordem recomendada:

1. Auditar o servidor pelo alias SSH `cuscuz` antes de modificar qualquer coisa.
2. Confirmar sistema operacional, RAM, disco e serviços existentes.
3. Criar usuário de deploy, configurar SSH seguro e firewall.
4. Instalar Docker e configurar swap se necessário.
5. Criar Compose de produção baseado em `image`, não em `build`.
6. Configurar login de leitura do GHCR sem expor token no repositório.
7. Configurar domínio, Caddy e HTTPS.
8. Configurar secrets no servidor.
9. Configurar volume SQLite e backup externo.
10. Fazer deploy manual e validar health, Basic Auth e compra.
11. Criar rollback e teste de restauração.
12. Adicionar CD ao GitHub Actions.

## CI/CD planejado

CI em pull requests e `main` deve executar testes Rails, RuboCop, Brakeman, Bundler Audit e `docker build`.

CD deve construir uma imagem tagueada pelo SHA do commit, publicar no GHCR, aguardar aprovação do ambiente de produção, conectar via SSH, fazer backup, atualizar o container, executar migrations/seeds e validar o health check.

O deploy deve começar com aprovação manual. Deploy automático poderá ser adotado depois que rollback e observabilidade estiverem comprovados.

## Limitações e riscos

- Basic Auth é temporário e não separa usuários;
- métricas ficam em memória e `/metrics` exige proteção operacional adicional;
- ainda não há HTTPS configurado;
- ainda não há backup externo do SQLite;
- ainda não há rollback automatizado;
- SQLite limita o MVP a uma instância e baixo volume;
- o servidor de 1 GB não deve executar build Docker;
- o pacote GHCR deve ser privado porque a imagem contém prompts.

## GitHub

- repositório: `https://github.com/JulioGsn/prompt-market`;
- branch principal: `main`;
- remote: `origin`;
- últimos commits antes deste contexto: `89be875` e `9110734`.

Não versionar chaves, tokens, `.env` real ou credenciais. Não usar push forçado.

## Regra para o próximo agente

Ler primeiro `AGENTS.md`, `README.md`, este arquivo e os ADRs relevantes. Antes de alterar o servidor, explicar o plano e executar uma auditoria somente leitura. Preservar as alterações existentes e registrar toda decisão operacional nova.
