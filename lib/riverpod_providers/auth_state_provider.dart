import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState 
{
  final bool isLoggedIn;
  final String? jwt;
  final String? userId;
  final DateTime? expiryDate;

  AuthState
  (
    {
      required this.isLoggedIn,
      this.jwt,
      this.userId,
      this.expiryDate,
    }
  );
}
class AuthNotifier extends StateNotifier<AuthState> 
{
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthNotifier() : super(AuthState(isLoggedIn: false)) 
  {
    _loadToken();
  }

  Future<void> _loadToken() async 
  {
    final jwt = await _storage.read(key: 'jwt');
    if (jwt != null) 
    {
      final decodedToken = JwtDecoder.decode(jwt);
      final userId = decodedToken['sub'];
      final expiryDate = JwtDecoder.getExpirationDate(jwt);

      // Check if the token is expired
      final isExpired = JwtDecoder.isExpired(jwt);

      if (isExpired) 
      {
        // Token is expired, log the user out
        await _storage.delete(key: 'jwt'); // Clear the expired token
        state = AuthState(isLoggedIn: false);
      } 
      else 
      {
        // Token is valid, update the state
        state = AuthState
        (
          isLoggedIn: true,
          jwt: jwt,
          userId: userId,
          expiryDate: expiryDate,
        );
      }
    }
  }
  //avoid async to make it synchronized
  void login(String jwt)
  {
    final decodedToken = JwtDecoder.decode(jwt);
    print("Decoded Token: $decodedToken");

    // Access specific claims
    final userId = decodedToken['sub']; // 'sub' is a common claim for user ID
    print("User ID: $userId");

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
      jwt: jwt,
      userId: userId,
      expiryDate: expiryDate,
    );

    // Store token in secure storage
    _storage.write(key: 'jwt', value: jwt);
  }

  Future<void> logout() async 
  {
    await _storage.delete(key: 'jwt');
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
  (ref) 
  {
    return AuthNotifier();
  }
);