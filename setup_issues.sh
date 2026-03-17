#!/usr/bin/env bash
# ============================================================
#  Chess Analyzer — GitHub Issues Setup
#  Requer: gh CLI autenticado (gh auth login)
#  Idempotente: pula labels, milestones e issues já existentes
# ============================================================
set -euo pipefail

# ─────────────────── Validação inicial ──────────────────────
if ! command -v gh &>/dev/null; then
  echo "❌ GitHub CLI (gh) não encontrado. Instale em https://cli.github.com/" >&2
  exit 1
fi

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null) || {
  echo "❌ Não foi possível detectar o repositório." >&2
  echo "   Execute o script dentro do diretório do projeto Git." >&2
  exit 1
}

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║        Chess Analyzer — GitHub Setup             ║"
echo "╠══════════════════════════════════════════════════╣"
echo "║  Repositório : $REPO"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ─────────────────────── HELPERS ────────────────────────────

label_exists() {
  gh api "repos/$REPO/labels" --paginate -q '.[].name' 2>/dev/null \
    | grep -qx "$1"
}

create_label() {
  local name="$1" color="$2" desc="$3"
  if label_exists "$name"; then
    echo "  ⏭  Label '$name' já existe."
  else
    gh api "repos/$REPO/labels" -X POST \
      -f name="$name" -f color="$color" -f description="$desc" >/dev/null
    echo "  ✅ Label '$name' criada."
  fi
}

milestone_exists() {
  gh api "repos/$REPO/milestones?state=all&per_page=100" \
    -q '.[].title' 2>/dev/null | grep -qx "$1"
}

create_milestone() {
  local title="$1" desc="$2"
  if milestone_exists "$title"; then
    echo "  ⏭  Milestone '$title' já existe."
  else
    gh api "repos/$REPO/milestones" -X POST \
      -f title="$title" -f description="$desc" >/dev/null
    echo "  ✅ Milestone '$title' criada."
  fi
}

issue_exists() {
  local title="$1"
  local count
  count=$(gh issue list --state all --search "\"$title\" in:title" \
    --json title -q "[.[] | select(.title == \"$title\")] | length" \
    2>/dev/null || echo 0)
  [ "${count:-0}" -gt 0 ]
}

create_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"
  local milestone="$4"

  if issue_exists "$title"; then
    echo "  ⏭  Issue já existe: $title"
    return 0
  fi

  local args=(
    --title "$title"
    --body  "$body"
  )
  [[ -n "$labels"    ]] && args+=(--label     "$labels")
  [[ -n "$milestone" ]] && args+=(--milestone "$milestone")

  gh issue create "${args[@]}" >/dev/null
  echo "  ✅ Issue criada: $title"
}

# ═══════════════════════════════════════════════════════════
#  LABELS
# ═══════════════════════════════════════════════════════════
echo "──────────────────────────────────────────────────"
echo "  🏷  Criando labels..."
echo "──────────────────────────────────────────────────"

create_label "backend"       "0075ca" "Código do servidor Spring Boot"
create_label "frontend"      "e4e669" "Código React / UI"
create_label "devops"        "c5def5" "CI/CD, Docker, infraestrutura"
create_label "qa"            "f9d0c4" "Testes e qualidade de código"
create_label "performance"   "fef2c0" "Otimizações de desempenho e latência"
create_label "stockfish"     "1d76db" "Integração com Stockfish via Project Panama"
create_label "mcp"           "b60205" "Model Context Protocol / Spring AI tools"
create_label "database"      "5319e7" "PostgreSQL, JPA e migrações Flyway"
create_label "cache"         "0e8a16" "Redis e estratégia de cache"
create_label "llm"           "d4c5f9" "Integração com LLM (Claude / GPT-4o)"
create_label "security"      "e11d48" "Autenticação, JWT e CORS"
create_label "documentation" "bfd4f2" "README, Swagger e JavaDoc"
create_label "setup"         "ededed" "Configuração inicial do projeto"
create_label "lichess"       "7057ff" "Integração com Lichess API"

# ═══════════════════════════════════════════════════════════
#  MILESTONES
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  🏁  Criando milestones..."
echo "──────────────────────────────────────────────────"

MS1="M1 – Setup & Infraestrutura"
MS2="M2 – Domínio & Persistência"
MS3="M3 – Integração Stockfish (Panama)"
MS4="M4 – Serviços Externos"
MS5="M5 – MCP & Orquestração IA"
MS6="M6 – API REST & Services"
MS7="M7 – Frontend React"
MS8="M8 – Performance & Cache"
MS9="M9 – DevOps & CI/CD"
MS10="M10 – QA & Testes"

create_milestone "$MS1"  "Repositório, Docker Compose, profiles Spring, variáveis de ambiente"
create_milestone "$MS2"  "Domain models, Value Objects, JPA entities, Flyway, Repositories, Mappers"
create_milestone "$MS3"  "StockfishEngine via FFM API (Project Panama – Java 25), StockfishPort"
create_milestone "$MS4"  "LichessClient (aberturas/puzzles), AIExplanationClient via Spring AI"
create_milestone "$MS5"  "MCPOrchestrator, ToolRegistry, AnalyzePosition, FindOpening, ExplainMove, ClassifyError"
create_milestone "$MS6"  "Controllers REST, Application Services, GlobalExceptionHandler, Redis Cache"
create_milestone "$MS7"  "Tabuleiro interativo, painel de análise, painel de treino, autenticação JWT"
create_milestone "$MS8"  "Execução paralela, cache Redis, índices PostgreSQL, Actuator + Micrometer"
create_milestone "$MS9"  "Dockerfiles multi-stage, GitHub Actions CI e CD"
create_milestone "$MS10" "Testes unitários, integração (Testcontainers), E2E (Playwright), carga (k6)"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M1: Setup & Infraestrutura
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS1"
echo "──────────────────────────────────────────────────"

create_issue \
"[SETUP] Configurar repositório e estrutura base do projeto" \
"## Motivo
Sem uma estrutura de repositório bem definida desde o início o projeto acumula dívida técnica e dificulta a colaboração. Este issue garante que todos partam da mesma base organizada.

