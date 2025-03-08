import 'package:drkwon/pages/blog/blog.dart';
import 'package:drkwon/pages/contact/contact.dart';
import 'package:drkwon/pages/faq/faq.dart';
import 'package:drkwon/pages/home/appointment_screen.dart';
//import 'package:drkwon/pages/login/google_signin_page.dart';
//import 'package:drkwon/pages/login/logout.dart';
import 'package:drkwon/pages/services/cataracts.dart';
import 'package:drkwon/pages/services/diabetic_retinopathy.dart';
import 'package:drkwon/pages/services/dry_eyes.dart';
import 'package:drkwon/pages/services/glaucoma.dart';
import 'package:drkwon/pages/services/lazy_eye.dart';
import 'package:drkwon/pages/services/macular_degeneration.dart';
import 'package:drkwon/pages/services/other_diseases.dart';
import 'package:drkwon/pages/services/pink_eye.dart';
import 'package:drkwon/pages/settings/settings.dart';
import 'package:drkwon/widgets/responsive_shell_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/transcoder/v1.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:drkwon/errors/not_found_screen.dart';
import 'package:drkwon/pages/home/home_screen.dart';
import 'package:drkwon/pages/login/create_account_screen.dart';
import 'package:drkwon/pages/login/login_screen_ds.dart';
import 'package:drkwon/pages/about/profile_screen.dart';
import 'package:drkwon/pages/state_data_down_up/color_mixer_screen.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

final Logger logger = Logger();

final routerProvider = Provider<GoRouter>
(
  (ref) 
  {
    final authState = ref.watch(authNotifierProvider);
    
    return GoRouter
    (
      initialLocation: '/', // Start with login if authentication is required
      routes: <RouteBase>
      [
        
        
        GoRoute
        (
          path: '/logout', 
          name: 'logout', 
          redirect: (context, state) 
          {
            ref.read(authNotifierProvider.notifier).logout();
            return null; // No redirection
          },
        ),
        ShellRoute
        (
          builder: (context, state, child) 
          {
            String currentPath = state.uri.toString();
            debugPrint("Current route: $currentPath");
            return ResponsiveShellRouteWidget(currentPath: currentPath, child: child);
          },
          routes: 
          [
            GoRoute(path: '/', name: 'home', builder: (context, state) => HomeScreen()),
            GoRoute(path: '/home', redirect: (context, state) => '/'),
            GoRoute(path: '/cataracts', name: 'cataracts', builder: (context, state) => CataractsScreen()),
            GoRoute(path: '/glaucoma', name: 'glaucoma', builder: (context, state) => GlaucomaScreen()),
            GoRoute(path: '/diabetic_retinopathy', name: 'diabetic_retinopathy', builder: (context, state) => DiabeticRetinopathyScreen()),
            GoRoute(path: '/macular_degeneration', name: 'macular_degeneration', builder: (context, state) => MacularDegenerationScreen()),
            GoRoute(path: '/lazy_eye', name: 'lazy_eye', builder: (context, state) => LazyEyeScreen()),
            GoRoute(path: '/pink_eye', name: 'pink_eye', builder: (context, state) => PinkEyeScreen()),
            GoRoute(path: '/dry_eyes', name: 'dry_eyes', builder: (context, state) => DryEyesScreen()),
            GoRoute(path: '/other_diseases', name: 'other_diseases', builder: (context, state) => OtherDiseasesScreen()),
            GoRoute(path: '/blog', name: 'blog', builder: (context, state) => BlogScreen()),
            GoRoute(path: '/faq', name: 'faq', builder: (context, state) => FaqScreen()),
            GoRoute(path: '/contact', name: 'contact', builder: (context, state) => ContactScreen()),
            GoRoute(path: '/create-account', name: 'create_account', builder: (context, state) => CreateAccountScreen()),
            GoRoute(path: '/profile', name: 'profile', builder: (context, state) => ProfileScreen()),
            GoRoute(path: '/settings', name: 'settings', builder: (context, state) => SettingsScreen()),
            GoRoute(path: '/color-mixer', name: 'color_mixer', builder: (context, state) => ColorMixerScreen()), 
            GoRoute(path: '/book-an-appointment', name: 'book_an_appointment', builder: (context, state) => AppointmentScreen()),  
  
            GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginScreen()),    
          ],
        ),
      ],
      redirect: (context, state) 
      {
        final isLoggedIn = authState.isLoggedIn;
        //The following statement generate an error; 
        //"Cannot use ref functions after the dependency of a provider changed but before the provider rebuilt"
        //final isLoggedIn = ref.read(authNotifierProvider).isLoggedIn;
        final isLoggingIn = state.uri.path == '/login';
        logger.d("redirect state.uri.path: ${state.uri.path}, $isLoggedIn");
        
        String? gotoRoute;

        if (!isLoggedIn)
        {
          if (state.uri.path == '/blog') //cliked from /blog
          {
            gotoRoute = '/login?whereFrom=/blog';
          }
          else if (state.uri.path == '/blog2') 
          {
            gotoRoute = '/login?whereFrom=/blog2';
          }
          else //it may clicked login sign then remember where you were 
          {

          }
        }
        else if (isLoggedIn && isLoggingIn) 
        {
          gotoRoute = '/';
        }

        // No redirection needed, allow navigation
        return gotoRoute;
      },
      errorBuilder: (context, state) => const NotFoundScreen(), // Custom 404 page
    );
  }
);