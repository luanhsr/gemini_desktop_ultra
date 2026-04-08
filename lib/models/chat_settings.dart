class ChatSettings {
  late String apiKey;
  late double temperature;
  late String selectedModel;
  late String mediaResolution;
  late String reasoningLevel;

  ChatSettings({
    required this.apiKey,
    this.temperature = 1.0,
    this.selectedModel = 'gemini-3.1-flash-lite-preview', // << Novo padrão
    this.mediaResolution = 'média',
    this.reasoningLevel = 'médio',
  });
}
