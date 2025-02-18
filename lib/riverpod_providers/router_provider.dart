import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:drkwon/errors/not_found_screen.dart';
import 'package:drkwon/pages/home_screen.dart';
import 'package:drkwon/pages/login/create_account_screen.dart';
import 'package:drkwon/pages/login/login_screen.dart';
import 'package:drkwon/pages/about/profile_screen.dart';
import 'package:drkwon/pages/state_data_down_up/color_mixer_screen.dart';
import 'package:drkwon/pages/tasks/task_screen.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

final Logger logger = Logger();

final routerProvider = Provider<GoRouter>
(
  (ref) 
  {
    final authState = ref.watch(authNotifierProvider);

    return GoRouter
    (
      initialLocation: '/home',
      routes: 
      [
        GoRoute
        (
          path: '/',
          name: 'home', // Named route
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute
        (
          path: '/login',
          name: 'login', // Named route
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute
        (
          path: '/create-account',
          name: 'create_account', // Named route
          builder: (context, state) => const CreateAccountScreen(),
        ),
        GoRoute
        (
          path: '/profile',
          name: 'profile', // Named route
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute
        (
          path: '/task1',
          name: 'task1', // Named route
          builder: (context, state) => const Task1Screen(),
        ),
        GoRoute
        (
          path: '/task2',
          name: 'task2', // Named route
          builder: (context, state) => const Task2Screen(),
        ),
        GoRoute
        (
          path: '/colorMixer',
          name: 'colorMixer', // Named route
          builder: (context, state) => const ColorMixerScreen(),
        ),
      ],
      redirect: (context, state) 
      {
        final isLoggedIn = authState.isLoggedIn;
        /********************************
        'state.matchedLocation' is Used in redirects:
        When implementing redirects based on user state, 
        state.matchedLocation is often used to check 
        if the current route matches a specific path 
        for redirecting purposes. 
        *********************************/
        final location = state.uri.toString();
        debugPrint("-----location----: $location");
        logger.d('here -- 0 --, isLoggedIn = $isLoggedIn location = $location fullPath = ${state.fullPath} matchedLocation = ${state.matchedLocation} path = ${state.path}');
        
        if (!isLoggedIn)
        {
          return '/login';
        }
        

        // No redirect needed
        return null;
      },
      errorBuilder: (context, state) => const NotFoundScreen(), // Custom 404 page
    );
  }
);