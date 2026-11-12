# ADR-004: Catálogo inicial em JSON versionado

## Status

Aceita

## Contexto

O MVP precisa exibir produtos antes de implementar administração, persistência de catálogo ou cadastro de vendedores. Os prompts são dados de exemplo controlados pelo projeto e não precisam ser editados por usuários durante esta fase.

## Opções consideradas

### Produtos definidos diretamente no código

Seria a solução com menos arquivos, mas misturaria dados de produto com comportamento da aplicação e dificultaria validar ou revisar o catálogo separadamente.

### Catálogo em JSON versionado

Mantém os dados fora do código Ruby, permite revisão independente e não exige banco ou painel administrativo.

### Catálogo no SQLite

Prepararia o sistema para administração e alteração de produtos, mas adicionaria migração, persistência e regras que ainda não são necessárias para a leitura do catálogo.

## Decisão

O catálogo inicial será armazenado em `data/products.json` e carregado pelo serviço `ProductCatalog` durante a preparação da aplicação.

Cada produto deve conter:

- `id` textual e único;
- `title` não vazio;
- `description` não vazia;
- `content` não vazio;
- `price` inteiro positivo.

O conteúdo completo será mantido no servidor e não será incluído nas views públicas de listagem ou detalhes.

## Consequências

- alterações no catálogo passam por revisão e deploy;
- um JSON inválido impede a aplicação de iniciar corretamente;
- o catálogo não pode ser editado em produção sem nova versão;
- não precisamos de banco ou painel administrativo nesta wave;
- a futura migração para tabela `products` deverá preservar IDs e regras de acesso.

## Validação

Testes devem cobrir:

- carregamento do catálogo válido;
- preço não inteiro ou não positivo;
- campos ausentes ou vazios;
- IDs duplicados;
- produto inexistente;
- conteúdo completo ausente das respostas públicas.
