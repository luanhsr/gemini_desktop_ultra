class ChatSettings {
  late String apiKey;
  late double temperature;
  late String selectedModel;
  late String mediaResolution;
  late String reasoningLevel;

  ChatSettings({
    required this.apiKey,
    this.temperature = 0.7,
    this.selectedModel = 'gemini-1.5-flash',
    this.mediaResolution = 'média',
    this.reasoningLevel = 'médio',
  });
}
