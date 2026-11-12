# Requisitos do MVP do Prompt Store

## Status

Proposta consolidada para o primeiro incremento funcional.

Este documento transforma as decisões atuais em comportamento verificável. Ele poderá mudar quando aprendermos mais durante o projeto; mudanças relevantes devem registrar contexto, motivo e impacto.

## 1. Contexto

O Prompt Store é um ecommerce pequeno de prompts de IA. Um prompt é tratado como um produto digital que pode ser descoberto no catálogo e adquirido por um usuário usando créditos internos.

O primeiro MVP não terá checkout, pagamento externo ou depósito de créditos. Para tornar o fluxo executável, haverá um usuário pré-configurado com 100 créditos iniciais.

## 2. Problema e objetivo

### Problema

Precisamos de um fluxo pequeno, mas realista, para exercitar catálogo, autorização, operação transacional, persistência e evolução segura de um produto digital.

### Objetivo do MVP

Permitir que o usuário pré-configurado:

- visualize os prompts disponíveis;
- consulte o preço e a descrição de cada produto;
- veja seu saldo;
- adquira um ou mais prompts usando créditos;
- acesse o conteúdo completo de cada prompt adquirido.

## 3. Atores

### Usuário

Pessoa que navega pelo catálogo e adquire prompts usando o saldo disponível.

### Sistema

Responsável por apresentar o catálogo, verificar saldo e aquisições anteriores, realizar a aquisição e controlar o acesso ao conteúdo.

Não haverá cadastro, login ou administração no MVP. O usuário pré-configurado representa o comprador inicial.

## 4. Escopo funcional

### RF-01: Exibir catálogo

O sistema deve exibir os prompts disponíveis com, no mínimo:

- identificador;
- título;
- descrição;
- preço inteiro em créditos.

O conteúdo completo do prompt não faz parte da visualização pública do catálogo.

### RF-02: Exibir saldo

O sistema deve exibir o saldo atual do usuário pré-configurado.

O saldo inicial deve ser de 100 créditos.

### RF-03: Exibir detalhes públicos

O sistema deve permitir consultar os dados públicos de um prompt sem revelar seu conteúdo completo antes da aquisição.

### RF-04: Adquirir prompt

O usuário deve conseguir adquirir um prompt quando:

- o produto existe;
- o preço é válido;
- o usuário ainda não adquiriu o produto;
- o saldo é maior ou igual ao preço.

Uma aquisição aprovada deve:

- debitar o preço do saldo;
- registrar a aquisição;
- registrar o preço efetivamente pago;
- liberar o conteúdo completo para o usuário.

### RF-05: Bloquear aquisição sem saldo

Quando o saldo for menor que o preço, o sistema deve rejeitar a aquisição, informar o motivo e preservar o saldo e o acesso do usuário.

### RF-06: Evitar aquisição duplicada

Quando o usuário tentar adquirir novamente um prompt já adquirido, o sistema deve informar que o produto já foi adquirido e não deve realizar nova cobrança.

### RF-07: Permitir várias aquisições

O usuário pode adquirir vários prompts na mesma sessão. Cada aquisição deve ser avaliada e registrada individualmente.

Neste MVP, “na mesma sessão” significa que não existe limite artificial de quantidade: o usuário pode realizar várias aquisições enquanto houver saldo e os produtos ainda não tiverem sido adquiridos. Não haverá carrinho ou checkout agrupado.

### RF-08: Acessar prompt adquirido

O conteúdo completo deve ser exibido somente quando existir uma aquisição válida para o usuário e para o produto solicitado.

## 5. Regras de negócio

### RN-01: Saldo inicial

O usuário pré-configurado começa com exatamente 100 créditos.

### RN-02: Unidade de preço

Preços e saldos são números inteiros de créditos. Não existem casas decimais no MVP.

### RN-03: Preço válido

Todo prompt comercializável deve possuir preço inteiro positivo.

### RN-04: Saldo suficiente

Uma aquisição só pode ser aprovada quando `saldo_atual >= preço`.

### RN-05: Saldo não negativo

Nenhuma operação pode concluir deixando o saldo do usuário abaixo de zero.

### RN-06: Preço pago

O registro da aquisição deve guardar o preço efetivamente pago, mesmo que o catálogo possa evoluir para permitir alteração de preço no futuro.

### RN-07: Atomicidade da aquisição

Uma aquisição deve resultar em todos estes efeitos ou em nenhum deles:

- débito do saldo;
- registro da aquisição;
- liberação do conteúdo.

Não pode existir débito sem aquisição nem aquisição sem débito correspondente.

### RN-08: Idempotência de repetição

Uma tentativa repetida de adquirir o mesmo prompt pelo mesmo usuário não pode criar nova cobrança.

### RN-09: Conteúdo protegido

O conteúdo completo não deve ser incluído em respostas públicas de catálogo ou detalhes antes da aquisição.

## 6. Modelo conceitual

### Product

Representa o prompt comercializado.

Campos mínimos:

- `id`;
- `title`;
- `description`;
- `content`;
- `price`.

O catálogo inicial será lido de `data/products.json`. O arquivo é versionado, validado durante a preparação da aplicação e não será servido como arquivo público.

### User

Representa o usuário pré-configurado.

Campos mínimos:

- `id`;
- `credits`.

### Acquisition

