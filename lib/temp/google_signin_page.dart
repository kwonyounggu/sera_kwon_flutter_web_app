import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/src/types.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'dart:js' as js;

class GoogleSignInPage extends StatefulWidget 
{
  const GoogleSignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> 
{
  final _storage = FlutterSecureStorage();
  bool _isLoading = false;
  String _errorMessage = '';
  late GoogleSignInPlugin _googleSignIn;

  @override
  void initState() 
  {
    super.initState();
    _initGoogleSignIn();
    js.context['googleSignInSuccess'] = (idToken) 
    {
      _handleSignIn(idToken);
    };
  }

  Future<void> _initGoogleSignIn() async {
    try 
    {
      _googleSignIn = GoogleSignInPlugin();
      await _googleSignIn.initWithParams(SignInInitParameters());
      _signInSilently();
    } 
    catch (e) 
    {
      setState
      (
        () 
        {
          _errorMessage = 'Error initializing Google Sign-In: $e';
        }
      );
      print('Google Sign-In initialization error: $e');
    }
  }

  Future<void> _signInSilently() async 
  {
    try 
    {
      final account = await _googleSignIn.signInSilently();
      if (account != null) 
      {
        _handleSignInSuccess(account);
      }
    } 
    catch (e) 
    {
      print('Silent sign-in failed: $e');
    }
  }

  Future<void> _handleSignIn(String idToken) async 
  {
    setState(() 
    {
      _isLoading = true;
      _errorMessage = '';
    });

    if (idToken.isNotEmpty) 
    {
      try 
      {
        final headers = {'Authorization': 'Bearer $idToken'};
        final response = await http.post
        (
          Uri.parse('http://localhost:8000/login/google'),
          headers: headers,
        );

        if (response.statusCode == 200) 
        {
          final data = json.decode(response.body);
          await _storage.write(key: 'jwt', value: data['access_token']);
          //context.go('/dashboard');
          print("==> route here");
        } 
        else 
        {
          final errorData = json.decode(response.body);
          setState
          (
            () 
            {
              _errorMessage = errorData['detail'] ?? 'Google login failed.';
            }
          );
        }
      } 
      catch (e) 
      {
        setState
        (
          () 
          {
            _errorMessage = 'Error during Google login: $e';
          }
        );
      }
    } 
    else 
    {
      setState
      (
        () 
        {
          _errorMessage = 'Google sign-in ID token not available.';
        }
      );
    }
    setState
    (
      () 
      {
        _isLoading = false;
      }
    );
  }

  Future<void> _handleSignInSuccess(GoogleSignInUserData account) async 
  {
    _handleSignIn(account.idToken ?? "");
    /*
    setState
    (
      () 
      {
        _isLoading = true;
        _errorMessage = '';
      }
    );
    final idToken = account.idToken;
    if (idToken != null) 
    {
      try 
      {
        final headers = {'Authorization': 'Bearer $idToken'};
        final response = await http.post
        (
          Uri.parse('http://localhost:8000/login/google'),
          headers: headers,
        );

        if (response.statusCode == 200) 
        {
          final data = json.decode(response.body);
          await _storage.write(key: 'jwt', value: data['access_token']);
          context.go('/dashboard');
        } 
        else 
        {
          final errorData = json.decode(response.body);
          setState
          (
            () 
            {
              _errorMessage = errorData['detail'] ?? 'Google login failed.';
            }
          );
        }
      } 
      catch (e) 
      {
        setState
        (
          () 
          {
            _errorMessage = 'Error during Google login: $e';
          }
        );
      }
    } 
    else 
    {
      setState
      (
        () 
        {
          _errorMessage = 'Google sign-in ID token not available.';
        }
      );
    }
    setState
    (
      () 
      {
        _isLoading = false;
      }
    );
    */
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar(title: Text('Google Sign-In')),
      body: Center
      (
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : Column
             (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>
                [
                  if (_errorMessage.isNotEmpty)
                    Padding
                    (
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text
                      (
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  _googleSignIn.renderButton(),
                ],
              ),
      ),
    );
  }
}