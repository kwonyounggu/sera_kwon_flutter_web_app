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
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true; // Track if there are more items to load
  String _errorMessage = '';
  int _page = 1;
  final int _perPage = 2; // 10, Number of blogs to load per page
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false; // Track if the "Back to Top" button should be shown

  @override
  void initState() 
  {
    super.initState();
    fetchBlogs();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() 
  {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() 
  {
    // Show/hide the "Back to Top" button based on scroll position
    if (_scrollController.offset >= 400 && !_showBackToTopButton) 
    {
      setState
      (
        () 
        {
          _showBackToTopButton = true;
        }
      );
    } 
    else if (_scrollController.offset < 400 && _showBackToTopButton) 
    {
      setState
      (
        () 
        {
          _showBackToTopButton = false;
        }
      );
    }

    // Load more data when the user scrolls to the bottom
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore && _hasMore) 
    {
      setState
      (
        () 
        {
          _page++;
        }
      );
      fetchBlogs(loadMore: true);
    }
  }

  Future<void> fetchBlogs({bool loadMore = false}) async 
  {
    try 
    {
      setState
      (
        () 
        {
          if (loadMore) 
          {
            _isLoadingMore = true;
          } 
          else 
          {
            _isLoading = true;
          }
        }
      );

      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs?visibility=public&is_hidden=false&page=$_page&per_page=$_perPage'));

      if (response.statusCode == 200) 
      {
        final newBlogs = json.decode(response.body);
        setState
        (
          () 
          {
          if (loadMore) 
          {
            _blogs.addAll(newBlogs);
          } 
          else 
          {
            _blogs = newBlogs;
          }
          _isLoading = false;
          _isLoadingMore = false;
          _hasMore = newBlogs.length >= _perPage; // Check if there are more items to load
        });
      } 
      else 
      {
        throw Exception('Failed to load blogs');
      }
    } 
    catch (e) 
    {
      setState
      (
        () 
        {
          _errorMessage = 'Failed to load blogs: $e';
          _isLoading = false;
          _isLoadingMore = false;
        });
    }
  }

  Future<void> _refreshBlogs() async 
  {
    setState
    (
      () 
      {
        _page = 1;
        _hasMore = true; // Reset the "has more" flag when refreshing
      }
    );
    await fetchBlogs();
  }

  void _scrollToTop() 
  {
    _scrollController.animateTo
    (
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Public Blog'),
        //backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator
      (
        onRefresh: _refreshBlogs,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : Stack
                (
                    children: 
                    [
                      Column
                      (
                        children: 
                        [
                          Expanded
                          (
                            child: ListView.builder
                            (
                              controller: _scrollController,
                              itemCount: _blogs.length + (_isLoadingMore ? 1 : 0) + (_hasMore ? 0 : 1), // Add 1 for "No more items"
                              itemBuilder: (context, index) 
                              {
                                if (index == _blogs.length) 
                                {
                                  if (_isLoadingMore) 
                                  {
                                    return Center(child: CircularProgressIndicator());
                                  } 
                                  else if (!_hasMore) 
                                  {
                                    return Padding
                                    (
                                      padding: EdgeInsets.all(16.0),
                                      child: Center
                                      (
                                        child: Text
                                        (
                                          'No more items',
                                          style: TextStyle(fontSize: 16, color: Colors.grey),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                final blog = _blogs[index];
                                return AnimatedOpacity
                                (
                                  opacity: 1.0,
                                  duration: Duration(milliseconds: 500),
                                  child: Card
                                  (
                                    margin: EdgeInsets.all(8.0),
                                    //elevation: 1.0,
                                    child: InkWell
                                    (
                                      onTap: () 
                                      {
                                        Navigator.push
                                        (
                                          context,
                                          MaterialPageRoute
                                          (
                                            builder: (context) => BlogDetailPage(blogId: blog['blog_id']),
                                          ),
                                        );
                                      },
                                      child: Column
                                      (
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: 
                                        [
                                          if (blog['image_url'] != null) Hero
                                          (
                                            tag: 'blog-image-${blog['blog_id']}',
                                            child: Image.network
                                            (
                                              blog['image_url'] ?? 'https://picsum.photos/150',
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding
                                          (
                                            padding: EdgeInsets.all(8.0),
                                            child: Column
                                            (
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: 
                                              [
                                                Text
                                                (
                                                  blog['title'],
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  _blogs[index]['content'] != null && _blogs[index]['content'].length > 100
                                                                                      ? _blogs[index]['content'].substring(0, 100) + '...'
                                                                                      : _blogs[index]['content'] ?? '',
                                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_isLoadingMore)
                            Padding
                            (
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          if (!_isLoadingMore && _hasMore)
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
                                      _page++;
                                    }
                                  );
                                  fetchBlogs(loadMore: true);
                                },
                                child: Text('Load More'),
                              ),
                            ),
                        ],
                      ),
                      if (_showBackToTopButton)
                        Positioned
                        (
                          bottom: 20,
                          right: 20,
                          child: FloatingActionButton
                          (
                            onPressed: _scrollToTop,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.arrow_upward),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}