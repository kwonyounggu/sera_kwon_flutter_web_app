
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ContactLensScreen extends ConsumerStatefulWidget 
{
  const ContactLensScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactLensScreenState createState() => _ContactLensScreenState();
}

class _ContactLensScreenState extends ConsumerState<ContactLensScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Contact Lens Under construction.'),
      ),
    );
  }
}