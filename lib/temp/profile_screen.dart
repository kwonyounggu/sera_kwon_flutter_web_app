import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
import 'package:drkwon/widgets/app_drawer.dart';

class ProfileScreen extends ConsumerWidget 
{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Profile'),
      ),
      drawer: AppDrawer(),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            const Text('Welcome to your Profile!'),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: () 
              {
                // Simulate a logout action
                authNotifier.logout();
                context.goNamed('home'); // Redirect to home after logout
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}