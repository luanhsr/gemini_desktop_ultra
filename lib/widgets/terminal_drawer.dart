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
      // Envolvemos em SingleChildScrollView para evitar estouro de tela
      child: SingleChildScrollView(
        child: Consumer<ChatProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Espaço extra pro topo
                  const Text(
                    'TERMINAL CONFIGURAÇÕES',
                    style: TextStyle(
                      color: Color(0xFF7CFF7A),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Modelo:',
                      style: TextStyle(color: Color(0xFF8BF18F))),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    dropdownColor: Colors.black,
                    value: provider.settings.selectedModel,
                    isExpanded: true,
                    style: const TextStyle(color: Color(0xFF8BF18F)),
                    // LISTA UNIFICADA E SEM DUPLICATAS:
                    items: const [
                      DropdownMenuItem(
                          value: 'gemini-3.1-flash-lite-preview',
                          child: Text('Gemini 3.1 Flash Lite')),
                      DropdownMenuItem(
                          value: 'gemini-2.5-flash',
                          child: Text('Gemini 2.5 Flash')),
                      DropdownMenuItem(
                          value: 'gemma-3-1b-it', child: Text('Gemma 3 - 1B')),
                      DropdownMenuItem(
                          value: 'gemma-3-4b-it', child: Text('Gemma 3 - 4B')),
                      DropdownMenuItem(
                          value: 'gemma-3-12b-it',
                          child: Text('Gemma 3 - 12B')),
                      DropdownMenuItem(
                          value: 'gemma-3-27b-it',
                          child: Text('Gemma 3 - 27B')),
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
                  // ... Mantenha o resto dos seus Dropdowns de Resolução e Raciocínio aqui ...
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
      ),
    );
  }
}
