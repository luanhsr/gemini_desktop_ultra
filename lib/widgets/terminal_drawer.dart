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
                    items: const [
                      DropdownMenuItem(
                          value: 'gemini-3.1-flash-lite-preview',
                          child: Text('Gemini 3.1 Flash Lite (500 RPD)')),
                      DropdownMenuItem(
                          value: 'gemini-2.5-flash',
                          child: Text('Gemini 2.5 Flash (20 RPD)')),
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
