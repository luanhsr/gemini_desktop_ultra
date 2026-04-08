import 'dart:async'; // Necessário para o Timer
import 'package:flutter/material.dart';
import '../models/chat_settings.dart';
import '../services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  late GeminiService _geminiService;
  final List<Map<String, String>> messages = [];
  bool isLoading = false;
  late ChatSettings settings;

  int totalTokens = 0;
  int currentRPM = 0;
  int currentTPM = 0;
  int currentRPD = 1;

  final List<DateTime> _requestTimestamps = [];
  final List<Map<String, dynamic>> _tokenUsageLog = [];
  DateTime? _lastResetDate;

  Timer? _timer;
  Duration timeUntilRPMReset = Duration.zero;
  Duration timeUntilRPDReset = const Duration(hours: 24);

  ChatProvider(this.settings) {
    _geminiService = GeminiService(settings);
    startQuotaTimers(); // Iniciamos o timer assim que o App abre
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty || isLoading) return;

    messages.add({'role': 'user', 'text': text});
    isLoading = true;
    notifyListeners();

    try {
      final responseData = await _geminiService.sendMessage(text);
      messages.add({'role': 'model', 'text': responseData['text'].toString()});

      int tokens = responseData['tokens'] as int;
      if (tokens > 0) {
        updateTokenCount(tokens);
        _updateQuotaMetrics(tokens);
      }
    } catch (e) {
      messages.add({'role': 'model', 'text': 'Erro: $e'});
    }

    isLoading = false;
    notifyListeners();
  }

  void _updateQuotaMetrics(int tokensSent) {
    DateTime now = DateTime.now();
    _requestTimestamps.add(now);
    _tokenUsageLog.add({'time': now, 'tokens': tokensSent});

    // RPD Logic
    if (_lastResetDate == null || _lastResetDate!.day != now.day) {
      currentRPD = 2;
      _lastResetDate = now;
    } else {
      currentRPD++;
    }
    notifyListeners();
  }

  void startQuotaTimers() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();

      // Limpa janelas expiradas
      _requestTimestamps.removeWhere((t) => now.difference(t).inSeconds >= 60);
      _tokenUsageLog.removeWhere(
          (t) => now.difference(t['time'] as DateTime).inSeconds >= 60);

      currentRPM = _requestTimestamps.length;
      currentTPM =
          _tokenUsageLog.fold(0, (sum, item) => sum + (item['tokens'] as int));

      if (_requestTimestamps.isNotEmpty) {
        timeUntilRPMReset = const Duration(minutes: 1) -
            now.difference(_requestTimestamps.first);
      } else {
        timeUntilRPMReset = Duration.zero;
      }

      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      timeUntilRPDReset = endOfDay.difference(now);

      notifyListeners();
    });
  }

  void updateTokenCount(int count) => totalTokens += count;

  void clearChat() {
    messages.clear();
    _geminiService.clearHistory();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Importante: mata o timer ao fechar o provider
    super.dispose();
  }

  void removeMessage(int index) {
    messages.removeAt(index);
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
}
