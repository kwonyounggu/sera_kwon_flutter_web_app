import 'package:drkwon/pages/blog/blog_details.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicBlogListing extends ConsumerStatefulWidget 
{
  const PublicBlogListing({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PublicBlogListingState createState() => _PublicBlogListingState();
}

class _PublicBlogListingState extends ConsumerState<PublicBlogListing> 
{
  List<dynamic> _blogs = [];

  @override
  void initState() 
  {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async 
  {
    final response = await http.get(Uri.parse('$FASTAPI_URL/blogs?visibility=DoctorsOnly')); // Replace with your FastAPI endpoint

    if (response.statusCode == 200) 
    {
      //print(response.body);
      print(json.decode(response.body));
      setState
      (
        () 
        {
          //_blogs = json.decode(response.body);
          
        }
      );
    } 
    else 
    {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Public Blog'),
      ),
      body: ListView.builder
      (
        itemCount: _blogs.length,
        itemBuilder: (context, index) 
        {
          return Card
          (
            margin: EdgeInsets.all(8.0),
            child: ListTile
            (
              title: Text(_blogs[index]['title']),
              subtitle: Text(_blogs[index]['content'].substring(0, 100) + '...'), // Show a snippet
              onTap: () 
              {
                Navigator.push
                (
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
