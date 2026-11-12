# Guia de Engenharia do Projeto

Este arquivo orienta agentes de IA e colaboradores humanos que trabalham neste repositório. Ele não é apenas um manual de execução: é um instrumento pedagógico para tornar explícitos o raciocínio, as decisões e os aprendizados de cada etapa do projeto.

O produto é o **Prompt Store**, um ecommerce pequeno de prompts de IA. O objetivo principal do repositório é praticar engenharia de software de forma completa e criar um registro reutilizável do processo.

## Objetivos de aprendizagem

Ao trabalhar neste projeto, devemos praticar conscientemente:

- descoberta e especificação de problemas;
- modelagem de domínio e definição de requisitos;
- projeto de arquitetura proporcional ao produto;
- implementação incremental;
- testes em diferentes níveis;
- integração e entrega contínuas;
- segurança, confiabilidade e observabilidade;
- manutenção, evolução e comunicação técnica;
- uso criterioso de IA e agentes na engenharia.

O objetivo não é maximizar a quantidade de tecnologia. O objetivo é compreender por que uma decisão foi tomada, quais alternativas existiam, quais riscos foram aceitos e como verificar o resultado.

## Modo professor

Toda mudança relevante deve ser conduzida em **modo professor**. Antes de implementar, o agente deve explicar, de forma concisa e concreta:

1. qual problema está sendo resolvido;
2. qual requisito ou hipótese dá origem à mudança;
3. quais alternativas foram consideradas;
4. por que a solução escolhida é adequada agora;
5. quais riscos, limitações e dívidas permanecem;
6. como o resultado será validado;
7. o que foi aprendido e qual é o próximo passo.

A explicação deve ser proporcional à mudança. Não é necessário produzir uma aula abstrata para uma alteração trivial, mas não se deve esconder uma decisão importante atrás de código gerado.

Quando uma decisão ainda não estiver madura, registrar a dúvida em vez de inventar uma certeza. Quando houver mais de uma solução razoável, apresentar o trade-off e escolher a alternativa mais simples que atenda ao requisito atual.

## Ordem de trabalho

Cada incremento deve passar por estas etapas, mesmo que algumas sejam pequenas:

### 1. Descoberta e especificação

Definir o problema antes da tecnologia.

Registrar:

- usuário ou ator envolvido;
- problema e contexto;
- objetivo do incremento;
- requisitos funcionais;
- requisitos não funcionais relevantes;
- não objetivos;
- critérios de aceitação;
- premissas, riscos e perguntas abertas.

Para o Prompt Store, a primeira regra de negócio importante é a aquisição de um prompt usando um saldo inicial. Essa regra deve ser descrita antes de decidir sua implementação.

### 2. Projeto

Escolher a menor arquitetura capaz de atender aos requisitos atuais.

Analisar:

- componentes e responsabilidades;
- modelo de domínio;
- fluxos principais e fluxos de erro;
- contratos entre partes do sistema;
- persistência e consistência;
- segurança e controle de acesso;
- operação, observabilidade e recuperação;
- alternativas descartadas e motivo do descarte.

Não criar abstrações, serviços ou infraestrutura antecipadamente. Uma abstração só deve existir quando reduzir complexidade real, proteger uma variação provável ou melhorar testabilidade de maneira comprovável.

### 3. Implementação

Implementar em incrementos pequenos e revisáveis.

Regras:

- manter o código simples e explícito;
- seguir as convenções da linguagem e do projeto;
- não alterar comportamento não relacionado sem justificativa;
- manter a documentação próxima do comportamento que ela descreve;
- tratar erros de forma explícita;
- evitar segredos no código e no histórico;
- preferir mudanças que possam ser revertidas com segurança.

O agente deve descrever quais arquivos foram alterados e qual responsabilidade cada alteração possui. Código gerado por IA deve ser lido, entendido e validado como qualquer outro código.

### 4. Validação e testes

Validar o comportamento, não apenas a execução feliz.

Considerar, conforme o risco:

- testes unitários para regras isoladas;
- testes de integração para componentes reais;
- testes de contrato para interfaces;
- testes ponta a ponta para fluxos críticos;
- testes de erro, limites, concorrência e repetição;
- análise estática, formatação e lint;
- revisão manual dos critérios de aceitação.

Para a compra de prompts, validar no mínimo:

- compra com saldo suficiente;
- rejeição sem saldo suficiente;
- saldo nunca negativo;
- acesso liberado somente após compra concluída;
- tentativa repetida não gera cobrança indevida;
- falha não deixa débito sem aquisição ou aquisição sem débito;
- preço efetivamente pago fica registrado.

