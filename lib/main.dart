import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drkwon/riverpod_providers/router_provider.dart';

void main() 
{
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final router = ref.watch(routerProvider);

    return MaterialApp.router
    (
      routerConfig: router,
      title: 'Eye Doctor Dr.KWON',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      scrollBehavior: CustomScrollBehavior(),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior 
{
  @override
  Set<PointerDeviceKind> get dragDevices => 
  {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
  };
}
