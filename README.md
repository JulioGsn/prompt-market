# Projeto de Engenharia de Software

Este repositório será um laboratório prático para aprender e reforçar engenharia de software construindo um produto pequeno, do início ao fim.

O produto inicial será um pequeno ecommerce de prompts de IA. Cada produto terá título, descrição e valor em créditos. O usuário terá um saldo inicial criado automaticamente e poderá adquirir prompts usando esses créditos, sem checkout ou pagamento externo na primeira versão.

A aplicação será construída com Ruby on Rails e SQLite. O primeiro incremento Rails substitui o protótipo exploratório em Rust e mantém o foco no domínio e no ciclo completo de engenharia.

## Produto inicial: Prompt Store

### Visão

Permitir que usuários descubram e adquiram prompts de IA de forma simples, usando créditos internos. O produto será um domínio pequeno, mas com regras de negócio suficientes para exercitar consistência, segurança e evolução.

### Primeiro escopo funcional

- exibir um catálogo de prompts;
- mostrar título, descrição e valor de cada prompt;
- criar ou disponibilizar um usuário com saldo inicial;
- permitir adquirir um prompt quando houver saldo suficiente;
- debitar os créditos da conta;
- liberar o prompt adquirido para o usuário;
- registrar a compra;
- impedir saldo negativo e compras duplicadas indevidas.

### Decisões iniciais

- não haverá checkout nem integração com pagamento na primeira versão;
- haverá um usuário pré-configurado;
- esse usuário receberá 100 créditos iniciais;
- não haverá depósito de créditos inicialmente;
- prompts serão produtos digitais;
- o conteúdo completo será liberado somente após a compra;
- os preços serão números inteiros de créditos;
- uma tentativa de comprar novamente um produto já adquirido informará que ele já foi adquirido;
- o catálogo inicial será lido de um arquivo JSON versionado;
- o usuário poderá adquirir vários prompts na mesma sessão;
- a implementação será evoluída em incrementos pequenos e verificáveis.

### Fora do escopo inicial

- pagamentos reais;
- depósito ou saque de créditos;
- múltiplos vendedores;
- comissões;
- avaliações e comentários;
- cupons e promoções;
- recomendação personalizada;
- edição colaborativa de prompts;
- integração com provedores de modelos de IA.

### Critérios de aceitação iniciais

- o usuário consegue visualizar o catálogo;
- cada produto exibe título, descrição e preço em créditos;
- o usuário consegue visualizar seu saldo;
- o saldo inicial exibido é de 100 créditos;
- uma compra com saldo suficiente é concluída uma única vez;
- uma compra sem saldo suficiente é rejeitada sem alterar o saldo;
- após a compra, o prompt fica disponível para o usuário;
- o conteúdo completo não fica disponível antes da compra;
- uma nova tentativa para um prompt já adquirido informa que ele já foi adquirido;
- o usuário consegue adquirir mais de um prompt na mesma sessão;
- o saldo e o histórico refletem a operação realizada;
- falhas não deixam uma compra parcialmente concluída.

### Evolução do domínio

O conceito de saldo será tratado inicialmente da forma mais simples que atenda aos requisitos. Quando o domínio exigir, poderemos evoluir para uma carteira com extrato imutável de créditos, idempotência, auditoria, reversão e integração com pagamentos. Essa evolução será justificada por requisitos e riscos concretos, não adicionada antecipadamente.

## Objetivo

Desenvolver a capacidade de conduzir um software por todo o seu ciclo de vida:

- entender um problema e especificar requisitos;
- projetar uma solução simples e sustentável;
- implementar com qualidade;
- validar o comportamento com testes e feedback;
- entregar e operar o software;
- observar, medir e proteger o sistema;
- evoluir e manter o produto com segurança.

O foco não é apenas fazer o site funcionar. Cada mudança deve ser uma oportunidade de praticar decisões técnicas, comunicação, automação, análise de trade-offs e disciplina de engenharia.

## Princípios do projeto

1. **Aprender fazendo:** cada conceito deve aparecer em uma mudança executável no repositório.
2. **Começar pequeno:** evitar complexidade prematura e adicionar apenas o necessário.
3. **Tornar o trabalho visível:** registrar decisões, requisitos, riscos, resultados de testes e incidentes.
4. **Qualidade desde o início:** automação, revisão e feedback rápido fazem parte do desenvolvimento, não são etapas finais.
5. **Evolução incremental:** cada incremento deve ser pequeno, verificável e reversível quando possível.
6. **Entender antes de copiar:** ferramentas e padrões serão usados com uma justificativa clara.

## Fases de engenharia

As fases não serão necessariamente lineares. O objetivo é praticar o ciclo completo e aprender a voltar a uma fase anterior quando novas informações surgirem.

### 1. Descoberta e especificação

