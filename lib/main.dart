import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/chat/models/chat_settings.dart';
import 'features/chat/provider/chat_provider.dart';
import 'features/chat/chat_screen.dart';

/// Inicializa dependências e inicia a aplicação.
Future<void> main() async {
  // Garante que o Flutter carregue as dependências antes de iniciar o App
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega o arquivo .env (que deve estar no seu gitignore)
  await dotenv.load(fileName: ".env");

  runApp(const GeminiApp());
}

/// # GeminiApp
///
/// Ponto de entrada da aplicação.
///
/// Este arquivo é responsável por inicializar o ambiente,
/// carregar configurações essenciais e montar a estrutura
/// principal utilizada pelo aplicativo.
///
/// ## Inicialização
///
/// Durante a execução do `main()`:
///
/// 1. O Flutter inicializa os bindings necessários.
/// 2. O arquivo `.env` é carregado.
/// 3. A aplicação é iniciada através de [GeminiApp].
///
/// ## Responsabilidades
///
/// - Carregar a chave da API.
/// - Criar a instância inicial de [ChatSettings].
/// - Registrar o [ChatProvider].
/// - Configurar tema e aparência global.
/// - Definir a tela inicial da aplicação.
///
/// ## Fluxo
///
/// ```text
/// main()
///     ↓
/// .env
///     ↓
/// ChatSettings
///     ↓
/// ChatProvider
///     ↓
/// ChatScreen
/// ```
///
/// ## Observações
///
/// - A chave da API é carregada do arquivo `.env`.
/// - O Provider é disponibilizado para toda a árvore de widgets.
/// - O tema visual da aplicação é configurado neste arquivo.
///
/// ## Código-fonte
///
/// <https://github.com/luanhsr/gemini_desktop_ultra/blob/main/lib/main.dart>
///
class GeminiApp extends StatelessWidget {
  const GeminiApp({super.key});

  /// Monta a estrutura principal da aplicação.
  ///
  /// Aqui são configurados:
  /// - Tema global.
  /// - Provider principal.
  /// - Tela inicial.
  @override
  Widget build(BuildContext context) {
    // Busca a API KEY do arquivo .env com fallback para string vazia
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

// No main.dart, garanta que o ChatSettings seja chamado assim:
    final settings = ChatSettings(
      apiKey: apiKey,
      // Não force modelos diferentes aqui por enquanto, deixe o GeminiService gerenciar
    );
    return MaterialApp(
      title: 'Gemini Desktop Ultra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Cascadia Code',
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: const Color(0xFF101010),
        colorScheme: const ColorScheme.dark(
          background: Colors.black,
          surface: Color(0xFF101010),
          primary: Color(0xFF7CFF7A),
          secondary: Color(0xFFFFEA00),
          error: Color(0xFFFF5E5E),
          onPrimary: Colors.black,
          onSurface: Color(0xFF8BF18F),
          onBackground: Color(0xFF8BF18F),
          onSecondary: Colors.black,
          onError: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF8BF18F), fontSize: 15),
          bodyMedium: TextStyle(color: Color(0xFF8BF18F), fontSize: 14),
          titleLarge: TextStyle(
              color: Color(0xFF7CFF7A),
              fontSize: 20,
              fontWeight: FontWeight.bold),
          labelLarge: TextStyle(color: Color(0xFFFFEA00)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF050505),
          hintStyle: const TextStyle(color: Color(0xFF7CFF7A)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF7CFF7A), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF7CFF7A), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFFFEA00), width: 1.5),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF7CFF7A),
            fontFamily: 'Cascadia Code',
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          iconTheme: IconThemeData(color: Color(0xFF7CFF7A)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF7CFF7A)),
      ),
      home: ChangeNotifierProvider(
        create: (_) => ChatProvider(settings),
        child: const ChatScreen(),
      ),
    );
  }
}
