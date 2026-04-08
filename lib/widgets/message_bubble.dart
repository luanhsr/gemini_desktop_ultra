import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import necessário

class MessageBubble extends StatefulWidget {
  final String text;
  final bool isUser;
  final VoidCallback? onDelete;

  const MessageBubble({
    required this.text,
    required this.isUser,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isDeleting = false;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('>> TEXTO COPIADO', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFF7CFF7A),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isDeleting = true),
      onTapUp: (_) => setState(() => _isDeleting = false),
      onTapCancel: () => setState(() => _isDeleting = false),
      onLongPress: () {
        setState(() => _isDeleting = true);
        Future.delayed(const Duration(milliseconds: 200), () {
          if (widget.onDelete != null) widget.onDelete!();
        });
      },
      child: Align(
        alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: _isDeleting
                ? const Color(0xFF4A0000)
                : (widget.isUser
                    ? const Color(0xFF071A07)
                    : const Color(0xFF121212)),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: _isDeleting
                    ? const Color(0xFFFF5E5E)
                    : (widget.isUser
                        ? const Color(0xFF7CFF7A)
                        : const Color(0xFF2A2A2A))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Aqui entra o Markdown em vez do Text simples
              MarkdownBody(
                data: widget.text,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                      color: Color(0xFF8BF18F),
                      fontSize: 15,
                      fontFamily: 'Cascadia Code'),
                  code: const TextStyle(
                      backgroundColor: Color(0xFF000000),
                      fontFamily: 'Cascadia Code',
                      color: Colors.amber),
                  codeblockDecoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4)),
                  strong: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  listBullet: const TextStyle(color: Color(0xFF7CFF7A)),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _copyToClipboard(context),
                  child: const Icon(Icons.content_copy_outlined,
                      size: 14, color: Color(0xFF555555)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
