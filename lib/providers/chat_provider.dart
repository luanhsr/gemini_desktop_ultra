import 'dart:async';
import 'dart:convert'; // Para o JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Persistência
import '../models/chat_settings.dart';
import '../services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  late GeminiService _geminiService;
  List<Map<String, String>> messages = [];
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
    _loadData(); // Carrega os dados salvos
    startQuotaTimers();
  }

  // --- PERSISTÊNCIA ---
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_messages', jsonEncode(messages));
    await prefs.setInt('total_tokens', totalTokens);
    await prefs.setInt('current_rpd', currentRPD);
    await prefs.setString(
        'last_reset_date', _lastResetDate?.toIso8601String() ?? '');
    await prefs.setString('selected_model', settings.selectedModel);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final msgs = prefs.getString('chat_messages');

    settings.selectedModel =
        prefs.getString('selected_model') ?? 'gemini-2.5-flash';
    _geminiService = GeminiService(settings); // Inicializa com o modelo salvo
    if (msgs != null) {
      final List<dynamic> decoded = jsonDecode(msgs);
      messages.addAll(decoded.map((e) => Map<String, String>.from(e)).toList());
    }

    totalTokens = prefs.getInt('total_tokens') ?? 0;
    currentRPD = prefs.getInt('current_rpd') ?? 1;
    final dateStr = prefs.getString('last_reset_date');
    if (dateStr != null && dateStr.isNotEmpty) {
      _lastResetDate = DateTime.parse(dateStr);
    }
    notifyListeners();
  }

  // --- LOGICA DE ENVIO ---
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
      _saveData(); // Salva após enviar
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

    if (_lastResetDate == null || _lastResetDate!.day != now.day) {
      currentRPD = 1;
      _lastResetDate = now;
    } else {
      currentRPD++;
    }
    notifyListeners();
  }

  void startQuotaTimers() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
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

  void updateTokenCount(int count) {
    totalTokens += count;
    _saveData();
  }

  void clearChat() {
    messages.clear();
    _saveData();
    _geminiService.clearHistory();
    notifyListeners();
  }

  void removeMessage(int index) {
    messages.removeAt(index);
    _saveData();
    _geminiService.clearHistory();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Ajustes ---
  void updateTemperature(double temp) {
    settings.temperature = temp;
    notifyListeners();
  }

  void updateModel(String model) {
    settings.selectedModel = model;
    try {
      _geminiService = GeminiService(settings); // Aqui ele troca a Engine
      _saveData(); // Salva a escolha
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao trocar modelo: $e");
    }
  }
}
