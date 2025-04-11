// search_results_screen.dart
import 'package:drkwon/model/blogs_comments_search_result.dart';
import 'package:drkwon/riverpod_providers/search_results_provider.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchResultsScreen extends ConsumerWidget 
{
  final String query;
  final String? previousPath;

  const SearchResultsScreen({super.key, required this.query, this.previousPath});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final searchResults = ref.watch(searchResultsProvider(query));
    final smallText = TextStyle(fontSize: 12, color: Colors.grey[600]);

    return searchResults.when
    (
      loading: () => Scaffold
      (
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold
      (
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (results)
      {
        final blogResults = results.where((r) => r.type == ResultType.blog).toList();
        final commentResults = results.where((r) => r.type == ResultType.comment).toList();

        return Scaffold
        (
          appBar: AppBar
          (
            title: Text('Search results (${results.length}) for "$query"'),
            leading: IconButton
            (
              icon: const Icon(Icons.arrow_back),
              onPressed: () 
              {
                if (previousPath != null) 
                {
                  context.go(previousPath!);
                } 
                else 
                {
                  context.go('/');
                }
              },
            ),
          ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: 
          [
            if (blogResults.isNotEmpty) 
            ...[
              const Text('📝 Blogs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...blogResults.map
              (
                (result) => ListTile
                (
                  title: Text(result.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: 
                    [
                      Text(result.contentPreview, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      Row
                      (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: 
                        [
                          Text('By: ${result.authorName}', style: smallText,),
                          Text(getFormattedDate(result.date), style: smallText,),
                          Row
                          (
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: 
                            [
                              Text('[${result.likes}] ', style: smallText,),
                              Icon(Icons.thumb_up, size: 16.0, color: Colors.amber)
                            ]
                          ),
                        ]
                      )
                    ],
                  ),
                  
                  onTap: () => context.go('/blogs/${result.id}'),
                )
              ),
              const Divider(height: 32),
            ],
            if (commentResults.isNotEmpty) 
            ...[
              const Text('💬 Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...commentResults.map
              (
                (result) => ListTile
                (
                  //title: Text(result.title),
                  subtitle: Column
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: 
                    [
                      Text(result.contentPreview, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      Row
                      (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: 
                        [
                          Text('By: ${result.authorName}', style: smallText,),
                          Text(getFormattedDate(result.date), style: smallText,),
                          Row
                          (
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: 
                            [
                              Text('[${result.likes}] ', style: smallText,),
                              Icon(Icons.thumb_up, size: 16.0, color: Colors.amber)
                            ]
                          ),
                        ]
                      )
                    ],
                  ),
                  onTap: () => context.go('/blogs/${result.id}'), // or a comment-specific page
                )
              ),
            ],
            if (blogResults.isEmpty && commentResults.isEmpty)
              const Center(child: Text('No matching results found.')),
          ],
        ),
        );
      }
    );
  }
}