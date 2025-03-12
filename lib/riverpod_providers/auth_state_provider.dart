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
      final userId = decodedToken['user_id'];
      final userEmail = decodedToken['email'];
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
          userEmail: userEmail,
          expiryDate: expiryDate,
        );
      }
    }
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
  }

  Future<void> logout() async 
  {
    if (state.isLoggedIn)
    {
      await _storage.delete(key: 'jwt');//access_token
      await _storage.delete(key: 'refresh_token');
      state = AuthState(isLoggedIn: false);
    }
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