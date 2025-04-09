import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:share_plus/share_plus.dart';


/// See https://chat.deepseek.com/a/chat/s/afd00bf3-5753-43a0-a712-966fd9de419a
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
  final MenuController _menuController = MenuController();

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
      // Add connectivity check here
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) 
      {
        if (mounted) 
        {
          ScaffoldMessenger.of(context).showSnackBar
          (
            SnackBar
            (
              content: Text('No internet connection'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        setState
        (
          () 
          {
            _isLoading = false;
            _errorMessage = 'No internet connection';
          }
        );
        return;
      }
      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}'));

      if (response.statusCode == 200) 
      {
        setState
        (
          () 
          {
            _blog = json.decode(response.body) ?? {};
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
    try 
    {
      // Add connectivity check here
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) 
      {
        if (mounted) 
        {
          ScaffoldMessenger.of(context).showSnackBar
          (
            SnackBar
            (
              content: Text('No internet connection'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        setState
        (
          () 
          {
            _isLoading = false;
            _errorMessage = 'No internet connection';
          }
        );
        return;
      }

      setState
      (
        () 
        {
          if (loadMore) 
          {
            _isLoadingMoreComments = true;
          } 
          else 
          {
            _isLoading = true;
          }
        }
      );

      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}/comments/?page=$_commentPage&per_page=$_commentsPerPage'));

      if (response.statusCode == 200) 
      {
        final newComments = json.decode(response.body);
        setState(() {
          if (loadMore) 
          {
            _comments.addAll(newComments);
          } 
          else 
          {
            _comments = newComments;
          }
          _isLoading = false;
          _isLoadingMoreComments = false;
          _hasMoreComments = newComments.length >= _commentsPerPage; // Check if there are more comments to load
        });
      } 
      else 
      {
        throw Exception('Failed to load comments');
      }
    } 
    catch (e) 
    {
      setState
      (
        () 
        {
          _errorMessage = 'Failed to load comments: $e';
          _isLoading = false;
          _isLoadingMoreComments = false;
        }
      );
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

  void _scrollToTop() 
  {
    _commentScrollController.animateTo
    (
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildBlogContent() 
  {
    return Padding
    (
      padding: EdgeInsets.all(12.0),
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          if (_blog != null && _blog['cover_image'] != null && _blog!['cover_image'].isNotEmpty) 
            Hero
            (
              tag: "cover_image-${_blog['blog_id']}",
              child: CachedNetworkImage
              (
                height: 200, 
                width: double.infinity,
                imageUrl: _blog['cover_image'],
                placeholder: (context, url) => Container
                (
                  color: Colors.grey[200], // Match your design
                  child: Center
                  (
                    child: CircularProgressIndicator
                    (
                      strokeWidth: 2,
                      color: Colors.blue,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              )
            ),
          SizedBox(height: 10),
          Html(data: _blog?['content'] ?? 'Content not available', style: {'body': Style(fontSize: FontSize(16.0)),},)
        ],
      )
    );
  }

  Widget _buildComments() 
  {
    return Expanded
    (
      child: RefreshIndicator
      (
        onRefresh: _refreshComments,
        child: ListView.builder
        (
          controller: _commentScrollController,
          itemCount: _comments.length + (_isLoadingMoreComments ? 1 : 0) + (_hasMoreComments ? 0 : 1), // Add 1 for "No more items"
          itemBuilder: (context, index) 
          {
            if (index == _comments.length) 
            {
              if (_isLoadingMoreComments) 
              {
                return Center(child: CircularProgressIndicator());
              } 
              else if (!_hasMoreComments) 
              {
                return Padding
                (
                  padding: EdgeInsets.all(16.0),
                  child: Center
                  (
                    child: Text
                    (
                      'No more comments',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }
            }
            final comment = _comments[index];
            return AnimatedOpacity
            (
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child:  Padding
              (
                padding: EdgeInsets.all(12.0),
                child: Card
                (
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding
                  (
                    padding: const EdgeInsets.all(8.0),
                    child: Column
                    (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: 
                      [
                        Text
                        (
                          comment['content'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text
                        (
                          'By: ${comment['user']?['name'] ?? 'Anonymous'}',
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
                IconButton //when url was fully given in the browser like /blogs/7/team-knowledge-rater
                (
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {context.go('/blogs');},
                ),
        
        title: Text(_blog != null ? _blog['title'] : 'Loading...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

        actions: 
        [
          MenuAnchor
          (
            controller: _menuController,
            style: MenuStyle
            (  // Add this
              backgroundColor: WidgetStateProperty.all(Colors.white),
            ),
            builder: (BuildContext context, MenuController controller, Widget? child) 
            {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
            menuChildren: 
            [ // Using menuChildren here
              MenuItemButton
                (
                  onPressed: _shareBlog, 
                  child: const Row
                  (
                    children: 
                    [
                      Icon(Icons.share, size: 18),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
              
              MenuItemButton
                (
                  onPressed: _copyLinkToClipboard,
                  child: const Row
                  (
                    children: 
                    [
                      Icon(Icons.link, size: 18),
                      SizedBox(width: 8),
                      Text('Copy Link'),
                    ],
                  ),
                ),
              
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Column
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  Text(_errorMessage),
                  ElevatedButton
                  (
                    onPressed: () 
                    {
                      _errorMessage = '';
                      fetchBlog();
                      fetchComments();
                    },
                    child: Text('Retry'),
                  ),
                ],
              )
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
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        child: FloatingActionButton
                        (
                          tooltip: 'Scroll to top',
                          onPressed: _scrollToTop,                      
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.arrow_upward),
                        ),
                      ),
                  ],
                ),
    );
  }

  //https://chat.deepseek.com/a/chat/s/afd00bf3-5753-43a0-a712-966fd9de419a
  void _shareBlog() 
  {
    if (_blog != null) 
    {
      Share.share
      (
        'Check out this blog: ${_blog!['title']}\n'
        '${Uri.base.origin}/#/blogs/${_blog!['blog_id']}/${_blog!['slug'] ?? ''}',
        subject: 'Blog Post from Optometrist Dr. Kwon', // Add subject for email clients
      );

    }
  }

  void _copyLinkToClipboard() 
  {
    if (_blog != null) 
    {
      final blogUrl = '${Uri.base.origin}/#/blogs/${_blog!['blog_id']}/${_blog!['slug']}';
      Clipboard.setData(ClipboardData(text: blogUrl));
      ScaffoldMessenger.of(context).showSnackBar
      (
        SnackBar(content: Text('Link copied to clipboard')),
      );
    }
  }

  // ignore: slash_for_doc_comments
  /**
   * IconButton
   * (
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showCustomMenu(context);
          },
        ),
   
  void _showCustomMenu(BuildContext context) 
  {
    showModalBottomSheet
    (
      context: context,
      builder: (BuildContext context) 
      {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _shareBlog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _copyLinkToClipboard();
              },
            ),
          ],
        );
      },
    );
  }
  */
}