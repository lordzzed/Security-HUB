🛡️ Security HUB: Automação AppSec com IAO Security HUB é uma solução modular de infraestrutura projetada para auditoria preditiva de segurança em aplicações web. Ele combina coleta de dados, orquestração de fluxos e análise baseada em Inteligência Artificial local (Mistral) para identificar vulnerabilidades estruturais antes que elas cheguem em produção.🏗️ Arquitetura do EcossistemaDiferente do código puro, o GitHub renderiza este diagrama automaticamente para os seus alunos:Snippet de códigograph LR
    A[Target Application] -->|Extrator| B(Python Collector)
    B -->|Webhook JSON| C{n8n Hub}
    C -->|Prompt| D[Ollama: Mistral]
    D -->|Analysis| C
    C -->|HTML Stream| E[WeasyPrint Engine]
    E -->|Final PDF| F((Technical Report))

    style D fill:#fff9c4,stroke:#333
    style C fill:#e1f5fe,stroke:#333
    style F fill:#c8e6c9,stroke:#333
🚀 Funcionalidades Principais🧠 Análise Preditiva: O modelo Mistral analisa cabeçalhos e sugere mitigações reais baseadas em Top 10 OWASP.⛓️ Orquestração Low-Code: Fluxos gerenciados via n8n para facilitar a manutenção do laboratório.📂 Geração de Artefatos: Conversão automática de HTML para laudos técnicos em PDF profissionais.🎮 Lab Interativo: Simulador visual de ataques (XSS, Clickjacking) para fins didáticos.⚙️ Instalação e SetupO projeto adota o princípio de Defense in Depth, garantindo isolamento total entre o sistema operacional e as ferramentas do lab.1. Provisionamento do SOBashsudo ./setup.sh
Este script configura o ambiente virtual (Venv) e instala as dependências gráficas necessárias.2. Inicialização da InfraBashdocker-compose up -d
3. Execução do ColetorBashsource venv/bin/activate
python3 coletor.py
🧪 Guia de Validação (Pentest & Fuzzing)Para garantir a resiliência do ambiente durante o curso, realize os seguintes testes:Fuzzing de Entrada: Tente injetar special characters no coletor.py para testar a sanitização do n8n.Escape de Contêiner: Valide se o mapeamento de volume está restrito ao diretório /relatorios/.Auditabilidade: Verifique se o PDF gerado mantém a integridade dos dados extraídos do alvo inicial.📦 Estrutura do RepositórioArquivoFunçãocoletor.pyExtração de headers via Requestsgerar_pdf.pyMotor de renderização WeasyPrintsetup.shAutomação de infra e TDD de ambientesimulador.htmlInterface visual de PoC (Ataques)
