import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleLoginPage extends StatefulWidget 
{
  const GoogleLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> 
{
  final GoogleSignIn _googleSignIn = GoogleSignIn
  (
    clientId: '1037051096786-g3657uojp3s60vbstbef6u87k1ja11qt.apps.googleusercontent.com', // Use your Google Client ID
    scopes: ['email', 'profile', 'openid'],
  );

  Future<void> _handleGoogleSignIn() async 
  {
    try 
    {
      // Initiate Google Sign-In
      debugPrint("==> calling await _googleSignIn.signIn()");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) 
      {
        debugPrint("==> googleUser == null");
        return;
      }
      debugPrint("==> calling await googleUser.authentication");
      // Get the Google ID token
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null) 
      {
        debugPrint("==> idToken == null)");
        throw Exception('Google ID token is null');
      }

      // Send the ID token to your FastAPI backend
      final response = await http.post
      (
        Uri.parse('http://127.0.0.1:8000/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) 
      {
        final token = jsonDecode(response.body)['access_token'];
        await _saveToken(token);
        print('==> Google login successful! Token: $token');
      }
      else 
      {
        print('==> Google login failed: ${response.body}');
      }
    } 
    catch (error) 
    {
      print('==> Google login error: $error');
    }
  }

  Future<void> _saveToken(String token) async 
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: Text('Google Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleGoogleSignIn,
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}