
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BlogScreen extends ConsumerStatefulWidget 
{
  const BlogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends ConsumerState<BlogScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Blog Under construction.'),
      ),
    );
  }
}