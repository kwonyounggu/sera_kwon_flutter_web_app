import 'package:drkwon/temp/token_refresh_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drkwon/riverpod_providers/router_provider.dart';
import 'package:flutter_quill/flutter_quill.dart'; // Import FlutterQuill
import 'package:flutter_localizations/flutter_localizations.dart'; // Import localization

//navigatorKey used in TokenService running separately, not used any more
//it is set router_provider.dart as GoRouter(navigatorKey:navigatorKey,...)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 

void main() 
{
  runApp(ProviderScope(child: const MyApp()));
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        cardTheme: CardTheme(elevation: 2),
        useMaterial3: true,
      ),
      scrollBehavior: CustomScrollBehavior(),
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate, // Add this delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', 'US'), // English, US
        // Add other locales as needed
      ],
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
