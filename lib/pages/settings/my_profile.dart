import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = FlutterSecureStorage();
  String _selectedRole = 'general';
  bool get _isDoctor => _selectedRole == 'od' || _selectedRole == 'md';
  
  // Form fields
  String? _clinicName;
  String? _address;
  String? _phone;
  String? _profilePicture;
  String? _selfDescription;
  bool _isLoading = false;
  String? _errorMessage;

  final InputDecoration _fieldDecoration = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  );

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) throw Exception('Authentication token not found.');

      final response = await http.post(
        Uri.parse('YOUR_BACKEND_API_URL/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'role': _selectedRole,
          if (_isDoctor) ...{
            'clinic_name': _clinicName,
            'address': _address,
            'phone': _phone,
            'self_description': _selfDescription,
          },
          'profile_picture': _profilePicture,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = jsonDecode(response.body)['detail'] ?? 'Update failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildRoleSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 20,
              children: [
                _RoleRadio(
                  value: 'general',
                  groupValue: _selectedRole,
                  label: 'General User',
                  onChanged: (v) => setState(() => _selectedRole = v!),
                ),
                _RoleRadio(
                  value: 'od',
                  groupValue: _selectedRole,
                  label: 'Optometrist (OD)',
                  onChanged: (v) => setState(() => _selectedRole = v!),
                ),
                _RoleRadio(
                  value: 'md',
                  groupValue: _selectedRole,
                  label: 'Medical Doctor (MD)',
                  onChanged: (v) => setState(() => _selectedRole = v!),
                ),
                _RoleRadio(
                  value: 'admin',
                  groupValue: _selectedRole,
                  label: 'Administrator',
                  onChanged: (v) => setState(() => _selectedRole = v!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Profile Setup'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Go back to the previous screen
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildRoleSelector(),
              SizedBox(height: 20),
              
              // Profile Picture
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile Picture', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      TextFormField(
                        decoration: _fieldDecoration.copyWith(
                          labelText: 'Image URL',
                          prefixIcon: Icon(Icons.link),
                        ),
                        onChanged: (v) => _profilePicture = v,
                        validator: (v) => v!.isEmpty ? 'Please enter a valid URL' : null,
                      ),
                      if (_profilePicture != null && _profilePicture!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(_profilePicture!),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              if (_isDoctor) ...[
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Professional Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: _fieldDecoration.copyWith(
                            labelText: 'Clinic/Hospital Name',
                            prefixIcon: Icon(Icons.business),
                          ),
                          onChanged: (v) => _clinicName = v,
                          validator: (v) => v!.isEmpty ? 'Required field' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: _fieldDecoration.copyWith(
                            labelText: 'Clinic Address',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          onChanged: (v) => _address = v,
                          validator: (v) => v!.isEmpty ? 'Required field' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: _fieldDecoration.copyWith(
                            labelText: 'Contact Phone',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (v) => _phone = v,
                          validator: (v) => v!.isEmpty ? 'Required field' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: _fieldDecoration.copyWith(
                            labelText: 'Professional Bio',
                            prefixIcon: Icon(Icons.description),
                          ),
                          maxLines: 3,
                          onChanged: (v) => _selfDescription = v,
                          validator: (v) => v!.isEmpty ? 'Please provide a brief description' : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _updateProfile,
                  child: _isLoading
                      ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator())
                      : Text('SAVE PROFILE', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleRadio extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final ValueChanged<String?> onChanged;

  const _RoleRadio({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}