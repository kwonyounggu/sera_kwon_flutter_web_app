//import 'package:drkwon/pages/blog/blog.dart';
import 'package:drkwon/main.dart';
import 'package:drkwon/pages/blog/blog_creation_dr.dart';
import 'package:drkwon/pages/blog/blog_details.dart';
import 'package:drkwon/pages/blog/public_blog_listing.dart';
import 'package:drkwon/pages/about/about_me.dart';
import 'package:drkwon/pages/contact/contact.dart';
import 'package:drkwon/pages/faq/faq.dart';
import 'package:drkwon/pages/search/desktop_search_result.dart';

import 'package:drkwon/pages/services/cataracts.dart';
import 'package:drkwon/pages/services/contact_lens.dart';

import 'package:drkwon/pages/services/dry_eyes.dart';

import 'package:drkwon/pages/services/other_diseases.dart';
import 'package:drkwon/pages/services/eye_exam.dart';
import 'package:drkwon/pages/settings/my_profile.dart';
import 'package:drkwon/pages/search/mobile_search_bar.dart';

import 'package:drkwon/widgets/responsive_shell_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logger/logger.dart';
import 'package:drkwon/errors/not_found_screen.dart';
import 'package:drkwon/pages/home/home_screen.dart';
import 'package:drkwon/pages/login/create_account_screen.dart';
import 'package:drkwon/pages/login/login_screen_ds.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

final Logger logger = Logger();
final routerProvider = Provider<GoRouter>
(
  (ref) 
  {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    //final authState =  ref.watch(authNotifierProvider);
    return GoRouter
    (
      navigatorKey: navigatorKey, // ✅ Use global key here defined in main.dart
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/logout',
          name: 'logout',
          redirect: (context, state) 
          {
            if (authNotifier.state.isLoggedIn)
            {
              ref.read(authNotifierProvider.notifier).logout();
            }
            return '/'; // No redirection loop
          },
        ),
        ShellRoute
        (
          builder: (context, state, child) 
          {
            String currentPath = state.uri.toString();
            debugPrint("Current route in ShellRoute: $currentPath");
            return ResponsiveShellRouteWidget(currentPath: currentPath, child: child);
          },
          routes: 
          [
            GoRoute(path: '/', name: 'home', builder: (context, state) => HomeScreen()),
            GoRoute(path: '/home', redirect: (context, state) => '/'),
            GoRoute(path: '/cataracts', name: 'cataracts', builder: (context, state) => CataractsScreen()),
            GoRoute(path: '/contact_lens', name: 'contact_lens', builder: (context, state) => ContactLensScreen()),
            GoRoute(path: '/eye_exam', name: 'eye_exam', builder: (context, state) => EyeExamScreen()),
            GoRoute(path: '/dry_eyes', name: 'dry_eyes', builder: (context, state) => DryEyesScreen()),
            GoRoute(path: '/other_diseases', name: 'other_diseases', builder: (context, state) => OtherDiseasesScreen()),
            GoRoute(path: '/blogs', name: 'blogs', builder: (context, state) => PublicBlogListing()),
            GoRoute
            (
              path: '/blogs/:id/:slug', 
              builder: (context, state)
              {
                try
                {
                  return BlogDetailPage(blogId:int.parse(state.pathParameters['id']!));
                }
                catch (e)
                {
                  return const NotFoundScreen();
                }
              }
            ),
            //GoRoute(path: '/blog_writing', name: 'blog_writing', builder: (context, state) => BlogCreationPage()),
            GoRoute(path: '/faq', name: 'faq', builder: (context, state) => FaqScreen()),
            GoRoute(path: '/contact', name: 'contact', builder: (context, state) => ContactScreen()),
            GoRoute(path: '/aboutme', name: 'aboutme', builder: (context, state) => AboutMeScreen()),
            GoRoute(path: '/create-account', name: 'create_account', builder: (context, state) => CreateAccountScreen()),
            GoRoute(path: '/profile', name: 'profile', builder: (context, state) => ProfileSetupScreen()),
            GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginScreen()),
            GoRoute
            (
              path: '/search',
              builder: (context, state) 
              {
                final extra = state.extra as Map<String, dynamic>?;
                final device = extra?['device'];

                if (device == 'mobile')
                {
                  final onSearchChanged = extra?['onSearchChanged'] as ValueChanged<String>? ?? (String query) {};
                  final onCancelSearch = extra?['onCancelSearch'] as VoidCallback? ?? () {};
                  final previousPath = extra?['previousPath'];
                  return MobileSearchScreen
                  (
                    onSearchChanged: onSearchChanged,
                    onCancelSearch: onCancelSearch,
                    previousPath: previousPath
                  );
                }
                else //desktop
                {
                  return SearchResultsScreen(query: extra?['query'] ?? '');
                }
              },
            ),
          ],
        ),
      ],
      refreshListenable: authNotifier.authStateListenable,
      redirect: (context, state) 
      {
        final authState = authNotifier.authState(); 
        final isLoggedIn = authState.isLoggedIn;
        final currentPath = state.uri.path;
        
        debugPrint("redirect state.uri.path: $currentPath, isLoggedIn: $isLoggedIn");

        if (isLoggedIn)
        {
          if (currentPath == '/login') return '/';
          return null; // Stay on the current route
        }

        //Not isLoggedIn from here
        switch(currentPath)
        {
          case '/blog_writing': 
          case '/blog_publish': return '/login?whereFrom$currentPath';
        }

        return null; // No redirection unless needed
      },
      errorBuilder: (context, state) => const NotFoundScreen(),
    );
  }
);
