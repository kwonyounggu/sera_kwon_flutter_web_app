// Add to your riverpod_providers/admin_providers.dart
import 'dart:convert';

import 'package:drkwon/model/blogs_comments_search_result.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final searchResultsProvider = FutureProvider.autoDispose.family<List<SearchResult>, String>
(
  (ref, query) async 
  {
    if (query.isEmpty) return [];
    
    final response = await http.get
    (
      Uri.parse('$FASTAPI_URL/search/?query=$query&include_author=true'),
    );
    
    if (response.statusCode == 200) 
    {
      debugPrint("INFO (searchResultProvider): ${response.body}");
      return (jsonDecode(response.body) as List).map((e) => SearchResult.fromJson(e)).toList();
    }
    throw Exception('Failed to load search results');
  }
);