Testes não devem depender de aleatoriedade, horário, rede ou estado global não controlado. Quando uma dependência externa for necessária, usar dublês nos testes rápidos e testes de integração explícitos para a dependência real.

### 5. Entrega e operação

Tratar execução e entrega como parte do produto.

Documentar:

- como executar localmente;
- como configurar o ambiente;
- como construir e testar;
- como publicar;
- como verificar saúde após uma publicação;
- como diagnosticar falhas;
- como reverter uma versão;
- quais sinais devem ser observados.

CI deve executar verificações determinísticas e rápidas o suficiente para fornecer feedback útil. CD só deve ser adicionado quando houver uma estratégia mínima de ambiente, configuração, rollback e observação.

### 6. Segurança e manutenção

Revisar segurança a cada evolução, não apenas antes do lançamento.

Para este produto, observar especialmente:

- autenticação e autorização;
- exposição indevida de prompts comprados;
- validação e escaping de conteúdo;
- proteção de credenciais e configurações;
- dependências e cadeia de build;
- abuso de endpoints de compra;
- concorrência e dupla cobrança;
- privacidade de usuários e histórico;
- auditoria de operações com créditos.

Riscos aceitos devem ser escritos. Uma limitação conhecida e documentada é preferível a uma falsa aparência de segurança.

## Decisões atuais

Estas decisões são a referência atual e podem mudar quando novas informações justificarem a mudança:

| Decisão | Motivo | Consequência |
| --- | --- | --- |
| O produto é um ecommerce de prompts de IA | Possui interface simples e regras de negócio reais | Permite evoluir de catálogo para operações transacionais |
| O produto de catálogo tem título, descrição e valor | Define um primeiro modelo mínimo | O conteúdo completo e seus metadados podem crescer depois |
| A compra usa créditos internos | Evita começar com um provedor de pagamento | Precisamos preservar invariantes de saldo e aquisição |
| Não há checkout na primeira versão | Mantém o foco no domínio e no fluxo principal | Depósito e pagamento real ficam para uma etapa posterior |
| Há um usuário pré-configurado com 100 créditos | Permite testar o fluxo sem implementar cadastro e depósito | O saldo inicial precisa ser explícito e reproduzível |
| O conteúdo completo só é liberado após a compra | Exercita autorização sobre um produto digital | O catálogo público não pode expor o prompt adquirido |
| Preços são inteiros e o usuário pode comprar vários prompts na sessão | Mantém a unidade de crédito simples no MVP | O saldo deve ser atualizado de forma consistente a cada compra |
| Uma compra repetida informa que o produto já foi adquirido | Evita cobrança duplicada e torna o comportamento explícito | A aquisição precisa ser consultada antes de debitar o saldo |
| O catálogo inicial fica em JSON versionado | Separa dados de implementação sem exigir banco ou painel | O formato deve ter validação e mudanças exigem deploy |
| O projeto usa Ruby on Rails com SQLite | Reduz complexidade incidental e acelera o ciclo web completo | Precisamos estudar as convenções, transações e limites do framework |
| A Wave 4 usa store SQLite com Active Record | Mantém saldo e aquisições após reinício sem serviço separado | Uma instância e baixo volume são limites aceitos no MVP |
| A Wave 5 usa observabilidade interna | Cria logs, métricas e health checks sem plataforma externa | Métricas reiniciam com o processo e endpoints ainda precisam de proteção |
| A Wave 6 mantém o MVP privado em produção | Evita expor uma conta compartilhada antes de implementar identidade | Basic Auth é temporário e TLS/deploy ainda precisam ser configurados |
| A Wave 7A usa Docker Compose local | Reproduz a execução e preserva SQLite em volume antes da VPS | HTTPS, backup externo e rollback ficam para a Wave 7B |

Mudanças nessas decisões devem ser registradas com contexto, alternativas, decisão nova e impacto.

## Artefatos por fase

O projeto deve acumular artefatos pequenos, úteis e versionados. Não criar documentos apenas para preencher uma lista.

### Descoberta

- visão do produto;
- requisitos e não requisitos;
- histórias ou casos de uso;
- critérios de aceitação;
- glossário do domínio;
- riscos e perguntas abertas.

### Projeto

- descrição da arquitetura;
- modelo de domínio;
- contratos e interfaces;
- decisões arquiteturais;
- modelo de ameaças quando houver superfície relevante;
- decisões de persistência e consistência.

### Implementação

- código executável;
- instruções de desenvolvimento;
- convenções do projeto;
- exemplos de configuração sem segredos;
- histórico Git compreensível.

### Validação

- estratégia de testes;
- testes automatizados;
- evidências de validação;
- resultados e limitações conhecidas;
- checklist de Definition of Done.

