import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget 
{
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('404 - Not Found'),
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            const Text
            (
              'Oops! The page you\'re looking for doesn\'t exist.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton
            (
              onPressed: () {
                context.go('/'); // Navigate back to Home
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}