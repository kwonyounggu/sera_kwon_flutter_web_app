
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PinkEyeScreen extends ConsumerStatefulWidget 
{
  const PinkEyeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PinkEyeScreenState createState() => _PinkEyeScreenState();
}

class _PinkEyeScreenState extends ConsumerState<PinkEyeScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Pink Eye Under construction.'),
      ),
    );
  }
}