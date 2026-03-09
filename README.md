# Chess Analyzer

Aplicação web para análise de partidas de xadrez, treinamento e estudo de aberturas.
O sistema combina um motor de xadrez local (Stockfish), dados da Lichess API e um modelo de linguagem (LLM) para oferecer análises detalhadas e explicações das jogadas.

---

## Sumário

- [Visão Geral da Arquitetura](#visão-geral-da-arquitetura)
- [Stack Tecnológica](#stack-tecnológica)
- [Componentes](#componentes)
  - [Frontend](#frontend)
  - [Backend](#backend)
  - [Serviços Externos](#serviços-externos)
  - [Persistência](#persistência)
- [Fluxo de Dados](#fluxo-de-dados)
- [Diagrama de Classes (Backend)](#diagrama-de-classes-backend)
- [Como Executar](#como-executar)
- [Variáveis de Ambiente](#variáveis-de-ambiente)

---

## Visão Geral da Arquitetura

```mermaid
flowchart TD
    USER(["Usuário"])

    subgraph FE["Frontend — React"]
        BOARD["Tabuleiro Interativo"]
        ANALYSIS_UI["Painel de Análise"]
        TRAINING_UI["Painel de Treino"]
    end

    subgraph BE["Backend — Spring Boot / Java 21"]
        subgraph CTRL["Controllers"]
            CC["ChessController"]
            UC["UserController"]
            AC["AnalysisController"]
        end

        subgraph SVC["Services"]
            AS["AnalysisService"]
            ES["ExplanationService"]
            OS["OpeningService"]
            TS["TrainingService"]
        end

        subgraph MCP["Spring AI + MCP Orchestrator"]
            T1["Tool: analisar_posicao()"]
            T2["Tool: buscar_abertura()"]
            T3["Tool: explicar_jogada()"]
            T4["Tool: classificar_erro()"]
        end
    end

    subgraph EXT["Serviços Externos"]
        SF["Stockfish\nprocesso UCI local"]
        LC["Lichess API\naberturas e puzzles"]
        LLM["LLM API\nClaude / GPT-4o"]
    end

    subgraph DB["Persistência"]
        PG[("PostgreSQL")]
        RD[("Redis cache")]
    end

    USER        -- "envia FEN / PGN"     --> BOARD
    BOARD       -- "REST / JSON"         --> CC
    CC          --> AS
    AS          --> MCP
    MCP         -- "UCI"                 --> SF
    MCP         -- "HTTP"                --> LC
    MCP         -- "HTTP"                --> LLM
    AS          --> ES
    AS          --> OS
    AC          --> TS
    AS          -- "salva análise"       --> PG
    UC          -- "salva partida"       --> PG
    AS          -- "cache"               --> RD
    ES          -- "explicação"          --> ANALYSIS_UI
    TS          -- "puzzles e relatório" --> TRAINING_UI
    ANALYSIS_UI -- "exibe"               --> USER
```

---

## Stack Tecnológica

| Camada            | Tecnologia                          |
|-------------------|-------------------------------------|
| Frontend          | React                               |
| Backend           | Java 21 + Spring Boot               |
| Orquestração IA   | Spring AI + MCP (Model Context Protocol) |
| Motor de xadrez   | Stockfish (processo UCI local)      |
| Aberturas/Puzzles | Lichess API                         |
| Modelo de linguagem | Claude / GPT-4o                   |
| Banco de dados    | PostgreSQL                          |
| Cache             | Redis                               |

---

## Componentes

### Frontend

| Componente       | Descrição                                                      |
|------------------|----------------------------------------------------------------|
| Tabuleiro Interativo | Interface principal para entrada de posições em FEN ou PGN |
| Painel de Análise    | Exibe a avaliação da posição e as explicações das jogadas   |
| Painel de Treino     | Apresenta puzzles e relatórios de progresso do usuário      |

### Backend

#### Controllers

| Controller         | Responsabilidade                                    |
|--------------------|-----------------------------------------------------|
| `ChessController`  | Recebe posições (FEN/PGN) e aciona a análise        |
| `UserController`   | Gerencia autenticação e persistência de partidas    |
| `AnalysisController` | Gerencia histórico de análises e sessões de treino |

#### Services

| Service              | Responsabilidade                                              |
|----------------------|---------------------------------------------------------------|
| `AnalysisService`    | Coordena o pipeline de análise, aciona o MCP Orchestrator     |
| `ExplanationService` | Gera explicações em linguagem natural para cada jogada        |
| `OpeningService`     | Identifica e recupera informações sobre aberturas             |
| `TrainingService`    | Seleciona puzzles e gera relatórios de treinamento            |

#### MCP Orchestrator (Spring AI)

| Tool                   | Descrição                                                  |
|------------------------|------------------------------------------------------------|
| `analisar_posicao()`   | Envia a posição ao Stockfish e retorna avaliação e variante|
| `buscar_abertura()`    | Consulta a Lichess API para identificar a abertura jogada  |
| `explicar_jogada()`    | Solicita ao LLM uma explicação da jogada em linguagem natural |
| `classificar_erro()`   | Classifica erros táticos e estratégicos cometidos         |

### Serviços Externos

| Serviço     | Protocolo | Função                                              |
|-------------|-----------|-----------------------------------------------------|
| Stockfish   | UCI       | Avaliação de posições e cálculo de melhores variantes|
| Lichess API | HTTP/REST | Base de aberturas e puzzles                         |
| LLM API     | HTTP/REST | Geração de explicações em linguagem natural         |

### Persistência

| Armazenamento | Uso                                                        |
|---------------|------------------------------------------------------------|
| PostgreSQL    | Partidas, usuários, histórico de análises                  |
| Redis         | Cache de análises recentes para redução de latência        |

---

## Fluxo de Dados

1. O usuário envia uma posição em formato **FEN** ou **PGN** pelo tabuleiro interativo.
2. O frontend envia a requisição via **REST/JSON** para o `ChessController`.
3. O `ChessController` delega ao `AnalysisService`, que aciona o **MCP Orchestrator**.
4. O MCP Orchestrator executa em paralelo:
   - Envia a posição ao **Stockfish** via protocolo UCI para obter a avaliação.
   - Consulta a **Lichess API** para identificar a abertura.
   - Solicita ao **LLM** uma explicação da jogada.
5. O `AnalysisService` persiste a análise no **PostgreSQL** e armazena em cache no **Redis**.
6. O `ExplanationService` envia a explicação para o **Painel de Análise**.
7. O `TrainingService` gera puzzles e relatórios exibidos no **Painel de Treino**.
8. O usuário visualiza os resultados na interface.

---

## Diagrama de Classes (Backend)

```mermaid
classDiagram
    direction TB

    class ChessController {
        +analyzePosition(fen: String) : AnalysisResponse
        +analyzeGame(pgn: String) : AnalysisResponse
    }

    class UserController {
        +register(dto: UserDTO) : UserResponse
        +login(dto: LoginDTO) : TokenResponse
        +saveGame(pgn: String) : GameResponse
    }

    class AnalysisController {
        +getHistory(userId: Long) : List~AnalysisResponse~
        +getTrainingReport(userId: Long) : TrainingReport
    }

    class AnalysisService {
        -mcpOrchestrator: McpOrchestrator
        -explanationService: ExplanationService
        -openingService: OpeningService
        +analyze(fen: String) : AnalysisResult
        +analyzeGame(pgn: String) : AnalysisResult
        +saveAnalysis(result: AnalysisResult) void
    }

    class ExplanationService {
        -llmClient: LlmClient
        +explain(move: Move, context: PositionContext) : String
    }

    class OpeningService {
        -lichessClient: LichessClient
        +identify(pgn: String) : Opening
    }

    class TrainingService {
        -lichessClient: LichessClient
        +getPuzzles(userId: Long) : List~Puzzle~
        +generateReport(userId: Long) : TrainingReport
    }

    class McpOrchestrator {
        +analisarPosicao(fen: String) : EvalResult
        +buscarAbertura(pgn: String) : Opening
        +explicarJogada(move: Move) : String
        +classificarErro(move: Move) : ErrorType
    }

    ChessController    --> AnalysisService
    AnalysisController --> TrainingService
    AnalysisService    --> McpOrchestrator
    AnalysisService    --> ExplanationService
    AnalysisService    --> OpeningService
    McpOrchestrator    --> ExplanationService
```

---

## Como Executar

### Pré-requisitos

- Java 21
- Node.js 20+
- Docker e Docker Compose (para PostgreSQL e Redis)
- Stockfish instalado e disponível no PATH
- Chave de API para Claude ou GPT-4o

### Backend

```bash
# Suba os serviços de infraestrutura
docker compose up -d

# Execute o backend
./mvnw spring-boot:run
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

A aplicação estará disponível em `http://localhost:5173` e o backend em `http://localhost:8080`.

---

## Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto backend com as seguintes variáveis:

| Variável              | Descrição                                      |
|-----------------------|------------------------------------------------|
| `DATABASE_URL`        | URL de conexão com o PostgreSQL                |
| `REDIS_URL`           | URL de conexão com o Redis                     |
| `LLM_API_KEY`         | Chave de API do provedor de LLM (Claude/OpenAI)|
| `LLM_PROVIDER`        | Provedor do LLM: `anthropic` ou `openai`       |
| `STOCKFISH_PATH`      | Caminho absoluto para o executável do Stockfish|
| `LICHESS_API_TOKEN`   | Token de acesso à Lichess API (opcional)       |
