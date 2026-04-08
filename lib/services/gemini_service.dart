import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_settings.dart';

class GeminiService {
  late GenerativeModel _model;
  late ChatSession _chatSession;

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

  void clearHistory() {
    _chatSession = _model.startChat();
  }
}