- definir o problema, o público e o contexto;
- identificar objetivos e não objetivos;
- escrever requisitos funcionais e não funcionais;
- definir critérios de aceitação;
- registrar premissas, riscos e perguntas em aberto;
- decidir como saberemos se o produto é útil.

**Artefatos esperados:** visão do produto, requisitos, casos de uso ou histórias, critérios de aceitação e registro de decisões.

### 2. Projeto

- escolher a arquitetura proporcional ao problema;
- definir interfaces, dados e responsabilidades;
- analisar alternativas e trade-offs;
- considerar desempenho, confiabilidade, segurança e operação;
- definir uma estratégia de evolução e migração quando necessário.

**Artefatos esperados:** descrição da arquitetura, diagramas simples quando ajudarem, contratos e decisões arquiteturais.

### 3. Implementação

- configurar o projeto Rails e as ferramentas de desenvolvimento;
- estabelecer convenções de código e formatação;
- implementar incrementos pequenos;
- revisar código e manter o histórico compreensível;
- documentar o que precisa ser conhecido para executar o sistema.

### 4. Validação e testes

- testar requisitos e critérios de aceitação;
- combinar testes unitários, de integração e ponta a ponta conforme a necessidade;
- validar erros, limites, entradas inválidas e regressões;
- usar análise estática, linting, formatação e revisão;
- separar testes rápidos de verificações mais caras.

### 5. Entrega e operação

- empacotar e publicar o software de forma reproduzível;
- criar CI para validar toda mudança;
- criar CD quando houver um ambiente seguro para entrega;
- configurar logs, métricas, traces e health checks;
- acompanhar disponibilidade, latência, erros e uso;
- definir como diagnosticar e reverter uma falha.

### 6. Segurança e manutenção

- modelar ameaças e reduzir a superfície de ataque;
- validar entradas e proteger segredos;
- manter dependências atualizadas e verificadas;
- aplicar princípio do menor privilégio;
- fazer backup e testar restauração quando houver dados;
- revisar dívida técnica, custos, documentação e riscos;
- aprender com incidentes por meio de postmortems sem culpabilização.

## Trilha técnica inicial

Esta é uma hipótese de sequência, não um compromisso rígido:

1. Especificação mínima do Prompt Store e critérios de aceitação.
2. Aplicação Rails com SQLite e página inicial testada.
3. Catálogo de prompts e página de detalhes.
4. Usuário inicial, saldo e aquisição de um prompt.
5. Persistência, migrações e transações SQLite.
6. Testes automatizados e qualidade local com `bin/rails test`, RuboCop, Brakeman e Bundler Audit.
7. Containerização e execução reproduzível.
8. CI com testes, lint, análise de segurança e build.
9. Deploy em um ambiente simples de hospedagem.
10. Logs estruturados, métricas, tracing e endpoint de saúde.
11. Configuração, segredos, segurança HTTP e modelo de ameaças.
12. Histórico de compras, extrato de créditos e idempotência.
13. Pagamento real ou depósito de créditos, somente se o produto justificar.
14. Evolução orientada por feedback, métricas e manutenção contínua.

Nenhuma tecnologia será adicionada apenas para parecer moderna. A escolha deverá responder a um requisito, risco operacional ou objetivo de aprendizado.

## Qualidade que vamos praticar

- requisitos claros e verificáveis;
- design simples e explícito;
- testes adequados ao risco;
- builds reproduzíveis;
- integração contínua;
- entrega contínua com possibilidade de rollback;
- observabilidade: logs, métricas, traces e alertas úteis;
- segurança de aplicação, infraestrutura e cadeia de dependências;
- documentação próxima do código e das decisões;
- revisão de código e histórico Git compreensível;
- acessibilidade, compatibilidade e desempenho quando aplicáveis;
- consistência transacional e auditabilidade das operações de créditos;
- recuperação de falhas e aprendizado operacional.

## Registro de decisões

Decisões relevantes serão registradas no repositório, preferencialmente junto do contexto, das alternativas consideradas e das consequências. Quando a quantidade justificar, usaremos Architecture Decision Records (ADRs).

## Definition of Done

Uma mudança estará concluída quando, conforme o seu escopo:

- o comportamento esperado estiver descrito;
- os critérios de aceitação estiverem atendidos;
- o código estiver formatado e lintado;
- testes relevantes estiverem passando;
- riscos e limitações estiverem registrados;
- a documentação necessária estiver atualizada;
- a mudança puder ser entregue e observada;
- houver uma forma conhecida de diagnosticar ou reverter problemas.

Para o primeiro `Hello World`, a Definition of Done será menor. Ela crescerá junto com o produto e com os riscos reais. Operações envolvendo créditos terão critérios adicionais de consistência e auditabilidade.

## Como vamos trabalhar

Cada incremento deve responder a quatro perguntas:

1. Qual problema ou hipótese estamos tratando?
2. Como saberemos que a mudança funcionou?
3. Quais riscos estamos aceitando?
4. O que aprendemos e qual é o próximo passo?

