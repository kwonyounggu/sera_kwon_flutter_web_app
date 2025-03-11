import 'package:drkwon/pages/blog/blog.dart';
import 'package:drkwon/pages/contact/contact.dart';
import 'package:drkwon/pages/faq/faq.dart';
import 'package:drkwon/pages/home/appointment_screen.dart';
import 'package:drkwon/pages/services/cataracts.dart';
import 'package:drkwon/pages/services/contact_lens.dart';
//import 'package:drkwon/pages/services/diabetic_retinopathy.dart';
import 'package:drkwon/pages/services/dry_eyes.dart';
//import 'package:drkwon/pages/services/glaucoma.dart';
//import 'package:drkwon/pages/services/macular_degeneration.dart';
import 'package:drkwon/pages/services/other_diseases.dart';
import 'package:drkwon/pages/services/eye_exam.dart';
import 'package:drkwon/pages/settings/settings.dart';
import 'package:drkwon/widgets/responsive_shell_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:drkwon/errors/not_found_screen.dart';
import 'package:drkwon/pages/home/home_screen.dart';
import 'package:drkwon/pages/login/create_account_screen.dart';
import 'package:drkwon/pages/login/login_screen_ds.dart';
import 'package:drkwon/pages/about/profile_screen.dart';
import 'package:drkwon/pages/state_data_down_up/color_mixer_screen.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

final Logger logger = Logger();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/logout',
        name: 'logout',
        redirect: (context, state) {
          ref.read(authNotifierProvider.notifier).logout();
          return '/'; // No redirection
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          String currentPath = state.uri.toString();
          debugPrint("Current route: $currentPath");
          return ResponsiveShellRouteWidget(currentPath: currentPath, child: child);
        },
        routes: [
          GoRoute(path: '/', name: 'home', builder: (context, state) => HomeScreen()),
          GoRoute(path: '/home', redirect: (context, state) => '/'),
          GoRoute(path: '/cataracts', name: 'cataracts', builder: (context, state) => CataractsScreen()),
          //GoRoute(path: '/glaucoma', name: 'glaucoma', builder: (context, state) => GlaucomaScreen()),
          //GoRoute(path: '/diabetic_retinopathy', name: 'diabetic_retinopathy', builder: (context, state) => DiabeticRetinopathyScreen()),
          //GoRoute(path: '/macular_degeneration', name: 'macular_degeneration', builder: (context, state) => MacularDegenerationScreen()),
          GoRoute(path: '/contact_lens', name: 'contact_lens', builder: (context, state) => ContactLensScreen()),
          GoRoute(path: '/eye_exam', name: 'eye_exam', builder: (context, state) => EyeExamScreen()),
          GoRoute(path: '/dry_eyes', name: 'dry_eyes', builder: (context, state) => DryEyesScreen()),
          GoRoute(path: '/other_diseases', name: 'other_diseases', builder: (context, state) => OtherDiseasesScreen()),
          //GoRoute(path: '/blog', name: 'blog', builder: (context, state) => BlogScreen()),
          GoRoute(path: '/faq', name: 'faq', builder: (context, state) => FaqScreen()),
          GoRoute(path: '/contact', name: 'contact', builder: (context, state) => ContactScreen()),
          GoRoute(path: '/create-account', name: 'create_account', builder: (context, state) => CreateAccountScreen()),
          GoRoute(path: '/profile', name: 'profile', builder: (context, state) => ProfileScreen()),
          GoRoute(path: '/settings', name: 'settings', builder: (context, state) => SettingsScreen()),
          //GoRoute(path: '/color-mixer', name: 'color_mixer', builder: (context, state) => ColorMixerScreen()),
          //GoRoute(path: '/book-an-appointment', name: 'book_an_appointment', builder: (context, state) => AppointmentScreen()),
          GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginScreen()),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoggingIn = state.uri.path == '/login';
      logger.d("redirect state.uri.path: ${state.uri.path}, $isLoggedIn");

      String? gotoRoute;

      //print("params: ${state.uri.toString()}, =>${state.uri.queryParameters["doit"]}");

      if (isLoggedIn)
      {
        final String? jwt = state.uri.queryParameters["jwt"];
        final String? whereFrom = state.uri.queryParameters["whereFrom"];

        if (isLoggingIn && jwt != null && whereFrom != null)
        {
          gotoRoute = whereFrom;
        }
        //No else is allowed (eg: isLoggedIn && /logout)
      }
      else //not logged in yet
      {
        if (state.uri.path == '/blog') 
        {

          gotoRoute = '/login?whereFrom=/blog';
        } 
        else if (state.uri.path == '/blog2') 
        {
          gotoRoute = '/login?whereFrom=/blog2';
        }
      } 

      return gotoRoute;
    },
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

/*
final routerProvider = Provider<GoRouter>
(
  (ref) 
  {
    final router = ref.read(goRouterProvider);

    // Listen for changes in the auth state
    ref.listen<AuthState>
    (
      authNotifierProvider, 
      (previous, next) 
      {
      if (next.isLoggedIn) 
      {
        // Perform navigation after the state is updated
        final currentPath = router.routerDelegate.currentConfiguration.uri.path;
        print("inside ref.listen: next.isLoggedIn=${next.isLoggedIn}, next.userId=${next.userId}, currentPath=$currentPath");
        // Check if the current path is /login and navigate to the appropriate route
        if (currentPath == '/login') //login callback from fastapi ->login(email) -> then comes here
        {
          final whereFrom = router.routerDelegate.currentConfiguration.uri.queryParameters['whereFrom'];
          if (whereFrom == '/blog') 
          {
            router.go('/blog');
          } 
          else 
          {
            router.go('/');
          }
        }
      }
    });

    return router;
  }
);*/