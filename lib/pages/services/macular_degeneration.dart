
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MacularDegenerationScreen extends ConsumerStatefulWidget 
{
  const MacularDegenerationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MacularDegenerationScreenState createState() => _MacularDegenerationScreenState();
}

class _MacularDegenerationScreenState extends ConsumerState<MacularDegenerationScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Macular Degeneration Under construction.'),
      ),
    );
  }
}