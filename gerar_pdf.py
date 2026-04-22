from weasyprint import HTML
import os

# Caminhos dos arquivos
arquivo_html = 'relatorios/relatorio_httpbin.html'
arquivo_pdf = 'relatorios/laudo_appsec_final.pdf'

def converter_para_pdf():
    print("[*] Lendo o relatório HTML gerado pela IA...")
    
    if not os.path.exists(arquivo_html):
        print(f"[!] Erro: O arquivo {arquivo_html} não foi encontrado.")
        return

    try:
        print("[*] Renderizando o documento para PDF usando motor seguro (WeasyPrint)...")
        # Converte e salva o PDF
        HTML(arquivo_html).write_pdf(arquivo_pdf)
        
        print(f"[+] Sucesso! O laudo final foi gerado e salvo em: {arquivo_pdf}")
    except Exception as e:
        print(f"[!] Ocorreu um erro durante a conversão: {e}")

if __name__ == "__main__":
    converter_para_pdf()
