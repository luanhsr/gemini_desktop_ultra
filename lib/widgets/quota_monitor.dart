import 'package:flutter/material.dart';

class QuotaMonitor extends StatelessWidget {
  final int rpm, tpm, rpd, totalTokens;
  final Duration timeRPM, timeRPD;
  final String currentModel; // Novo parâmetro recebido do provider

  const QuotaMonitor({
    required this.rpm,
    required this.tpm,
    required this.rpd,
    required this.totalTokens,
    required this.timeRPM,
    required this.timeRPD,
    required this.currentModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cálculo dos limites baseado no modelo ativo
    final bool isGemma = currentModel.contains('gemma');
    final int maxRPM = isGemma ? 30 : 15;
    final int maxTPM = isGemma ? 15 : 250;
    final int maxRPD = isGemma ? 14400 : 500;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _stat("RPM", "$rpm/$maxRPM", "${timeRPM.inSeconds}s"),
            _stat("TPM", "${(tpm / 1000).toInt()}K/${maxTPM}K", null),
            _stat("RPD", "$rpd/$maxRPD",
                "${timeRPD.inHours}h ${timeRPD.inMinutes % 60}m"),
          ],
        ),
        const SizedBox(height: 10),
        _stat("TOTAL TOKENS", "$totalTokens", null),
      ],
    );
  }

  Widget _stat(String label, String val, String? time) => Column(
        children: [
          Text("$label: $val",
              style: const TextStyle(
                  color: Color(0xFF7CFF7A),
                  fontSize: 10,
                  fontFamily: 'Cascadia Code')),
          if (time != null)
            Text(time,
                style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 8,
                    fontFamily: 'Cascadia Code')),
        ],
      );
}
