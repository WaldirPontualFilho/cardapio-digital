# Dockerfile Backend Spring Boot - VERSÃO CORRIGIDA
FROM openjdk:17-jdk-slim

# Instalar Maven e curl
RUN apt-get update && \
    apt-get install -y maven curl && \
    rm -rf /var/lib/apt/lists/*

# Criar usuário não-root para segurança
RUN addgroup --system spring && adduser --system --group spring

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY . .

# Dar permissão de execução ao mvnw
RUN chmod +x mvnw

# Mudar ownership para usuário spring
RUN chown -R spring:spring /app

# Usar usuário não-root para build
USER spring

# Build da aplicação gerando JAR executável
RUN ./mvnw clean package -DskipTests -Dspring-boot.repackage.skip=false

# Verificar arquivos gerados
RUN ls -la /app/target/

# Expor porta da aplicação
EXPOSE 8080

# Variáveis de ambiente para configuração do banco
ENV SPRING_PROFILES_ACTIVE=docker
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/food
ENV SPRING_DATASOURCE_USERNAME=cardapio_user
ENV SPRING_DATASOURCE_PASSWORD=cardapio123

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/food || exit 1

# ENTRYPOINT CORRIGIDO - buscar especificamente por JAR executável
ENTRYPOINT ["sh", "-c", "java -jar /app/target/cardapio-*.jar"]