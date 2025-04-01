import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Timeline extends ConsumerWidget {
  final List<Widget> children;

  const Timeline({super.key, required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Timeline line
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: Colors.blue.shade200,
          ),
        ),
        Column(
          children: children
              .asMap()
              .entries
              .map((entry) => _TimelineItem(
                    isLast: entry.key == children.length - 1,
                    child: entry.value,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final bool isLast;
  final Widget child;

  const _TimelineItem({required this.isLast, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: child,
          ),
        ),
      ],
    );
  }
}

class TimelineEvent extends StatelessWidget {
  final String time;
  final String title;
  final String content;

  const TimelineEvent({
    super.key,
    required this.time,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                content,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}