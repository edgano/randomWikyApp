import 'dart:convert';
import 'package:http/http.dart' as http;

class WikipediaService {
  Future<Map<String, dynamic>> fetchRandomArticle(String language) async {
    final response = await http.get(
      Uri.parse('https://${language}.wikipedia.org/api/rest_v1/page/random/summary'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load article');
    }
  }
}
