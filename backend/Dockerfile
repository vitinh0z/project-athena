FROM maven:3.9-eclipse-temurin-25 AS builder
WORKDIR /app

# Cache de dependências: copia apenas o pom antes do source
COPY pom.xml .
RUN mvn dependency:go-offline -B -q

COPY src ./src
RUN mvn package -DskipTests -B -q

# ─── Runtime: apenas JRE, sem toolchain de build ───────────────────────────
FROM eclipse-temurin:25-jre AS runtime
WORKDIR /app

# curl é necessário para o HEALTHCHECK (a imagem base não inclui wget/curl por padrão)
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/*

RUN groupadd -r appgroup && useradd -r -g appgroup -u 1001 appuser
USER 1001

COPY --from=builder /app/target/*.jar app.jar

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -fsS http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

ENTRYPOINT ["java", "--enable-native-access=ALL-UNNAMED", "-jar", "app.jar"]
