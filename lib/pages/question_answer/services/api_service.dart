import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://your-api-url.com';

  

  Future<String> askQuestion(String question) async {
    final response = await http.post(Uri.parse('$_baseUrl/ask-question'), headers: {
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      'question': question,
    }));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to ask question');
    }
  }
}
