import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:drkwon/data/drkwon_json.dart';
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
    final fontSize = MediaQuery.of(context).size.width * 0.025;

    return Padding
    (
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView
        ( // For scrollable content
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildResumeWidgets(jsonData, context, fontSize),
          ),
        ),
      );
    
  }

  List<Widget> _buildResumeWidgets(Map<String, dynamic> data, BuildContext context, double fontSize) 
  {
    List<Widget> widgets = [];

    data.forEach
    (
      (key, value) 
      {
        widgets.add
        (
          //NAME, ADDRRESS, PHONE, EMAIL, EDUCATTON, EXPERIENCE, SKILLS
          AutoSizeText
          (
            key.toUpperCase(),
            minFontSize: 12,
            maxFontSize: 22,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            maxLines: 1,
          )
        );

        //education, experience, skills
        if (value is List) 
        {
          for (var item in value) 
          {
            if (item is Map) 
            {
              item.forEach
              (
                (k, v) 
                {
                  widgets.add(_buildClickableText(k, v.toString(), context, fontSize));
                }
              );
            } 
            else //skills
            {
              widgets.add
              (
                AutoSizeText
                (
                      item.toString(),
                      minFontSize: 12,
                      maxFontSize: 22,
                      style: TextStyle(fontSize: fontSize)
                )
              );
            }
          }
        } 
        else if (value is Map) 
        {
          value.forEach
          (
            (k, v) 
            {
              widgets.add(_buildClickableText(k, v.toString(), context, fontSize));
            }
          );
        } 
        else 
        {
          widgets.add
          (
            AutoSizeText
            (
                  value.toString(),
                  minFontSize: 12,
                  maxFontSize: 22,
                  style: TextStyle(fontSize: fontSize)
            )
          );
        }
        widgets.add(const SizedBox(height: 8)); // Spacing
      }
    );

    return widgets;
  }

  Widget _buildClickableText(String key, String value, BuildContext context, double fontSize)
  { 
    debugPrint("key = $key");
    if (key == "degree") 
    { // Example: Make email clickable
      return InkWell
      (
        onTap: () 
        {
          context.go('/profile'); // Navigate to /contact route
        },
        //child: Text
        //(
        //  value,
        //  style: const TextStyle
        //  (
        //        decoration: TextDecoration.underline, color: Colors.blue
        //  )
        //),
        child: AutoSizeText
        (
            value,
            minFontSize: 12,
            maxFontSize: 22,
            style: TextStyle(fontSize: fontSize, decoration: TextDecoration.underline, color: Colors.blue),
        )
      );
    } 
    else 
    {
      return AutoSizeText
      (
            value,
            minFontSize: 12,
            maxFontSize: 22,
            style: TextStyle(fontSize: fontSize)
      );
    }
  }
}
