import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
import 'package:drkwon/widgets/app_drawer.dart';

class CreateAccountScreen extends ConsumerWidget 
{
  const CreateAccountScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Create Account'),
      ),
      drawer: AppDrawer(),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            const Text('Create a new account.'),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: () 
              {
                // Simulate account creation
                authNotifier.createAccount('newUser456');
                context.goNamed('home'); // Redirect to home after account creation
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}