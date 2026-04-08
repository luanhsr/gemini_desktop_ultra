import 'package:flutter/material.dart';

class QuotaMonitor extends StatelessWidget {
  final int rpm, tpm, rpd, totalTokens;
  final Duration timeRPM, timeRPD;

  const QuotaMonitor(
      {required this.rpm,
      required this.tpm,
      required this.rpd,
      required this.totalTokens,
      required this.timeRPM,
      required this.timeRPD,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _stat("RPM", "$rpm/15", "${timeRPM.inSeconds}s"),
            _stat("TPM", "${(tpm / 1000).toInt()}K/250K", null),
            _stat("RPD", "$rpd/500",
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
