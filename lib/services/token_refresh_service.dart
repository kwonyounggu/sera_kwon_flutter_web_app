import 'dart:async';
import 'dart:convert';

import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService 
{
  final GlobalKey<NavigatorState> navigatorKey;
  TokenService(this.navigatorKey); // ✅ Accept navigatorKey in constructor

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Timer? tokenRefreshTimer;

  void startTokenRefreshTimer() 
  { 
    print("INFO: startTokenRefreshTimer() of TokenService is called");
    tokenRefreshTimer?.cancel(); //in case we have a timer, we'll cancel it.
    tokenRefreshTimer = Timer.periodic
    (
      Duration(minutes: 2), 
      (timer) async 
      {
        final refreshToken = await _storage.read(key: 'refresh_token');
        if (refreshToken != null) 
        {
          if (timer.isActive) {await refreshAccessToken(refreshToken);}
          else {return;}
        } 
        else 
        {
          timer.cancel(); // Stop if no refresh token exists
        }
      },
    );
  }

  void printToken(String jwt)
  {
    print("#### Refresh token returned successfully ####");
    final decodedToken = JwtDecoder.decode(jwt);
    print("Decoded Token: $decodedToken");

    // Access specific claims
    final userId = decodedToken['user_id']; // 'sub' is a common claim for user ID
    print("User ID: $userId");

    final userEmail = decodedToken['email']; // 'sub' is a common claim for user ID
    print("User Email: $userEmail");

    // Check expiration
    final isExpired = JwtDecoder.isExpired(jwt);
    print("Is Expired: $isExpired");

    // Get expiration date
    final expiryDate = JwtDecoder.getExpirationDate(jwt);
    print("Expiry Date: $expiryDate");
  }
  Future<void> refreshAccessToken(String refreshToken) async 
  {
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
          GoRouter.of(context).refresh(); // Only refresh the UI
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
    }
  }
}
