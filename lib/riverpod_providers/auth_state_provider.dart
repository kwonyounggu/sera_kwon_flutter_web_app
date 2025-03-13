import 'dart:async';
import 'dart:convert';

import 'package:drkwon/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class AuthState 
{
  final bool isLoggedIn;
  final String? jwt;
  final int? userId;
  final String? userEmail;
  final DateTime? expiryDate;

  AuthState
  (
    {
      required this.isLoggedIn,
      this.jwt,
      this.userId,
      this.userEmail,
      this.expiryDate,
    }
  );
}
class AuthNotifier extends StateNotifier<AuthState> 
{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Timer? tokenRefreshTimer;

  AuthNotifier() : super(AuthState(isLoggedIn: false)) 
  {
    print("AuthNotifier, _loadToken is called");
    _loadToken();
  }

  Future<void> _loadToken() async 
  {
    final jwt = await _storage.read(key: 'jwt');
    final refreshToken = await _storage.read(key: 'refresh_token');

    if (jwt != null) 
    {
      final isExpired = JwtDecoder.isExpired(jwt);
      if (isExpired && refreshToken != null) 
      {
        await refreshAccessToken(refreshToken); // Try refreshing
      } 
      else if (!isExpired) 
      {
        _updateStateFromToken(jwt);
      } 
      else //isExpired
      {
        await _storage.delete(key: 'jwt'); // Clear invalid token
        state = AuthState(isLoggedIn: false);
      }
    }
  }

  void _updateStateFromToken(String jwt) 
  {
    final decodedToken = JwtDecoder.decode(jwt);

    state = AuthState
    (
      isLoggedIn: true,
      jwt: jwt,
      userId: decodedToken['user_id'],
      userEmail: decodedToken['email'],
      expiryDate: JwtDecoder.getExpirationDate(jwt),
    );
  }
  //avoid async to make it synchronized
  void login(String jwt, String refreshToken)
  {
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

    

    // Update state
    state = AuthState
    (
      isLoggedIn: true,
      jwt: jwt, //------- remove later ? --------
      userId: userId,
      userEmail: userEmail,
      expiryDate: expiryDate,
    );

    // Store token in secure storage
    _storage.write(key: 'jwt', value: jwt);
    _storage.write(key: 'refresh_token', value: refreshToken);

    // Start the refresh timer
    startTokenRefreshTimer();
  }

  Future<void> logout() async 
  {
    if (state.isLoggedIn)
    {
      // Stop the refresh timer
      tokenRefreshTimer?.cancel();

      await _storage.delete(key: 'jwt');//access_token
      await _storage.delete(key: 'refresh_token');

      state = AuthState(isLoggedIn: false);
    }
  }

  void createAccount(String userId) 
  {
    //state = state.copyWith(isLoggedIn: true, userId: userId);
  }

  void startTokenRefreshTimer() 
  {
    tokenRefreshTimer = Timer.periodic
    (
      Duration(minutes: 2), //14
      (timer) async 
      {
        final refreshToken = await _storage.read(key: 'refresh_token');
        if (refreshToken != null) 
        {
          await refreshAccessToken(refreshToken);
        } 
        else 
        {
          timer.cancel();
        }
      },
    );
  }


  Future<void> refreshAccessToken(String refreshToken) async 
  {
    try 
    {
      final response = await http.post
      (
        Uri.parse('$FASTAPI_URL/refresh'),
        headers: 
        {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refresh_token': refreshToken}),
        //the following is less secure, because tokens could appear in server logs or network traces.
        //Uri.parse('$FASTAPI_URL/refresh?refresh_token=$refreshToken'),
      );

      if (response.statusCode == 200) 
      {
        final newAccessToken = json.decode(response.body)['access_token'];
        await _storage.write(key: 'jwt', value: newAccessToken);
        _updateStateFromToken(newAccessToken);
      } 
      else 
      {
        tokenRefreshTimer?.cancel();
        print("Refresh token failed or expired. User needs to log in again.");
        //_showSessionExpiredDialog
        logout();
      }
    } 
    catch (e) 
    {
      print("Token refresh error: $e");
    }
  }

  /*
  //To implement
  //see at the bottom of https://chatgpt.com/c/67cdefdb-55b0-800a-ab98-544e875de6e2
  void _showSessionExpiredDialog() 
  {
    WidgetsBinding.instance.addPostFrameCallback
    (
      (_) 
      {
        showDialog
        (
          context: context,
          builder: (context) => AlertDialog
          (
            title: const Text("Session Expired"),
            content: const Text("Your session has expired. Please log in again."),
            actions: 
            [
              TextButton
              (
                onPressed: () 
                {
                  Navigator.of(context).pop();
                  logout(); // Clear state and tokens
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    );
  } 
  */
}

// Create a Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>
(
  (ref) 
  {
    return AuthNotifier();
  }
);