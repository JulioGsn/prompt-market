# ADR-005: Aquisição em memória na Wave 3

## Status

Substituída por ADR-006

## Contexto

Precisamos validar as regras de aquisição antes de misturá-las com migrações, queries e ciclo de vida do banco. O MVP possui um único usuário pré-configurado e ainda não precisa sobreviver ao reinício do processo nesta etapa.

## Opções consideradas

### Implementar SQLite imediatamente

Resolveria persistência desde o início, mas misturaria regras de saldo, transação e acesso ao banco no primeiro teste do domínio.

### Armazenar estado em memória

Permite exercitar a regra de negócio com testes rápidos e uma implementação pequena. O estado é protegido por `Mutex` para que a operação de aquisição seja indivisível dentro do processo.

### Usar sessão HTTP

Seria inadequado para o saldo, pois sessões não são o lugar correto para representar uma operação de crédito e dificultariam a futura consistência transacional.

## Decisão

Usaremos `InMemoryPurchaseStore` na Wave 3. Ele mantém:

- saldo inicial de 100 créditos;
- aquisições por produto;
- preço efetivamente pago;
- prevenção de aquisição repetida;
- rejeição de saldo insuficiente;
- exclusão de efeitos parciais sob o mesmo lock.

O estado é compartilhado pelo único usuário pré-configurado e reinicia quando o processo reinicia ou quando o ambiente de desenvolvimento recarrega a aplicação. Isso é uma limitação explícita, não uma característica de produção.

## Consequências

- testes de domínio são rápidos e independentes de SQLite;
- o controller conhece apenas o contrato do store;
- o saldo não sobrevive ao reinício;
- a aplicação ainda não pode ser escalada para múltiplos processos;
- a Wave 4 deverá preservar os comportamentos e substituir a implementação por uma transação SQLite.

## Validação

Os testes cobrem compra aprovada, saldo insuficiente, aquisição repetida, várias aquisições, preço pago e liberação do conteúdo pela interface HTTP.
