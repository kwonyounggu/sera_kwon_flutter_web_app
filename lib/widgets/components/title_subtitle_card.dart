import 'package:auto_size_text/auto_size_text.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FactHCard extends ConsumerWidget 
{
  final IconData icon;
  final String title;
  final String text;

  const FactHCard
  (
    {
      super.key,
      required this.icon,
      required this.title,
      required this.text,
    }
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    return Card
    (
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile
      (
        contentPadding: EdgeInsets.all(20),
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: AutoSizeText
        (
          title,
          minFontSize: 18,
          maxFontSize: 20,
          style: TextStyle
          (
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: AutoSizeText
        (
          text,
          minFontSize: 16,
          maxFontSize: 18
        ),
        onTap: () 
        {
          // Navigate to blog post
        },
      ),
    );
  }
}

class FeatureCard extends StatelessWidget 
{
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard
  (
    {
      required this.icon,
      required this.title,
      required this.subtitle,
      super.key,
    }
  );

@override
  Widget build(BuildContext context) 
  {
    return LayoutBuilder(builder: (context, constraints) 
    {
      return ConstrainedBox
      (
        constraints: BoxConstraints(minWidth: 200),
        child: Tooltip( // Wrap the entire Column with Tooltip
          message: '$title\n$subtitle', // Combine title and subtitle for tooltip
          child: Card
          (
            elevation: 4,
            child: Padding
            (
              padding: const EdgeInsets.all(20),
              child: Column
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  Icon(icon, size: 40, color: AppConstants.primaryColor),
                  const SizedBox(height: 15),
                  Flexible
                  (
                    child: AutoSizeText
                    (
                      title,
                      minFontSize: 8,
                      maxFontSize: 20,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible
                  (
                    child: AutoSizeText
                    (
                      subtitle,
                      minFontSize: 4,
                      maxFontSize: 18,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}