import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';
import 'random_article_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => LanguageProvider(),
    child: const RandomWikipediaApp(),
  ));
}

class RandomWikipediaApp extends StatelessWidget {
  const RandomWikipediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return MaterialApp(
          title: 'Random Wikipedia',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            fontFamily: 'Roboto',
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
              titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            fontFamily: 'Roboto',
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
              titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
            ),
          ),
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
          locale: Locale(languageProvider.language),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RandomArticleScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          'Random Wikipedia',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
