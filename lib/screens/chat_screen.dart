import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/terminal_drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Ulan I.A - TERMINAL ULTRA'),
        actions: [],
      ),
      endDrawer: const TerminalDrawer(),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF090909),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF7CFF7A), width: 1),
                  ),
                ),
                child: const Text(
                  '>> ESPAÇO DE MEMÓRIA: ATIVADO',
                  style: TextStyle(
                    color: Color(0xFF7CFF7A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return MessageBubble(
                      text: message['text']!,
                      isUser: message['role'] == 'user',
                    );
                  },
                ),
              ),
              if (provider.isLoading)
                const LinearProgressIndicator(
                  color: Color(0xFF7CFF7A),
                  backgroundColor: Color(0xFF050505),
                ),
              ChatInput(
                onSend: (text) {
                  provider.sendMessage(text);
                  _scrollToBottom();
                },
                onQuickAction: (action) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Função ainda não inserida'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xFF050505),
                    ),
                  );
                },
                isLoading: provider.isLoading,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
