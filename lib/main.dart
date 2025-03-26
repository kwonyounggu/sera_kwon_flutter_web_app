import 'package:drkwon/services/token_refresh_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drkwon/riverpod_providers/router_provider.dart';
import 'package:flutter_quill/flutter_quill.dart'; // Import FlutterQuill
import 'package:flutter_localizations/flutter_localizations.dart'; // Import localization

//navigatorKey used in TokenService running separately
//it is set router_provider.dart as GoRouter(navigatorKey:navigatorKey,...)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 

void main() 
{
  runApp(ProviderScope(child: MyApp(tokenService: TokenService(navigatorKey))));
}

class MyApp extends ConsumerWidget 
{
  final TokenService tokenService;
  const MyApp({super.key, required this.tokenService});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final router = ref.watch(routerProvider);

    // Start TokenService timer after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback
    (
      (_) 
      {
        tokenService.startTokenRefreshTimer(ref);
      }
    );

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
