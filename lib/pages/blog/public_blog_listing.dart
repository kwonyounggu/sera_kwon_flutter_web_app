import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicBlogListing extends StatefulWidget {
  @override
  _PublicBlogListingState createState() => _PublicBlogListingState();
}

class _PublicBlogListingState extends State<PublicBlogListing> {
  List<dynamic> _blogs = [];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    final response = await http.get(Uri.parse('YOUR_FASTAPI_URL/blogs?visibility=Public')); // Replace with your FastAPI endpoint

    if (response.statusCode == 200) {
      setState(() {
        _blogs = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Blog'),
      ),
      body: ListView.builder(
        itemCount: _blogs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(_blogs[index]['title']),
              subtitle: Text(_blogs[index]['content'].substring(0, 100) + '...'), // Show a snippet
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogDetailPage(blogId: _blogs[index]['blog_id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
