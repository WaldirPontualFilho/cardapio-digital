# 📋 DESENVOLVIMENTO - Cardápio Digital

## 🎯 **Planejamento do Projeto**

### **Objetivo**
Desenvolver uma aplicação fullstack para gerenciamento de cardápio digital utilizando **Spring Boot** (backend), **React** (frontend), **PostgreSQL** (banco) e **Docker** (containerização).

### **Escopo Funcional**
- Sistema CRUD para itens do cardápio
- Interface web responsiva
- API RESTful
- Persistência de dados
- Deploy containerizado

### **Tecnologias Escolhidas**
| Categoria | Tecnologia | Justificativa |
|-----------|------------|---------------|
| **Backend** | Java 17 + Spring Boot 3.2.0 | Robustez, produtividade, ecossistema maduro |
| **Frontend** | React 18 + TypeScript | Componentização, tipagem, performance |
| **Banco** | PostgreSQL 16 | Confiabilidade, ACID, SQL padrão |
| **Containerização** | Docker + Docker Compose | Portabilidade, consistência de ambiente |
| **Build** | Maven + Vite | Gestão de dependências otimizada |

## 📊 **Metodologia Ágil - Scrum Adaptado**

### **Framework Utilizado: Scrum Individual**
- **Adaptação**: Scrum para desenvolvimento individual
- **Ferramentas**: GitHub Projects, GitHub Issues
- **Cerimônias**: Sprint Planning, Daily (auto-avaliação), Sprint Review

### **Estrutura das Sprints**

#### **Sprint 1 - Foundation (5 dias)**
**Sprint Goal:** Estabelecer arquitetura base e backend funcional

**Sprint Backlog:**
| Item | Tipo | Story Points | Status |
|------|------|--------------|--------|
| Configurar projeto Spring Boot | Setup | 3 | ✅ Done |
| Criar entidade Food + Repository | Development | 5 | ✅ Done |
| Implementar Controller REST | Development | 5 | ✅ Done |
| Configurar PostgreSQL | Infrastructure | 3 | ✅ Done |
| Implementar CORS | Configuration | 2 | ✅ Done |

**Resultado:** API REST funcional com endpoints GET/POST

#### **Sprint 2 - Frontend Integration (5 dias)**
**Sprint Goal:** Desenvolver interface de usuário e integração

**Sprint Backlog:**
| Item | Tipo | Story Points | Status |
|------|------|--------------|--------|
| Setup projeto React + TypeScript | Setup | 3 | ✅ Done |
| Criar componentes base (Card, Modal) | Development | 8 | ✅ Done |
| Implementar hooks com React Query | Development | 5 | ✅ Done |
| Integrar frontend-backend | Integration | 5 | ✅ Done |
| Estilização responsiva | UI/UX | 3 | ✅ Done |

**Resultado:** Interface completa com CRUD funcional

#### **Sprint 3 - DevOps & Quality (5 dias)**
**Sprint Goal:** Containerização, CI/CD e documentação

**Sprint Backlog:**
| Item | Tipo | Story Points | Status |
|------|------|--------------|--------|
| Dockerfiles + Docker Compose | DevOps | 8 | ✅ Done |
| Configurar GitHub Actions | CI/CD | 5 | ✅ Done |
| Implementar testes automatizados | Quality | 8 | ✅ Done |
| Documentação README + DESENVOLVIMENTO | Documentation | 5 | ✅ Done |
| Scripts de automação | DevOps | 3 | ✅ Done |

**Resultado:** Aplicação production-ready com CI/CD

## 🛠️ **Ferramentas Utilizadas**

### **Gestão de Projeto**
- **GitHub Projects**: Kanban board para organização de tarefas
- **GitHub Issues**: Tracking de bugs e features
- **GitHub Milestones**: Controle de sprints

### **Desenvolvimento**
- **IDE**: IntelliJ IDEA (backend) + VS Code (frontend)
- **Versionamento**: Git + GitHub
- **Package Management**: Maven (Java) + npm (Node.js)

