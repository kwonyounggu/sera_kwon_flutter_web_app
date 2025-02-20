
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class GlaucomaScreen extends ConsumerStatefulWidget 
{
  const GlaucomaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GlaucomaScreenState createState() => _GlaucomaScreenState();
}

class _GlaucomaScreenState extends ConsumerState<GlaucomaScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Glaucoma Under construction.'),
      ),
    );
  }
}