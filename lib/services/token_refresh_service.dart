import 'dart:async';
import 'dart:convert';

import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

class TokenService 
{
  static TokenService? _instance; // Make it nullable and use lazy initialization.
  final GlobalKey<NavigatorState> navigatorKey;
  // Private constructor with parameters
  TokenService._internal(this.navigatorKey); // ✅ Accept navigatorKey in constructor

  factory TokenService(GlobalKey<NavigatorState> navigatorKey) 
  {
    _instance ??= TokenService._internal(navigatorKey); // Initialize if null
    return _instance!;
  }

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Timer? tokenRefreshTimer;
  bool _timerStarted = false; // Flag to track if timer has started

  void startTokenRefreshTimer(WidgetRef ref) 
  { 
    //if not logged in then immediately try to get the refresh token
    if (_timerStarted) return; // Prevent multiple starts

    print("INFO: startTokenRefreshTimer() of TokenService is called");
    tokenRefreshTimer?.cancel(); //in case we have a timer, we'll cancel it.
    tokenRefreshTimer = Timer.periodic
    (
      Duration(minutes: TOKEN_REFRESH_TIME_MIN), 
      (timer) async 
      {
        final refreshToken = await _storage.read(key: 'refresh_token');
        if (refreshToken != null && timer.isActive) 
        {
          await refreshAccessToken(refreshToken, ref);
        } 
        else 
        {
          timer.cancel(); // Stop if no refresh token exists
        }
        _timerStarted = true; 
      },
    );
  }

  void printToken(String jwt)
  {
    final decodedToken = JwtDecoder.decode(jwt);
    print('''
    #### Refresh token returned successfully ####
    Decoded Token: $decodedToken
    User ID: ${decodedToken['user_id']}
    User Email: ${decodedToken['email']}
    Is Expired: ${JwtDecoder.isExpired(jwt)}
    Expiry Date: ${JwtDecoder.getExpirationDate(jwt)}
    ''');
  }

  Future<void> refreshAccessToken(String refreshToken, WidgetRef ref) async 
  {
    print("INFO: refreshAccessToken of TokenService, refreshToken: $refreshToken");
    try 
    {
      final response = await http.post
      (
        Uri.parse('$FASTAPI_URL/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) 
      {
        final newAccessToken = json.decode(response.body)['access_token'];
        await _storage.write(key: 'jwt', value: newAccessToken);
        printToken(newAccessToken);

        final BuildContext? context = navigatorKey.currentContext;
        if (context != null && context.mounted) 
        {
          if (!ref.read(authNotifierProvider).isLoggedIn)
          {  
            ref.read(authNotifierProvider.notifier).updateToken(newAccessToken);
            //GoRouter.of(context).go('/contact'); //testing
          }
          //GoRouter.of(context).refresh(); // Only refresh the UI
        }
      } 
      else 
      {
        tokenRefreshTimer?.cancel();
        print("Session expired. Redirecting to logout...");
        final BuildContext? context = navigatorKey.currentContext;
        if (context != null && context.mounted) 
        {
          GoRouter.of(context).go('/logout'); // Only logout if refresh fails
        }
      }
    } 
    catch (e) 
    {
      print("Token refresh error: $e");
      tokenRefreshTimer?.cancel(); // Cancel timer on critical errors
    }
    finally 
    {
      print("INFO: refreshAccessToken(...) has been implemented");
    }
  }
}
