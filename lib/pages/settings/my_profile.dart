import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // For storing tokens

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  String _selectedRole = 'General User';
  bool _isDoctor = false;
  String? _selectedProvinceState;
  String? _selectedDoctorType;
  final _storage = FlutterSecureStorage();
  final List<String> _provincesStates = [
    'Ontario', 'Quebec', 'British Columbia', 'California', 'New York', // Example list
    // Add all Provinces/States here
  ];
  final List<String> _doctorTypes = ['Eye Doctor', 'Medical Doctor'];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      final url = Uri.parse('YOUR_BACKEND_API_URL/profile'); // Replace with your backend URL
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'role': _selectedRole,
          'provinceState': _selectedProvinceState,
          'doctorType': _selectedDoctorType,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        final error = jsonDecode(response.body)['detail'];
        setState(() {
          _errorMessage = error;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                title: Text('General User'),
                value: 'General User',
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                    _isDoctor = false;
                  });
                },
              ),
              RadioListTile(
                title: Text('Doctor'),
                value: 'Doctor',
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                    _isDoctor = true;
                  });
                },
              ),
              RadioListTile(
                title: Text('Admin'),
                value: 'Admin',
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                    _isDoctor = false;
                  });
                },
              ),
              if (_isDoctor) ...[
                DropdownButtonFormField<String>(
                  value: _selectedProvinceState,
                  items: _provincesStates.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProvinceState = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Province/State'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedDoctorType,
                  items: _doctorTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDoctorType = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Doctor Type'),
                ),
              ],
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}