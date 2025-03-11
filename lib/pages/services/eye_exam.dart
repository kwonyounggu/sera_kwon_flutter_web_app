
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class EyeExamScreen extends ConsumerStatefulWidget 
{
  const EyeExamScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EyeExamScreenState createState() => _EyeExamScreenState();
}

class _EyeExamScreenState extends ConsumerState<EyeExamScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Comprehensive Eye exam  Under construction.'),
      ),
    );
  }
}