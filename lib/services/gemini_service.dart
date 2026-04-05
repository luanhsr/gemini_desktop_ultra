import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_settings.dart';

class GeminiService {
  late GenerativeModel model;
  late ChatSession chat;
  final List<Content> history = [];

  GeminiService(ChatSettings settings) {
    model = GenerativeModel(
      model: settings.selectedModel,
      apiKey: settings.apiKey,
      generationConfig: GenerationConfig(
        temperature: settings.temperature,
        topP: 0.95,
        topK: 40,
      ),
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      history.add(Content.text(message));
      chat = model.startChat(
        history:
            history.sublist(0, history.length > 0 ? history.length - 1 : 0),
      );

      final response = await chat.sendMessage(Content.text(message));
      final responseText = response.text ?? 'Sem resposta';

      history.add(Content.model([TextPart(responseText)]));
      return responseText;
    } catch (e) {
      return 'Erro na API: $e';
    }
  }

  void clearHistory() {
    history.clear();
  }
}
