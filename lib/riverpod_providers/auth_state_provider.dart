import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState 
{
  final bool isLoggedIn;
  //final String? jwt;
  final int? userId;
  final String? userEmail;
  //final DateTime? expiryDate;
  //final bool isLoading; // New: Loading state

  AuthState
  (
    {
      required this.isLoggedIn,
      //this.jwt,
      this.userId,
      this.userEmail,
      //this.expiryDate,
      //this.isLoading = false, // Default to false
    }
  );

  AuthState copyWith
  (
    {
      bool? isLoggedIn,
      //String? jwt,
      int? userId,
      String? userEmail,
      //DateTime? expiryDate,
      //bool? isLoading,
    }
  ) 
  {
    return AuthState
    (
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      //jwt: jwt ?? this.jwt,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      //expiryDate: expiryDate ?? this.expiryDate,
      //isLoading: isLoading ?? this.isLoading,
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
      //eventhough it is expired it will be refreshed
      //so new token will be stored in as jwt and isLoggedIn = true through TokenService
      await _storage.delete(key: 'jwt');
      state = AuthState(isLoggedIn: false);
    }
  }

  /// Note that all the information other than userId, userEmail, etc is in jwt of FlutterSecureStorage
  void _updateStateFromToken(String jwt) 
  {
    final decodedToken = JwtDecoder.decode(jwt);

    state = AuthState
    (
      isLoggedIn: true,
      //jwt: jwt,
      userId: decodedToken['user_id'],
      userEmail: decodedToken['email'],
      //expiryDate: JwtDecoder.getExpirationDate(jwt),
    );
  }

  void updateToken(String jwt) 
  {
    print("INFO: updateToken(...) is called");
    _updateStateFromToken(jwt);
  }

  //refresh token lasts for 7 days
  //unless the user does not logout (refresh token = null then) and
  //use the web page within 7 days then login will last forever
  void login(String jwt, String refreshToken)
  {
    _updateStateFromToken(jwt);
 
    print("access token expire date: ${JwtDecoder.getExpirationDate(jwt)}");
    print("refresh token expire date: ${JwtDecoder.getExpirationDate(refreshToken)}");
    print("refresh token just got from server: $refreshToken");
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
