import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import 'system_instruction_panel.dart';

class TerminalDrawer extends StatelessWidget {
  const TerminalDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TERMINAL CONFIGURAÇÕES',
                  style: TextStyle(
                    color: Color(0xFF7CFF7A),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Modelo:',
                  style: TextStyle(color: Color(0xFF8BF18F)),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: provider.settings.selectedModel,
                  isExpanded: true,
                  style: const TextStyle(color: Color(0xFF8BF18F)),
                  items: const [
                    DropdownMenuItem(
                        value: 'gemini-1.5-pro', child: Text('Gemini 1.5 Pro')),
                    DropdownMenuItem(
                        value: 'gemini-1.5-flash',
                        child: Text('Gemini 1.5 Flash')),
                    DropdownMenuItem(
                        value: 'gemini-2.0-flash-thinking-exp',
                        child: Text('Gemini 2.0 Thinking')),
                  ],
                  onChanged: (val) {
                    if (val != null) provider.updateModel(val);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Temperatura: ${provider.settings.temperature.toStringAsFixed(1)}',
                  style: const TextStyle(color: Color(0xFF8BF18F)),
                ),
                Slider(
                  activeColor: const Color(0xFF7CFF7A),
                  inactiveColor: const Color(0xFF1C1C1C),
                  value: provider.settings.temperature,
                  min: 0,
                  max: 2,
                  divisions: 20,
                  onChanged: (val) => provider.updateTemperature(val),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Resolução de Mídia:',
                  style: TextStyle(color: Color(0xFF8BF18F)),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: provider.settings.mediaResolution,
                  isExpanded: true,
                  style: const TextStyle(color: Color(0xFF8BF18F)),
                  items: [
                    DropdownMenuItem(
                      value: 'baixa',
                      child: Tooltip(
                        message:
                            'A IA reduz a qualidade da imagem para o mínimo necessário.\nUso: Identificar objetos grandes ou entender o contexto geral de uma foto. É mais rápido e economiza limite de processamento.',
                        child: const Text('Baixa'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'média',
                      child: Tooltip(
                        message:
                            'Um equilíbrio entre nitidez e velocidade.\nUso: O padrão para a maioria das tarefas onde você precisa que a IA entenda detalhes sem ser algo extremamente minucioso.',
                        child: const Text('Média'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'alta',
                      child: Tooltip(
                        message:
                            'A IA analisa a imagem em alta definição (geralmente dividindo-a em partes menores para não perder detalhes).\nUso: Essencial para ler textos pequenos em documentos escaneados, identificar códigos em prints de tela ou analisar detalhes técnicos em diagramas. Consome muito mais "espaço" na memória do chat.',
                        child: const Text('Alta'),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) provider.updateMediaResolution(val);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nível de Raciocínio:',
                  style: TextStyle(color: Color(0xFF8BF18F)),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: provider.settings.reasoningLevel,
                  isExpanded: true,
                  style: const TextStyle(color: Color(0xFF8BF18F)),
                  items: [
                    DropdownMenuItem(
                      value: 'mínimo',
                      child: Tooltip(
                        message:
                            'A IA responde de forma básica e rápida.\nUso: Tarefas simples e diretas.',
                        child: const Text('Mínimo'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'baixo',
                      child: Tooltip(
                        message:
                            'A IA responde de forma mais instintiva e direta.\nNa prática: É ideal para tarefas criativas, resumos simples ou conversas informais. A resposta é quase instantânea.',
                        child: const Text('Baixo'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'médio',
                      child: Tooltip(
                        message:
                            'A IA faz uma verificação rápida de lógica antes de responder.\nNa prática: Bom para tarefas de escrita que exigem estrutura ou explicações que precisam de um encadeamento lógico claro.',
                        child: const Text('Médio'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'alto',
                      child: Tooltip(
                        message:
                            'Ativa o "Deep Thinking" (Pensamento Profundo). A IA cria uma cadeia complexa de raciocínio, testa hipóteses internamente e corrige erros antes mesmo de você ver a primeira palavra.\nNa prática: Usado para matemática avançada, depuração de códigos complexos (debugging), lógica pesada ou problemas que exigem planejamento de várias etapas. A resposta demora mais para começar a aparecer porque a IA está "pensando".',
                        child: const Text('Alto'),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) provider.updateReasoningLevel(val);
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    SystemInstructionPanel.open(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090909),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xFF7CFF7A), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Instrução de sistema',
                          style: TextStyle(
                            color: Color(0xFF7CFF7A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Personalize como a I.A deve responder.',
                          style: TextStyle(color: Color(0xFF8BF18F)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFF7CFF7A)),
                const SizedBox(height: 16),
                const Text(
                  'STATUS: ONLINE',
                  style: TextStyle(
                    color: Color(0xFFFFEA00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
