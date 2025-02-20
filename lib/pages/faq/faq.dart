
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FaqScreen extends ConsumerStatefulWidget 
{
  const FaqScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Faaq Under construction.'),
      ),
    );
  }
}