import 'dart:convert';
import 'package:http/http.dart' as http;

class WikipediaService {
  static const _randomUrl = 'https://en.wikipedia.org/api/rest_v1/page/random/summary';

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    final response = await http.get(Uri.parse(_randomUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load article');
    }
  }
}
