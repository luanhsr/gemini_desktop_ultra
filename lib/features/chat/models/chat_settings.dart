/// # ChatSettings
///
/// Modelo que concentra as configurações ativas do chat.
///
/// Ele funciona como o pacote de estado que a aplicação usa para saber:
///
/// - qual chave está sendo usada;
/// - qual modelo está selecionado;
/// - qual temperatura a geração deve seguir;
/// - qual resolução será usada para mídia;
/// - qual nível de raciocínio a interface está pedindo.
///
/// ## Papel no sistema
///
/// Este objeto costuma circular entre `provider`, `services` e widgets.
/// A ideia é simples: o estado fica reunido em um único lugar, em vez de
/// espalhar valores soltos pela aplicação.
///
/// ## Valores padrão
///
/// ```dart
/// selectedModel = 'gemini-3.1-flash-lite-preview'
/// temperature = 1.0
/// mediaResolution = 'média'
/// reasoningLevel = 'médio'
/// ```
///
/// ## Observação importante
///
/// `apiKey` é obrigatória porque o objeto não faz sentido sem uma credencial
/// válida para a comunicação com a API.
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
