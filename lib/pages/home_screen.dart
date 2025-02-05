import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drkwon/widgets/app_drawer.dart';

class HomeScreen extends ConsumerWidget 
{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Home'),
      ),
      drawer: const AppDrawer(), // Add the drawer here
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            const Text('Welcome to the Home Screen!'),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: () 
              {
                context.goNamed('profile'); // Navigate to Profile Screen using named route
              },
              child: const Text('Go to Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: () 
              {
                context.go('/unknown'); // Navigate to an unknown route
              },
              child: const Text('Go to Unknown Route'),
            ),
          ],
        ),
      ),
    );
  }
}