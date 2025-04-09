import 'package:drkwon/pages/blog/blog_details.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

////////////////////////////////////////////////////////////////////////////////////////////////
///See https://www.perplexity.ai/search/seo-related-fields-meta-title-LZzpokQoQ4KNNf1wUlralQ
////////////////////////////////////////////////////////////////////////////////////////////////
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
  String _visibility = 'public'; //public, doctor, all
  int _page = 1;
  final int _perPage = 2; // 10, Number of blogs to load per page
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false; // Track if the "Back to Top" button should be shown

  final _smallText = TextStyle(fontSize: 12, color: Colors.grey[600]);

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

      final response = await http.get(Uri.parse('$FASTAPI_URL/blogs/?visibility=$_visibility&is_hidden=false&page=$_page&per_page=$_perPage'));

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
    //debugPrint("INFO: _visiblity = $_visibility");
    return Scaffold
    (
      appBar: AppBar
      (
        centerTitle: false,
        title: Text('Blogs'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>
        [
          _buildNavButton(),
          const SizedBox(width: 20),
          Tooltip
          (
            message: 'Write a new blog post', // Tooltip message
            child: Stack
            (
              alignment: Alignment.center,
              children: <Widget>
              [
                Container
                (
                  width: 40.0, // Adjust the size as needed
                  height: 40.0, // Adjust the size as needed
                  decoration: BoxDecoration
                  (
                    shape: BoxShape.circle,
                    color: Colors.blue.withValues(alpha: 0.3), // Adjust color and opacity
                  ),
                ),
                IconButton
                (
                  icon: Icon(Icons.edit),
                  onPressed: () 
                  {
                    print('Write new blog post');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      
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
                                //debugPrint("INFO: cover_image=${blog['cover_image']}");
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
                                        context.push('/blogs/${blog['blog_id']}/${blog['slug']}');
                                      },
                                      child: Column
                                      (
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: 
                                        [
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
                                                Text
                                                (
                                                  _blogs[index]['excerpt'] != null && _blogs[index]['excerpt'].length > 100
                                                                                      ? _blogs[index]['excerpt'].substring(0, 100) + '...'
                                                                                      : _blogs[index]['excerpt'] ?? '',
                                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                ),
                                                SizedBox(height: 8.0),
                                                Row
                                                (
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                                  children: <Widget>
                                                  [
                                                    Text('By: ${_blogs[index]['author']['name']}', style: _smallText,),
                                                    Text(_getFormattedDate(_blogs[index]['updated_at']), style: _smallText,),
                                                    Row
                                                    (
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: 
                                                      [
                                                        Text('[${_blogs[index]['num_views']}]', style: _smallText,),
                                                        Icon(Icons.remove_red_eye, size: 16.0, color: Colors.amber)
                                                      ]
                                                    ),
                                                    Row
                                                    (
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: 
                                                      [
                                                        Text('[${_blogs[index]['rating']}]', style: _smallText,),
                                                        Icon(Icons.thumb_up, size: 16.0, color: Colors.amber)
                                                      ]
                                                    ),
                                                    const SizedBox(width: 8)
                                                  ],
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

  Widget _buildNavButton() 
  {
    return SegmentedButton<String>
    (
      segments: const <ButtonSegment<String>>
      [
        ButtonSegment<String>
        (
          value: 'public',
          label: Text('Public'),
        ),
        ButtonSegment<String>
        (
          value: 'doctor',
          label: Text('Doctors'),
        ),
        ButtonSegment<String>
        (
          value: 'all',
          label: Text('All'),
        ),
      ],
      selected: <String>{_visibility},
      onSelectionChanged: (Set<String> newSelection) 
      {
        setState
        (
          () 
          {
            _visibility = newSelection.first;
            //https://www.perplexity.ai/search/blog-dart-for-a-flutter-web-fi-leuEkqHGRfu.m67eDVgL6Q
            _page = 1; // Reset the page to 1
            _hasMore = true; // Reset the "has more" flag
            _blogs.clear(); // Clear the current list of blogs
          }
        );
        fetchBlogs(); // Fetch blogs with the new visibility filter
      },
    );
  }

  String _getFormattedDate(String datetime) 
  {
    const monthAbbreviations = 
    [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final date = DateTime.parse(datetime);
    final year = date.year.toString().substring(0); // Get last 2 digits of year
    final month = monthAbbreviations[date.month - 1];
    final day = date.day.toString().padLeft(2, '0'); // Add leading zero if needed
    
    return '$year-$month-$day';
  }
}