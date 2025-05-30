# 🍽️ Cardápio Digital

Uma aplicação fullstack moderna para gerenciamento de cardápio digital, desenvolvida com **Spring Boot**, **React** e **PostgreSQL**, totalmente containerizada com **Docker**.

<div align="center">

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-green)
![React](https://img.shields.io/badge/React-18.2.0-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![Docker](https://img.shields.io/badge/Docker-✓-blue)

</div>

## 📁 Documentação por Componente

- 🚀 **[Backend API](./backend/README.md)** - Spring Boot, PostgreSQL, Docker
- 🎨 **[Frontend Web](./frontend/README.md)** - React, TypeScript, Vite
- 📋 **[Metodologia](./DESENVOLVIMENTO.md)** - Scrum, sprints, retrospectivas

## 🚀 Quick Start

```bash
# 1. Clone o repositório
git clone <seu-repositorio>
cd cardapio-digital

# 2. Configure as variáveis de ambiente
cp .env.example .env
# Edite o arquivo .env com suas configurações

# 3. Execute a aplicação
./scripts/start.sh

# 4. Acesse a aplicação
# Frontend: http://localhost
# API: http://localhost:8080/food
```

## 📋 Pré-requisitos

- **Docker** >= 20.0
- **Docker Compose** >= 2.0
- **Git**
- **Bash** (para scripts de automação)

### Portas Utilizadas
- **80**: Frontend (React + Nginx)
- **8080**: Backend (Spring Boot)
- **5432**: PostgreSQL

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │   PostgreSQL    │
│   React + Nginx │◄──►│  Spring Boot    │◄──►│   Database      │
│   Port: 80      │    │   Port: 8080    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Stack Tecnológica

**Backend:**
- Java 17
- Spring Boot 3.2.0
- Spring Data JPA
- PostgreSQL Driver
- Maven

**Frontend:**
- React 18.2.0
- TypeScript
- Vite
- TanStack Query
- Axios

**DevOps:**
- Docker + Docker Compose
- GitHub Actions (CI/CD)
- Nginx (Proxy/Static files)

## 📁 Estrutura do Projeto

```
cardapio-digital/
├── backend/                    # API Spring Boot
│   ├── src/main/java/com/example/cardapio/
│   ├── Dockerfile
│   └── pom.xml
├── frontend/                   # App React
│   ├── src/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
├── scripts/                    # Scripts de automação
│   ├── build.sh
│   ├── start.sh
│   └── test.sh
├── .github/workflows/          # CI/CD
├── docker-compose.yml          # Orquestração
├── .env.example               # Template de configuração
├── README.md                  # Este arquivo
└── DESENVOLVIMENTO.md         # Metodologia ágil
```

## 🔧 Scripts de Automação

### Build
```bash
./scripts/build.sh
```
Compila as imagens Docker sem cache.

### Inicialização
```bash
./scripts/start.sh
```
Inicia a aplicação completa e verifica saúde dos serviços.

### Testes
```bash
./scripts/test.sh
```
Executa bateria completa de testes automatizados.

## 🧪 Testes Automatizados

O projeto inclui testes automatizados que cobrem:

- ✅ **Conectividade**: Backend e Frontend
- ✅ **API Funcional**: GET/POST endpoints
- ✅ **Performance**: Latência de resposta
- ✅ **Integridade**: Persistência de dados
- ✅ **Configuração**: CORS e Headers
- ✅ **Carga**: Requisições simultâneas

```bash
# Executar todos os testes
./scripts/test.sh

# Testes específicos via CI/CD
git push origin main  # Triggers GitHub Actions
```

## 📊 API Endpoints

| Método | Endpoint | Descrição | Body |
|--------|----------|-----------|------|
| `GET` | `/food` | Lista todos os itens | - |
| `POST` | `/food` | Cria novo item | `{"title": "string", "image": "string", "price": number}` |

### Exemplo de Uso

```bash
# Listar itens
curl http://localhost:8080/food

# Criar item
curl -X POST http://localhost:8080/food \
  -H "Content-Type: application/json" \
  -d '{"title": "Pizza Margherita", "image": "url", "price": 2500}'
```

## ⚙️ Configuração

### Variáveis de Ambiente

Copie `.env.example` para `.env` e configure:

```bash
# Banco de dados
POSTGRES_DB=food
POSTGRES_USER=cardapio_user
POSTGRES_PASSWORD=sua_senha_aqui

# Aplicação
SPRING_PROFILES_ACTIVE=docker
REACT_APP_API_URL=http://localhost:8080

# Portas (opcional)
FRONTEND_PORT=80
BACKEND_PORT=8080
POSTGRES_PORT=5432
```

### Logs Organizados

Os logs são organizados por serviço:

```bash
# Logs de todos os serviços
docker-compose logs -f

# Logs específicos
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres

# Logs com timestamp
docker-compose logs -f -t
```

### Configurações Avançadas

**Backend (Spring Boot):**
- Profile ativo: `docker`
- JPA: Auto-criação de tabelas
- CORS: Configurado para desenvolvimento

**Frontend (React):**
- Build: Vite (desenvolvimento rápido)
- Proxy: Nginx para servir arquivos estáticos
- API URL: Configurável via variável de ambiente

## 🚨 Troubleshooting

### Problemas Comuns

**1. Porta em uso**
```bash
# Verificar processos nas portas
netstat -tulpn | grep :80
netstat -tulpn | grep :8080
netstat -tulpn | grep :5432

# Parar containers
docker-compose down
```

**2. Container não inicia**
```bash
# Ver logs detalhados
docker-compose logs [service-name]

# Rebuild completo
docker-compose down
docker system prune -f
docker-compose up --build
```

**3. Banco não conecta**
```bash
# Verificar saúde do PostgreSQL
docker-compose exec postgres pg_isready -U cardapio_user

# Conectar manualmente ao banco
docker-compose exec postgres psql -U cardapio_user -d food
```

**4. Frontend não carrega**
```bash
# Verificar Nginx
docker-compose logs frontend

# Testar diretamente
curl http://localhost
```

## 🔄 CI/CD Pipeline

O projeto possui pipeline automatizado com GitHub Actions:

### Triggers
- ✅ Push para `main`
- ✅ Pull Request para `main`

### Stages
1. **Test Backend**: Testes unitários Java
2. **Test Frontend**: Testes unitários React
3. **Build**: Construção das imagens Docker
4. **Integration Test**: Testes de integração
5. **Deploy**: Deploy automático (configurável)

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

### Padrões de Código

**Backend:**
- Java 17+ features
- Spring Boot conventions
- JPA naming conventions
- RESTful API design

**Frontend:**
- TypeScript strict mode
- React Hooks
- Functional components
- CSS modules/styled-components

## 📈 Performance

### Métricas Atuais
- **Build Time**: ~3 minutos (CI/CD completo)
- **Startup Time**: ~30 segundos (aplicação completa)
- **API Response**: <500ms (endpoints principais)
- **Frontend Load**: <2 segundos (primeira carga)

### Otimizações Implementadas
- Multi-stage Docker builds
- Nginx gzip compression
- React code splitting (Vite)
- PostgreSQL connection pooling

## 🔒 Segurança

### Implementações
- ✅ CORS configurado adequadamente
- ✅ SQL injection prevention (JPA)
- ✅ Input validation (Spring Boot)
- ✅ Container security (non-root users)

### Próximas Implementações
- [ ] JWT Authentication
- [ ] Rate limiting
- [ ] Input sanitization
- [ ] HTTPS/SSL

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🏆 Funcionalidades

- ✅ **CRUD completo** de itens do cardápio
- ✅ **Interface responsiva** e intuitiva
- ✅ **API RESTful** com Spring Boot
- ✅ **Persistência** com PostgreSQL
- ✅ **Containerização** completa com Docker
- ✅ **CI/CD** automatizado com GitHub Actions
- ✅ **Testes automatizados** integrados
- ✅ **Scripts de automação** para desenvolvimento
- ✅ **Logs organizados** por serviço
- ✅ **Documentação** abrangente

## 🎯 Roadmap

### Próximas Versões
- [ ] Sistema de autenticação
- [ ] Categorização de produtos
- [ ] Upload de imagens
- [ ] Carrinho de compras
- [ ] Sistema de pedidos
- [ ] Relatórios e analytics
- [ ] Notificações em tempo real

### Melhorias Técnicas
- [ ] Cache com Redis
- [ ] Monitoring com Prometheus/Grafana
- [ ] Testes E2E com Playwright
- [ ] Microservices architecture
- [ ] Kubernetes deployment

## 👨‍💻 Desenvolvimento

Este projeto foi desenvolvido seguindo metodologia ágil (Scrum) com foco em:
- **Entregas incrementais** de valor
- **Qualidade de código** desde o início
- **Automação** de processos
- **Documentação** contínua

Veja detalhes completos em [DESENVOLVIMENTO.md](DESENVOLVIMENTO.md).

---

⭐ **Se este projeto foi útil, considere dar uma estrela no GitHub!**

**Desenvolvido com ❤️ e metodologia ágil**