import 'dart:async';
import 'dart:convert'; // Para o JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Persistência
import '../models/chat_settings.dart';
import '../../../services/google/gemini_service.dart';

/// # ChatProvider
///
/// Principal controlador de estado da aplicação.
///
/// Este provider atua como ponto central de comunicação entre
/// a interface e os serviços responsáveis pelas interações com a IA.
///
/// Além do gerenciamento das mensagens, ele também é responsável
/// por controlar configurações da sessão, persistência local
/// e monitoramento estimado de consumo.
///
/// ## Responsabilidades
///
/// - Armazenar o histórico de mensagens.
/// - Enviar mensagens para o GeminiService.
/// - Receber respostas do modelo.
/// - Persistir dados localmente.
/// - Gerenciar configurações ativas.
/// - Monitorar métricas de uso.
/// - Notificar a interface quando houver alterações.
///
/// ## Componentes Relacionados
///
/// ```text
/// Widgets
///     ↓
/// ChatProvider
///     ↓
/// GeminiService
///     ↓
/// API Gemini
/// ```
///
/// ## Estados Gerenciados
///
/// | Estado | Finalidade |
/// |----------|----------|
/// | `messages` | Histórico da conversa atual. |
/// | `isLoading` | Indica que uma requisição está em andamento. |
/// | `settings` | Configurações ativas do chat. |
/// | `totalTokens` | Total estimado de tokens utilizados. |
/// | `currentRPM` | Requisições realizadas no último minuto. |
/// | `currentTPM` | Tokens utilizados no último minuto. |
/// | `currentRPD` | Requisições realizadas no dia atual. |
///
/// ## Persistência
///
/// O provider salva automaticamente informações importantes
/// utilizando SharedPreferences.
///
/// Atualmente são persistidos:
///
/// - Histórico de mensagens.
/// - Modelo selecionado.
/// - Total de tokens.
/// - Estatísticas diárias.
///
/// Isso permite que parte do estado seja restaurada
/// quando a aplicação for iniciada novamente.
///
/// ## Observações
///
/// - Este é o principal ponto de atualização da interface.
/// - Toda alteração relevante executa `notifyListeners()`.
/// - O provider não se comunica diretamente com a API.
/// - Toda comunicação externa ocorre através do [GeminiService].
///
/// ## Código-fonte
///
/// <https://github.com/luanhsr/gemini_desktop_ultra/blob/main/lib/providers/chat_provider.dart>
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

  /// Cria uma nova instância do ChatProvider.
  ///
  /// Durante a inicialização:
  ///
  /// 1. Cria o GeminiService.
  /// 2. Carrega dados persistidos.
  /// 3. Inicia os temporizadores de monitoramento.
  ///
  /// Fluxo:
  ///
  /// ```text
  /// ChatProvider
  ///     ↓
  /// GeminiService
  ///     ↓
  /// _loadData()
  ///     ↓
  /// startQuotaTimers()
  /// ```
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

  /// Envia uma mensagem para o modelo atualmente selecionado.
  ///
  /// Este método representa o fluxo principal da aplicação.
  ///
  /// ## Fluxo
  ///
  /// ```text
  /// Usuário
  ///     ↓
  /// sendMessage()
  ///     ↓
  /// Adiciona mensagem localmente
  ///     ↓
  /// Ativa isLoading
  ///     ↓
  /// GeminiService.sendMessage()
  ///     ↓
  /// Recebe resposta
  ///     ↓
  /// Atualiza métricas
  ///     ↓
  /// Salva dados
  ///     ↓
  /// Atualiza interface
  /// ```
  ///
  /// ## Comportamentos
  ///
  /// - Ignora mensagens vazias.
  /// - Impede múltiplos envios simultâneos.
  /// - Registra mensagens do usuário.
  /// - Registra respostas do modelo.
  /// - Atualiza estatísticas de consumo.
  /// - Persiste os dados localmente.
  ///
  /// Em caso de erro, a falha é adicionada ao histórico
  /// como uma mensagem do modelo.
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

  /// ## Atualiza métricas locais de utilização.
  ///
  /// Os valores calculados aqui são apenas estimativas
  /// utilizadas para monitoramento visual.
  ///
  /// **Métricas atualizadas:**
  ///
  /// - RPM
  /// - TPM
  /// - RPD
  ///
  /// Também registra o horário da requisição
  /// para permitir cálculos temporais posteriores.
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

  /// ## Inicia os temporizadores responsáveis pelo cálculo
  /// contínuo das métricas de uso.
  ///
  /// Um timer é executado a cada segundo para:
  ///
  /// - Remover registros expirados.
  /// - Recalcular RPM.
  /// - Recalcular TPM.
  /// - Atualizar contadores regressivos.
  /// - Notificar a interface.
  ///
  /// ## Janela de cálculo
  ///
  /// RPM e TPM utilizam uma janela móvel de 60 segundos.
  ///
  /// Isso significa que valores antigos são removidos
  /// automaticamente conforme envelhecem.
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

  /// Altera o modelo atualmente utilizado.
  ///
  /// Sempre que um novo modelo é selecionado:
  ///
  /// 1. O valor é salvo em `settings`.
  /// 2. Um novo GeminiService é criado.
  /// 3. A configuração é persistida.
  /// 4. A interface é atualizada.
  ///
  /// A recriação do serviço garante que futuras requisições
  /// utilizem imediatamente o novo modelo selecionado.
  ///
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
