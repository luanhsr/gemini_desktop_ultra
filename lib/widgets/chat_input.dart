import 'package:flutter/material.dart';
import 'quick_action_menu.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final Function(String) onQuickAction;
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
  final TextEditingController _controller = TextEditingController();
  bool _menuOpen = false;

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
  }

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
