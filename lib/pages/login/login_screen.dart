import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

class LoginScreen extends ConsumerWidget 
{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    //final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Login'),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            const Text('Please log in to continue.'),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: () 
              {
                // Simulate a login action
                //authNotifier.login('user123');
                ref.read(authNotifierProvider.notifier).login('user123');
                context.goNamed('home'); // Redirect to home after login
              },
              child: const Text('Login'),
            ),
            /*const SizedBox(height: 20),
            TextButton
            (
              onPressed: () 
              {
                context.goNamed('create_account'); // Navigate to account creation
              },
              child: const Text('Create an Account'),
            ),*/
          ],
        ),
      ),
    );
  }
}