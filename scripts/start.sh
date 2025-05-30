#!/bin/bash

# ===========================================
# CARDÁPIO DIGITAL - SCRIPT DE START
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
echo "🚀 CARDÁPIO DIGITAL - START"
echo "======================================${NC}"

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    error "Docker não está rodando. Inicie o Docker primeiro."
fi

# Verificar se .env existe
if [[ ! -f ".env" ]]; then
    warning "Arquivo .env não encontrado. Criando a partir do .env.example..."
    if [[ -f ".env.example" ]]; then
        cp .env.example .env
        log "Configure as senhas no arquivo .env se necessário"
    fi
fi

# Parar containers se estiverem rodando
log "Parando containers existentes..."
docker-compose down 2>/dev/null || true

# Iniciar aplicação
log "Iniciando aplicação..."
docker-compose up -d

# Aguardar containers ficarem prontos
log "Aguardando containers ficarem prontos..."
sleep 20

# Verificar saúde dos containers
log "Verificando saúde dos containers..."

containers=("cardapio-postgres" "cardapio-backend" "cardapio-frontend")
all_healthy=true

for container in "${containers[@]}"; do
    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "$container.*Up"; then
        success "$container está rodando"
    else
        error "$container não está rodando corretamente"
        all_healthy=false
    fi
done

if $all_healthy; then
    # Testar conectividade
    log "Testando conectividade..."
    
    # Testar backend (com retry)
    for i in {1..10}; do
        if curl -s http://localhost:8080/food > /dev/null; then
            success "Backend API está respondendo em http://localhost:8080/food"
            break
        elif [ $i -eq 10 ]; then
            warning "Backend pode não estar pronto ainda. Aguarde alguns segundos."
        else
            sleep 3
        fi
    done
    
    # Testar frontend
    if curl -s http://localhost > /dev/null; then
        success "Frontend está disponível em http://localhost"
    else
        warning "Frontend pode não estar pronto ainda. Aguarde alguns segundos."
    fi
    
    echo -e "\n${GREEN}🎉 APLICAÇÃO INICIADA COM SUCESSO!${NC}"
    echo -e "${BLUE}📱 Acesse a aplicação:${NC}"
    echo "   Frontend: http://localhost"
    echo "   Backend API: http://localhost:8080/food"
    echo ""
    echo -e "${BLUE}📊 Comandos úteis:${NC}"
    echo "   Ver logs: docker-compose logs -f"
    echo "   Ver status: docker-compose ps"
    echo "   Parar: docker-compose down"
    echo "   Executar testes: ./scripts/test.sh"
    
else
    error "Alguns containers falharam ao iniciar. Verifique os logs com: docker-compose logs"
fi
