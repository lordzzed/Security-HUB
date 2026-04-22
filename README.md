Documentação do projeto security hub
Hub de automação em AppSec projetado para auditoria preditiva de cabeçalhos HTTP. A infraestrutura integra Inteligência Artificial local (Mistral), orquestração modular via n8n e motores de renderização segura para a geração automática de laudos técnicos.

Arquitetura de fluxo de dados
O diagrama abaixo ilustra a arquitetura assíncrona e o fluxo de dados entre o extrator e a camada de inteligência:

Snippet de código
flowchart TD
    subgraph Coleta [Camada de Extração]
        Target[Aplicação Alvo] -- Headers --> Collector[Coletor Python]
        Collector -- Payload JSON --> WAF[n8n Webhook]
    end

    subgraph Inteligencia [Orquestração e IA]
        WAF -- Prompt Engineering --> AI[Ollama: Mistral]
        AI -- Análise Preditiva --> WAF
    end

    subgraph Output [Gerador de Artefatos]
        WAF -- Stream HTML --> PDF[Engine WeasyPrint]
        PDF -- Laudo Técnico --> Storage[(Relatórios PDF)]
    end

    style AI fill:#fff9c4,stroke:#333,stroke-width:2px,color:#000
    style Storage fill:#c8e6c9,stroke:#333,stroke-width:2px,color:#000
    style WAF fill:#e1f5fe,stroke:#333,stroke-width:2px,color:#000
Stack de arquitetura
n8n (Orquestrador): Hub central que gerencia o ciclo de vida dos dados, desde o recebimento via Webhook até a formatação Markdown.

Ollama (Mistral): Modelo de linguagem local responsável pela auditoria de segurança preditiva, eliminando a dependência de APIs de terceiros.

WeasyPrint: Motor de renderização seguro que converte artefatos HTML em documentos PDF profissionais e selecionáveis.

Python 3.10+: Linguagem core do coletor de headers e do script de automação de setup.

Diretrizes de segurança (Defense in depth)
Este ambiente segue restrições críticas de segurança validadas em laboratório:

Isolamento de File System: O acesso do orquestrador é restrito via variável N8N_RESTRICT_FILE_ACCESS_TO, prevenindo vulnerabilidades de Path Traversal no host.

Ambiente Confinado (Venv): Todas as dependências Python residem em um Virtual Environment isolado, prevenindo a poluição de bibliotecas do sistema operacional.

Sanitização de Entrada: O fluxo do n8n atua como uma camada de sanitização antes que os dados cheguem ao modelo de IA.

Variáveis de ambiente
Crie um arquivo .env na raiz do projeto para configurar os endpoints da sua infraestrutura local.

Snippet de código
# Endpoints do Laboratório
N8N_WEBHOOK_URL=http://localhost:5678/webhook-test/security-hub
OLLAMA_API_BASE=http://localhost:11434

# Configurações de Escrita
N8N_RESTRICT_FILE_ACCESS_TO=/home/node/relatorios
Procedimento de subida de ambiente
Para realizar o deploy deste laboratório em um ambiente Kali Linux:

Clone o repositório:

Bash
git clone https://github.com/lordzzed/Security-HUB.git
cd Security-HUB
Execute o provisionamento automático (Setup):

Bash
sudo chmod +x setup.sh
sudo ./setup.sh
Este comando configura o Venv, instala dependências do SO e valida o ambiente (TDD).

Inicie a orquestração de contêineres:

Bash
docker-compose up -d
Acesse o Simulador Local:
Abra o navegador em http://localhost:8080/simulador.html para realizar testes de PoC (XSS/Clickjacking).
