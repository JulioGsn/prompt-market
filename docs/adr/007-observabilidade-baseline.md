# ADR-007: Baseline de observabilidade interno

## Status

Aceita para o MVP

## Contexto

Antes de publicar o Prompt Store, precisamos conseguir responder perguntas básicas: a aplicação está viva, o banco está pronto, quantas requisições ocorreram, quanto demoraram e quais compras falharam?

Ainda não há volume, múltiplas instâncias ou necessidade de operar uma plataforma externa de métricas. Adicionar Prometheus, Grafana e OpenTelemetry agora aumentaria a infraestrutura antes de existir uma hipótese operacional para validar.

## Opções consideradas

### Logs sem estrutura e monitoramento manual

Seria rápido, mas dificultaria busca, agregação e diagnóstico automatizado.

### Stack externa completa

Prometheus, Grafana, OpenTelemetry e um serviço de alertas oferecem uma solução robusta, mas adicionam serviços, configuração e custo ao MVP.

### Baseline interno

Logs JSON, eventos de requisição, métricas simples em memória e health checks permitem aprender os contratos de observabilidade com pouca infraestrutura.

## Decisão

Usaremos no MVP:

- logs JSON em produção;
- evento de requisição com método, rota, status, duração e request ID;
- eventos de compra sem conteúdo de prompt;
- `/health/live` para verificar processo;
- `/health/ready` para verificar SQLite;
- `/metrics` com contadores e timings em JSON.

## Consequências

- diagnóstico local e inicial fica simples;
- os logs podem ser consumidos por ferramentas externas depois;
- métricas são perdidas quando o processo reinicia;
- `/metrics` ainda não possui autenticação;
- não há retenção, alertas ou dashboard;
- a Wave de segurança deverá revisar a exposição dos endpoints;
- Prometheus ou outro backend poderá substituir o armazenamento interno sem alterar os eventos do domínio.

## Validação

Testes verificam contadores, timings, health check saudável, falha de banco e resposta do endpoint de métricas. O servidor real deve retornar respostas JSON 200 para os health checks em condições normais.
