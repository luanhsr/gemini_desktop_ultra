/// # Widget ModelSelector
///
/// ### Responsabilidades:
/// Selecionar o modelo de IA utilizado nas conversas.
///
/// ### Pacotes utilizados:
/// 1. material.dart - Componentes da interface.
/// 2. provider.dart - Gerenciamento de estado.
/// 3. chat_provider.dart - Acesso e atualização das configurações do chat.
///
/// # Classe ModelSelector
///
/// Widget Stateless responsável por exibir e controlar
/// a seleção do modelo de IA.
///
/// ### Como funciona:
/// - Obtém o modelo atual através de [ChatProvider].
/// - Exibe os modelos disponíveis em um DropdownButton.
/// - Permite ao usuário alterar o modelo selecionado.
/// - Atualiza o estado global através de [ChatProvider.updateModel].
///
/// ### Modelos disponíveis:
/// - gemini-3.1-flash-lite-preview
/// - gemma-3-1b-it
/// - gemma-3-27b-it
///
/// ### Fluxo:
/// 1. Lê o valor atual em [ChatProvider.settings].
/// 2. Exibe o modelo selecionado.
/// 3. Aguarda a escolha do usuário.
/// 4. Executa [ChatProvider.updateModel] quando um novo modelo é selecionado.
///
/// ### Link para direto do widget: https://github.com/luanhsr/gemini_desktop_ultra/blob/main/lib/widgets/model_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/chat_provider.dart';

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

            ///
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
