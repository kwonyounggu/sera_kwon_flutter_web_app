import 'package:drkwon/pages/dashboard/models/blog_post.dart';
import 'package:drkwon/pages/dashboard/models/comment.dart';
import 'package:drkwon/pages/dashboard/models/user.dart';
import 'package:drkwon/pages/dashboard/services/api_service.dart';
import 'package:flutter/material.dart';


class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  List<BlogPost> _blogPosts = [];
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadBlogPosts();
    _loadComments();
  }

  Future<void> _loadUsers() async {
    final users = await _apiService.getUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _loadBlogPosts() async {
    final blogPosts = await _apiService.getBlogPosts();
    setState(() {
      _blogPosts = blogPosts;
    });
  }

  Future<void> _loadComments() async {
    final comments = await _apiService.getComments();
    setState(() {
      _comments = comments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Users'),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_users[index].name),
                              subtitle: Text(_users[index].email),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _apiService.deleteUser(_users[index].id);
                                  _loadUsers();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Blog Posts'),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _blogPosts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_blogPosts[index].title),
                              subtitle: Text(_blogPosts[index].content),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _apiService.deleteBlogPost(_blogPosts[index].id);
                                  _loadBlogPosts();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Comments'),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _comments.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_comments[index].content),
                              subtitle: Text(_comments[index].author),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _apiService.deleteComment(_comments[index].id);
                                  _loadComments();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _apiService.createBlogPost();
                      _loadBlogPosts();
                    },
                    child: Text('Create Blog Post'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _apiService.createComment();
                      _loadComments();
                    },
                    child: Text('Create Comment'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
