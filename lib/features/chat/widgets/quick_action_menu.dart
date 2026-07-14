/// # QuickActionMenu
///
/// Widget responsável pela exibição do menu de ações rápidas
/// disponível na interface do chat.
///
/// Este componente fornece atalhos para recursos que podem ser
/// utilizados durante uma conversa, evitando que o usuário precise
/// executar fluxos mais longos para acessar funcionalidades comuns.
///
/// ## Responsabilidades
///
/// - Exibir o menu de ações rápidas.
/// - Controlar animações de abertura e fechamento.
/// - Encaminhar ações selecionadas para o componente pai.
/// - Fornecer feedback visual durante a exibição.
/// - Disponibilizar atalhos para recursos multimídia.
///
/// ## Dependências
///
/// - AnimationController
/// - SingleTickerProviderStateMixin
/// - SizeTransition
/// - AnimatedBuilder
///
/// ## Fluxo
///
/// ```text
/// Usuário
///     ↓
/// Abre menu
///     ↓
/// visible = true
///     ↓
/// AnimationController
///     ↓
/// Menu expandido
///     ↓
/// Seleciona ação
///     ↓
/// onAction()
/// ```
///
/// ## Ações Disponíveis
///
/// | Ação | Finalidade |
/// |--------|--------|
/// | drive | Integração com arquivos do Google Drive. |
/// | upload | Envio de arquivos locais. |
/// | audio | Gravação ou envio de áudio. |
/// | camera | Captura de imagem pela câmera. |
/// | youtube | Utilização de vídeos do YouTube. |
/// | media | Seleção de mídia genérica. |
///
/// ## Sistema de Animação
///
/// O menu utiliza duas animações independentes:
///
/// - Expansão vertical através de [SizeTransition].
/// - Efeito visual "glitch" através de deslocamentos animados.
///
/// ## Observações
///
/// - O componente não executa as ações diretamente.
/// - Toda ação é encaminhada através de `onAction`.
/// - O estado de visibilidade é controlado externamente.
/// - O widget mantém apenas o estado necessário para animações.
///
/// ## Código-fonte
///
/// <https://github.com/luanhsr/gemini_desktop_ultra/blob/main/lib/widgets/quick_action_menu.dart>

import 'package:flutter/material.dart';

class QuickActionMenu extends StatefulWidget {
  /// Define se o menu deve estar visível.
  final bool visible;

  /// Callback executado quando uma ação é selecionada.
  final ValueChanged<String> onAction;

  const QuickActionMenu({
    required this.visible,
    required this.onAction,
    Key? key,
  }) : super(key: key);

  @override
  State<QuickActionMenu> createState() => _QuickActionMenuState();
}

class _QuickActionMenuState extends State<QuickActionMenu>
    with SingleTickerProviderStateMixin {
  /// Controlador principal das animações do menu.
  late final AnimationController _controller;

  /// Controla a expansão e recolhimento do menu.
  late final Animation<double> _expandAnimation;

  /// Responsável pelo efeito visual de deslocamento ("glitch")
  /// exibido durante a abertura do menu.
  late final Animation<Offset> _glitchOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 260),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _glitchOffset = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0), end: const Offset(3, -1)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(3, -1), end: const Offset(-2, 2)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-2, 2), end: const Offset(2, -1)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(2, -1), end: const Offset(0, 0)),
        weight: 10,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.linear),
    ));
  }

  @override
  void didUpdateWidget(covariant QuickActionMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      _controller.forward(from: 0);
    } else if (!widget.visible && oldWidget.visible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIcon(String label, IconData icon, String action) {
    return Tooltip(
      message: label,
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF7CFF7A)),
        onPressed: () => widget.onAction(action),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      axisAlignment: -1,
      child: AnimatedBuilder(
        animation: _glitchOffset,
        builder: (context, child) {
          return Transform.translate(
            offset: _glitchOffset.value,
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF050505),
            border: Border.all(color: const Color(0xFF7CFF7A), width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIcon('Drive', Icons.drive_folder_upload, 'drive'),
              _buildIcon('Upload', Icons.upload_file, 'upload'),
              _buildIcon('Gravar Áudio', Icons.mic, 'audio'),
              _buildIcon('Câmera', Icons.camera_alt, 'camera'),
              _buildIcon('Youtube Video', Icons.ondemand_video, 'youtube'),
              _buildIcon('Mídia Simples', Icons.perm_media, 'media'),
            ],
          ),
        ),
      ),
    );
  }
}
