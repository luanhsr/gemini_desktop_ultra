/// # ChatInput
///
/// Componente responsável pela entrada de comandos do usuário.
///
/// Este widget concentra toda a interação de entrada da tela de chat,
/// permitindo:
///
/// - Digitação manual de comandos.
/// - Envio de mensagens.
/// - Execução de ações rápidas.
/// - Controle visual do menu de ações rápidas.
///
/// ## Estado Interno
///
/// | Campo | Função |
/// |---------|---------|
/// | `_controller` | Armazena e controla o texto digitado pelo usuário. |
/// | `_menuOpen` | Controla a visibilidade do [QuickActionMenu]. |
///
/// ## Callbacks Externos
///
/// | Callback | Responsabilidade |
/// |------------|------------------|
/// | `onSend` | Recebe o texto digitado quando uma mensagem é enviada. |
/// | `onQuickAction` | Recebe a ação escolhida no menu rápido. |
///
/// ## Fluxo de Envio
///
/// ```text
/// Usuário
///     ↓
/// Digita mensagem
///     ↓
/// Enter ou botão enviar
///     ↓
/// onSend(texto)
///     ↓
/// Campo é limpo
/// ```
///
/// ## Fluxo de Ações Rápidas
///
/// ```text
/// Usuário
///     ↓
/// Botão '+'
///     ↓
/// QuickActionMenu
///     ↓
/// Seleciona ação
///     ↓
/// onQuickAction()
///     ↓
/// Menu é fechado
/// ```
///
/// ## Dependências
///
/// - [QuickActionMenu]
/// - Material Dart
///
/// ## Observações
///
/// - Quando `isLoading` é verdadeiro, novos envios são bloqueados.
/// - O menu de ações rápidas também é bloqueado durante carregamento.
/// - O widget mantém apenas estado visual local.
/// - O processamento das mensagens ocorre fora deste componente.
///
/// ## Código-fonte
///
/// <https://github.com/luanhsr/gemini_desktop_ultra/blob/main/lib/widgets/chat_input.dart>
import 'package:flutter/material.dart';
import 'quick_action_menu.dart';

class ChatInput extends StatefulWidget {
  /// Callback executado quando o usuário envia uma mensagem.
  final Function(String) onSend;

  /// Callback executado quando uma ação rápida é selecionada.
  final Function(String) onQuickAction;

  /// Indica que uma operação está em andamento.
  ///
  /// Quando verdadeiro, o envio de mensagens e as ações rápidas
  /// ficam temporariamente indisponíveis.
  final bool isLoading;
  const ChatInput({
    required this.onSend,
    required this.onQuickAction,
    required this.isLoading,
    Key? key,
  }) : super(key: key);
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  /// Controla o conteúdo digitado pelo usuário.
  ///
  /// Também é utilizado para limpar o campo após o envio.
  final TextEditingController _controller = TextEditingController();

  /// Controla a visibilidade do [QuickActionMenu].
  bool _menuOpen = false;

  /// Alterna a visibilidade do menu de ações rápidas.
  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
  }

  /// Encaminha a ação selecionada para o callback externo
  /// e fecha o menu após a execução.
  void _handleQuickAction(String action) {
    widget.onQuickAction(action);
    setState(() => _menuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuickActionMenu(
          visible: _menuOpen,
          onAction: _handleQuickAction,
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFF070707),
            border: Border(
              top: BorderSide(color: Color(0xFF7CFF7A), width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  style: const TextStyle(color: Color(0xFF8BF18F)),
                  decoration: const InputDecoration(
                    hintText: 'COMANDO >',
                    hintStyle: TextStyle(color: Color(0xFF7CFF7A)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: widget.isLoading
                      ? null
                      : (_) {
                          widget.onSend(_controller.text);
                          _controller.clear();
                        },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7CFF7A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.black,
                  tooltip: 'Ações rápidas',
                  onPressed: widget.isLoading ? null : _toggleMenu,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF7CFF7A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  icon: const Icon(Icons.keyboard_return),
                  color: Colors.black,
                  onPressed: widget.isLoading
                      ? null
                      : () {
                          widget.onSend(_controller.text);
                          _controller.clear();
                        },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override

  /// Libera os recursos associados ao [_controller].
  ///
  /// Necessário para evitar vazamentos de memória quando
  /// o widget é removido da árvore de widgets.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
