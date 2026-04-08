import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ModelSelector extends StatelessWidget {
  const ModelSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    value: 'gemini-3.1-flash-lite-preview',
                    child: Text('Gemini 3.1 Flash Lite')),
                DropdownMenuItem(
                    value: 'gemma-3-1b-it', child: Text('Gemma 3 (1B)')),
                DropdownMenuItem(
                    value: 'gemma-3-27b-it', child: Text('Gemma 3 (27B)')),
              ],
              onChanged: (val) {
                if (val != null) provider.updateModel(val);
              },
            ),
          ],
        );
      },
    );
  }
}