O README funcionará como mapa de alto nível. Requisitos, decisões, runbooks, planos de teste e outros detalhes serão separados em documentos quando isso melhorar a clareza.

## Próximo passo

As waves de catálogo, aquisição, persistência e observabilidade estão concluídas. A próxima wave será a revisão de segurança antes de qualquer exposição pública:

- revisar autenticação e o modo privado do MVP;
- proteger métricas e conteúdo adquirido;
- revisar headers, CSRF, sessões e segredos;
- validar entradas e limites de compra;
- registrar o modelo de ameaças.

O marco atual é: **ter um fluxo de compra persistente e diagnosticável antes de preparar o deploy**.

## Status das waves

### Wave 1: Fundação Rails

Concluída:

- aplicação Rails 8.1 com SQLite;
- página inicial server-side;
- CSS responsivo local;
- teste de integração da página inicial;
- RuboCop sem offenses;
- Brakeman sem warnings;
- Bundler Audit sem vulnerabilidades conhecidas;
- banco SQLite preparado localmente;
- decisão registrada em `docs/adr/003-migracao-de-rust-para-rails.md`.

### Wave 2: Catálogo

Concluída:

- definir o formato do catálogo JSON;
- validar produtos na inicialização;
- exibir listagem e detalhes;
- manter o conteúdo completo protegido;
- testar produto válido e produto inexistente.

Também foi registrada a decisão de catálogo em `docs/adr/004-catalogo-inicial-em-json.md`.

### Wave 3: Domínio de aquisição

Concluída:

- implementar o usuário pré-configurado com 100 créditos;
- validar saldo e preço;
- validar o domínio inicialmente em memória;
- impedir aquisição repetida;
- liberar o conteúdo somente após aquisição;
- testar compra aprovada, saldo insuficiente e repetição.

O estado em memória foi uma etapa temporária para validar o domínio antes da persistência. A decisão está registrada em `docs/adr/005-aquisicao-em-memoria-na-wave-3.md`.

### Wave 4: Persistência SQLite

Concluída:

- criar migrações para usuário e aquisições;
- substituir o store em memória por Active Record;
- preservar as regras e os testes do domínio;
- garantir débito e aquisição na mesma transação;
- testar reinicialização e falhas de persistência.

O schema usa constraints para saldo não negativo, preço positivo e aquisição única por usuário/produto. A decisão está registrada em `docs/adr/006-persistencia-em-sqlite.md`.

### Wave 5: Observabilidade

Concluída:

- adicionar logs estruturados;
- registrar requisições e resultados de compra sem expor prompts;
- criar health checks de aplicação e banco;
- definir métricas básicas de erro, latência e aquisições;
- testar diagnóstico de uma falha conhecida.

O baseline usa logs JSON em produção, métricas internas e health checks. A decisão e as limitações estão em `docs/adr/007-observabilidade-baseline.md`.

### Wave 6: Segurança

Concluída:

- revisar autenticação e modo privado;
- proteger conteúdo e endpoints operacionais;
- revisar CSRF, headers, sessões e segredos;
- validar entradas, abuso e limites de compra;
- documentar ameaças e riscos aceitos.

O MVP agora é privado em produção com Basic Auth, CSP e headers de segurança. Health checks continuam públicos para monitoramento. A decisão está registrada em `docs/adr/008-mvp-privado-e-headers-de-seguranca.md`.

### Wave 7: Container e deploy

Próxima:

- criar imagem Docker mínima e executar como usuário não-root;
- persistir o volume SQLite;
- preparar schema e seeds no procedimento de deploy;
- configurar Caddy, domínio e HTTPS;
- configurar secrets sem versioná-los;
- definir backup, restauração, rollback e monitoramento externo.

## Pendências operacionais antes do deploy

- provisionar `SECRET_KEY_BASE`, `RAILS_MASTER_KEY` e credenciais Basic Auth;
- executar `bin/rails db:prepare db:seed` no ambiente de produção;
- configurar TLS e `force_ssl` atrás do proxy;
- definir retenção e destino externo dos backups SQLite;
- configurar monitoramento externo para health checks;
- decidir retenção de logs, alertas e dashboard de métricas;
- manter `/metrics` restrito à rede ou autenticação operacional;
- testar rollback e restauração antes de considerar o deploy concluído.

## Execução local

Requisitos:

- Ruby instalado;
- Bundler instalado;

Para iniciar o servidor:

```bash
bin/rails server
```

Em outro terminal, consulte `http://127.0.0.1:3000/` ou execute:

```bash
curl http://127.0.0.1:3000/
```

Verificações locais:

```bash
bin/rails test
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
```

## Camada visual inicial

A primeira interface usa views server-side do Rails e CSS local. Isso mantém o frontend no mesmo projeto e evita uma cadeia de build JavaScript enquanto o domínio ainda está sendo construído. Hotwire poderá ser avaliado quando houver uma interação real que justifique atualizações parciais de páginas.
