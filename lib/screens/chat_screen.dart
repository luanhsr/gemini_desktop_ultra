import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/terminal_drawer.dart';
import '../widgets/quota_monitor.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStats = false; // Controle de visibilidade do monitor

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
        actions: [
          IconButton(
            icon: Icon(_showStats ? Icons.analytics : Icons.analytics_outlined),
            tooltip: 'Monitor de Quota',
            onPressed: () => setState(() => _showStats = !_showStats),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Limpar Chat',
            onPressed: () =>
                Provider.of<ChatProvider>(context, listen: false).clearChat(),
          ),
        ],
      ),
      endDrawer: const TerminalDrawer(),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());

          return Column(
            children: [
              // HEADER MINIMALISTA
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  children: [
                    if (_showStats)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: QuotaMonitor(
                          rpm: provider.currentRPM,
                          tpm: provider.currentTPM,
                          rpd: provider.currentRPD,
                          totalTokens: provider.totalTokens, // Novo parâmetro
                          timeRPM: provider.timeUntilRPMReset, // Novo parâmetro
                          timeRPD: provider.timeUntilRPDReset, // Novo parâmetro
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        provider.messages.isEmpty
                            ? '>> STATUS: AGUARDANDO COMANDO...'
                            : '>> TOKENS USADOS: ${provider.totalTokens} / 1048576',
                        style: const TextStyle(
                          color: Color(0xFF7CFF7A),
                          fontFamily: 'Cascadia Code',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                      onDelete: () => provider.removeMessage(index),
                    );
                  },
                ),
              ),

              if (provider.isLoading)
                const LinearProgressIndicator(
                  color: Color(0xFF7CFF7A),
                  backgroundColor: Colors.transparent,
                ),

              ChatInput(
                isLoading: provider.isLoading,
                onSend: (text) => provider.sendMessage(text),
                onQuickAction: (action) {},
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
