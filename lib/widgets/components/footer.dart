import 'package:drkwon/widgets/components/footer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Footer widget
class Footer extends ConsumerWidget 
{
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    return  Container
    (
      color: Colors.blue.shade900,
      padding: const EdgeInsets.only(left:0.0, top: 40.0, right: 0.0, bottom: 0.0),
      child: Column
      (
        children: 
        [
          const Text
          (
            'Canada Advanced Eye Care',
            style: TextStyle
            (
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Wrap
          (
            spacing: 40,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: const 
            [
              FooterItem
              (
                icon: Icons.location_on,
                title: 'Locations',
                content: '2 Champagne Dr\nUnit C2 East Entrance\nToronto, Ontario M3J 0K2',
              ),
              FooterItem
              (
                icon: Icons.phone,
                title: 'Contact',
                content: '416.792.3043\n24/7 Emergency: (416) 792-3043',
              ),
              FooterItem
              (
                icon: Icons.access_time,
                title: 'Hours',
                content: 'Mon-Fri: 9am-5pm\nSat: 9am-3pm',
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text
          (
            '© 2024 Canada Advanced Eye Care. All Rights Reserved.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}