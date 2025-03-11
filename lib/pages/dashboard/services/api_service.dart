import 'package:drkwon/pages/dashboard/models/blog_post.dart';
import 'package:drkwon/pages/dashboard/models/comment.dart';
import 'package:drkwon/pages/dashboard/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://your-api-url.com';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body).map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<BlogPost>> getBlogPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/blog-posts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body).map((json) => BlogPost.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load blog posts');
    }
  }

  Future<List<Comment>> getComments() async {
    final response = await http.get(Uri.parse('$_baseUrl/comments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body).map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> deleteBlogPost(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/blog-posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete blog post');
    }
  }

  Future<void> deleteComment(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/comments/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }

  Future<void> createBlogPost() async {
    final response = await http.post(Uri.parse('$_baseUrl/blog-posts'), headers: {
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      'title': 'New Blog Post',
      'content': 'This is a new blog post',
    }));
    if (response.statusCode != 201) {
      throw Exception('Failed to create blog post');
    }
  }

  Future<void> createComment() async {
    final response = await http.post(Uri.parse('$_baseUrl/comments'), headers: {
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      'content': 'This is a new comment',
      'author': 'John Doe',
    }));
    if (response.statusCode != 201) {
      throw Exception('Failed to create comment');
    }
  }
}
