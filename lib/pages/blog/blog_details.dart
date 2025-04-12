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
class BlogDetailPage extends ConsumerStatefulWidget {
  final int blogId;

  const BlogDetailPage({super.key, required this.blogId});

  @override
  // ignore: library_private_types_in_public_api
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends ConsumerState<BlogDetailPage> {
  dynamic _blog;
  List<dynamic> _comments = [];
  bool _isLoading = true;
  bool _isLoadingMoreComments = false;
  bool _hasMoreComments = true; // Track if there are more comments to load
  String _errorMessage = '';
  int _commentPage = 1;
  final int _commentsPerPage = 10; // Number of comments to load per page
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false; // Track if the "Back to Top" button should be shown
  final MenuController _menuController = MenuController();

  final _smallText = TextStyle(fontSize: 12, color: Colors.grey[600]);

  @override
  void initState() 
  {
    super.initState();
    fetchBlog();
    fetchComments();
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

    // Load more comments when the user scrolls to the bottom
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isLoadingMoreComments &&
        _hasMoreComments) 
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
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No internet connection'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        setState(() {
          _isLoading = false;
          _errorMessage = 'No internet connection';
        });
        return;
      }
      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}'));

      if (response.statusCode == 200) {
        setState(() {
          _blog = json.decode(response.body) ?? {};
        });
      } else {
        throw Exception('Failed to load blog');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load blog: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchComments({bool loadMore = false}) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No internet connection'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        setState(() {
          _isLoading = false;
          _errorMessage = 'No internet connection';
        });
        return;
      }

      setState(() {
        if (loadMore) {
          _isLoadingMoreComments = true;
        } else {
          _isLoading = true;
        }
      });

      final response = await http.get(
          Uri.parse('$FASTAPI_URL/blogs/${widget.blogId}/comments/?page=$_commentPage&per_page=$_commentsPerPage'));

      if (response.statusCode == 200) {
        final newComments = json.decode(response.body);
        setState(() {
          if (loadMore) {
            _comments.addAll(newComments);
          } else {
            _comments = newComments;
          }
          _isLoadingMoreComments = false;
          _hasMoreComments = newComments.length >= _commentsPerPage;
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load comments: $e';
        _isLoadingMoreComments = false;
      });
    } finally {
      if (!loadMore) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshAll() async {
    setState(() {
      _commentPage = 1;
      _hasMoreComments = true;
    });
    await Future.wait([fetchBlog(), fetchComments()]);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
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
            Hero(
              tag: "cover_image-${_blog['blog_id']}",
              child: CachedNetworkImage
              (
                height: 200,
                width: double.infinity,
                imageUrl: _blog['cover_image'],
                placeholder: (context, url) => Container
                (
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator
                    (
                      strokeWidth: 2,
                      color: Colors.blue,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 10),
          Html
          (
            data: _blog?['content'] ?? 'Content not available',
            style: {'body': Style(fontSize: FontSize(16.0))},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar
      (
        leading: Navigator.of(context).canPop()
            ? IconButton
              (
                icon: const Icon(Icons.arrow_back_ios, size: 20), // iOS-style back icon
                padding: const EdgeInsets.only(left: 8),
                onPressed: () 
                {
                  Navigator.of(context).maybePop();
                },
              )
            : IconButton
              (
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                padding: const EdgeInsets.only(left: 8),
                onPressed: () 
                {
                  context.go('/blogs');
                },
              ),
        /*title: Text
        (
          _blog != null ? _blog['title'] : 'Loading...',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),*/
      //See https://www.perplexity.ai/search/from-the-attached-file-an-over-I3LGY4IuRE.J5JouMlfG2g
      title: _blog != null ? ConstrainedBox
      (
        constraints: BoxConstraints(maxWidth: 300), // Adjust maxWidth as needed
        child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: 
              [
                Text
                (
                  _blog['title'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Wrap
                (
                  spacing: 8, // gap between adjacent items
                  children: <Widget>
                  [
                    Text
                      (
                        'By: ${_blog['author']['name']} • ${getFormattedDate(_blog['updated_at'])}',
                        style: _smallText,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),

                    //Text
                    //(
                    //  getFormattedDate(_blog['updated_at']),
                     // style: _smallText,
                    //),

                    Row
                    (
                      mainAxisSize: MainAxisSize.min,
                      children: 
                      [
                        Text
                        (
                          '[${_blog['num_views']}] ',
                          style: _smallText,
                        ),
                        Icon
                        (
                          Icons.remove_red_eye,
                          size: 16.0,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    //SizedBox(width: 8),
                    Row
                    (
                      mainAxisSize: MainAxisSize.min,
                      children: 
                      [
                        Text
                        (
                          '[${_blog['likes']}] ',
                          style: _smallText,
                        ),
                        Icon
                        (
                          Icons.thumb_up,
                          size: 16.0,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ],
            ),
      ) : null,

        actions: 
        [
          MenuAnchor
          (
            controller: _menuController,
            style: MenuStyle
            (
              backgroundColor: WidgetStateProperty.all(Colors.white),
            ),
            builder: (BuildContext context, MenuController controller, Widget? child) 
            {
              return IconButton
              (
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  if (controller.isOpen) 
                  {
                    controller.close();
                  } 
                  else 
                  {
                    controller.open();
                  }
                },
              );
            },
            menuChildren: 
            [
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
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage),
                    ElevatedButton(
                      onPressed: () {
                        _errorMessage = '';
                        fetchBlog();
                        fetchComments();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: _refreshAll,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        controller: _scrollController,
                        physics: AlwaysScrollableScrollPhysics(), // Ensures single scrollbar behavior
                        slivers: [
                          // Blog content as a sliver
                          SliverToBoxAdapter(
                            child: _buildBlogContent(),
                          ),
                          // Spacing between blog and comments
                          SliverToBoxAdapter(
                            child: SizedBox(height: 20),
                          ),
                          // Comments header
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Comments',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Comments list (no separate scrollbar, part of the main scroll)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
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
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Card(
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
                                              'By: ${comment['user']?['name'] ?? 'Anonymous'}',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: _comments.length +
                                  (_isLoadingMoreComments ? 1 : 0) +
                                  (_hasMoreComments ? 0 : 1),
                            ),
                          ),
                          // Load more button as a sliver
                          if (!_isLoadingMoreComments && _hasMoreComments)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _commentPage++;
                                    });
                                    fetchComments(loadMore: true);
                                  },
                                  child: Text('Load More Comments'),
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Floating "Back to Top" button
                      if (_showBackToTopButton)
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: FloatingActionButton(
                            tooltip: 'Scroll to top',
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

  void _shareBlog() {
    if (_blog != null) {
      Share.share(
        'Check out this blog: ${_blog!['title']}\n'
        '${Uri.base.origin}/#/blogs/${_blog!['blog_id']}/${_blog!['slug'] ?? ''}',
        subject: 'Blog Post from Optometrist Dr. Kwon',
      );
    }
  }

  void _copyLinkToClipboard() {
    if (_blog != null) {
      final blogUrl = '${Uri.base.origin}/#/blogs/${_blog!['blog_id']}/${_blog!['slug']}';
      Clipboard.setData(ClipboardData(text: blogUrl));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link copied to clipboard')),
      );
    }
  }
}