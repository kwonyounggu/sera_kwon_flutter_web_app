
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends ConsumerStatefulWidget 
{
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      //appBar: AppBar
      //(
      //  title: const Text('Home'),
      //),
      body: const Center
      (
        child: Text('Under construction.'),
      ),
    );
  }
}