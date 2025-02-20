import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: slash_for_doc_comments
/**********************************************************************
 * Note that when this screen is called and routed it produces crashing
 */

class LogoutScreen extends ConsumerStatefulWidget 
{
  const LogoutScreen({super.key});

  @override
  ConsumerState<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends ConsumerState<LogoutScreen> 
{
  @override
  void initState() 
  {
    super.initState();
    // Call logout when the screen is initialized
    ref.read(authNotifierProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      //appBar: AppBar(title: const Text('Logout')),
      body: const Center(child: Text('You have been logged out.')),
    );
  }
}