// Add to main.dart
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminBannerProvider = StateProvider<bool>
(
  (ref) 
  {
    // Get auth state
    final authState = ref.watch(authNotifierProvider);
    // Automatically show banner for admins on login (or set default to false)
    return authState.isLoggedIn && authState.userType == 'admin';
  }
);