Representa a aquisição de um produto por um usuário.

Campos mínimos:

- `user_id`;
- `product_id`;
- `paid_price`;
- `acquired_at`, quando o mecanismo de persistência exigir data;
- identificador próprio, se necessário pela implementação.

Uma combinação de usuário e produto deve representar no máximo uma aquisição concluída no MVP.

## 7. Fluxos principais

### Fluxo A: consultar catálogo

1. O usuário acessa o catálogo.
2. O sistema carrega produtos válidos.
3. O sistema exibe título, descrição e preço.
4. O sistema não exibe o conteúdo completo.

### Fluxo B: adquirir produto com saldo suficiente

1. O usuário consulta um produto.
2. O sistema verifica que o produto existe.
3. O sistema verifica que o usuário ainda não o adquiriu.
4. O sistema verifica que há saldo suficiente.
5. O sistema debita o preço.
6. O sistema registra a aquisição e o preço pago.
7. O sistema libera o conteúdo completo.
8. O sistema apresenta o novo saldo.

### Fluxo C: adquirir produto sem saldo suficiente

1. O usuário solicita a aquisição.
2. O sistema verifica o saldo.
3. O sistema rejeita a operação.
4. O sistema informa que o saldo é insuficiente.
5. O saldo e as aquisições permanecem inalterados.

### Fluxo D: repetir aquisição

1. O usuário solicita um produto já adquirido.
2. O sistema identifica a aquisição existente.
3. O sistema informa que o produto já foi adquirido.
4. O sistema não debita créditos novamente.

### Fluxo E: consultar conteúdo protegido

1. O usuário solicita o conteúdo completo de um produto.
2. O sistema verifica se existe aquisição válida.
3. Se existir, o sistema exibe o conteúdo.
4. Se não existir, o sistema nega o acesso sem revelar o conteúdo.

## 8. Critérios de aceitação

### CA-01: saldo inicial

```text
Dado o usuário pré-configurado
Quando o sistema é iniciado ou o usuário é consultado
Então seu saldo é de 100 créditos
```

### CA-02: catálogo público

```text
Dado um catálogo com pelo menos um prompt válido
Quando o usuário consulta o catálogo
Então vê título, descrição e preço do prompt
E não vê o conteúdo completo
```

### CA-03: compra aprovada

```text
Dado um usuário com 100 créditos
E um prompt com preço 30
E o usuário ainda não adquiriu o prompt
Quando o usuário realiza a aquisição
Então a operação é aprovada
E o saldo passa a ser 70
E a aquisição é registrada com preço pago igual a 30
E o conteúdo completo fica disponível
```

### CA-04: saldo insuficiente

```text
Dado um usuário com 10 créditos
E um prompt com preço 30
Quando o usuário tenta realizar a aquisição
Então a operação é rejeitada
E o saldo continua sendo 10
E o conteúdo completo continua protegido
```

### CA-05: aquisição repetida

```text
Dado um usuário que já adquiriu um prompt
Quando tenta adquirir o mesmo prompt novamente
Então recebe a informação de que o produto já foi adquirido
E não sofre novo débito
```

### CA-06: várias aquisições

```text
Dado um usuário com saldo suficiente para dois produtos
Quando adquire o primeiro e depois o segundo
Então ambas as aquisições são registradas
E o saldo é reduzido pela soma dos preços
E ambos os conteúdos ficam disponíveis
```

### CA-07: falha sem operação parcial

```text
Dado que ocorre uma falha durante a aquisição
Quando a operação termina com erro
Então não existe débito sem aquisição
E não existe aquisição sem débito correspondente
```

## 9. Requisitos não funcionais do MVP

- execução local reproduzível;
- comportamento determinístico nos testes;
- ausência de dependência de pagamento externo;
- erros apresentados sem expor conteúdo protegido;
- validação dos dados do catálogo na inicialização ou no carregamento;
- código formatado, lintado e testado;
- documentação suficiente para executar e validar o sistema.

Requisitos de disponibilidade, escala e desempenho serão definidos quando houver um ambiente de deploy e uma hipótese de uso que justifique suas medições.

## 10. Não objetivos

- checkout;
- pagamento real;
- depósito de créditos;
- cadastro e autenticação de usuários;
- múltiplos vendedores;
- carrinho;
- avaliações;
- recomendações;
- integração direta com modelos de IA;
- painel administrativo completo.

## 11. Perguntas ainda abertas

Estas perguntas não impedem o próximo incremento, mas devem ser respondidas antes de dependerem da implementação:

- quais convenções e componentes Rails serão adotados em cada wave;
- quando o catálogo deverá migrar de JSON para uma tabela persistida;
- qual formato de erro será usado pela interface;
- como o arquivo SQLite será respaldado e restaurado no ambiente de deploy;
- como o usuário pré-configurado será identificado na interface;
- quais dados de exemplo representarão prompts reais sem expor conteúdo de terceiros sem autorização.

## 12. Estratégia de validação

O primeiro conjunto de testes deve cobrir as regras de negócio sem depender de HTTP, banco, horário ou aleatoriedade. Depois, testes de integração devem verificar a composição entre armazenamento, serviço de aquisição e interface HTTP.

O resultado será considerado validado quando os critérios CA-01 a CA-07 forem cobertos por testes automatizados ou por uma justificativa explícita para qualquer critério ainda manual.
