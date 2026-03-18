<div align="center">

# ♟ Chess Analyzer

**Analise suas partidas. Entenda seus erros. Evolua de verdade.**

Motor Stockfish + Lichess API + IA generativa — tudo em um só lugar, em português.

[![CI Backend](https://github.com/seu-usuario/chess-analyzer/actions/workflows/ci-backend.yml/badge.svg)](https://github.com/seu-usuario/chess-analyzer/actions/workflows/ci-backend.yml)
[![CI Frontend](https://github.com/seu-usuario/chess-analyzer/actions/workflows/ci-frontend.yml/badge.svg)](https://github.com/seu-usuario/chess-analyzer/actions/workflows/ci-frontend.yml)
[![Coverage](https://codecov.io/gh/seu-usuario/chess-analyzer/branch/main/graph/badge.svg)](https://codecov.io/gh/seu-usuario/chess-analyzer)
[![Release](https://img.shields.io/github/v/release/seu-usuario/chess-analyzer)](https://github.com/seu-usuario/chess-analyzer/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-25-orange)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5-green)](https://spring.io/projects/spring-boot)
[![Open in GitHub Codespaces](https://img.shields.io/badge/Open%20in-Codespaces-black?logo=github)](https://codespaces.new/seu-usuario/chess-analyzer)

<br/>

<!-- Substitua pela URL do seu GIF gravado após o primeiro deploy -->
![Chess Analyzer em ação](docs/assets/demo.gif)

</div>

---

## O que é

Chess Analyzer é uma aplicação web open source para análise de partidas de xadrez. Você cola uma posição FEN ou importa um PGN completo e recebe, em segundos: a avaliação do Stockfish, a abertura identificada via Lichess e uma explicação em linguagem natural gerada por IA sobre o que aconteceu em cada lance — e por quê.

Sem cadastro em plataformas externas. Sem limite de partidas. Você hospeda, você controla.

---

## Funcionalidades

-  **Análise com Stockfish** — avaliação de posições FEN e partidas PGN completas, com profundidade configurável e integração nativa via Project Panama (Java 25)
-  **Explicações por IA** — cada lance explicado em português pelo Claude ou GPT-4o, adaptado ao seu nível (iniciante, intermediário, avançado)
-  **Identificação de aberturas** — reconhecimento automático com código ECO, nome e estatísticas de vitória via Lichess Explorer
-  **Classificação de erros** — blunders, mistakes e inaccuracies identificados automaticamente com contexto tático e estratégico
-  **Treino com puzzles** — puzzles selecionados com base nos seus erros mais frequentes, com dificuldade adaptativa
-  **Relatório de progresso** — acurácia por semana, distribuição de erros e suas aberturas mais jogadas
-  **Modo offline** — análise técnica completa mesmo sem chave de LLM configurada

---

## Demo

<div align="center">

| Análise de posição | Classificação de erros | Painel de treino |
|---|---|---|
| ![análise](docs/assets/screenshot-analysis.png) | ![erros](docs/assets/screenshot-errors.png) | ![treino](docs/assets/screenshot-training.png) |

</div>

---

## Quick Start

> Pré-requisitos: [Docker](https://docs.docker.com/get-docker/) e [Java 25](https://adoptium.net/).

```bash
# 1. Clone e entre no projeto
git clone https://github.com/seu-usuario/chess-analyzer.git
cd chess-analyzer

# 2. Configure as variáveis de ambiente
cp .env.example .env
# Edite o .env com sua chave de LLM e o caminho do Stockfish

# 3. Suba tudo
make dev
```

A aplicação estará disponível em **http://localhost:5173**.

Quer contribuir ou configurar do zero? Veja o [Guia de Desenvolvimento →](docs/DEVELOPMENT.md)

Quer hospedar em produção? Veja o [Guia de Self-Hosting →](docs/SELF_HOSTING.md)

---

## Stack

| Camada | Tecnologia |
|---|---|
| Frontend | React + TypeScript + Vite |
| Backend | Java 25 + Spring Boot 3.5 |
| Motor de xadrez | Stockfish via Project Panama (FFM API) |
| Orquestração de IA | Spring AI + MCP |
| Modelo de linguagem | Claude / GPT-4o (configurável) |
| Aberturas e puzzles | Lichess API |
| Banco de dados | PostgreSQL + Flyway |
| Cache | Redis |

---

## Documentação

| Documento | Descrição |
|---|---|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Decisões arquiteturais, diagramas e fluxo de dados |
| [DEVELOPMENT.md](docs/DEVELOPMENT.md) | Como rodar localmente, testes e estrutura do projeto |
| [API.md](docs/API.md) | Endpoints REST com exemplos de request e response |
| [SELF_HOSTING.md](docs/SELF_HOSTING.md) | Variáveis de ambiente, Docker e configuração em produção |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Como contribuir com o projeto |
| [SECURITY.md](SECURITY.md) | Política de divulgação responsável de vulnerabilidades |

---

## Contribuindo

Contribuições são muito bem-vindas. Se é sua primeira vez, comece pelas issues com a label [`good first issue`](https://github.com/seu-usuario/chess-analyzer/labels/good%20first%20issue).

Veja o [Guia de Contribuição completo →](CONTRIBUTING.md)

[![Contributors](https://contrib.rocks/image?repo=seu-usuario/chess-analyzer)](https://github.com/vitinh0z/project-athena/graphs/contributors)

---

## Roadmap

Acompanhe o progresso do projeto pelos [Milestones do GitHub →](https://github.com/vitinh0z/project-athena/milestones)

---

## Licença

Distribuído sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.

---

<div align="center">

Feito com ♟ e ☕

**[⭐ Deixe uma star se o projeto te ajudou](https://github.com/seu-usuario/chess-analyzer)**

</div>
