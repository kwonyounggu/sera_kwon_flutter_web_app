import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState 
{
  final bool isLoggedIn;
  final String? jwt;
  final int? userId;
  final String? userEmail;
  final DateTime? expiryDate;
  final bool isLoading; // New: Loading state

  AuthState
  (
    {
      required this.isLoggedIn,
      this.jwt,
      this.userId,
      this.userEmail,
      this.expiryDate,
      this.isLoading = false, // Default to false
    }
  );

  AuthState copyWith
  (
    {
      bool? isLoggedIn,
      String? jwt,
      int? userId,
      String? userEmail,
      DateTime? expiryDate,
      bool? isLoading,
    }
  ) 
  {
    return AuthState
    (
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      jwt: jwt ?? this.jwt,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      expiryDate: expiryDate ?? this.expiryDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> 
{
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthNotifier() : super(AuthState(isLoggedIn: false)) 
  {
    print("AuthNotifier, _loadToken is called");
    _loadToken();
  }

  Future<void> _loadToken() async 
  {
    final jwt = await _storage.read(key: 'jwt');

    if (jwt != null && !JwtDecoder.isExpired(jwt)) 
    {
      _updateStateFromToken(jwt);
    } 
    else 
    {
      await _storage.delete(key: 'jwt'); // Clear invalid token
      state = AuthState(isLoggedIn: false);
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

  void login(String jwt, String refreshToken)
  {
    final decodedToken = JwtDecoder.decode(jwt);
    final userId = decodedToken['user_id']; 
    final userEmail = decodedToken['email']; 
    final expiryDate = JwtDecoder.getExpirationDate(jwt);

    // Update state
    state = AuthState
    (
      isLoggedIn: true,
      jwt: jwt, 
      userId: userId,
      userEmail: userEmail,
      expiryDate: expiryDate,
    );

    // Store token in secure storage
    _storage.write(key: 'jwt', value: jwt);
    _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> logout() async 
  {
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'refresh_token');

    state = AuthState(isLoggedIn: false);
  }

  void createAccount(String userId) 
  {
    //state = state.copyWith(isLoggedIn: true, userId: userId);
  }
}

// Create a Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>
(
  (ref) => AuthNotifier()
);
