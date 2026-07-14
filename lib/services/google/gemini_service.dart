import 'package:google_generative_ai/google_generative_ai.dart';
import '../../features/chat/models/chat_settings.dart';

/// # GeminiService
///
/// Camada responsável pela comunicação direta com a API Gemini.
///
/// Este serviço encapsula a biblioteca `google_generative_ai`,
/// isolando os detalhes da API do restante da aplicação.
///
/// ## Responsabilidades
///
/// - Inicializar o modelo selecionado.
/// - Criar e manter uma sessão de conversa.
/// - Enviar mensagens para a IA.
/// - Receber respostas do modelo.
/// - Coletar informações de uso de tokens.
/// - Tratar erros comuns da API.
///
/// ## Fluxo
///
/// ```text
/// ChatProvider
///     ↓
/// GeminiService
///     ↓
/// Google Gemini API
/// ```
///
/// ## Observações
///
/// - O modelo utilizado é definido por [ChatSettings.selectedModel].
/// - A temperatura utilizada é definida por [ChatSettings.temperature].
/// - O histórico da conversa é mantido através de [ChatSession].
/// - Este serviço não possui responsabilidade de interface ou persistência.
///
/// ## Código-fonte
///
/// <https://github.com/luanhsr/gemini_desktop_ultra/blob/main/lib/services/gemini_service.dart>
class GeminiService {
  late GenerativeModel _model;
  late ChatSession _chatSession;

  /// Cria uma nova instância do serviço Gemini.
  ///
  /// Durante a inicialização:
  ///
  /// - Configura o modelo selecionado.
  /// - Aplica os parâmetros definidos em [ChatSettings].
  /// - Inicia uma nova sessão de conversa.
  GeminiService(ChatSettings settings) {
    // Correção: Agora ouve qual modelo o App passar em vez de fixar em um antigo!
    _model = GenerativeModel(
        model: settings.selectedModel,
        apiKey: settings.apiKey.trim(),
        // Bônus: Agora ele escuta a barrinha de Temperatura da sua interface!
        generationConfig: GenerationConfig(
          temperature: settings.temperature,
        ));

    _chatSession = _model.startChat();
  }

  /// Envia uma mensagem para o modelo e retorna a resposta.
  ///
  /// Retorno:
  ///
  /// - `text` → conteúdo retornado pelo modelo.
  /// - `tokens` → quantidade total de tokens utilizados.
  ///
  /// Também realiza tratamento básico de falhas,
  /// incluindo erros de quota e respostas inválidas.
  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      if (message.isEmpty) return {'text': 'Mensagem vazia.', 'tokens': 0};

      final response = await _chatSession.sendMessage(Content.text(message));

      return {
        'text': response.text ?? 'Erro: Resposta vazia ou bloqueada.',
        'tokens': response.usageMetadata?.totalTokenCount ?? 0,
      };
    } catch (e) {
      String errorMsg = e.toString();
      // MANTEMOS seu detector de limite de quota aqui:
      if (errorMsg.contains('429') ||
          errorMsg.contains('Quota exceeded') ||
          errorMsg.contains('limit: 0')) {
        return {
          'text': '>>> BLOQUEIO DE COTA (Aguarde 1 min) <<<\nLog: $errorMsg',
          'tokens': 0
        };
      }
      return {'text': '>>> ERRO NO SERVIÇO <<<\n$errorMsg', 'tokens': 0};
    }
  }

  /// Reinicia a sessão atual de conversa.
  ///
  /// Na prática, cria uma nova [ChatSession],
  /// descartando todo o contexto anterior.
  void clearHistory() {
    _chatSession = _model.startChat();
  }
}
