import 'dart:convert';

import 'package:drkwon/data/resume_jason.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResumeScreen extends ConsumerWidget 
{
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final jsonData = jsonDecode(resumeJson);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // For scrollable content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildResumeWidgets(jsonData, context),
          ),
        ),
      );
    
  }

  List<Widget> _buildResumeWidgets(Map<String, dynamic> data, BuildContext context) 
  {
    List<Widget> widgets = [];

    data.forEach
    ((key, value) {
      widgets.add(Text(key.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold)));

      if (value is List) {
        for (var item in value) {
          if (item is Map) {
            item.forEach((k, v) {
              widgets.add(_buildClickableText(k, v.toString(), context));
            });
          } else {
            widgets.add(Text(item.toString()));
          }
        }
      } else if (value is Map) {
        value.forEach((k, v) {
           widgets.add(_buildClickableText(k, v.toString(), context));
        });
      } else {
        widgets.add(Text(value.toString()));
      }
      widgets.add(const SizedBox(height: 8)); // Spacing
    });

    return widgets;
  }

  Widget _buildClickableText(String key, String value, BuildContext context) 
  { debugPrint("key = $key");
    if (key == "degree") 
    { // Example: Make email clickable
      return InkWell
      (
        onTap: () 
        {
          context.go('/profile'); // Navigate to /contact route
        },
        child: Text
        (
          value,
          style: const TextStyle
          (
                decoration: TextDecoration.underline, color: Colors.blue
          )
        ),
      );
    } else {
      return Text(value);
    }
  }
}
