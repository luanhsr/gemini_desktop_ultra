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
                    value: 'gemini-2.5-flash', child: Text('Gemini 2.5 Flash')),
                DropdownMenuItem(
                    value: 'gemini-2.0-flash', child: Text('Gemini 2.0 Flash')),
                DropdownMenuItem(
                    value: 'gemini-2.0-flash-lite',
                    child: Text('Gemini 2.0 Lite')),
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
