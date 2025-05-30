#!/bin/bash

# ===========================================
# CARDÁPIO DIGITAL - SCRIPT DE BUILD
# ===========================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

echo -e "${BLUE}======================================"
echo "🏗️  CARDÁPIO DIGITAL - BUILD"
echo "======================================${NC}"

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    error "Docker não está rodando. Inicie o Docker primeiro."
fi

# Configurar ambiente
log "Configurando variáveis de ambiente..."
if [[ ! -f ".env" ]]; then
    if [[ -f ".env.example" ]]; then
        cp .env.example .env
        log "Arquivo .env criado a partir do .env.example"
        log "Configure as senhas antes de continuar!"
    else
        error "Arquivo .env.example não encontrado"
    fi
fi

# Build das imagens
log "Construindo imagens Docker..."
docker-compose build --no-cache

success "Build concluído com sucesso!"

# Mostrar imagens criadas
log "Imagens criadas:"
docker images | grep cardapio

echo -e "\n${GREEN}Para iniciar a aplicação, execute:${NC}"
echo "  ./scripts/start.sh"
echo ""
echo -e "${GREEN}Para executar testes, execute:${NC}"
echo "  ./scripts/test.sh"
