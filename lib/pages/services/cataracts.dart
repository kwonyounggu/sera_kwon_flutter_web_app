
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CataractsScreen extends ConsumerStatefulWidget 
{
  const CataractsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CataractsScreenState createState() => _CataractsScreenState();
}

class _CataractsScreenState extends ConsumerState<CataractsScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: const Center
      (
        child: Text('Cataracts Under construction.'),
      ),
    );
  }
}