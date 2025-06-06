#!/bin/bash

# ===========================================
# CARDÁPIO DIGITAL - SCRIPT DE DEPLOY
# ===========================================

set -e  # Sair em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
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

# Banner
echo -e "${BLUE}"
echo "======================================"
echo "🍽️  CARDÁPIO DIGITAL DEPLOY"
echo "======================================"
echo -e "${NC}"

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    error "Docker não está rodando. Inicie o Docker primeiro."
fi

# Função para verificar arquivos necessários
check_files() {
    log "Verificando arquivos necessários..."
    
    required_files=(
        "docker-compose.yml"
        "backend/Dockerfile"
        "frontend/Dockerfile"
        "frontend/nginx.conf"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            error "Arquivo obrigatório não encontrado: $file"
        fi
    done
    
    success "Todos os arquivos necessários estão presentes"
}

# Função para configurar ambiente
setup_env() {
    log "Configurando variáveis de ambiente..."
    
    if [[ ! -f ".env" ]]; then
        if [[ -f ".env.example" ]]; then
            cp .env.example .env
            warning "Arquivo .env criado a partir do .env.example"
            warning "IMPORTANTE: Configure as senhas no arquivo .env antes de continuar!"
            echo "Pressione ENTER para continuar ou Ctrl+C para cancelar..."
            read
        else
            warning "Arquivo .env não encontrado. Usando configurações padrão."
        fi
    fi
    
    success "Ambiente configurado"
}

# Função para fazer backup do banco
backup_database() {
    if [[ "$1" == "--backup" ]]; then
        log "Fazendo backup do banco de dados..."
        
        # Criar diretório de backup se não existir
        mkdir -p ./backup
        
        # Nome do backup com timestamp
        BACKUP_FILE="./backup/cardapio_backup_$(date +%Y%m%d_%H%M%S).sql"
        
        # Fazer backup se container existir
        if docker ps -a --format "table {{.Names}}" | grep -q "cardapio-postgres"; then
            docker exec cardapio-postgres pg_dump -U cardapio_user food > "$BACKUP_FILE" 2>/dev/null || true
            success "Backup salvo em: $BACKUP_FILE"
        else
            warning "Container do PostgreSQL não encontrado. Pulando backup."
        fi
    fi
}

# Função para limpar containers antigos
cleanup() {
    log "Limpando containers e imagens antigas..."
    
    # Parar containers se estiverem rodando
    docker-compose down 2>/dev/null || true
    
    # Remover containers orfãos
    docker-compose down --remove-orphans 2>/dev/null || true
    
    # Limpeza opcional de imagens não utilizadas
    if [[ "$1" == "--clean" ]]; then
        warning "Removendo imagens não utilizadas..."
        docker system prune -f
        docker volume prune -f
    fi
    
    success "Limpeza concluída"
}

# Função para build e deploy
deploy() {
    log "Iniciando build das imagens..."
    
    # Build das imagens
    docker-compose build --no-cache
    success "Build concluído"
    
    log "Iniciando containers..."
    
    # Subir containers
    docker-compose up -d
    
    # Aguardar containers ficarem healthy
    log "Aguardando containers ficarem prontos..."
    sleep 10
    
    # Verificar saúde dos containers
    check_health
}

# Função para verificar saúde dos containers
check_health() {
    log "Verificando saúde dos containers..."
    
    containers=("cardapio-postgres" "cardapio-backend" "cardapio-frontend")
    
    for container in "${containers[@]}"; do
        if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "$container.*Up"; then
            success "$container está rodando"
        else
            error "$container não está rodando corretamente"
        fi
    done
    
    # Testar conectividade
    log "Testando conectividade..."
    
    # Testar backend
    if curl -s http://localhost:8080/food > /dev/null; then
        success "Backend respondendo em http://localhost:8080/food"
    else
        warning "Backend pode não estar pronto ainda. Aguarde alguns segundos."
    fi
    
    # Testar frontend
    if curl -s http://localhost > /dev/null; then
        success "Frontend respondendo em http://localhost"
    else
        warning "Frontend pode não estar pronto ainda. Aguarde alguns segundos."
    fi
}

# Função para mostrar logs
show_logs() {
    log "Exibindo logs dos containers..."
    docker-compose logs --tail=50 -f
}

# Função para mostrar status
show_status() {
    echo -e "\n${BLUE}=== STATUS DOS CONTAINERS ===${NC}"
    docker-compose ps
    
    echo -e "\n${BLUE}=== RECURSOS UTILIZADOS ===${NC}"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
    
    echo -e "\n${BLUE}=== ENDPOINTS DISPONÍVEIS ===${NC}"
    echo "🌐 Frontend: http://localhost"
    echo "🔧 Backend API: http://localhost:8080/food"
    echo "🗄️ PostgreSQL: localhost:5432"
}

# Processar argumentos
case "${1:-deploy}" in
    "deploy")
        check_files
        setup_env
        backup_database "$2"
        cleanup "$2"
        deploy
        show_status
        ;;
    "logs")
        show_logs
        ;;
    "status")
        show_status
        ;;
    "stop")
        log "Parando containers..."
        docker-compose down
        success "Containers parados"
        ;;
    "restart")
        log "Reiniciando containers..."
        docker-compose restart
        check_health
        success "Containers reiniciados"
        ;;
    "clean")
        cleanup --clean
        ;;
    "backup")
        backup_database --backup
        ;;
    "help")
        echo "Uso: $0 [comando] [opções]"
        echo ""
        echo "Comandos:"
        echo "  deploy [--backup] [--clean]  Deploy completo da aplicação"
        echo "  logs                         Mostra logs em tempo real"
        echo "  status                       Mostra status dos containers"
        echo "  stop                         Para todos os containers"
        echo "  restart                      Reinicia os containers"
        echo "  clean                        Remove containers e imagens não utilizadas"
        echo "  backup                       Faz backup do banco de dados"
        echo "  help                         Mostra esta ajuda"
        echo ""
        echo "Opções para deploy:"
        echo "  --backup                     Faz backup antes do deploy"
        echo "  --clean                      Remove imagens antigas"
        echo ""
        echo "Exemplos:"
        echo "  $0 deploy --backup --clean"
        echo "  $0 logs"
        echo "  $0 status"
        ;;
    *)
        error "Comando inválido: $1. Use '$0 help' para ver os comandos disponíveis."
        ;;
esac
