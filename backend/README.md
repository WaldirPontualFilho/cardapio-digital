# 🚀 Cardápio Digital - Backend API

API RESTful desenvolvida com **Spring Boot 3.2.0** e **Java 17** para gerenciamento de cardápio digital.

<div align="center">

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-green)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![Maven](https://img.shields.io/badge/Maven-3.9-red)
![Docker](https://img.shields.io/badge/Docker-Ready-blue)

</div>

## 📋 Visão Geral

Esta API fornece endpoints para operações CRUD de itens do cardápio, com persistência em PostgreSQL e configuração para execução em containers Docker.

### Funcionalidades
- ✅ **CRUD completo** para itens do cardápio
- ✅ **Validação de dados** com Bean Validation
- ✅ **CORS configurado** para desenvolvimento
- ✅ **JPA/Hibernate** para ORM
- ✅ **Health checks** integrados
- ✅ **Logs estruturados**
- ✅ **Perfis de configuração** (local/docker)

## 🏗️ Arquitetura

```
┌─────────────────────────────────────┐
│            Backend API              │
├─────────────────────────────────────┤
│  Controller Layer (REST Endpoints)  │
│  ├─ FoodController                  │
│  └─ @CrossOrigin configured         │
├─────────────────────────────────────┤
│  Service Layer (Business Logic)     │
│  └─ [Future: FoodService]          │
├─────────────────────────────────────┤
│  Repository Layer (Data Access)     │
│  ├─ FoodRepository (JPA)           │
│  └─ Spring Data JPA                │
├─────────────────────────────────────┤
│  Entity Layer (Data Model)          │
│  ├─ Food (JPA Entity)              │
│  ├─ FoodRequestDTO                 │
│  └─ FoodResponseDTO                │
├─────────────────────────────────────┤
│  Database Layer                     │
│  └─ PostgreSQL 16                  │
└─────────────────────────────────────┘
```

## 🚦 Quick Start

### Pré-requisitos
- **Java 17+**
- **Maven 3.6+**
- **PostgreSQL 16** (ou Docker)

### Execução Local

```bash
# 1. Clone e acesse o backend
git clone <repo>
cd cardapio-digital/backend

# 2. Configure o banco (PostgreSQL local)
# Crie database: food
# Usuário: cardapio_user
# Senha: cardapio123

# 3. Execute a aplicação
./mvnw spring-boot:run

# 4. Acesse a API
curl http://localhost:8080/food
```

### Execução com Docker

```bash
# Na raiz do projeto
docker-compose up backend postgres
```

## 📊 API Endpoints

### Base URL
```
http://localhost:8080
```

### Endpoints Disponíveis

| Método | Endpoint | Descrição | Request Body | Response |
|--------|----------|-----------|--------------|----------|
| `GET` | `/food` | Lista todos os itens | - | `Array<FoodResponseDTO>` |
| `POST` | `/food` | Cria novo item | `FoodRequestDTO` | `void` (200 OK) |

### Exemplos de Uso

#### GET /food - Listar Itens
```bash
curl -X GET http://localhost:8080/food
```

**Response:**
```json
[
  {
    "id": 1,
    "title": "Pizza Margherita",
    "image": "https://example.com/pizza.jpg",
    "price": 2500
  }
]
```

#### POST /food - Criar Item
```bash
curl -X POST http://localhost:8080/food \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Pizza Margherita",
    "image": "https://example.com/pizza.jpg", 
    "price": 2500
  }'
```

**Request Body:**
```json
{
  "title": "string",      // Nome do item (obrigatório)
  "image": "string",      // URL da imagem (obrigatório)
  "price": number         // Preço em centavos (obrigatório)
}
```

## 🗂️ Estrutura do Projeto

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/example/cardapio/
│   │   │   ├── CardapioApplication.java       # Classe principal
│   │   │   ├── controller/
│   │   │   │   └── FoodController.java        # REST Controller
│   │   │   ├── food/
│   │   │   │   ├── Food.java                  # Entidade JPA
│   │   │   │   ├── FoodRepository.java        # Repository
│   │   │   │   ├── FoodRequestDTO.java        # DTO Request
│   │   │   │   └── FoodResponseDTO.java       # DTO Response
│   │   │   └── ServletInitializer.java        # WAR deployment
│   │   └── resources/
│   │       └── application.properties         # Configurações
│   └── test/
│       └── java/com/example/cardapio/
│           └── CardapioApplicationTests.java  # Testes
├── Dockerfile                                 # Container config
├── mvnw                                       # Maven wrapper
├── mvnw.cmd                                   # Maven wrapper (Windows)
├── pom.xml                                    # Dependências Maven
└── README.md                                  # Este arquivo
```

## ⚙️ Configuração

### Perfis de Ambiente

#### Local Development (`application.properties`)
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/food
spring.datasource.username=cardapio_user
spring.datasource.password=cardapio123
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

#### Docker Profile (via environment variables)
```bash
SPRING_PROFILES_ACTIVE=docker
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/food
SPRING_DATASOURCE_USERNAME=cardapio_user
SPRING_DATASOURCE_PASSWORD=cardapio123
```

### Dependências Principais

```xml
<dependencies>
    <!-- Spring Boot Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- Spring Boot Data JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- PostgreSQL Driver -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
    </dependency>
    
    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>
```

## 🧪 Testes

### Executar Testes
```bash
# Testes unitários
./mvnw test

# Testes com cobertura
./mvnw test jacoco:report

# Testes de integração
./mvnw verify
```

### Estrutura de Testes
```bash
src/test/java/
└── com/example/cardapio/
    ├── CardapioApplicationTests.java     # Context loading
    ├── controller/
    │   └── FoodControllerTest.java       # Controller tests
    ├── repository/
    │   └── FoodRepositoryTest.java       # Repository tests
    └── integration/
        └── FoodIntegrationTest.java      # E2E tests
```

## 🐳 Docker

### Dockerfile Features
- ✅ **Multi-stage build** (Maven + Runtime)
- ✅ **Non-root user** para segurança
- ✅ **Health check** integrado
- ✅ **JAR executável** otimizado

### Build Manual
```bash
# Build da imagem
docker build -t cardapio-backend .

# Executar container
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/food \
  cardapio-backend
```

## 📈 Monitoramento

### Health Check
```bash
# Verificar saúde da aplicação
curl http://localhost:8080/food

# Response esperado: 200 OK com array JSON
```

### Logs
```bash
# Logs da aplicação
docker-compose logs backend

# Logs em tempo real
docker-compose logs -f backend
```

### Métricas
- **Startup Time**: ~15-30 segundos
- **Response Time**: <200ms (endpoints simples)
- **Memory Usage**: ~512MB (container)

## 🔧 Desenvolvimento

### Setup do Ambiente
```bash
# 1. Instalar Java 17
sdk install java 17.0.8-oracle

# 2. Configurar PostgreSQL local
createdb food
createuser cardapio_user

# 3. IDE Setup (IntelliJ/VS Code)
# - Instalar plugins: Lombok, Spring Boot
# - Configurar annotation processing
```

### Hot Reload
```bash
# Com Spring Boot DevTools
./mvnw spring-boot:run

# Mudanças são recarregadas automaticamente
```

### Debug Mode
```bash
# Executar em modo debug
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"

# Conectar debugger na porta 5005
```

## 🚨 Troubleshooting

### Problemas Comuns

#### 1. Erro de Conexão com Banco
```bash
# Verificar se PostgreSQL está rodando
pg_isready -h localhost -p 5432

# Verificar credenciais
psql -h localhost -U cardapio_user -d food
```

#### 2. Porta 8080 em Uso
```bash
# Verificar processo na porta
netstat -tulpn | grep :8080

# Matar processo
kill -9 <PID>

# Ou usar porta alternativa
./mvnw spring-boot:run -Dserver.port=8081
```

#### 3. Erro de Build Maven
```bash
# Limpar cache Maven
./mvnw clean

# Build com dependências atualizadas
./mvnw clean install -U
```

#### 4. Problema com Lombok
```bash
# Verificar annotation processing habilitado na IDE
# IntelliJ: Settings > Build > Compiler > Annotation Processors
# Reinstalar plugin Lombok se necessário
```

## 🔄 Próximas Melhorias

### Features Planejadas
- [ ] **Autenticação JWT**
- [ ] **Validação de entrada** com Bean Validation
- [ ] **Paginação** nos endpoints
- [ ] **Filtros e busca**
- [ ] **Categorização** de produtos
- [ ] **Upload de imagens**
- [ ] **Audit trail** (criação/modificação)

### Melhorias Técnicas
- [ ] **Cache** com Redis
- [ ] **Documentação** com OpenAPI/Swagger
- [ ] **Metrics** com Micrometer
- [ ] **Observabilidade** com Spring Boot Actuator
- [ ] **Rate limiting**
- [ ] **Async processing**

## 📝 Contribuição

### Code Style
- **Java**: Google Java Style Guide
- **Spring Boot**: Convenções oficiais
- **JPA**: Named queries quando possível
- **DTOs**: Records para imutabilidade

### Commit Messages
```bash
feat: adiciona endpoint para atualizar item
fix: corrige problema de CORS
refactor: extrai service layer
test: adiciona testes de integração
```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](../LICENSE) para detalhes.

---

**Desenvolvido com Spring Boot e ❤️**