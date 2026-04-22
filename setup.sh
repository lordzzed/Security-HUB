#!/bin/bash

# Parar a execução se qualquer comando falhar (Fail-fast)
set -e

# Cores para o terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Iniciando setup seguro do Security Hub...${NC}"

# Fase 1: Validação de privilégios e provisionamento do SO
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}[!] Erro: Este script precisa ser executado como root (use sudo).${NC}"
  exit 1
fi

echo -e "${YELLOW}[*] Atualizando repositórios e instalando dependências base do SO...${NC}"
apt-get update -y
# Instalamos o weasyprint via apt para puxar as bibliotecas C nativas (pango, cairo)
apt-get install -y python3 python3-venv python3-pip weasyprint docker.io docker-compose curl

# Fase 2: Defense in Depth (Isolamento do Python)
echo -e "${YELLOW}[*] Criando ambiente virtual isolado (Defense in Depth)...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}[+] Virtual Environment criado com sucesso.${NC}"
else
    echo -e "${YELLOW}[-] Venv já existe, pulando criação.${NC}"
fi

echo -e "${YELLOW}[*] Instalando pacotes Python dentro do Venv...${NC}"
# Executamos o pip de dentro do venv para não quebrar pacotes do sistema
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt

# Fase 3: Permissões seguras do Lab
echo -e "${YELLOW}[*] Configurando permissões granulares dos diretórios de saída...${NC}"
mkdir -p relatorios
# ID 1000 é o usuário padrão 'node' dentro do container n8n
chown -R 1000:1000 relatorios/
chmod -R 755 relatorios/

# Fase 4: Validação Contínua (TDD de Infraestrutura)
echo -e "${YELLOW}[*] Executando testes de validação de ambiente...${NC}"

validate_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}[+] $1 está instalado.${NC}"
    else
        echo -e "${RED}[!] Falha na validação: $1 não encontrado.${NC}"
        exit 1
    fi
}

validate_command "docker"
validate_command "docker-compose"
validate_command "python3"

if ./venv/bin/python -c "import weasyprint, requests" 2>/dev/null; then
    echo -e "${GREEN}[+] Bibliotecas Python validadas no Venv.${NC}"
else
    echo -e "${RED}[!] Falha na validação das bibliotecas Python.${NC}"
    exit 1
fi

echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}[+] Setup concluído com sucesso!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "Para rodar o coletor e o gerador de PDF agora, você deve ativar o ambiente isolado:"
echo -e "Comando: ${YELLOW}source venv/bin/activate${NC}"
