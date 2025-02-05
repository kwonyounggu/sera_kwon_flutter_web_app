import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
class AuthState 
{
  final bool isLoggedIn;
  final String? userId;

  AuthState({this.isLoggedIn = false, this.userId});

  AuthState copyWith({bool? isLoggedIn, String? userId}) 
  {
    logger.i('isLoggedIn = $isLoggedIn, this.isLoggedIn = ${this.isLoggedIn}');
    logger.i('userId = $userId, this.userId = ${this.userId}');
    return AuthState
    (
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userId: userId ?? this.userId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> 
{
  AuthNotifier() : super(AuthState());

  void login(String userId) 
  {
    state = state.copyWith(isLoggedIn: true, userId: userId);
  }

  void logout() 
  {
    state = state.copyWith(isLoggedIn: false, userId: null);
  }

  void createAccount(String userId) 
  {
    state = state.copyWith(isLoggedIn: true, userId: userId);
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