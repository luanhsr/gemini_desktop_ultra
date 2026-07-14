/// # QuotaMonitor
///
/// Widget responsável pelo monitoramento e exibição dos limites
/// de uso da API atualmente selecionada.
///
/// O componente apresenta métricas relacionadas ao consumo de
/// requisições e tokens, permitindo acompanhar a utilização
/// da cota disponível durante a execução da aplicação.
///
/// ## Responsabilidades
///
/// - Exibir consumo de RPM.
/// - Exibir consumo de TPM.
/// - Exibir consumo de RPD.
/// - Exibir total de tokens processados.
/// - Exibir tempo restante para renovação das cotas.
/// - Ajustar limites conforme o modelo selecionado.
///
/// ## Métricas Monitoradas
///
/// | Métrica | Significado |
/// |----------|----------|
/// | RPM | Requests Per Minute. |
//// | TPM | Tokens Per Minute. |
/// | RPD | Requests Per Day. |
/// | Total Tokens | Quantidade total de tokens processados. |
///
/// ## Fluxo
///
/// ```text
/// Modelo Atual
///     ↓
/// Definição dos Limites
///     ↓
/// Cálculo das Cotas
///     ↓
/// Exibição na Interface
/// ```
///
/// ## Limites Dinâmicos
///
/// Os limites exibidos variam conforme o modelo atualmente ativo.
///
/// ### Gemma
///
/// - RPM: 30
/// - TPM: 15K
/// - RPD: 14400
///
/// ### Gemini
///
/// - RPM: 15
/// - TPM: 250K
/// - RPD: 500
///
/// ## Observações
///
/// - O widget não realiza controle de cotas.
/// - O widget apenas exibe informações recebidas externamente.
/// - Os valores são calculados e atualizados por outros componentes.
/// - A identificação do modelo é realizada através de `currentModel`.
///
/// ## Código-fonte
///
/// <https://github.com/luanhsr/gemini_desktop_ultra/blob/main/lib/widgets/quota_monitor.dart>

import 'package:flutter/material.dart';

class QuotaMonitor extends StatelessWidget {
  // Métricas de consumo e limites atuais, rpm, tpm, rpd e totalTokens são fornecidos externamente.
  final int rpm, tpm, rpd, totalTokens;

  /// Tempo restante para renovação do limite RPM. e RPD (requisições por minuto e por dia).
  final Duration timeRPM, timeRPD;

  /// Utilizado para determinar quais limites devem ser exibidos.
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
    /// Cálculo dos limites baseado no modelo ativo
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
