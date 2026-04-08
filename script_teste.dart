import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  const minhaChaveApi = 'AIzaSyBYdPrDy4x0ZA54ou_XRttbi09ov89HmNI';
  final modelosParaTestar = [
    'gemma-3-1b-it',
    'gemma-3-4b-it',
    'gemma-3-12b-it',
    'gemma-3-27b-it'
  ];

  print('🟡 Iniciando teste em lote nos modelos Gemma...\n');

  for (var modelo in modelosParaTestar) {
    print('Tentando: $modelo...');
    final model = GenerativeModel(model: modelo, apiKey: minhaChaveApi.trim());
    try {
      final res =
          await model.generateContent([Content.text('Responda apenas "OK"')]);
      print('🟢 $modelo -> OK!');
    } catch (e) {
      print('🔴 $modelo -> FALHOU. Erro: ${e.toString().substring(0, 50)}...');
    }
  }
  exit(0);
}