### Entrega e operação

- pipeline CI/CD;
- instruções de deploy;
- health check;
- logs, métricas e traces relevantes;
- runbook;
- plano de rollback;
- registro de incidentes e aprendizados.

### Manutenção

- backlog técnico;
- atualizações de dependências;
- revisões de segurança;
- mudanças de schema e migrações;
- postmortems quando aplicável;
- justificativas para remoção ou substituição de componentes.

## Registro de uma decisão

Para decisões que merecem vida própria, usar um ADR ou seção equivalente com este formato:

```md
# ADR-NNN: Título da decisão

## Status

Proposta | Aceita | Substituída | Rejeitada

## Contexto

Qual problema ou restrição motivou a decisão?

## Opções consideradas

Quais alternativas foram analisadas?

## Decisão

O que foi escolhido e por quê?

## Consequências

Quais benefícios, custos, riscos e dívidas foram aceitos?

## Validação

Como saberemos se a decisão continua adequada?
```

## Uso de IA e agentes

IA é uma ferramenta de aceleração e exploração, não uma autoridade técnica.

Agentes devem:

- inspecionar o contexto antes de alterar arquivos;
- declarar suposições relevantes;
- propor mudanças pequenas;
- não inventar resultados de testes ou fontes;
- verificar o código gerado;
- executar validações adequadas;
- destacar incertezas e riscos;
- preservar mudanças existentes de outros colaboradores;
- atualizar a documentação quando a mudança alterar uma decisão ou contrato.

O operador humano continua responsável pelo entendimento e pela aprovação das decisões. Quando o objetivo for pedagógico, explicar também o caminho que levou à solução, não apenas entregar o resultado.

## Definition of Done pedagógica

Além da Definition of Done do README, um incremento de aprendizagem só está completo quando:

- é possível explicar o problema que ele resolve;
- os requisitos e critérios de aceitação estão localizáveis;
- a decisão técnica principal está registrada;
- os testes cobrem o risco relevante;
- as limitações conhecidas estão explícitas;
- o comando ou procedimento de validação foi executado;
- o aprendizado pode ser reutilizado em outro projeto.

## Preservação do conhecimento

O conhecimento não deve ficar apenas no histórico da conversa com agentes.

Ao final de cada marco, registrar:

- o que foi construído;
- por que foi construído daquela forma;
- o que deu errado;
- como foi diagnosticado;
- quais alternativas foram descartadas;
- quais conceitos gerais podem ser reutilizados;
- quais decisões devem ser revistas no futuro.

O README apresenta o mapa do projeto. Este arquivo apresenta o método de trabalho. Documentos específicos, ADRs, testes, runbooks e histórico Git preservam as evidências detalhadas.

## Entregáveis finais de conhecimento

Ao final do projeto, produzir dois artefatos derivados do repositório:

### Skill reutilizável

Uma skill deve condensar práticas e decisões que possam ser aplicadas em projetos futuros, incluindo:

- preparação e descoberta;
- padrões de especificação;
- critérios para escolher arquitetura e tecnologias;
- estratégia de testes;
- práticas de CI/CD;
- segurança e observabilidade;
- uso de agentes com verificação humana;
- erros comuns e formas de evitá-los;
- checklists reutilizáveis.

Ela deve explicar princípios e critérios, não apenas repetir comandos específicos deste projeto.

### Apresentação HTML autocontida

O site final deve contar a história do projeto do início ao fim, incluindo:

- problema e evolução da visão;
- requisitos e mudanças de escopo;
- arquitetura e decisões importantes;
- tecnologias utilizadas e motivos;
- testes e validações;
- CI/CD;
- segurança e observabilidade;
- incidentes, limitações e aprendizados;
- o que seria feito diferente;
- como aplicar o conhecimento em projetos futuros.

O HTML deve ser autocontido, sem depender de serviços externos para sua apresentação básica. As informações devem ser derivadas de documentos e evidências versionados, não reconstruídas apenas pela memória ao final.

## Regra final

Nunca adicionar uma tecnologia apenas para marcar uma caixa de seleção. Cada ferramenta, padrão ou etapa deve responder a uma necessidade do produto, a um risco real ou a um objetivo explícito de aprendizagem.


## Communication rules

- Prioritize information that affects my decisions.
- Do not narrate routine tool calls.
- Report only meaningful milestones and blockers.
- Final response:
  - Status: DONE / PARTIAL / BLOCKED
  - Changed: one sentence
  - Verification: tests and results
  - Attention: risks or decisions requiring me
- Keep summaries under 100 words when practical.
- Never hide errors or skipped tests.
- Provide detailed reasoning and logs on request.
