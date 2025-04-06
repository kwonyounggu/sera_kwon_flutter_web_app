import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  bool _isLoading = true;
  bool _isLoadingMoreComments = false;
  bool _hasMoreComments = true; // Track if there are more comments to load
  String _errorMessage = '';
  int _commentPage = 1;
  final int _commentsPerPage = 10; // Number of comments to load per page
  final ScrollController _commentScrollController = ScrollController();
  bool _showBackToTopButton = false; // Track if the "Back to Top" button should be shown

  @override
  void initState() 
  {
    super.initState();
    fetchBlog();
    fetchComments();
    _commentScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() 
  {
    _commentScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() 
  {
    // Show/hide the "Back to Top" button based on scroll position
    if (_commentScrollController.offset >= 400 && !_showBackToTopButton) 
    {
      setState
      (
        () 
        {
          _showBackToTopButton = true;
        }
      );
    } 
    else if (_commentScrollController.offset < 400 && _showBackToTopButton) 
    {
      setState
      (
        () 
        {
          _showBackToTopButton = false;
        }
      );
    }

    // Load more comments when the user scrolls to the bottom
    if (_commentScrollController.position.pixels == _commentScrollController.position.maxScrollExtent && !_isLoadingMoreComments && _hasMoreComments) 
    {
      setState
      (
        () 
        {
          _commentPage++;
        }
      );
      fetchComments(loadMore: true);
    }
  }

  Future<void> fetchBlog() async 
  {
    try 
    {
      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}'));

      if (response.statusCode == 200) 
      {
        setState
        (
          () 
          {
            _blog = json.decode(response.body);
          }
        );
      } 
      else 
      {
        throw Exception('Failed to load blog');
      }
    } 
    catch (e) 
    {
      setState
      (
        () 
        {
          _errorMessage = 'Failed to load blog: $e';
        }
      );
    }
  }

  Future<void> fetchComments({bool loadMore = false}) async 
  {
    try {
      setState(() {
        if (loadMore) {
          _isLoadingMoreComments = true;
        } else {
          _isLoading = true;
        }
      });

      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}/comments?page=$_commentPage&per_page=$_commentsPerPage'));

      if (response.statusCode == 200) 
      {
        final newComments = json.decode(response.body);
        setState(() {
          if (loadMore) {
            _comments.addAll(newComments);
          } else {
            _comments = newComments;
          }
          _isLoading = false;
          _isLoadingMoreComments = false;
          _hasMoreComments = newComments.length >= _commentsPerPage; // Check if there are more comments to load
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load comments: $e';
        _isLoading = false;
        _isLoadingMoreComments = false;
      });
    }
  }

  Future<void> _refreshComments() async 
  {
    setState
    (
      () 
      {
        _commentPage = 1;
        _hasMoreComments = true; // Reset the "has more" flag when refreshing
      }
    );
    await fetchComments();
  }

  void _scrollToTop() {
    _commentScrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildBlogContent() {
    return Padding
    (
      padding: EdgeInsets.all(12.0),
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          if (_blog['cover_image'] != null) Hero
          (
            tag: "cover_image-${_blog['blog_id']}-${_blog['slug']}",
            child: Image.network
            (
              _blog['cover_image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) 
              {
                // Return nothing if the image fails to load
                return const SizedBox.shrink();
              },
            ),
          ),
          SizedBox(height: 10),
          Text(
            _blog['title'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            _blog['content'],
            style: TextStyle(fontSize: 16),
          ),
        ],
      )
    );
  }

  Widget _buildComments() 
  {
    return Expanded
    (
      child: RefreshIndicator(
        onRefresh: _refreshComments,
        child: ListView.builder(
          controller: _commentScrollController,
          itemCount: _comments.length + (_isLoadingMoreComments ? 1 : 0) + (_hasMoreComments ? 0 : 1), // Add 1 for "No more items"
          itemBuilder: (context, index) {
            if (index == _comments.length) {
              if (_isLoadingMoreComments) {
                return Center(child: CircularProgressIndicator());
              } else if (!_hasMoreComments) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No more comments',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }
            }
            final comment = _comments[index];
            return AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child:  Padding
              (
                padding: EdgeInsets.all(12.0),
                child: Card
                (
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment['content'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'By: ${comment['user']['name'] ?? 'Anonymous'}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        leading: Navigator.of(context).canPop() ? BackButton() : 
                IconButton //when url was fully given in the browser like /blogs/7/team-knowledge-rate
                (
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {context.go('/blogs');},
                ),
        title: Text(_blog != null ? _blog['title'] : 'Loading...'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Stack
              (
                  children: 
                  [
                    Column
                    (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: 
                      [
                        _buildBlogContent(),
                        SizedBox(height: 20),
                        Padding
                        (
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                                        'Comments',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                        ),
                        _buildComments(),
                        if (_isLoadingMoreComments)
                          Padding
                          (
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        if (!_isLoadingMoreComments && _hasMoreComments)
                          Padding
                          (
                            padding: EdgeInsets.all(8.0),
                            child: ElevatedButton
                            (
                              onPressed: () 
                              {
                                setState
                                (
                                  () 
                                  {
                                    _commentPage++;
                                  }
                                );
                                fetchComments(loadMore: true);
                              },
                              child: Text('Load More Comments'),
                            ),
                          ),
                      ],
                    ),
                    if (_showBackToTopButton)
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          onPressed: _scrollToTop,                      
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.arrow_upward),
                        ),
                      ),
                  ],
                ),
    );
  }
}