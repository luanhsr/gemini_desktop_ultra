#  Gemini Desktop Ultra - ULAN I.A

Um terminal minimalista para interface com I.A. Projetado para ser rápido, eficiente, dinâmico com monitoramento de uso em tempo real e persistência local.

> **Status do Projeto:** 🟡 Beta Refinamento | **Arquitetura:** Provider Pattern + Clean Architecture

##  Sobre o Projeto

O **Ulan I.A - Terminal Ultra** não é apenas um wrapper de API; é um ecossistema completo para entusiastas de I.A que desejam controlar exatamente o custo e o fluxo de dados dos seus prompts de diferentes tipos de I.As gratuitas.

### Principais Funcionalidades

- **Monitoramento de Tráfego ("Sentinela"):** Dashboards dinâmicos calculando em tempo real:
    - **RPM** (Requests Per Minute)
    - **TPM** (Tokens Per Minute)
    - **RPD** (Requests Per Day)
    - **MAS É ESTIMADO, PARA CONTROLE, não recebe os valores reais da API**
- **Multi-Modelo:** Suporte nativo e seleção dinâmica entre a família **Gemini Flash** e futuramente outras I.As
- **Memória Persistente:** Histórico de conversas, consumo de tokens e parâmetros de quota salvos automaticamente via `SharedPreferences`.
- **UI Terminal-Styled:** Design "C-like" com foco em minimalismo e leitura de dados.
- **Segurança de Execução:** Trava de segurança (`isLoading`) impedindo chamadas sobrepostas e controle estrito de cotas para evitar banimento da API.

---

## Tecnologias Utilizadas

- **Linguagem:** Dart
- **Framework:** Flutter (Desktop Windows)
- **Estado:** `provider` (Gerenciamento de Estado)
- **Persistência:** `shared_preferences`
- **Networking:** `google_generative_ai` SDK - em breve novas serão adicionadas
- **Config:** `flutter_dotenv` (Gestão segura de credenciais)

---

## Como Iniciar

### Pré-requisitos
- Flutter SDK instalado.
- **Windows:** Modo de Desenvolvedor habilitado nas configurações do Windows (`ms-settings:developers`).

### Instalação

1. Clone o repositório:
   ```git clone <seu-repositorio>```

2. Instale as dependências:
   ```flutter pub get```

3. Crie um arquivo .env na raiz do projeto com sua API Key do Google AI Studio:
   GEMINI_API_KEY=sua_chave_aqui

4. Execute o terminal:
   ```flutter run```

### Arquitetura Técnica

- lib/providers/chat_provider.dart: Cérebro da operação. Gerencia estado, timers, lógica de quota (janela deslizante) e persistência.
- lib/services/: Camada de comunicação (Proxy/Service). Contratos definidos para abstração futura (Ready for GROQ/DeepSeek).
- lib/widgets/: Componentes modulares (TerminalDrawer, QuotaMonitor, MessageBubble).

### Road-map de Evolução

- [ ] Implementar sistema de "Hub de IAs" (Arquitetura Multi-Provedor).
- [ ] Integração nativa com GROQ (LLama 3/DeepSeek R1).
- [ ] Refatoração para arquitetura de múltiplas conversas.

---
