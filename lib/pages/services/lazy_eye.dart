
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LazyEyeScreen extends ConsumerStatefulWidget 
{
  const LazyEyeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LazyEyeScreenState createState() => _LazyEyeScreenState();
}

class _LazyEyeScreenState extends ConsumerState<LazyEyeScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Lazy Eye Under construction.'),
      ),
    );
  }
}