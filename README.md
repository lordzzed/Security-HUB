Planejamento de infraestrutura e automação appsec
Este repositório contém a implementação completa do Security Hub, uma solução de automação para análise de segurança de aplicações (AppSec) que integra ferramentas de coleta, orquestração por contêineres e inteligência artificial local para auditoria de cabeçalhos HTTP.

Arquitetura do sistema
O funcionamento do ecossistema baseia-se em um fluxo de dados unidirecional e modular, garantindo que cada componente seja isolado e auditável. Abaixo, a representação visual da arquitetura:

digraph SecurityHub {
    rankdir=LR;
    node [shape=box, style=filled, fontname="Arial", fillcolor="#f9f9f9"];
    
    Alvo [label="Alvo (HTTP Target)", fillcolor="#ffe6e6"];
    Coletor [label="Coletor Python\n(Requests)"];
    N8N [label="Orquestrador n8n\n(Webhooks)", fillcolor="#e1f5fe"];
    IA [label="IA Local\n(Ollama/Mistral)", fillcolor="#fff9c4"];
    PDF [label="Gerador PDF\n(WeasyPrint)"];
    Report [label="Laudo Técnico", shape=note, fillcolor="#c8e6c9"];
    
    Alvo -> Coletor [label="GET/POST"];
    Coletor -> N8N [label="JSON"];
    N8N -> IA [label="Prompt"];
    IA -> N8N [label="Análise"];
    N8N -> PDF [label="HTML"];
    PDF -> Report [label="Output"];
}

Funcionalidades principais
Análise preditiva: Utiliza o modelo Mistral para identificar a ausência de cabeçalhos críticos como HSTS, CSP e X-Frame-Options.

Orquestração modular: Fluxo de trabalho automatizado via n8n para integração entre coleta e análise.

Simulação didática: Inclui um ambiente de simulação (simulador.html) para demonstração visual de ataques como XSS e Clickjacking.

Geração de laudos: Conversão automática de diagnósticos em documentos PDF profissionais.

Guia de instalação e setup
O projeto utiliza o princípio de Defense in depth, isolando as dependências do sistema através de ambientes virtuais e contêineres.

Provisionamento automático:
Execute o script de setup para configurar o ambiente Python e as dependências do sistema:

sudo ./setup.sh

Este script automatiza a criação do Venv, instalação de pacotes e validação de permissões de diretório.

Inicialização da infraestrutura:
Suba os serviços de orquestração e IA:

docker-compose up -d

Execução do laboratório:
Ative o ambiente virtual e execute o coletor:

source venv/bin/activate
python3 coletor.py

Fluxo de validação contínua (TDD)
A infraestrutura é validada em três etapas antes da geração do artefato final:

Integridade do ambiente: O setup.sh verifica a presença de binários essenciais (Docker, Python).

Conectividade do Hub: Validação de comunicação entre o coletor e o Webhook do n8n.

Auditabilidade do relatório: Verificação de permissões de escrita na pasta relatorios/ antes da conversão para PDF.

Guia de validação de segurança (Pentest e Fuzzing)
Para garantir a resiliência do ambiente, sugerem-se os seguintes testes:

Fuzzing de entrada: Injeção de caracteres especiais e strings de comando no coletor.py para testar a sanitização no n8n.

Escape de contêiner: Tentativa de acesso a arquivos fora da pasta permitida (N8N_RESTRICT_FILE_ACCESS_TO).

Simulação de ataque: Uso do simulador.html para validar se o diagnóstico da IA corresponde ao comportamento real da aplicação vulnerável.
