#!/bin/bash

# ===========================================
# CARDÁPIO DIGITAL - TESTES AUTOMATIZADOS
# ===========================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

echo -e "${BLUE}======================================"
echo "🧪 CARDÁPIO DIGITAL - TESTES"
echo "======================================${NC}"

API_URL="http://localhost:8080"
FRONTEND_URL="http://localhost"

# Verificar se aplicação está rodando
if ! curl -s "$API_URL/food" > /dev/null; then
    error "Aplicação não está rodando. Execute ./scripts/start.sh primeiro"
fi

log "=== TESTES DE CONECTIVIDADE ==="

# Teste Backend
if curl -s -f "$API_URL/food" > /dev/null; then
    success "Backend API está respondendo"
else
    error "Backend API não está respondendo"
fi

# Teste Frontend
if curl -s -f "$FRONTEND_URL" > /dev/null; then
    success "Frontend está respondendo"
else
    error "Frontend não está respondendo"
fi

log "=== TESTES FUNCIONAIS DA API ==="

# Teste GET inicial
log "Testando GET /food (lista inicial)"
initial_response=$(curl -s "$API_URL/food")
if echo "$initial_response" | grep -q '\[\]' || echo "$initial_response" | grep -q '"id"'; then
    success "GET /food retorna lista válida"
else
    error "GET /food retorna resposta inválida"
fi

# Teste POST - criar item
log "Testando POST /food (criar item de teste)"
test_item='{
    "title": "Pizza Teste Automatizado",
    "image": "https://via.placeholder.com/250x200",
    "price": 2999
}'

post_response=$(curl -s -w "%{http_code}" -X POST "$API_URL/food" \
    -H "Content-Type: application/json" \
    -d "$test_item")

http_code="${post_response: -3}"
if [ "$http_code" -eq 200 ] || [ "$http_code" -eq 201 ]; then
    success "POST /food criou item com sucesso (HTTP $http_code)"
else
    error "POST /food falhou com código HTTP $http_code"
fi

# Aguardar persistência
sleep 2

# Teste GET após POST
log "Testando GET /food (verificar item criado)"
updated_response=$(curl -s "$API_URL/food")
if echo "$updated_response" | grep -q "Pizza Teste Automatizado"; then
    success "Item criado está presente na lista"
else
    error "Item criado não foi encontrado"
fi

log "=== TESTES DE PERFORMANCE ==="

# Teste de latência da API
log "Testando latência da API"
api_time=$(curl -w "%{time_total}" -s -o /dev/null "$API_URL/food")
success "API respondeu em ${api_time}s"

log "=== TESTES DE INTEGRIDADE ==="

# Verificar headers de resposta
log "Verificando headers HTTP"
headers=$(curl -s -I "$API_URL/food")
if echo "$headers" | grep -q "Content-Type: application/json"; then
    success "API retorna Content-Type correto"
else
    warning "Content-Type da API pode estar incorreto"
fi

# Verificar CORS
log "Verificando configuração CORS"
cors_response=$(curl -s -H "Origin: http://localhost" -I "$API_URL/food")
if echo "$cors_response" | grep -q "Access-Control-Allow-Origin"; then
    success "CORS está configurado"
else
    warning "CORS pode não estar configurado adequadamente"
fi

# Resumo final
echo -e "\n${GREEN}🎉 TODOS OS TESTES CONCLUÍDOS!${NC}"
echo -e "${BLUE}📊 Resumo dos testes executados:${NC}"
echo "  ✅ Conectividade (Backend + Frontend)"
echo "  ✅ Funcionalidade da API (GET + POST)"
echo "  ✅ Performance básica"
echo "  ✅ Integridade de dados"
echo "  ✅ Configurações (CORS + Headers)"

echo -e "\n${BLUE}📱 Aplicação testada e funcionando:${NC}"
echo "   Frontend: $FRONTEND_URL"
echo "   Backend: $API_URL/food"
