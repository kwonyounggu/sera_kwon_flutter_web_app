import 'package:flutter/material.dart';

class MLAParagraph extends StatelessWidget 
{
  final String text;

  const MLAParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) 
  {
    return RichText
    (
      text: TextSpan
      (
        children: 
        [
          WidgetSpan
          (
            child: SizedBox(width: 40), // First-line indent
          ),
          TextSpan
          (
            text: text,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}