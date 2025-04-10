// search_results_screen.dart
import 'package:drkwon/riverpod_providers/search_results_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchResultsScreen extends ConsumerWidget 
{
  final String query;
  
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final searchResults = ref.watch(searchResultsProvider(query));

    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Search results for "$query"'),
        leading: IconButton
        (
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: searchResults.when
      (
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (results) => ListView.builder
        (
          itemCount: results.length,
          itemBuilder: (context, index) => ListTile
          (
            title: Text(results[index].title),
            subtitle: Text(results[index].contentPreview),
            onTap: () => context.go('/blog/${results[index].id}'),
          ),
        ),
      ),
    );
  }
}