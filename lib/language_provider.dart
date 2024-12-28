import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _language = 'en';

  String get language => _language;

  // Cambiar idioma
  void changeLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
  }

  // Obtener las traducciones
  Map<String, String> get translations {
    if (_language == 'es') {
      return {
        'title' : 'Random Wikipedia',
        'next_article': 'Siguiente Artículo',
        'share': 'Compartir',
        'about': 'Acerca de',
        'about_info' : 'Una app que muestra articulos aleatorios de Wikipedia.',
        'exit': 'Salir',
        'exit_text': 'Esta seguro que quiere salir de la aplicacion?',
        'cancel': 'Cancelar',
        'change_language': 'Cambiar Idioma',
      };
    } else {
      return {
        'title' : 'Random Wikipedia',
        'next_article': 'Next Article',
        'share': 'Share',
        'about': 'About',
        'about_info' : 'Random Wikipedia is a simple app that fetches random Wikipedia articles.',
        'exit': 'Exit',
        'exit_text': 'Are you sure you want to exit?',
        'cancel': 'Cancel',
        'change_language': 'Change Language',
      };
    }
  }
}
