import requests
import json
import datetime

# Configurações
ALVO = "http://httpbin.org/get"
WEBHOOK_N8N = "http://localhost:5678/webhook-test/coleta-headers"

def coletar_headers(url):
    print(f"[*] Iniciando varredura didática no alvo: {url}")
    try:
        resposta = requests.get(url, timeout=10)
        headers = dict(resposta.headers)
        
        headers['Date'] = datetime.datetime.now(datetime.timezone.utc).strftime('%a, %d %b %Y %H:%M:%S GMT')
        
        payload = {
            "alvo": url,
            "dados_brutos": headers
        }
        
        print("[*] Cabeçalhos extraídos com sucesso. Enviando para o Hub (n8n)...")
        enviar_n8n(payload)
        
    except requests.exceptions.RequestException as e:
        print(f"[!] Erro ao conectar no alvo: {e}")

def enviar_n8n(payload):
    try:
        resposta = requests.post(WEBHOOK_N8N, json=payload)
        if resposta.status_code == 200:
            print("[+] Dados enviados com sucesso para o motor de IA!")
        else:
            print(f"[!] O n8n rejeitou o payload. Status: {resposta.status_code}")
    except requests.exceptions.ConnectionError:
        print("[!] Erro: Não foi possível alcançar o n8n.")

if __name__ == "__main__":
    coletar_headers(ALVO)
