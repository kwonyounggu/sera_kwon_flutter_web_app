import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
import 'package:drkwon/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget 
{
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> 
{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isChecked = false;
  bool _isLoading = false;  // Track loading state

  @override
  void initState() 
  {
    super.initState();
    _checkForLoginToken();  // Call the function to check for the JWT and whereFrom
  }

  void _checkForLoginToken() async 
  {
    setState
    (
      () 
      {
        _isLoading = true;  // Start loading
      }
    );
    // Get the current URL
    final Uri currentUri = Uri.base;
    // Extract the fragment (part after #)
    String fragment = currentUri.fragment;

    // Check if the fragment contains query parameters
    if (fragment.contains('?') && fragment.contains('jwt') && fragment.contains('refresh') && fragment.contains('whereFrom')) 
    {
        //String fragmentPath = fragment.split('?')[0]; //which is /login
        String fragmentQuery = fragment.split('?')[1];

        // Parse the query parameters from the fragment
        Map<String, String> fragmentParams = Uri.splitQueryString(fragmentQuery);

        // Check if the fragment contains the whereFrom parameter
        String jwtToken = fragmentParams['jwt']!;
        String refreshToken = fragmentParams['refresh']!;
        if (jwtToken.isNotEmpty)
        {
            Future.microtask(() {ref.read(authNotifierProvider.notifier).login(jwtToken, refreshToken);});              
        }
        else 
        {
          print("Error: JWT missing from URL");
        }

    }
    setState
    (
      () 
      {
        _isLoading = false;  // Start loading
      }
    );
  }
  //ignore the following function now
  Future<void> _login() async 
  {
    if (_formKey.currentState!.validate()) 
    {
      // Add login logic here
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      final response = await http.post
      (
        Uri.parse('http://your-ec2-ip:8000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode
        (
          {
          'username': _emailController.text,
          'password': _passwordController.text,
          }
        ),
      );

      if (response.statusCode == 200) 
      {
        final token = json.decode(response.body)['access_token'];
        // Save the token to localStorage or secure storage
        print('Logged in with token: $token');
        ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(content: Text('Login successful!')),
        );
      } 
      else 
      {
        ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    }
  }

  
  Future<void> loginWithGoogle(BuildContext context, WidgetRef ref) async 
  {
    try
    {   
        final Uri currentUri = Uri.base;
        print("currentUri = $currentUri");
        String? whereFrom;
        // Extract the fragment (part after #)
        String fragment = currentUri.fragment;

        // Check if the fragment contains query parameters
        if (fragment.contains('?')) 
        {
          // Split the fragment into path and query parameters
          //String fragmentPath = fragment.split('?')[0];//which is /login
          String fragmentQuery = fragment.split('?')[1];//which is query params

          // Parse the query parameters from the fragment
          Map<String, String> fragmentParams = Uri.splitQueryString(fragmentQuery);

          // Check if the fragment contains the whereFrom parameter
          if (fragmentParams.containsKey('whereFrom')) 
          {
            whereFrom = fragmentParams['whereFrom']!;
          }
        }

        // Get the current route
        String googleLoginUrl = '$FASTAPI_URL/login/google';
        if (whereFrom != null && whereFrom.isNotEmpty) 
        {
          googleLoginUrl += '?whereFrom=$whereFrom'; // Correctly append the query parameter
        }
        print("==> ($whereFrom)googleLoginUrl value in loginWidthGoogle: $googleLoginUrl");

        final Uri url = Uri.parse(googleLoginUrl);
        if (await canLaunchUrl(url)) 
        {
          await launchUrl(url, webOnlyWindowName: '_self',);
        } 
        else 
        {
          //Remember to handle potential errors and provide appropriate feedback to the user if the URL cannot be launched
          throw 'Could not launch $url';
        }
    }
    catch (e)
    {
      print('Error connecting to FastAPI: $e');
    }
  }

  @override
  Widget build(BuildContext context) 
  {
        return Scaffold
        (
          appBar: AppBar
          (
            title: Text('Login'),
          ),
          body: Center
          ( child: _isLoading ? CircularProgressIndicator()  // Show loading indicator
                  : Padding
                    (
                      padding: const EdgeInsets.all(16.0),
                      child: Form
                      (
                        key: _formKey,
                        child: Column
                        (
                          children: 
                          [
                            // Company Logo
                            Text
                            (
                              'Eye Doctor S KWON',
                              style: TextStyle
                              (
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),

                            TextFormField
                            (
                              controller: _emailController,
                              decoration: InputDecoration
                              (
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) 
                              {
                                if (value == null || value.isEmpty) 
                                {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) 
                                {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField
                            (
                              controller: _passwordController,
                              decoration: InputDecoration
                              (
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton
                                (
                                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () 
                                  {
                                    setState
                                    (
                                      () 
                                      {
                                        _obscurePassword = !_obscurePassword;
                                      }
                                    );
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) 
                              {
                                if (value == null || value.isEmpty) 
                                {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) 
                                {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            // Consent Radio Button
                              Row
                              (
                                children: 
                                [
                                  Radio
                                  (
                                    value: _isChecked,
                                    groupValue: true,
                                    onChanged: (bool? value) 
                                    {
                                      setState
                                      (
                                        () 
                                        {
                                          _isChecked = value ?? false;
                                        }
                                      );
                                    },
                                  ),
                                  Flexible
                                  (
                                    child: Text
                                    (
                                      'I confirm that I have read, consent and agree to your website\'s Terms of use and privacy',
                                      style: TextStyle(fontSize: 14),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                            ElevatedButton
                            (
                              onPressed: _login,
                              child: Text('Login'),
                            ),

                            SizedBox(height: 20),

                              // Forgot Password and Sign Up
                              Row
                              (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: 
                                [
                                  TextButton
                                  (
                                    onPressed: () {
                                      // Add forgot password logic here
                                    },
                                    child: Text('Forgot Password?'),
                                  ),
                                  TextButton
                                  (
                                    onPressed: () 
                                    {
                                      // Add sign up logic here
                                    },
                                    child: Text('Sign Up'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            // Continue with Google
                              Row
                              (
                                children: 
                                [
                                  Expanded
                                  (
                                    child: Divider
                                    (
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Padding
                                  (
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('OR'),
                                  ),
                                  Expanded
                                  (
                                    child: Divider
                                    (
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              SizedBox
                              (
                                width: double.infinity,
                                child: ElevatedButton.icon
                                (
                                  icon: Image.asset
                                  (
                                    'assets/images/google_logo.png', // Add your Google logo asset here
                                    height: 24,
                                  ),
                                  label: Text('Continue with Google'),
                                  style: ElevatedButton.styleFrom
                                  (
                                    foregroundColor: Colors.black, 
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () 
                                  {
                                    // Add Google login logic here
                                    loginWithGoogle(context, ref);
                                  },
                                ),
                              ),

                          ],
                        ),
                      ),
                    ),
          ),
        );
  } //build
}