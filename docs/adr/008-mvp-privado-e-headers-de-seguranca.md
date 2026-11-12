# ADR-008: MVP privado e headers de segurança

## Status

Aceita para o MVP

## Contexto

O produto possui um usuário pré-configurado e ainda não tem cadastro, login por usuário ou isolamento entre contas. Publicá-lo sem proteção faria qualquer visitante compartilhar a mesma conta, saldo e aquisições.

Também precisamos reduzir riscos comuns de navegador antes de preparar um deploy.

## Opções consideradas

### Publicar sem autenticação

É simples, mas não protege o conteúdo adquirido nem o saldo compartilhado. Foi rejeitado.

### Implementar autenticação completa

Resolveria identidade individual, mas adicionaria cadastro, sessões, recuperação de acesso e novos requisitos ao MVP atual.

### Proteger o MVP inteiro com Basic Auth

Mantém o produto privado para o operador, permite deploy real e adia autenticação de usuários até existir requisito para múltiplas contas.

## Decisão

Em produção:

- a aplicação e `/metrics` exigem Basic Auth;
- credenciais vêm de `PROMPT_STORE_USERNAME` e `PROMPT_STORE_PASSWORD`;
- credenciais ausentes fazem a aplicação responder `503` nas rotas privadas;
- `/health/live` e `/health/ready` permanecem acessíveis para monitoramento;
- o conteúdo completo continua protegido pela regra de aquisição;
- CSP e headers de segurança são aplicados;
- segredos não são versionados.

TLS, `force_ssl` e terminação HTTPS ficam para a wave de proxy/deploy.

## Consequências

- o MVP não deve ser tratado como ecommerce público;
- Basic Auth é uma barreira operacional temporária, não autenticação de produto;
- métricas ficam protegidas em produção;
- os endpoints de health revelam apenas estado genérico;
- ainda não há rate limiting, gestão de usuários ou auditoria completa;
- o deploy precisa fornecer schema, seeds e segredos antes de aceitar tráfego autenticado.

## Validação

O smoke test de produção confirmou:

- health público com `200`;
- aplicação sem credenciais com `401`;
- métricas sem credenciais com `401`;
- aplicação e métricas com credenciais válidas com `200`.

Testes também verificam CSP, headers, CSRF provido pelo Rails e comparação segura das credenciais.
