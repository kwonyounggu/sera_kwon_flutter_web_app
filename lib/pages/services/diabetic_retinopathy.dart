
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DiabeticRetinopathyScreen extends ConsumerStatefulWidget 
{
  const DiabeticRetinopathyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiabeticRetinopathyScreenState createState() => _DiabeticRetinopathyScreenState();
}

class _DiabeticRetinopathyScreenState extends ConsumerState<DiabeticRetinopathyScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Diabetic Retinopathy Under construction.'),
      ),
    );
  }
}