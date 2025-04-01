// Consultation Form Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsultationForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const ConsultationForm({super.key, required this.formKey});

  @override
  // ignore: library_private_types_in_public_api
  _ConsultationFormState createState() => _ConsultationFormState();  // Changed to private class name
}

class _ConsultationFormState extends ConsumerState<ConsultationForm> {  // Made private with underscore
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {  // Added dispose method to clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container
    (
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Form
      (
        key: widget.formKey,
        child: SingleChildScrollView
        (
          child: Column
          (
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: 
            [
              const Text
              (
                'Book Consultation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              TextFormField
              (
                controller: _nameController,
                decoration: const InputDecoration
                (
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField
              (
                controller: _emailController,
                decoration: const InputDecoration
                (
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,  // Added for better UX
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) 
                  {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField
              (
                controller: _phoneController,
                decoration: const InputDecoration
                (
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Required';
                  }
                  if (value.length < 10) 
                  {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              InkWell
              (
                onTap: () async 
                {
                  final date = await showDatePicker
                  (
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );
                  if (date != null) 
                  {  // Added null check
                    setState(() => _selectedDate = date);
                  }
                },
                child: InputDecorator
                (
                  decoration: const InputDecoration
                  (
                    labelText: 'Preferred Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text
                  (
                    _selectedDate == null
                        ? 'Select date'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  ),  // Added proper date formatting
                ),
              ),
              const SizedBox(height: 30),
              FilledButton
              (
                style: FilledButton.styleFrom
                (
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () 
                {  // Fixed syntax error in style
                  if (widget.formKey.currentState!.validate()) 
                  {
                    // Handle form submission
                    Navigator.pop(context);
                  }
                },
                child: const Text('Schedule Consultation'),
              ),
            ],
          )
        ),
      ),
    );
  }
}

// Footer Item Component
