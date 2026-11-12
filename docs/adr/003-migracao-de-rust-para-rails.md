# ADR-003: Migração de Rust para Ruby on Rails

## Status

Aceita

## Contexto

O produto é um ecommerce pequeno de prompts, com catálogo, formulários, persistência, regras de créditos e operações transacionais. O objetivo principal do projeto é praticar o ciclo completo de engenharia de software e recuperar confiança nas fases de descoberta, projeto, implementação, validação, entrega e manutenção.

O protótipo inicial em Rust com Axum e Askama validou um servidor HTTP e uma página HTML, mas exigiria mais código incidental para CRUD, formulários, migrações e convenções de uma aplicação web tradicional.

## Opções consideradas

### Continuar com Rust, Axum e Askama

Vantagens:

- tipos e contratos explícitos;
- aprendizado aprofundado de Rust;
- controle detalhado sobre a composição da aplicação.

Desvantagens:

- mais decisões de infraestrutura web para um ecommerce pequeno;
- maior distância até CRUD, migrações e formulários;
- risco de o aprendizado da linguagem dominar o aprendizado do processo de engenharia.

### Ruby on Rails

Vantagens:

- convenções fortes para aplicações web;
- Active Record e migrações integrados;
- geradores para reduzir trabalho repetitivo;
- suporte natural a HTML server-side e SQLite;
- ferramentas de teste, segurança e deploy no ecossistema;
- menor tempo entre requisito e incremento executável.

Desvantagens:

- convenções podem esconder detalhes importantes;
- é necessário estudar o que os geradores produzem;
- abstrações do framework podem mascarar SQL e transações se não forem examinadas;
- Ruby e Rails passam a ser o novo ecossistema de aprendizado.

## Decisão

O Prompt Store será implementado em **Ruby on Rails 8 com SQLite**.

O protótipo Rust será preservado apenas no histórico desta fase e não continuará como segunda aplicação no diretório principal. A documentação, os requisitos, os critérios de aceitação e os aprendizados do protótipo serão reaproveitados.

Usaremos as convenções do Rails, mas os geradores não substituirão o entendimento do código. Cada modelo, migração, controller, view e teste gerado deverá ser lido e relacionado a um requisito.

## Consequências

### Benefícios

- maior velocidade para construir e testar o domínio do Prompt Store;
- mais tempo disponível para praticar transações, segurança, CI/CD e operação;
- SQLite reduz a infraestrutura inicial;
- o projeto pode evoluir como um monólito modular.

### Custos e riscos

- precisamos aprender Ruby, Rails e Active Record;
- SQLite limita o cenário inicial a uma instância e baixo volume;
- o framework pode esconder comportamento se não revisarmos SQL, callbacks e transações;
- o caminho de migração para outro banco deverá ser documentado se o produto crescer.

## Validação

A decisão será considerada adequada enquanto:

- conseguirmos implementar incrementos de negócio menores e mais claros;
- os testes cobrirem as regras importantes;
- o comportamento transacional puder ser explicado e verificado;
- o framework não impedir a observabilidade, segurança ou operação necessárias;
- o tempo economizado for investido em engenharia, não apenas em geração de código.

## Aprendizado esperado

Comparar uma aplicação explícita em Rust com uma aplicação convencional em Rails ajuda a separar complexidade essencial do domínio da complexidade incidental do framework. A lição não é escolher sempre a ferramenta mais produtiva, mas reconhecer quando uma convenção libera atenção para riscos mais importantes.
