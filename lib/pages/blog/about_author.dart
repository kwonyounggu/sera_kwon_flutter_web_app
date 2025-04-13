import 'package:flutter/material.dart';

class AboutAuthor extends StatelessWidget {
  final String authorName;
  final String authorImageUrl;
  final String authorDescription;

  const AboutAuthor({
    super.key,
    required this.authorName,
    required this.authorImageUrl,
    required this.authorDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'About the author',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(authorImageUrl),
            ),
            const SizedBox(width: 16.0),
            Text(
              authorName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          authorDescription,
          style: const TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }
}