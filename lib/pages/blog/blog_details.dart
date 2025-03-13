import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlogDetailPage extends ConsumerStatefulWidget 
{
  final int blogId;

  const BlogDetailPage({super.key, required this.blogId});

  @override
  // ignore: library_private_types_in_public_api
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends ConsumerState<BlogDetailPage> 
{
  dynamic _blog;
  List<dynamic> _comments = [];

  @override
  void initState() {
    super.initState();
    fetchBlog();
    fetchComments();
  }

  Future<void> fetchBlog() async {
    final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}')); // Replace with your FastAPI endpoint

    if (response.statusCode == 200) {
      setState(() {
        _blog = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load blog');
    }
  }

  Future<void> fetchComments() async {
      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}/comments')); // Replace with your FastAPI endpoint

    if (response.statusCode == 200) {
      setState(() {
        _comments = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_blog != null ? _blog['title'] : 'Loading...'),
      ),
      body: _blog != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _blog['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _blog['content'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _comments[index]['content'],
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'By: ${_comments[index]['user']['name'] ?? 'Anonymous'}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
