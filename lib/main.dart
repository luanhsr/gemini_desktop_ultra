import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/chat_settings.dart';
import 'providers/chat_provider.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const GeminiApp());
}

class GeminiApp extends StatelessWidget {
  const GeminiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = ChatSettings(
      apiKey: 'SUA_CHAVE_API_AQUI', // ← COLOCA AQUI
      temperature: 0.7,
      selectedModel: 'gemini-1.5-flash',
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
