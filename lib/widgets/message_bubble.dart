import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({
    required this.text,
    required this.isUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF071A07) : const Color(0xFF121212),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isUser ? const Color(0xFF7CFF7A) : const Color(0xFF2A2A2A),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF8BF18F),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
