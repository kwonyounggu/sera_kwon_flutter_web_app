import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';

/// Diagnostic item widget
class DiagnosticItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const DiagnosticItem({required this.text, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePadding({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double padding = AppConstants.horizontalPadding;
    
    if (width < AppConstants.breakpoints['sm']!) {
      padding = 20.0;
    } else if (width < AppConstants.breakpoints['md']!) {
      padding = 50.0;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: child,
    );
  }
}

// Section title widget
class SectionTitle extends StatelessWidget 
{
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: EdgeInsets.symmetric(vertical: AppConstants.sectionSpacing),
      child: Text(title, style: Theme.of(context).textTheme.displayLarge),
    );
  }
}