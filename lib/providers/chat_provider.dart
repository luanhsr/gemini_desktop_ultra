import 'package:flutter/material.dart';
import '../models/chat_settings.dart';
import '../services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  late GeminiService _geminiService;
  final List<Map<String, String>> messages = [];
  bool isLoading = false;
  late ChatSettings settings;

  ChatProvider(this.settings) {
    _geminiService = GeminiService(settings);
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    messages.add({'role': 'user', 'text': text});
    isLoading = true;
    notifyListeners();

    try {
      final response = await _geminiService.sendMessage(text);
      messages.add({'role': 'model', 'text': response});
    } catch (e) {
      messages.add({'role': 'model', 'text': 'Erro: $e'});
    }

    isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    messages.clear();
    _geminiService.clearHistory();
    notifyListeners();
  }

  void updateTemperature(double temp) {
    settings.temperature = temp;
    notifyListeners();
  }

  void updateModel(String model) {
    settings.selectedModel = model;
    _geminiService = GeminiService(settings);
    notifyListeners();
  }

  void updateMediaResolution(String resolution) {
    settings.mediaResolution = resolution;
    notifyListeners();
  }

  void updateReasoningLevel(String level) {
    settings.reasoningLevel = level;
    notifyListeners();
  }
}
