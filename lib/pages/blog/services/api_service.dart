import 'package:drkwon/pages/dashboard/models/blog_post.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService 
{
  //final String _baseUrl = 'https://your-api-url.com';
  final String _baseUrl = FASTAPI_URL;

  Future<List<BlogPost>> getBlogPosts() async 
  {
    final response = await http.get(Uri.parse('$_baseUrl/blogs/1'));
    if (response.statusCode == 200) 
    {
      return jsonDecode(response.body).map((json) => BlogPost.fromJson(json)).toList();
    } 
    else 
    {
      throw Exception('Failed to load blog posts');
    }
  }

  Future<String> askQuestion(String question) async 
  {
    final response = await http.post
    (
      Uri.parse('$_baseUrl/ask-question'), 
      headers: 
      {
        'Content-Type': 'application/json',
      }, 
      body: jsonEncode
      (
        {
          'question': question,
        }
      )
    );
    if (response.statusCode == 200) 
    {
      return response.body;
    } 
    else 
    {
      throw Exception('Failed to ask question');
    }
  }
}
