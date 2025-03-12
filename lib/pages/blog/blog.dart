import 'package:drkwon/pages/blog/models/blog_post.dart';
import 'package:drkwon/pages/blog/services/api_service.dart';
import 'package:flutter/material.dart';


class BlogScreen extends StatefulWidget 
{
  const BlogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogScreen> 
{
  final ApiService _apiService = ApiService();
  List<BlogPost> _blogPosts = [];
  bool _isLoading = false;

  @override
  void initState() 
  {
    super.initState();
    _loadBlogPosts();
  }

  Future<void> _loadBlogPosts() async 
  {
    setState
    (
      () 
      {
        _isLoading = true;
      }
    );
    final blogPosts = await _apiService.getBlogPosts();
    setState
    (
      () 
      {
        _blogPosts = blogPosts;
        _isLoading = false;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _blogPosts.length,
              itemBuilder: (context, index) {
                return BlogPostCard(blogPost: _blogPosts[index]);
              },
            ),
    );
  }
}

class BlogPostCard extends StatelessWidget {
  final BlogPost blogPost;

  const BlogPostCard({super.key, required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              blogPost.title,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(blogPost.content),
            SizedBox(height: 16),
            Row(
              children: [
                //Text('Author: ${blogPost.author}'),
                SizedBox(width: 16),
                //Text('Date: ${blogPost.date}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
