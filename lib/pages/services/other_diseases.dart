
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class OtherDiseasesScreen extends ConsumerStatefulWidget 
{
  const OtherDiseasesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OtherDiseasesScreenState createState() => _OtherDiseasesScreenState();
}

class _OtherDiseasesScreenState extends ConsumerState<OtherDiseasesScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Other Diseases Under construction.'),
      ),
    );
  }
}