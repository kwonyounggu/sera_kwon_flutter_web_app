
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DryEyesScreen extends ConsumerStatefulWidget 
{
  const DryEyesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DryEyesScreenState createState() => _DryEyesScreenState();
}

class _DryEyesScreenState extends ConsumerState<DryEyesScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Dry Eyes Under construction.'),
      ),
    );
  }
}