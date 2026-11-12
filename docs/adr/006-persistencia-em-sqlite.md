# ADR-006: Persistência de créditos e aquisições em SQLite

## Status

Aceita

## Contexto

O store em memória da Wave 3 validou as regras de aquisição, mas o saldo e as compras eram perdidos quando o processo reiniciava. O MVP precisa sobreviver ao reinício e manter a relação entre usuário, saldo e produtos adquiridos.

O produto ainda terá uma única instância e baixo volume. Não há requisito atual para múltiplos servidores, alta disponibilidade ou um banco remoto.

## Opções consideradas

### Continuar em memória

É simples, mas não atende persistência nem permite testar o comportamento real após reinicialização.

### SQLite com Active Record

Fornece persistência local, migrações, constraints e transações sem exigir um serviço separado. É adequado para uma instância pequena e mantém o foco no domínio.

### PostgreSQL

Oferece mais capacidade para concorrência, replicação e múltiplas instâncias, mas adicionaria um serviço operacional antes de haver necessidade de escala.

## Decisão

Usaremos SQLite como banco do MVP e Active Record como camada de persistência.

O schema inicial contém:

- `users.credits`, com valor inteiro não negativo;
- `acquisitions.user_id`;
- `acquisitions.product_id`;
- `acquisitions.paid_price`;
- timestamps da aquisição;
- índice único em `(user_id, product_id)`.

A aquisição ocorre em uma transação. O saldo é atualizado somente quando a conta possui créditos suficientes, e o registro da aquisição é criado na mesma transação. O índice único protege contra aquisição duplicada no nível do banco.

## Consequências

### Benefícios

- saldo e aquisições sobrevivem ao reinício;
- regras importantes também estão protegidas por constraints do banco;
- os testes usam o banco real da aplicação;
- não precisamos operar um serviço PostgreSQL no MVP.

### Custos e riscos

- a aplicação fica limitada inicialmente a uma instância e baixo volume;
- o arquivo SQLite precisa estar em armazenamento persistente no deploy;
- backups e restauração do arquivo precisam ser planejados;
- migração para PostgreSQL poderá ser necessária se houver múltiplas instâncias ou maior concorrência.

## Validação

Testes cobrem compra aprovada, saldo insuficiente, repetição, múltiplas aquisições e rollback. A adequação do SQLite deverá ser revista antes de escalar horizontalmente ou publicar para muitos usuários.
