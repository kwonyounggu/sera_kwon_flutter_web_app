//import 'package:drkwon/pages/blog/blog.dart';
import 'package:drkwon/pages/blog/blog_creation_dr.dart';
import 'package:drkwon/pages/blog/public_blog_listing.dart';
import 'package:drkwon/pages/contact/contact.dart';
import 'package:drkwon/pages/faq/faq.dart';
//import 'package:drkwon/pages/home/appointment_screen.dart';
import 'package:drkwon/pages/services/cataracts.dart';
import 'package:drkwon/pages/services/contact_lens.dart';
//import 'package:drkwon/pages/services/diabetic_retinopathy.dart';
import 'package:drkwon/pages/services/dry_eyes.dart';
//import 'package:drkwon/pages/services/glaucoma.dart';
//import 'package:drkwon/pages/services/macular_degeneration.dart';
import 'package:drkwon/pages/services/other_diseases.dart';
import 'package:drkwon/pages/services/eye_exam.dart';
import 'package:drkwon/pages/settings/my_profile.dart';
//import 'package:drkwon/pages/settings/settings.dart';
import 'package:drkwon/widgets/responsive_shell_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:googleapis/civicinfo/v2.dart';
import 'package:logger/logger.dart';
import 'package:drkwon/errors/not_found_screen.dart';
import 'package:drkwon/pages/home/home_screen.dart';
import 'package:drkwon/pages/login/create_account_screen.dart';
import 'package:drkwon/pages/login/login_screen_ds.dart';
//import 'package:drkwon/pages/about/profile_screen.dart';
//import 'package:drkwon/pages/state_data_down_up/color_mixer_screen.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

final Logger logger = Logger();
final lastPathProvider = StateProvider<String>((ref) => '/');
final routerProvider = Provider<GoRouter>
(
    (ref) 
    {
      //final authNotifier = ref.watch(authNotifierProvider.notifier);
      final authState =  ref.watch(authNotifierProvider);

      return GoRouter
      (
        //initialLocation: '/',
        routes: <RouteBase>
        [
          GoRoute
          (
            path: '/logout',
            name: 'logout',
            redirect: (context, state) 
            {
              ref.read(authNotifierProvider.notifier).logout();
              return '/'; // No redirection
            },
          ),
          ShellRoute
          (
            builder: (context, state, child) 
            {
              String currentPath = state.uri.toString();
              debugPrint("Current route in ShellRoute: $currentPath");
              WidgetsBinding.instance.addPostFrameCallback
              (
                (_) 
                {
                  ref.read(lastPathProvider.notifier).state = currentPath;
                }
              );
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
              GoRoute(path: '/blog_list', name: 'blog_list', builder: (context, state) => PublicBlogListing()),
              GoRoute(path: '/blog_writing', name: 'blog_writing', builder: (context, state) => BlogCreationPage()),
              GoRoute(path: '/faq', name: 'faq', builder: (context, state) => FaqScreen()),
              GoRoute(path: '/contact', name: 'contact', builder: (context, state) => ContactScreen()),
              GoRoute(path: '/create-account', name: 'create_account', builder: (context, state) => CreateAccountScreen()),
              GoRoute(path: '/profile', name: 'profile', builder: (context, state) => ProfileSetupScreen()),
              //GoRoute(path: '/settings', name: 'settings', builder: (context, state) => SettingsScreen()),
              //GoRoute(path: '/color-mixer', name: 'color_mixer', builder: (context, state) => ColorMixerScreen()),
              //GoRoute(path: '/book-an-appointment', name: 'book_an_appointment', builder: (context, state) => AppointmentScreen()),
              GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginScreen()),
            ],
          ),
        ],
        //refreshListenable: authNotifier.authStateListenable, //this will help GoRouter to rebuild only when the auth state changes
        redirect: (context, state) 
        {       
          if (authState.isLoading) return null; //prevent redirect until the loading is finished.
          

          final isLoggedIn = authState.isLoggedIn;
          final currentPath = state.uri.path;
          final lastPath = ref.read(lastPathProvider);

          logger.d("Redirect: Current path - $currentPath, isLoggedIn - $isLoggedIn, Last path - $lastPath");

          // If user is logged in and not on the login page, stay on the current path
          if (isLoggedIn && currentPath != '/login') 
          {
            // Update last path only if not loading and logged in
            ref.read(lastPathProvider.notifier).state = currentPath;
            return null; // Do not redirect
          }          

          String? gotoRoute;

          if (isLoggedIn) 
          {
              final String? whereFrom = state.uri.queryParameters["whereFrom"];
              if (currentPath == '/login' && whereFrom != null) //comes from login_screen_dr.dart after storing the required data
              {
                  gotoRoute = whereFrom;
              } 
              else if (currentPath == '/login') 
              {
                  gotoRoute = lastPath; // Redirect to last known path after login
              }
          } 
          else 
          { // Not logged in
              if (state.uri.path == '/blog2') 
              {
                  gotoRoute = '/login?whereFrom=/blog2';
              }
          } 

          return gotoRoute;
          
        },
        errorBuilder: (context, state) => const NotFoundScreen(),
      );
    }
);
