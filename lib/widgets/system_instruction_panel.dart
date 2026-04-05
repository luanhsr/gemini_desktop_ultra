import 'package:flutter/material.dart';

class SystemInstructionPanel extends StatefulWidget {
  const SystemInstructionPanel({Key? key}) : super(key: key);

  static Future<void> open(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Instrução de sistema',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Align(
          alignment: Alignment.centerRight,
          child: SystemInstructionPanel(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    );
  }

  @override
  State<SystemInstructionPanel> createState() => _SystemInstructionPanelState();
}

class _SystemInstructionPanelState extends State<SystemInstructionPanel> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<Map<String, dynamic>> _instructions = [
    {'label': 'Responda de forma amigável e concisa.', 'enabled': true},
    {'label': 'Use linguagem técnica e objetiva.', 'enabled': true},
    {'label': 'Seja criativo e detalhado.', 'enabled': false},
  ];
  String? _selectedInstruction;
  bool _useInstruction = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final height = MediaQuery.of(context).size.height * 0.8;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF7CFF7A), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(-4, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: Color(0xFF7CFF7A)),
                    SizedBox(width: 10),
                    Text(
                      'Instrução de sistema',
                      style: const TextStyle(
                        fontFamily: 'Cascadia Code',
                        color: Color(0xFF7CFF7A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFFFEA00)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Defina como a IA deve responder ao usuário com este comando.',
              style: TextStyle(
                fontFamily: 'Cascadia Code',
                color: Color(0xFF8BF18F),
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final useColumn = constraints.maxWidth < 560;
                return useColumn
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontFamily: 'Cascadia Code',
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: const Color(0xFF7CFF7A),
                              foregroundColor: Colors.black,
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Criar nova instrução'),
                            onPressed: () {
                              setState(() {
                                _selectedInstruction = null;
                                _titleController.clear();
                                _contentController.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF121212),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7CFF7A)),
                              ),
                            ),
                            dropdownColor: const Color(0xFF121212),
                            value: _selectedInstruction,
                            hint: const Text('Selecionar instrução',
                                style: TextStyle(
                                  fontFamily: 'Cascadia Code',
                                  color: Color(0xFF8BF18F),
                                )),
                            items: _instructions
                                .map(
                                  (instruction) => DropdownMenuItem(
                                    value: instruction['label'] as String,
                                    child: Text(
                                      instruction['label'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Cascadia Code',
                                        color: Color(0xFF8BF18F),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedInstruction = value;
                                if (value != null) {
                                  _titleController.text =
                                      'Instrução selecionada';
                                  _contentController.text = value;
                                }
                              });
                            },
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 0,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontFamily: 'Cascadia Code',
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: const Color(0xFF7CFF7A),
                                foregroundColor: Colors.black,
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Criar nova instrução'),
                              onPressed: () {
                                setState(() {
                                  _selectedInstruction = null;
                                  _titleController.clear();
                                  _contentController.clear();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF121212),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7CFF7A)),
                                ),
                              ),
                              dropdownColor: const Color(0xFF121212),
                              value: _selectedInstruction,
                              hint: const Text('Selecionar instrução',
                                  style: TextStyle(
                                    fontFamily: 'Cascadia Code',
                                    color: Color(0xFF8BF18F),
                                  )),
                              items: _instructions
                                  .map(
                                    (instruction) => DropdownMenuItem(
                                      value: instruction['label'] as String,
                                      child:
                                          Text(instruction['label'] as String,
                                              style: const TextStyle(
                                                fontFamily: 'Cascadia Code',
                                                color: Color(0xFF8BF18F),
                                              )),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedInstruction = value;
                                  if (value != null) {
                                    _titleController.text =
                                        'Instrução selecionada';
                                    _contentController.text = value;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Título',
              style: TextStyle(
                fontFamily: 'Cascadia Code',
                color: Color(0xFF7CFF7A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontFamily: 'Cascadia Code',
                color: Color(0xFF8BF18F),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF121212),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF7CFF7A)),
                ),
                hintText: 'Título da instrução',
                hintStyle: const TextStyle(
                  fontFamily: 'Cascadia Code',
                  color: Color(0xFF5B8B5A),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Texto da instrução',
              style: TextStyle(
                fontFamily: 'Cascadia Code',
                color: Color(0xFF7CFF7A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(
                  fontFamily: 'Cascadia Code',
                  color: Color(0xFF8BF18F),
                ),
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7CFF7A)),
                  ),
                  hintText: 'Escreva as instruções da IA aqui...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Cascadia Code',
                    color: Color(0xFF5B8B5A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _useInstruction,
                  activeColor: const Color(0xFF7CFF7A),
                  checkColor: Colors.black,
                  onChanged: (value) {
                    setState(() {
                      _useInstruction = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'Utilizar instrução',
                    style: TextStyle(
                      fontFamily: 'Cascadia Code',
                      color: Color(0xFF8BF18F),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontFamily: 'Cascadia Code',
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: const Color(0xFF7CFF7A),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Salvar instrução'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
