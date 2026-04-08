# Gemini Desktop Ultra (nome pode trocar)

O **Gemini Desktop Ultra** é um terminal de I.A de alta performance desenvolvido em Flutter. Ele oferece monitoramento em tempo real de consumo de tokens, limites de API (RPM, TPM, RPD) e uma interface minimalista estilo "hacker/terminal".

## Funcionalidades
- **Monitoramento em Tempo Real:** Acompanhe seu uso de RPM (Requisições por minuto), TPM (Tokens por minuto) e RPD (Requisições por dia).
- **Interface Minimalista:** Design focado em produtividade, sem distrações.
- **Controle de Parâmetros:** Ajuste de temperatura, modelo e instruções de sistema.
- **Histórico Inteligente:** Gerenciamento de contexto com reset de memória.

##  Como rodar o projeto

### Pré-requisitos
- Flutter SDK instalado e configurado.
- Editor de código (VS Code recomendado).

### Passo a passo

1. **Clone o repositório:**
```bash
git clone https://github.com/luanhsr/gemini_desktop_ultra.git
cd gemini_desktop_ultra
```

2. **Instale as dependências:**
```bash
flutter pub get
```

3. **Configure suas credenciais:**
- Na raiz do projeto, crie um arquivo chamado `.env`.
- Insira sua chave de API do Google AI Studio da seguinte forma:
```
GEMINI_API_KEY=SUA_CHAVE_API_AQUI
```
(Nota: Insira a chave após o sinal de = sem espaços e sem aspas).

4. **Execute o projeto:**
```bash
flutter run
```

## Tecnologias Utilizadas
- Flutter: Framework principal.
- Provider: Gerenciamento de estado.
- Google Generative AI: Integração com modelos Gemini.
- Flutter Dotenv: Gerenciamento seguro de chaves de API.
