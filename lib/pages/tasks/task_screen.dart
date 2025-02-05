import 'package:flutter/material.dart';

class Task1Screen extends StatelessWidget 
{
  const Task1Screen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Task 1'),
      ),
      body: const Center
      (
        child: Text('This is Task 1 Screen.'),
      ),
    );
  }
}

class Task2Screen extends StatelessWidget 
{
  const Task2Screen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Task 2'),
      ),
      body: const Center
      (
        child: Text('This is Task 2 Screen.'),
      ),
    );
  }
}