## Checklist
- [ ] Criar/revisar \`.gitignore\` cobrindo Java, Node, IDEs e \`.env\`
- [ ] Revisar \`README.md\` (já existe) e manter sincronizado com cada milestone
- [ ] Adicionar \`LICENSE\`
- [ ] Configurar \`.editorconfig\` para padronizar indentação (4 espaços Java / 2 JS)
- [ ] Definir branch strategy: \`main\` / \`develop\` / \`feature/*\` / \`fix/*\`
- [ ] Habilitar regras de proteção na branch \`main\` (PR obrigatório + CI verde)
- [ ] Criar template de Pull Request (\`.github/pull_request_template.md\`)
- [ ] Criar templates de Issues: bug report e feature request
- [ ] Configurar \`CODEOWNERS\` se houver mais de um contribuidor" \
"setup,documentation" "$MS1"

create_issue \
"[DEVOPS] Configurar Docker Compose para PostgreSQL e Redis" \
"## Motivo
A aplicação depende de PostgreSQL e Redis. Um \`docker-compose.yml\` pronto elimina instalação manual e garante que todos os desenvolvedores usem as mesmas versões, evitando divergências de ambiente.

## Checklist
- [ ] Criar \`docker-compose.yml\` na raiz do projeto
- [ ] Serviço \`postgres:16-alpine\` com volume nomeado persistente
- [ ] Serviço \`redis:7-alpine\` com volume nomeado persistente
- [ ] Expor portas padrão apenas via \`127.0.0.1\` (5432, 6379) para evitar exposição acidental
- [ ] Adicionar \`healthcheck\` em cada serviço
- [ ] Criar rede interna \`chess-net\` para isolamento
- [ ] Criar \`.env.example\` documentando todas as variáveis necessárias
- [ ] Testar \`docker compose up -d\` e conectividade dos serviços
- [ ] Documentar no README como subir a infraestrutura local" \
"devops,database,cache" "$MS1"

create_issue \
"[SETUP] Configurar variáveis de ambiente e profiles Spring" \
"## Motivo
Separar configurações sensíveis do código-fonte é fundamental para segurança e portabilidade entre ambientes. Profiles Spring garantem que cada ambiente tenha suas próprias configurações sem alteração de código.

## Checklist
- [ ] Criar \`application.yml\` com configurações comuns a todos os profiles
- [ ] Criar \`application-dev.yml\` apontando para serviços locais Docker
- [ ] Criar \`application-prod.yml\` lendo exclusivamente de variáveis de ambiente
- [ ] Criar \`@ConfigurationProperties\` para: \`LlmProperties\`, \`StockfishProperties\`, \`LichessProperties\`
- [ ] Mapear: \`DATABASE_URL\`, \`REDIS_URL\`, \`LLM_API_KEY\`, \`LLM_PROVIDER\`, \`STOCKFISH_PATH\`, \`LICHESS_API_TOKEN\`
- [ ] Validar propriedades com \`@Validated\` e \`@NotBlank\` no startup
- [ ] Garantir que \`.env\` e secrets estão no \`.gitignore\`
- [ ] Documentar todas as variáveis no README (tabela já existente — preencher descrições)" \
"backend,setup,devops" "$MS1"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M2: Domínio & Persistência
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS2"
echo "──────────────────────────────────────────────────"

create_issue \
"[BACKEND] Implementar domain models e Value Objects" \
"## Motivo
Os domain models são o núcleo da arquitetura hexagonal. Implementá-los com Value Objects ricos garante que as regras de negócio fiquem no lugar correto, sem vazar para camadas de infraestrutura ou API.

## Checklist

### Entidades de domínio
- [ ] \`User\`: id, username, email, passwordHash, createdAt
- [ ] \`Game\`: id, pgn (VO), white, black, result, playedAt, userId
- [ ] \`Move\`: notation, fenBefore, fenAfter, evaluation, errorType, explanation
- [ ] \`Analysis\`: id, fen, engineResult, explanation, opening, createdAt
- [ ] \`GameAnalysis\`: associação 1-N entre Game e lista de Analysis por lance
- [ ] \`Opening\`: eco, name, pgn, winRateWhite, winRateBlack, drawRate
- [ ] \`OpeningStats\`: userId, opening, totalGames, wins, draws, losses
- [ ] \`Puzzle\`: id, fen, solution (lista de lances), difficulty, themes, rating
- [ ] \`Report\`: userId, period, accuracyAvg, blundersTotal, mistakesTotal, openingsStats
- [ ] \`EngineResult\`: score (centipawns), mateIn, bestMove, pv, depth

### Value Objects
- [ ] \`Fen\`: construtor valida formato FEN (regex + verificação de campos)
- [ ] \`Pgn\`: valida PGN mínimo (tags + lances)
- [ ] \`Evaluation\`: encapsula score, distingue centipawns de mate
- [ ] \`ReportType\`: enum (WEEKLY, MONTHLY, ALL_TIME)

### Qualidade
- [ ] \`equals\` / \`hashCode\` / \`toString\` em todos os VOs
- [ ] Testes unitários para os VOs com casos válidos e inválidos" \
"backend,database" "$MS2"

create_issue \
"[BACKEND] Configurar JPA entities e migrações Flyway" \
"## Motivo
Usar Flyway garante que o schema do banco evolui de forma controlada, versionada e reproduzível em todos os ambientes. Sem isso, mudanças de schema viram operações manuais propensas a erro.

## Checklist

### Dependências
- [ ] Adicionar \`flyway-core\` ao \`pom.xml\`
- [ ] Adicionar \`flyway-database-postgresql\`

### JPA Entities (\`infrastructure.persistence.entity\`)
- [ ] Anotar todas as entities com \`@Entity\`, \`@Table\`, \`@Id\`, \`@GeneratedValue\`
- [ ] Configurar \`@OneToMany\` / \`@ManyToOne\` com \`FetchType.LAZY\` padrão
- [ ] Adicionar \`@CreatedDate\` / \`@LastModifiedDate\` com JPA Auditing

### Migrações Flyway (\`resources/db/migration\`)
- [ ] \`V1__create_users.sql\`
- [ ] \`V2__create_games.sql\`
- [ ] \`V3__create_analysis.sql\`
- [ ] \`V4__create_openings.sql\`
- [ ] \`V5__create_puzzles.sql\`
- [ ] \`V6__create_reports.sql\`

### Repositories (\`infrastructure.persistence.repository\`)
- [ ] \`UserRepository extends JpaRepository<UserEntity, Long>\`
- [ ] \`GameRepository\` com query de histórico paginado por userId
- [ ] \`AnalysisRepository\` com busca por hash da FEN
- [ ] Testar migrações em banco limpo via Testcontainers" \
"backend,database" "$MS2"

create_issue \
"[BACKEND] Implementar mappers (domain ↔ entity ↔ DTO)" \
"## Motivo
Na arquitetura hexagonal as conversões entre camadas devem ser explícitas e centralizadas. Mappers evitam que lógica de conversão se espalhe pelo código e facilitam mudanças de schema ou contrato de API.

## Checklist
- [ ] Avaliar uso de MapStruct para reduzir boilerplate (recomendado)
- [ ] \`GameMapper\`: domain Game ↔ GameDTO
- [ ] \`AnalysisMapper\`: domain Analysis ↔ AnalysisDTO
- [ ] \`MoveMapper\`: domain Move ↔ MoveDTO
- [ ] \`GameEntityMapper\`: domain Game ↔ JPA GameEntity
- [ ] \`AnalysisEntityMapper\`: domain Analysis ↔ JPA AnalysisEntity
- [ ] \`MoveEntityMapper\`: domain Move ↔ JPA MoveEntity
- [ ] Cobrir cada mapper com testes unitários (round-trip: domain → entity → domain)" \
"backend" "$MS2"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M3: Stockfish via Project Panama
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS3"
echo "──────────────────────────────────────────────────"

create_issue \
"[STOCKFISH] Implementar StockfishEngine via Project Panama (FFM API – Java 25)" \
"## Motivo
A integração via Foreign Function & Memory API (Project Panama, estável desde Java 22 — JEP 454) é a abordagem mais performática para comunicação nativa em Java 25. Elimina overhead de subprocesso UCI e permite invocar a biblioteca nativa do Stockfish diretamente via \`MethodHandle\`, reduzindo latência de análise e simplificando gerenciamento de recursos com \`Arena\`.

## Contexto técnico
- \`SymbolLookup.libraryLookup(path, arena)\` carrega a shared lib nativa
- \`Linker.nativeLinker().downcallHandle()\` cria handles para funções C do Stockfish
- \`Arena\` gerencia o ciclo de vida da memória nativa (auto-close)
- \`MemorySegment\` representa strings e buffers passados ao engine

## Checklist

### Preparação
- [ ] Atualizar \`pom.xml\`: \`<java.version>25</java.version>\`
- [ ] Adicionar JVM flag: \`--enable-native-access=ALL-UNNAMED\` no \`spring-boot-maven-plugin\`
- [ ] Documentar como compilar Stockfish como shared library (\`libstockfish.so\` / \`.dylib\` / \`.dll\`)

### Implementação FFM
- [ ] Criar \`StockfishFFMBridge\`: carrega lib via \`SymbolLookup.libraryLookup()\`
- [ ] Implementar wrapper do protocolo UCI sobre a bridge (isready, ucinewgame, position, go)
- [ ] Usar \`Arena.ofConfined()\` para escopo controlado de memória nativa
- [ ] Garantir \`arena.close()\` via try-with-resources

### StockfishEngine
- [ ] Implementar \`StockfishEngine implements StockfishPort\`
- [ ] \`EvalResult analyze(Fen fen, int depth)\`
- [ ] \`List<String> getTopMoves(Fen fen, int n)\`
- [ ] \`String getPrincipalVariation(Fen fen)\`
- [ ] Fallback via subprocesso UCI (\`ProcessBuilder\`) caso a lib nativa não esteja disponível

### Testes
- [ ] Teste de integração: posição inicial → score ≈ 0, depth ≥ 15
- [ ] Teste de integração: posição de mate em 1 → score = mate, melhor lance correto
- [ ] Teste de liberação de memória: nenhum leak após 1000 análises" \
"backend,stockfish,performance" "$MS3"

create_issue \
"[STOCKFISH] Definir contrato StockfishPort e configuração" \
"## Motivo
A interface \`StockfishPort\` desacopla o domínio da implementação concreta da FFM API. Isso permite usar um mock nos testes de services e trocar a estratégia de integração sem alterar nenhuma regra de negócio.

## Checklist
- [ ] Definir contrato completo em \`StockfishPort\`
  - [ ] \`EvalResult analyze(Fen fen, int depth)\`
  - [ ] \`List<String> getTopMoves(Fen fen, int n)\`
- [ ] Criar \`StockfishProperties\` (\`@ConfigurationProperties(\"stockfish\")\`)
  - [ ] \`path\`: caminho para a shared library ou executável
  - [ ] \`depth\`: profundidade padrão de análise
  - [ ] \`threads\`: número de threads do engine
  - [ ] \`hashMb\`: tamanho do hash table em MB
- [ ] Registrar bean com \`@ConditionalOnProperty\` para alternar entre FFM e subprocesso
- [ ] Adicionar smoke test no startup: envia \`isready\` e verifica resposta \`readyok\`
- [ ] Criar \`StockfishMockPort\` para uso nos testes unitários de services" \
"backend,stockfish" "$MS3"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M4: Serviços Externos
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS4"
echo "──────────────────────────────────────────────────"

create_issue \
"[BACKEND] Implementar LichessClient (aberturas e puzzles)" \
"## Motivo
A Lichess API fornece dados ricos de aberturas (Explorer) e puzzles de alta qualidade. Centralizar a integração em \`LichessClient\` facilita retry, rate limiting, circuit breaker e mock em testes, tornando o sistema resiliente a falhas externas.

## Checklist
- [ ] Implementar \`LichessClient implements LichessPort\`
- [ ] Configurar \`RestClient\` (Spring 6) com base URL e timeout
- [ ] Endpoint de abertura: \`GET https://explorer.lichess.ovh/masters?fen={fen}\`
- [ ] Endpoint de puzzles: \`GET https://lichess.org/api/puzzle/next\`
- [ ] Autenticação via \`Authorization: Bearer \${LICHESS_API_TOKEN}\`
- [ ] Implementar retry com backoff exponencial (Resilience4j ou Spring Retry)
- [ ] Implementar circuit breaker para degradação graciosa quando Lichess estiver fora
- [ ] Mapear JSON de resposta para \`Opening\` e \`Puzzle\` do domínio
- [ ] Tratar resposta vazia (abertura desconhecida) com valor padrão
- [ ] Testes com WireMock simulando respostas da Lichess (200, 429, 503)" \
"backend,lichess" "$MS4"

create_issue \
"[BACKEND] Implementar AIExplanationClient via Spring AI" \
"## Motivo
O Spring AI abstrai a comunicação com diferentes provedores de LLM. Usar \`ChatClient\` permite trocar de provedor (Claude → GPT-4o ou vice-versa) apenas por configuração, sem alterar nenhum código de negócio.

## Checklist
- [ ] Implementar \`AIExplanationClient implements LlmPort\`
- [ ] Configurar \`ChatClient\` com provedor selecionável via \`LLM_PROVIDER\` (\`anthropic\` ou \`openai\`)
- [ ] Criar prompt template para explicação de jogada em português (nível do jogador como variável)
- [ ] Criar prompt template para classificação de erro tático/estratégico
- [ ] Implementar \`String explain(Move move, PositionContext ctx)\`
- [ ] Implementar \`ErrorType classifyError(Move move, EvalResult eval)\`
- [ ] Configurar \`temperature\` e \`maxTokens\` por tipo de tarefa
- [ ] Adicionar tratamento de erros: rate limit (429), timeout, contexto excedido
- [ ] Testes com mock do \`ChatClient\` verificando estrutura do prompt" \
"backend,llm" "$MS4"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M5: MCP & Orquestração
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS5"
echo "──────────────────────────────────────────────────"

create_issue \
"[MCP] Implementar AnalyzePositionTool" \
"## Motivo
Esta tool é o ponto de entrada do MCP para análise de posições. Ela encapsula a chamada ao Stockfish e retorna dados estruturados que o orquestrador combina com as demais tools para montar a resposta final.

## Checklist
- [ ] Anotar \`AnalyzePositionTool\` com \`@Tool\` (Spring AI)
- [ ] Implementar \`EvalResult analisarPosicao(@ToolParam String fen)\`
- [ ] Validar FEN de entrada via \`FenUtils.isValid()\` antes de chamar o engine
- [ ] Lançar \`InvalidFenException\` para FEN inválida
- [ ] Retornar: score (centipawns ou mate), melhor lance, PV, profundidade analisada
- [ ] Adicionar descrição semântica clara da tool para o LLM decidir quando invocá-la
- [ ] Registrar no \`ToolRegistry\`
- [ ] Testes unitários com \`StockfishPort\` mockado" \
"backend,mcp,stockfish" "$MS5"

create_issue \
"[MCP] Implementar FindOpeningTool" \
"## Motivo
Identificar a abertura jogada enriquece a análise com contexto histórico e estatísticas de vitória, permitindo ao LLM gerar explicações mais educativas e direcionadas para o nível do jogador.

## Checklist
- [ ] Implementar \`Opening buscarAbertura(@ToolParam String pgn)\`
- [ ] Delegar ao \`LichessPort\` para consulta ao Explorer
- [ ] Retornar: nome, código ECO, variante, taxa de vitória por cor
- [ ] Adicionar cache Redis na resposta com TTL de 24h (posições de abertura mudam raramente)
- [ ] Tratar abertura desconhecida com \`Opening.unknown()\`
- [ ] Registrar no \`ToolRegistry\`
- [ ] Testes com \`LichessPort\` mockado (abertura encontrada, não encontrada, erro de rede)" \
"backend,mcp,lichess" "$MS5"

create_issue \
"[MCP] Implementar ExplainMoveTool" \
"## Motivo
Gerar explicações em linguagem natural é o principal diferencial do Chess Analyzer. Esta tool usa o LLM para transformar dados técnicos (score Stockfish, variante) em insights compreensíveis para jogadores de todos os níveis.

## Checklist
- [ ] Implementar \`String explicarJogada(@ToolParam Move move, EvalResult eval, Opening opening)\`
- [ ] Construir prompt contextualizado: lance, avaliação, abertura, cor do jogador, nível
- [ ] Incluir comparação com a melhor jogada do Stockfish no prompt
- [ ] Suportar parâmetro de nível (BEGINNER / INTERMEDIATE / ADVANCED) que ajusta a profundidade da explicação
- [ ] Retornar explicação em português
- [ ] Registrar no \`ToolRegistry\`
- [ ] Testes verificando estrutura e relevância do prompt gerado" \
"backend,mcp,llm" "$MS5"

create_issue \
"[MCP] Implementar ClassifyErrorTool" \
"## Motivo
Classificar erros (blunder, mistake, inaccuracy) e sua natureza (tático, estratégico, de abertura, de final) é fundamental para o módulo de treinamento direcionar o estudo do usuário de forma efetiva.

## Checklist
- [ ] Definir enum \`ErrorType\`: BLUNDER, MISTAKE, INACCURACY, GOOD_MOVE, EXCELLENT
- [ ] Definir enum \`ErrorNature\`: TACTIC, STRATEGY, OPENING, ENDGAME
- [ ] Implementar lógica baseada em delta de centipawns:
  - Blunder: delta > 200 cp
  - Mistake: delta 100–200 cp
  - Inaccuracy: delta 50–100 cp
- [ ] Integrar LLM para descrição textual do motivo do erro
- [ ] Registrar no \`ToolRegistry\`
- [ ] Testes com posições de blunder conhecidas (tática clássica) e boas jogadas" \
"backend,mcp,llm" "$MS5"

create_issue \
"[MCP] Implementar MCPOrchestrator e ToolRegistry" \
"## Motivo
O orquestrador é o coração do sistema de IA. Ele coordena a execução das tools, agrega resultados e decide o fluxo de análise. A execução paralela das tools independentes maximiza performance e reduz latência percebida pelo usuário.

## Checklist
- [ ] Implementar \`MCPOrchestrator\` usando \`ChatClient\` com tools registradas
- [ ] Execução paralela: \`analisarPosicao\` + \`buscarAbertura\` via \`CompletableFuture.allOf()\`
- [ ] Execução sequencial: \`explicarJogada\` + \`classificarErro\` após dados do engine disponíveis
- [ ] Configurar timeout por tool: Stockfish 5s, Lichess 3s, LLM 15s
- [ ] Implementar \`ToolRegistry\` para registro e lookup dinâmico de tools
- [ ] Tratar falhas parciais: se Lichess falhar, análise continua sem abertura
- [ ] Logar cada tool call com duração (MDC logging) para observabilidade
- [ ] Testes de integração do orquestrador completo com todas as tools mockadas" \
"backend,mcp" "$MS5"

create_issue \
"[BACKEND] Implementar DTOs de request/response (API e MCP)" \
"## Motivo
DTOs bem definidos são o contrato público da API. Separá-los dos domain models protege o domínio de mudanças externas e viabiliza o versionamento da API sem quebrar clientes.

## Checklist
- [ ] \`MCPRequestDTO\`: fen, pgn, depth, playerLevel
- [ ] \`MCPResponseDTO\`: evaluation, bestMove, explanation, opening, errors, durationMs
- [ ] \`AnalysisDTO\`: id, fen, score, bestMove, explanation, opening, errors
- [ ] \`GameDTO\`: id, pgn, white, black, result, playedAt
- [ ] \`MoveDTO\`: notation, errorType, errorNature, explanation
- [ ] \`OpeningDTO\`: eco, name, winRate
- [ ] \`PuzzleDTO\`: id, fen, themes, difficulty
- [ ] \`ReportDTO\`: period, accuracy, blunders, mistakes, openingStats
- [ ] \`UserDTO\`: username, email (nunca expor passwordHash)
- [ ] Adicionar Bean Validation: \`@NotBlank\`, \`@Pattern\` para FEN (\`[prnbqkPRNBQK1-8\\/]{1,} [wb] ...\`)
- [ ] Usar Java records para DTOs de resposta (imutabilidade)
- [ ] Documentar com \`@Schema\` do Swagger" \
"backend,mcp" "$MS5"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M6: API REST & Services
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS6"
echo "──────────────────────────────────────────────────"

create_issue \
"[BACKEND] Implementar ChessController (análise FEN/PGN)" \
"## Motivo
O \`ChessController\` é o ponto de entrada REST para a funcionalidade principal. Uma API REST clara e bem documentada facilita a integração com o frontend e com clientes externos no futuro.

## Checklist
- [ ] \`POST /api/v1/analysis/position\` – recebe FEN, retorna AnalysisDTO
- [ ] \`POST /api/v1/analysis/game\` – recebe PGN completo, retorna lista de AnalysisDTO por lance
- [ ] Validar input com \`@Valid\` + Bean Validation antes de processar
- [ ] Lançar \`InvalidFenException\` para FEN inválida
- [ ] Retornar HTTP 202 Accepted para análise de partida completa (assíncrono)
- [ ] Adicionar \`@RestController\`, \`@RequestMapping(\"/api/v1\")\`
- [ ] Documentar com \`@Operation\`, \`@ApiResponse\` do Swagger
- [ ] Testes de integração com MockMvc: FEN válida, FEN inválida, PGN válido" \
"backend" "$MS6"

create_issue \
"[BACKEND] Implementar UserController (auth JWT e gestão de partidas)" \
"## Motivo
Autenticação segura é pré-requisito para histórico pessoal, análises salvas e relatórios de progresso. JWT stateless se encaixa bem na arquitetura REST e é suportado nativamente pelo Spring Security.

## Checklist

### Dependências
- [ ] Adicionar Spring Security ao \`pom.xml\`
- [ ] Adicionar \`jjwt-api\`, \`jjwt-impl\`, \`jjwt-jackson\`

### Endpoints
- [ ] \`POST /api/v1/auth/register\` – valida email único, hash BCrypt, retorna tokens
- [ ] \`POST /api/v1/auth/login\` – retorna access token (15 min) + refresh token (7 dias)
- [ ] \`POST /api/v1/auth/refresh\` – renova access token via refresh token válido
- [ ] \`POST /api/v1/users/games\` – salva partida do usuário autenticado
- [ ] \`GET /api/v1/users/games\` – lista partidas paginadas (\`?page=0&size=20\`)

### Segurança
- [ ] Configurar \`SecurityFilterChain\`: \`/auth/**\` público, demais rotas protegidas
- [ ] Implementar \`JwtAuthenticationFilter\`
- [ ] Hash de senha com \`BCryptPasswordEncoder\`
- [ ] Configurar CORS para permitir o frontend (\`localhost:5173\`)

### Testes
- [ ] Teste de integração: register → login → request autenticado → logout" \
"backend,security" "$MS6"

create_issue \
"[BACKEND] Implementar AnalysisController (histórico e treino)" \
"## Motivo
Manter histórico de análises e sessões de treino permite ao usuário acompanhar sua evolução e ao sistema adaptar progressivamente a dificuldade dos puzzles recomendados.

## Checklist
- [ ] \`GET /api/v1/analysis/history\` – histórico paginado do usuário autenticado
- [ ] \`GET /api/v1/analysis/{id}\` – detalhe de uma análise específica
- [ ] \`GET /api/v1/training/puzzles\` – lista de puzzles recomendados (dificuldade adaptativa)
- [ ] \`POST /api/v1/training/puzzles/{id}/solve\` – registra resolução (correto/incorreto, tempo)
- [ ] \`GET /api/v1/training/report\` – relatório de progresso (\`?period=WEEKLY\`)
- [ ] Aplicar paginação com \`Pageable\` em todos os endpoints de listagem
- [ ] Retornar 404 com mensagem clara para recursos não encontrados
- [ ] Testes de integração com Testcontainers" \
"backend" "$MS6"

create_issue \
"[BACKEND] Implementar AnalysisService, ExplanationService, OpeningService e TrainingService" \
"## Motivo
Os services encapsulam a lógica de negócio e orquestram as chamadas entre domínio, MCP e repositórios. Mantê-los finos e coesos facilita testes unitários e evolução independente de cada funcionalidade.

## Checklist
- [ ] \`AnalysisService.analyze(Fen)\`: aciona MCPOrchestrator → persiste no PostgreSQL → armazena no Redis
- [ ] \`AnalysisService.analyzeGame(Pgn)\`: itera lances via \`PgnUtils.extractMoves()\`, agrega análises em paralelo
- [ ] \`ExplanationService.explain(Move, PositionContext)\`: delega ao \`LlmPort\`, retorna String
- [ ] \`OpeningService.identify(Pgn)\`: consulta \`LichessPort\`, persiste abertura identificada
- [ ] \`TrainingService.getPuzzles(userId)\`: seleciona puzzles por rating e temas dos erros frequentes
- [ ] \`TrainingService.generateReport(userId)\`: agrega estatísticas (acurácia, blunders, aberturas)
- [ ] Anotar com \`@Transactional\` onde há múltiplas escritas
- [ ] Testes unitários com Mockito para cada service (todos os paths: sucesso e falha)" \
"backend" "$MS6"

create_issue \
"[BACKEND] Implementar GlobalExceptionHandler e utilitários FenUtils/PgnUtils" \
"## Motivo
Tratamento centralizado de erros garante respostas HTTP consistentes e informativas. Utilitários de validação protegem o sistema de inputs malformados antes que cheguem ao Stockfish ou LLM, evitando desperdício de recursos.

## Checklist
- [ ] Implementar \`GlobalExceptionHandler\` com \`@RestControllerAdvice\`
- [ ] Mapear exceções para status HTTP:
  - \`InvalidFenException\` → 422 Unprocessable Entity
  - \`AnalysisNotFoundException\` → 404 Not Found
  - \`UserNotFoundException\` → 404 Not Found
  - \`GameNotFoundException\` → 404 Not Found
  - \`MethodArgumentNotValidException\` → 400 Bad Request
  - Exceções não mapeadas → 500 Internal Server Error
- [ ] Retornar \`ProblemDetail\` (RFC 7807) com \`type\`, \`title\`, \`status\`, \`detail\`
- [ ] Implementar \`FenUtils.isValid(String)\` – valida os 6 campos FEN
- [ ] Implementar \`PgnUtils.isValid(String)\` – valida tags e lances
- [ ] Implementar \`PgnUtils.extractMoves(String)\` – retorna lista de notações
- [ ] Logar erros 5xx com MDC (userId, fen, requestId)
- [ ] Testes para cada tipo de exceção" \
"backend" "$MS6"

create_issue \
"[BACKEND] Configurar Redis Cache e estratégia de invalidação" \
"## Motivo
Análises de posição são computacionalmente custosas (Stockfish + LLM). Armazenar resultados no Redis com TTL adequado reduz latência para posições recorrentes e diminui custo de API do LLM em requisições repetidas.

## Checklist
- [ ] Configurar \`RedisCacheManager\` em \`AppConfig\` com serialização Jackson
- [ ] Cache \`analysis-by-fen\`: chave = hash(FEN + depth), TTL = 1h
- [ ] Cache \`opening-by-pgn\`: chave = hash(PGN prefix), TTL = 24h
- [ ] Anotar \`AnalysisService\` com \`@Cacheable\`, \`@CacheEvict\`
- [ ] Configurar política de eviction: \`allkeys-lru\` no Redis
- [ ] Implementar \`RedisCache\` para operações customizadas fora do Spring Cache
- [ ] Adicionar métrica de hit rate do cache (via Micrometer)
- [ ] Teste de integração verificando cache hit/miss com Testcontainers Redis" \
"backend,cache,performance" "$MS6"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M7: Frontend React
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS7"
echo "──────────────────────────────────────────────────"

create_issue \
"[FRONTEND] Configurar projeto React com Vite, TypeScript e dependências base" \
"## Motivo
Uma configuração limpa e bem tipada do frontend garante builds rápidos, hot reload eficiente, detecção precoce de erros via TypeScript e alinhamento com as melhores práticas da stack React moderna.

## Checklist
- [ ] Criar projeto: \`npm create vite@latest frontend -- --template react-ts\`
- [ ] Instalar \`chess.js\` (lógica de xadrez) e \`react-chessboard\` (UI do tabuleiro)
- [ ] Instalar \`@tanstack/react-query\` para gerenciamento de estado servidor
- [ ] Instalar \`react-router-dom\` para navegação
- [ ] Instalar \`zustand\` para estado global (usuário, configurações)
- [ ] Instalar \`react-hook-form\` + \`zod\` para formulários com validação
- [ ] Instalar \`axios\` e criar \`src/api/client.ts\` com base URL e interceptors de auth
- [ ] Configurar proxy Vite para o backend (\`localhost:8080\`)
- [ ] Configurar ESLint (plugin react, react-hooks, typescript) + Prettier
- [ ] Criar estrutura de pastas: \`components/\`, \`pages/\`, \`api/\`, \`hooks/\`, \`store/\`, \`types/\`
- [ ] Configurar variável de ambiente \`VITE_API_BASE_URL\`" \
"frontend,setup" "$MS7"

create_issue \
"[FRONTEND] Implementar tabuleiro interativo (ChessBoard component)" \
"## Motivo
O tabuleiro é o componente central da aplicação. Uma UX fluida para entrada e visualização de jogadas é o que diferencia uma ferramenta profissional de análise de um simples leitor de FEN.

## Checklist
- [ ] Criar \`<ChessBoard />\` usando \`react-chessboard\`
- [ ] Input de FEN com validação em tempo real (regex no cliente)
- [ ] Input de PGN via textarea com preview do número de lances
- [ ] Exibir setas coloridas das melhores jogadas do Stockfish
- [ ] Navegação por lances: ⏮ ◀ ▶ ⏭ (início, anterior, próximo, fim)
- [ ] Destacar o último lance com highlight nas casas de origem e destino
- [ ] Permitir jogar lances manualmente via drag & drop
- [ ] Indicador de vez (brancas/pretas) com ícone de relógio
- [ ] Botão para inverter o tabuleiro (jogar como pretas)
- [ ] Responsivo para telas mobile (mínimo 320px)
- [ ] Testes com React Testing Library: renderização, drag&drop, navegação" \
"frontend" "$MS7"

create_issue \
"[FRONTEND] Implementar painel de análise (AnalysisPanel)" \
"## Motivo
O painel de análise transforma dados técnicos do Stockfish em informações visuais absorvíveis. Uma boa apresentação de score, variante e explicação é o que motiva o jogador a entender seus erros e evoluir.

## Checklist
- [ ] Criar \`<AnalysisPanel />\`
- [ ] Barra de vantagem vertical (brancas/pretas) animada conforme o score
- [ ] Exibir avaliação numérica: \`+1.3\` ou \`M3\` (mate em 3)
- [ ] Exibir melhor jogada sugerida com notação algébrica
- [ ] Exibir variante principal (PV) com lances clicáveis para navegar
- [ ] Exibir explicação em linguagem natural gerada pelo LLM com skeleton loading
- [ ] Exibir nome da abertura + código ECO com link para o Lichess
- [ ] Lista de erros por lance: 🔴 Blunder / 🟠 Mistake / 🟡 Inaccuracy / ✅ Boa jogada
- [ ] Estado de carregamento com skeleton enquanto análise é processada
- [ ] Botão de exportar análise em PGN anotado com comentários do LLM" \
"frontend" "$MS7"

create_issue \
"[FRONTEND] Implementar painel de treino (TrainingPanel: puzzles e relatório)" \
"## Motivo
O módulo de treino transforma o Chess Analyzer de simples analisador em ferramenta de evolução contínua, mantendo o usuário engajado com desafios progressivos e visualização de progresso.

## Checklist
- [ ] Criar \`<TrainingPanel />\` com abas: Puzzles / Relatório
- [ ] Aba Puzzles:
  - [ ] Tabuleiro interativo para resolver o puzzle
  - [ ] Indicação do tema (tática, garfo, cravada, etc.)
  - [ ] Botão de dica após 3 tentativas erradas
  - [ ] Exibir solução com explicação após resolução
  - [ ] Feedback visual: ✅ correto em verde / ❌ incorreto em vermelho
- [ ] Aba Relatório:
  - [ ] Gráfico de acurácia por semana (recharts LineChart)
  - [ ] Distribuição de erros: blunders vs mistakes vs inaccuracies (PieChart)
  - [ ] Top 5 aberturas mais jogadas com taxa de vitória
  - [ ] Temas de erros mais frequentes
- [ ] Testes dos componentes principais" \
"frontend" "$MS7"

create_issue \
"[FRONTEND] Implementar autenticação (login, registro, rotas protegidas)" \
"## Motivo
Autenticação no frontend garante que histórico e progresso sejam persistidos por usuário. O fluxo deve ser fluido e seguro sem atrapalhar o acesso rápido ao analisador.

## Checklist
- [ ] Criar página \`/login\` com formulário email + senha
- [ ] Criar página \`/register\` com email, username, senha + confirmação
- [ ] Validação client-side com react-hook-form + zod
- [ ] Armazenar access token em memória (zustand) e refresh token em cookie httpOnly
- [ ] Interceptor axios: injeta \`Authorization: Bearer\` em cada request
- [ ] Interceptor axios: ao receber 401, tenta refresh antes de redirecionar ao login
- [ ] Criar \`<PrivateRoute />\` que redireciona para /login se não autenticado
- [ ] Exibir username e avatar (initial) no header quando autenticado
- [ ] Botão de logout: limpa estado, redireciona para /login
- [ ] Testar fluxo completo: register → login → navegar → logout" \
"frontend,security" "$MS7"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M8: Performance & Cache
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS8"
echo "──────────────────────────────────────────────────"

create_issue \
"[PERFORMANCE] Execução paralela das MCP tools no pipeline de análise" \
"## Motivo
\`analisarPosicao\` (Stockfish, ~500ms) e \`buscarAbertura\` (Lichess, ~300ms) são independentes e podem rodar em paralelo. Sem paralelismo o tempo total é a soma das latências; com paralelismo é o máximo delas — redução estimada de 40-60% na latência percebida.

## Checklist
- [ ] Refatorar \`MCPOrchestrator\` para usar \`CompletableFuture.allOf(stockfishFuture, lichessFuture)\`
- [ ] Configurar \`ThreadPoolTaskExecutor\` dedicado para análise (parâmetros via \`@ConfigurationProperties\`)
- [ ] Definir timeout por tool via \`CompletableFuture.orTimeout()\`
- [ ] Garantir que falha em uma future não cancela as demais (\`exceptionally()\`)
- [ ] Medir latência P50/P95/P99 antes e após (logs estruturados com \`durationMs\`)
- [ ] Documentar o ganho de performance medido no PR" \
"performance,backend,mcp" "$MS8"

create_issue \
"[PERFORMANCE] Otimização de queries PostgreSQL e índices" \
"## Motivo
Consultas de histórico e relatórios crescem com o volume de dados. Índices adequados e queries otimizadas garantem que a experiência não se degrade conforme o banco cresce.

## Checklist
- [ ] Habilitar em dev: \`spring.jpa.show-sql=true\` e \`hibernate.generate_statistics=true\`
- [ ] Diagnosticar queries N+1 com Hibernate statistics e corrigir com \`JOIN FETCH\`
- [ ] Migration: índice em \`analysis(fen_hash)\` para busca por posição
- [ ] Migration: índice composto em \`game(user_id, played_at DESC)\` para histórico
- [ ] Migration: índice em \`opening_stats(user_id, opening_eco)\` para relatórios
- [ ] Usar \`Pageable\` em todos os endpoints de listagem (sem \`findAll()\` sem paginação)
- [ ] Rodar \`EXPLAIN ANALYZE\` nas queries mais frequentes e documentar resultados
- [ ] Ajustar pool HikariCP: \`maximum-pool-size\`, \`minimum-idle\`, \`connection-timeout\`" \
"performance,database" "$MS8"

create_issue \
"[PERFORMANCE] Configurar Spring Actuator e métricas com Micrometer" \
"## Motivo
Sem observabilidade, problemas de performance em produção são difíceis de diagnosticar. Micrometer com Prometheus expõe métricas prontas para Grafana e gera alertas antes que os usuários percebam degradação.

## Checklist
- [ ] Adicionar ao \`pom.xml\`: \`spring-boot-starter-actuator\`, \`micrometer-registry-prometheus\`
- [ ] Expor: \`/actuator/health\`, \`/actuator/info\`, \`/actuator/prometheus\`
- [ ] Proteger endpoints do Actuator (apenas acesso interno ou role ADMIN)
- [ ] Métrica customizada \`chess.analysis.duration\` (Timer) por tipo de análise
- [ ] Métrica \`chess.stockfish.calls.total\` (Counter) com tag de profundidade
- [ ] Métrica \`chess.llm.tokens.used\` (Counter) com tag de provedor
- [ ] Métrica \`chess.cache.hit.ratio\` (Gauge) para Redis
- [ ] Adicionar serviço Prometheus ao \`docker-compose.yml\` (opcional, para dev)" \
"performance,devops,backend" "$MS8"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M9: DevOps & CI/CD
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS9"
echo "──────────────────────────────────────────────────"

create_issue \
"[DEVOPS] Criar Dockerfiles multi-stage para backend e frontend" \
"## Motivo
Dockerfiles multi-stage garantem builds reproduzíveis e imagens de produção enxutas (apenas o runtime, sem toolchain de build). Essenciais para CI/CD e deploy em qualquer plataforma sem dependências de ambiente.

## Checklist

### Backend (\`backend/Dockerfile\`)
- [ ] Stage \`builder\`: \`maven:3.9-eclipse-temurin-25\` — compila o JAR
- [ ] Stage \`runtime\`: \`eclipse-temurin:25-jre-alpine\` — executa o JAR
- [ ] Copiar apenas o \`pom.xml\` e baixar dependências antes do source (aproveitar layer cache)
- [ ] Adicionar JVM flags: \`--enable-native-access=ALL-UNNAMED\` no \`ENTRYPOINT\`
- [ ] Adicionar \`HEALTHCHECK\` via \`/actuator/health\`
- [ ] Executar como usuário não-root (\`USER 1001\`)

### Frontend (\`frontend/Dockerfile\`)
- [ ] Stage \`builder\`: \`node:20-alpine\` — \`npm ci && npm run build\`
- [ ] Stage \`runtime\`: \`nginx:alpine\` servindo o diretório \`dist/\`
- [ ] Configurar nginx para SPA (redirecionar 404 para \`index.html\`)

### Compose
- [ ] Atualizar \`docker-compose.yml\` adicionando serviços \`backend\` e \`frontend\`
- [ ] Testar \`docker compose up --build\` e smoke test da aplicação completa" \
"devops" "$MS9"

create_issue \
"[DEVOPS] Configurar GitHub Actions – Pipeline CI (backend e frontend)" \
"## Motivo
CI automatizado garante que nenhum código quebrado chegue à branch principal. Feedback rápido no PR economiza tempo de debug e aumenta confiança nos merges.

## Checklist

### \`.github/workflows/ci-backend.yml\`
- [ ] Trigger: push e PR para \`develop\` e \`main\`
- [ ] Setup Java 25 com \`actions/setup-java\` (distribution: \`temurin\`)
- [ ] Cache de dependências Maven via \`actions/cache\`
- [ ] Executar \`./mvnw verify\` (compila + testes unitários + integração)
- [ ] Executar análise estática com \`./mvnw checkstyle:check\`
- [ ] Upload de relatório de cobertura JaCoCo como artefato
- [ ] Threshold mínimo de cobertura: 70% (configurar no JaCoCo plugin)

### \`.github/workflows/ci-frontend.yml\`
- [ ] Trigger: push e PR para \`develop\` e \`main\`
- [ ] Setup Node 20 com cache de \`node_modules\`
- [ ] Executar: \`npm ci && npm run lint && npm test -- --coverage && npm run build\`

### GitHub
- [ ] Configurar status checks obrigatórios: ambos os workflows devem ser verdes para merge" \
"devops,qa" "$MS9"

create_issue \
"[DEVOPS] Configurar GitHub Actions – Pipeline CD (build e deploy)" \
"## Motivo
CD automatizado elimina erro humano no deploy e viabiliza entregas frequentes com confiança. O pipeline é acionado apenas após CI verde na branch main, garantindo que só código validado vai para produção.

## Checklist

### \`.github/workflows/cd.yml\`
- [ ] Trigger: push para \`main\` (após CI verde via \`needs\`)
- [ ] Build e push das imagens Docker para GHCR (\`ghcr.io\`)
- [ ] Tag das imagens: commit SHA (imutável) + \`latest\`
- [ ] Scan de vulnerabilidades nas imagens com \`trivy\`
- [ ] Deploy na plataforma escolhida (VPS via SSH, Railway, Fly.io, etc.)
- [ ] Smoke test pós-deploy: \`curl /actuator/health\` deve retornar 200

### Secrets no GitHub
- [ ] \`GHCR_TOKEN\` – acesso ao GitHub Container Registry
- [ ] \`DEPLOY_SSH_KEY\` – chave para acesso ao servidor
- [ ] \`LLM_API_KEY\` – chave do provedor de LLM
- [ ] \`DATABASE_URL\`, \`REDIS_URL\` – strings de conexão de produção

### Documentação
- [ ] Documentar processo de rollback (re-deploy de tag anterior)
- [ ] Documentar como acionar rollback manual em caso de incidente" \
"devops" "$MS9"

# ═══════════════════════════════════════════════════════════
#  ISSUES — M10: QA & Testes
# ═══════════════════════════════════════════════════════════
echo ""
echo "──────────────────────────────────────────────────"
echo "  📋  Criando issues — $MS10"
echo "──────────────────────────────────────────────────"

create_issue \
"[QA] Testes unitários – Domain Models e Value Objects" \
"## Motivo
Value Objects com validação incorreta causam bugs silenciosos difíceis de rastrear em produção. Testes unitários garantem que as regras de negócio do domínio se comportam conforme o esperado antes de qualquer integração.

## Checklist
- [ ] \`FenTest\`: FEN válida, FEN com campo faltando, FEN com peças inválidas, posição inicial
- [ ] \`PgnTest\`: PGN completo válido, PGN sem resultado, extração correta de lances
- [ ] \`EvaluationTest\`: comparações entre scores, distinção centipawns vs mate, \`Evaluation.DRAW\`
- [ ] \`MoveTest\`: classificação de erro por delta de centipawns (limites exatos)
- [ ] \`UserTest\`: criação, validação de campos obrigatórios
- [ ] Configurar JaCoCo no \`pom.xml\` com threshold 80% nas classes de domínio
- [ ] Adicionar JaCoCo ao CI para bloquear build se cobertura cair abaixo do threshold" \
"qa,backend" "$MS10"

create_issue \
"[QA] Testes unitários – Application Services com Mockito" \
"## Motivo
Testes unitários de services com mocks isolam a lógica de negócio das dependências externas, tornando os testes rápidos, determinísticos e executáveis sem infraestrutura.

## Checklist
- [ ] \`AnalysisServiceTest\`
  - [ ] Análise com sucesso: mock MCPOrchestrator retorna resultado, verifica persistência e cache
  - [ ] Análise com LLM falhando: verifica que resultado parcial (sem explicação) é salvo
  - [ ] Cache hit: verifica que MCPOrchestrator não é chamado na segunda análise da mesma FEN
- [ ] \`ExplanationServiceTest\`: mock LlmPort, verifica que prompt contém FEN e avaliação
- [ ] \`OpeningServiceTest\`: mock LichessPort, verifica mapeamento correto (encontrada / não encontrada)
- [ ] \`TrainingServiceTest\`: mock LichessPort, verifica lógica de seleção por dificuldade
- [ ] Cobertura mínima: 80% nos services
- [ ] Garantir que nenhum teste de unit faz chamada de rede real" \
"qa,backend" "$MS10"

create_issue \
"[QA] Testes de integração – Controllers com MockMvc e Testcontainers" \
"## Motivo
Testes de integração validam o pipeline completo (controller → service → banco), capturando problemas que testes unitários com mocks não detectam — como queries JPA incorretas ou migrações com problema.

## Checklist
- [ ] Adicionar ao \`pom.xml\`: \`testcontainers-bom\`, \`testcontainers-postgresql\`, \`testcontainers-redis\`
- [ ] Criar \`AbstractIntegrationTest\` com \`@SpringBootTest\` + \`@Testcontainers\`
- [ ] \`ChessControllerIT\`:
  - [ ] POST /position com FEN válida → 200 com AnalysisDTO
  - [ ] POST /position com FEN inválida → 422 com ProblemDetail
  - [ ] POST /game com PGN válido → 202 Accepted
- [ ] \`UserControllerIT\`:
  - [ ] Fluxo completo: register → login → request autenticado → 200
  - [ ] Login com senha errada → 401
  - [ ] Request sem token → 401
- [ ] \`AnalysisControllerIT\`:
  - [ ] GET /history paginado → lista correta
  - [ ] GET /analysis/{id} inexistente → 404
- [ ] Verificar cache Redis: primeira chamada persiste, segunda é hit" \
"qa,backend" "$MS10"

create_issue \
"[QA] Testes de integração – StockfishEngine (Project Panama / FFM)" \
"## Motivo
A integração via FFM API é complexa e sensível ao ambiente de execução. Testes específicos garantem que o engine responde corretamente e não vaza memória nativa antes de qualquer deploy.

## Checklist
- [ ] Criar \`StockfishEngineIT\` anotado com \`@EnabledIfEnvironmentVariable(named = \"STOCKFISH_PATH\")\`
- [ ] Teste: posição inicial → score entre -50 e +50 cp, depth ≥ 15
- [ ] Teste: posição com mate em 1 → score = Mate 1, melhor lance correto
- [ ] Teste: 100 análises seguidas sem erro de memória nativa (stress básico)
- [ ] Teste: \`Arena.close()\` correto — nenhum \`MemorySegment\` acessível após close
- [ ] Configurar CI para instalar Stockfish via \`apt-get install stockfish\` no runner
- [ ] Adicionar job separado no CI para estes testes (evitar bloquear o CI principal)" \
"qa,backend,stockfish" "$MS10"

create_issue \
"[QA] Testes E2E – Frontend com Playwright" \
"## Motivo
Testes end-to-end validam a experiência real do usuário no browser, detectando regressões no fluxo completo que testes unitários e de integração não cobrem.

## Checklist
- [ ] Instalar e configurar Playwright (\`npm init playwright@latest\`)
- [ ] Configurar baseURL para apontar ao ambiente de staging
- [ ] Cenário 1: register → login → inserir FEN → receber análise → ver explicação
- [ ] Cenário 2: importar PGN → navegar pelos lances → ver erros classificados
- [ ] Cenário 3: acessar painel de treino → resolver puzzle → ver solução
- [ ] Cenário 4: logout → tentar acessar /history → redirecionado para /login
- [ ] Configurar screenshots automáticos em caso de falha
- [ ] Rodar E2E no CI em job separado (requer backend + frontend em execução)" \
"qa,frontend" "$MS10"

create_issue \
"[QA] Testes de carga – Pipeline de análise e API REST (k6)" \
"## Motivo
O sistema combina Stockfish (CPU-intensivo) + LLM (alta latência) + Redis. Testes de carga revelam gargalos e definem limites operacionais antes da produção, evitando surpresas em picos de uso.

## Checklist

### SLOs (Service Level Objectives) a validar
- [ ] P95 < 3s para análise com cache hit
- [ ] P95 < 10s para análise sem cache (Stockfish + LLM)
- [ ] Taxa de erro < 1% sob carga de 20 usuários simultâneos

### Cenários k6 (\`tests/load/\`)
- [ ] Cenário 1: rampa 1→10→20 usuários analisando posições diferentes (sem cache)
- [ ] Cenário 2: 50 usuários lendo histórico (cache hit esperado)
- [ ] Cenário 3: spike de 5→50 usuários em 10 segundos (teste de resiliência)

### Ação sobre resultados
- [ ] Ajustar tamanho do pool de threads do Stockfish se gargalo identificado
- [ ] Ajustar \`maximum-pool-size\` do HikariCP se gargalo for banco
- [ ] Documentar capacidade máxima medida e recomendações de escalabilidade" \
"qa,performance" "$MS10"

# ═══════════════════════════════════════════════════════════
#  FIM
# ═══════════════════════════════════════════════════════════
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  ✅  Setup concluído com sucesso!                ║"
echo "╠══════════════════════════════════════════════════╣"
echo "║  Acesse as issues em:                            ║"
echo "║  https://github.com/$REPO/issues"
echo "╚══════════════════════════════════════════════════╝"
echo ""
