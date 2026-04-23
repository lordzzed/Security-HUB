#!/bin/bash

# Parar a execução se qualquer comando falhar (Fail-fast)
set -e

# Cores para o terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Iniciando setup profissional do Security Hub...${NC}"

# Fase 1: Privilégios e Dependências do SO
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[!] Erro: Execute como root (sudo).${NC}"
  exit 1
fi

echo -e "${YELLOW}[*] Instalando dependências base e suporte a compressão (zstd)...${NC}"
apt-get update -y
apt-get install -y python3 python3-venv python3-pip weasyprint docker.io docker-compose curl zstd

# Fase 2: Provisionamento de IA (Ollama + Modelos)
echo -e "${YELLOW}[*] Configurando motor de IA local...${NC}"
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
fi

# Tenta subir o serviço se ele não estiver rodando
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${YELLOW}[*] Servidor Ollama não detectado. Iniciando...${NC}"
    ollama serve > /dev/null 2>&1 &
    
    # Aguarda o servidor acordar (TDD de infra)
    echo -ne "${YELLOW}[*] Aguardando o servidor responder...${NC}"
    until curl -s http://localhost:11434/api/tags > /dev/null; do
        echo -ne "."
        sleep 2
    done
    echo -e "${GREEN} OK!${NC}"
fi

echo -e "${YELLOW}[*] Baixando modelos...${NC}"
ollama pull mistral
ollama pull llama3.2

# Fase 3: Defense in Depth (Ambiente Python)
echo -e "${YELLOW}[*] Criando Venv isolado...${NC}"
[ ! -d "venv" ] && python3 -m venv venv
./venv/bin/pip install --upgrade pip
[ -f "requirements.txt" ] && ./venv/bin/pip install -r requirements.txt

# Fase 4: Permissões de Escrita Segura
mkdir -p relatorios
chown -R 1000:1000 relatorios/
chmod -R 755 relatorios/

# Fase 5: Validação Contínua (TDD de Infra)
echo -e "${YELLOW}[*] Validando integridade do ambiente...${NC}"
command -v docker >/dev/null && echo -e "${GREEN}[+] Docker OK${NC}"
command -v ollama >/dev/null && echo -e "${GREEN}[+] Ollama OK${NC}"
ollama list | grep -q "llama3.2" && echo -e "${GREEN}[+] Llama 3.2 pronto${NC}"

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}[+] Setup concluído! Os modelos estão prontos.${NC}"
echo -e "${GREEN}======================================================${NC}"
