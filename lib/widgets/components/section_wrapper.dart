import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SectionWrapper extends ConsumerWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  const _SectionWrapper({
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...children.expand((widget) => [
                      widget,
                      if (widget != children.last)
                        const SizedBox(height: 30),
                    ])
              ],
            ),
          );
        },
      ),
    );
  }
}