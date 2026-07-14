/// # AIEngine
///
/// Contrato base para integração de modelos de IA.
///
/// Toda implementação deve ser capaz de:
///
/// - Enviar mensagens.
/// - Gerenciar seu próprio histórico.
///
/// Isso permite trocar ou adicionar novas engines
/// sem alterar o restante da aplicação.
///
/// ## Exemplos
///
/// - GeminiEngine
/// - OpenAIEngine
/// - OllamaEngine
abstract class AIEngine {
  /// Envia uma mensagem para a IA e retorna a resposta.
  Future<Map<String, dynamic>> sendMessage(String message);

  /// Limpa o histórico interno da conversa.
  void clearHistory();
}