### **DevOps & Deployment**
- **Containerização**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **Testing**: JUnit (backend) + Jest (frontend)

### **Monitoramento**
- **Logs**: Logback (Spring Boot) + console.log (React)
- **Health Checks**: Spring Actuator + Docker healthcheck

## 🚧 **Desafios Enfrentados e Soluções**

### **Desafio 1: Configuração CORS**
**Problema:** Frontend não conseguia acessar API backend por questões de CORS
**Solução:** Configuração `@CrossOrigin` no controller Spring Boot
**Aprendizado:** Importância da configuração adequada de CORS em desenvolvimento

### **Desafio 2: Containerização do Spring Boot**
**Problema:** WAR vs JAR - aplicação gerava WAR expandido em vez de JAR executável
**Solução:** Alteração no `pom.xml` de `<packaging>war</packaging>` para `<packaging>jar</packaging>`
**Aprendizado:** Diferenças entre deployments WAR e JAR no Spring Boot

### **Desafio 3: Comunicação entre Containers**
**Problema:** Frontend não conseguia se comunicar com backend via Docker
**Solução:** Configuração adequada de networks no Docker Compose e URLs corretas
**Aprendizado:** Conceitos de networking em Docker

### **Desafio 4: Build Multi-stage do Frontend**
**Problema:** Otimização do tamanho da imagem Docker do frontend
**Solução:** Multi-stage build com Node.js (build) + Nginx (runtime)
**Aprendizado:** Estratégias de otimização de imagens Docker

### **Desafio 5: Configuração Proxy Nginx**
**Problema:** Roteamento adequado de requisições estáticas vs API
**Solução:** Configuração `nginx.conf` com `try_files` e proxy_pass
**Aprendizado:** Configuração de proxy reverso com Nginx

## 📈 **Métricas e Resultados**

### **Velocity das Sprints**
- **Sprint 1**: 18 Story Points entregues
- **Sprint 2**: 24 Story Points entregues  
- **Sprint 3**: 29 Story Points entregues
- **Velocity Média**: 23,7 SP/sprint

### **Qualidade do Código**
- **Cobertura de Testes**: >80% (backend), >70% (frontend)
- **Build Success Rate**: 100% (CI/CD)
- **Zero Critical Bugs**: Validação manual e automatizada

### **Performance**
- **Tempo de Build**: ~3 minutos (CI/CD completo)
- **Startup Time**: <30 segundos (aplicação completa)
- **Response Time**: <500ms (API endpoints)

## 🔄 **Retrospectivas**

### **O que funcionou bem:**
- **Stack moderna**: Tecnologias atuais e bem documentadas
- **Docker**: Eliminou problemas de "funciona na minha máquina"
- **GitHub Actions**: CI/CD automatizado desde o início
- **Metodologia ágil**: Entrega incremental com valor

### **O que pode melhorar:**
- **Testes E2E**: Implementar testes end-to-end com Playwright/Cypress
- **Monitoring**: Adicionar métricas de performance (Prometheus/Grafana)
- **Security**: Implementar autenticação/autorização
- **Database**: Adicionar migrations controladas

### **Lições Aprendidas:**
- **Containerização precoce** evita problemas de deploy
- **CI/CD desde o início** garante qualidade contínua
- **Documentação paralela** ao desenvolvimento economiza tempo
- **Iterações pequenas** permitem feedback rápido

## 🎯 **Próximas Iterações**

### **Backlog Futuro:**
- [ ] Sistema de autenticação (JWT)
- [ ] Categorização de produtos
- [ ] Upload de imagens
- [ ] Carrinho de compras
- [ ] Relatórios de vendas
- [ ] Notificações push
- [ ] Versão mobile (React Native)

### **Melhorias Técnicas:**
- [ ] Implementar cache com Redis
- [ ] Adicionar monitoring com Prometheus
- [ ] Configurar ambiente de staging
- [ ] Implementar feature flags
- [ ] Adicionar testes de carga

---

**Projeto desenvolvido com metodologia ágil e foco em qualidade de software** 🚀