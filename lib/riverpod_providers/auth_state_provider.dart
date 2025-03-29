import 'dart:async';
import 'dart:convert';

import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

// see https://chatgpt.com/c/67cdefdb-55b0-800a-ab98-544e875de6e2 on Mar 28 Fri
class AuthState 
{
  final bool isLoggedIn;
  final bool isLoading; // New: Loading state
  final int? userId;
  final String? userEmail;
  final String? userType; //admin, doctor, general

  AuthState({required this.isLoggedIn, this.isLoading = false, this.userId, this.userEmail, this.userType});

  AuthState copyWith({bool? isLoggedIn, bool? isLoading, int? userId, String? userEmail, String? userType}) 
  {
    return AuthState
    (
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userType: userType ?? this.userType,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> with WidgetsBindingObserver
{
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Timer? tokenRefreshTimer;
  final ValueNotifier<AuthState> authStateListenable = ValueNotifier<AuthState>(AuthState(isLoggedIn: false));
  
  AuthNotifier() : super(AuthState(isLoggedIn: false)) 
  {
    debugPrint("INFO ${DateTime.now()}:AuthNotifier, _loadToken is called");
    _loadToken();
    WidgetsBinding.instance.addObserver(this); // Listen for app lifecycle changes
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) 
  {
    if (state == AppLifecycleState.paused) 
    {
      tokenRefreshTimer?.cancel(); // Stop timer when app is backgrounded
    } 
    else if (state == AppLifecycleState.resumed) 
    {
      startTokenRefreshTimer(); // Safely restart timer on resume
    }
  }

  Future<void> _loadToken() async 
  {
    final jwt = await _storage.read(key: 'jwt');
    final refreshToken = await _storage.read(key: 'refresh_token');

    if (jwt != null)
    {
      final isExpired = JwtDecoder.isExpired(jwt);
      if (!isExpired) //isLoggedIn <- True
      { 
        debugPrint("INFO ${DateTime.now()}: _loadToken, token is not expired --1--");
        _updateStateFromToken(jwt);
      }
      else if (refreshToken != null) //get new token using refresh_token
      { 
        debugPrint("INFO ${DateTime.now()}: _loadToken, token is expired so get new one --2--");
        await refreshAccessToken(refreshToken); // Try refreshing for a new token
      }
      else //token is expired and no refresh token, is this case possible?
      { 
        debugPrint("INFO ${DateTime.now()}: _loadToken, token is expired and refresh token is null --3--");
        await _storage.delete(key: 'jwt'); // Clear invalid token
        //state = AuthState(isLoggedIn: false);
        //authStateListenable.value = state; // Notify listeners
      }
    }
    else if (refreshToken != null) //is this case possible?
    {   
      debugPrint("INFO ${DateTime.now()}: _loadToken, token is null but refresh token is not null --4--");
        await refreshAccessToken(refreshToken); // Try refreshing for a new token
    }
    else //jwt == null && refresh_token == null
    { 
      debugPrint("INFO ${DateTime.now()}: _loadToken, token and refresh token both are null --5--");
       //state = AuthState(isLoggedIn: false);
       //authStateListenable.value = state; // Notify listeners
    }
  }

  void _updateStateFromToken(String jwt) 
  {
    debugPrint("INFO ${DateTime.now()}: _updateStateFromToken, --1--");
    final decodedToken = JwtDecoder.decode(jwt);
    
    if (!state.isLoggedIn)
    {
      state = AuthState
      (
        isLoggedIn: true,
        userId: decodedToken['user_id'],
        userEmail: decodedToken['email'],
        userType: decodedToken['user_type'],
      );

      authStateListenable.value = state; 
    }
  }

  //refresh token lasts for 7 days
  //unless the user does not logout (refresh token = null then) and
  //use the web page within 7 days then login will last forever
  void login(String jwt, String refreshToken)
  {
    
 
    debugPrint("INFO ${DateTime.now()}:: login() access token expire date: ${JwtDecoder.getExpirationDate(jwt)}");
    debugPrint("INFO ${DateTime.now()}:: login() refresh token expire date: ${JwtDecoder.getExpirationDate(refreshToken)}");
    debugPrint("INFO ${DateTime.now()}:: login() refresh token just got from server: $refreshToken");
    // Store token in secure storage
    _storage.write(key: 'jwt', value: jwt);
    _storage.write(key: 'refresh_token', value: refreshToken);

    _updateStateFromToken(jwt);

    // Start the refresh timer
    // See https://chatgpt.com/c/67cdefdb-55b0-800a-ab98-544e875de6e2
    startTokenRefreshTimer();
  }

  void startTokenRefreshTimer() 
  { 
    debugPrint("INFO ${DateTime.now()}:: startTokenRefreshTimer(...) is called --1--");
    tokenRefreshTimer?.cancel();
    tokenRefreshTimer = Timer.periodic
    (
      Duration(minutes: TOKEN_REFRESH_TIME_MIN), //14
      (timer) async 
      {
        final refreshToken = await _storage.read(key: 'refresh_token');
        if (refreshToken != null) 
        { 
          debugPrint("INFO ${DateTime.now()}: startTokenRefreshTimer(...) is called --2--");
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
    debugPrint("INFO ${DateTime.now()}: refreshAccessToken(...) is called --1--");
    state = state.copyWith(isLoading: true); // Set loading state
    authStateListenable.value = state;
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
      );

      if (response.statusCode == 200) 
      {
        final newAccessToken = json.decode(response.body)['access_token'];
        await _storage.write(key: 'jwt', value: newAccessToken);
        _updateStateFromToken(newAccessToken);
        startTokenRefreshTimer();
      } 
      else 
      {
        debugPrint("INFO ${DateTime.now()}: refreshAccessToken, Refresh token failed or expired. User needs to log in again.");
        //_showSessionExpiredDialog
        logout();
      }
    } 
    catch (e) 
    {
      debugPrint("INFO ${DateTime.now()}: Token refresh error: $e");
      logout();
    }
    finally
    {
      state = state.copyWith(isLoading: false); // Reset loading state
      authStateListenable.value = state;
    }
  }
  
  Future<void> logout() async 
  {
    // Stop the refresh timer
    tokenRefreshTimer?.cancel();

    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'refresh_token');

    state = AuthState(isLoggedIn: false);

    authStateListenable.value = state; // Notify listeners
  }

  void createAccount(String userId) 
  {
    //state = state.copyWith(isLoggedIn: true, userId: userId);
  }

  AuthState authState()
  {
    return state;
  }

  @override
  void dispose() 
  {
    WidgetsBinding.instance.removeObserver(this); // Observer removed
    authStateListenable.dispose();  // Dispose of the ValueNotifier
    tokenRefreshTimer?.cancel();
    super.dispose();
  }
}

// Create a Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>
(
  (ref) => AuthNotifier()
);
