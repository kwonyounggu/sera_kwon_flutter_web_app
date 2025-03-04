import 'package:drkwon/utils/gmail_api_key.dart';
import 'package:drkwon/utils/google_email.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // For date formatting
import 'package:http/http.dart' as http;

class AppointmentScreen extends StatefulWidget 
{
  const AppointmentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> 
{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ohipController = TextEditingController();
  final TextEditingController _concernController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedService;
  bool _isUrgent = false;
  bool _isRobot = false;

  // List of services
  final List<String> _services = 
  [
    'Cataract',
    'Cornea',
    'Dry Eyes',
    'Glaucoma',
    'Oculoplastics',
    'Retina',
    'Uveitis',
    'Cosmetics',
    'LASIK',
    'Etc'
  ];

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async 
  {
    final DateTime? picked = await showDatePicker
    (
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) 
    {
      setState
      (
        () 
        {
          _selectedDate = picked;
          _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      );
    }
  }

  // Function to send email
  Future<void> _sendEmail() async 
  {
    if (_formKey.currentState!.validate() && _isRobot) 
    {
      // Collect all form data
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String dob = _dobController.text;
      final String email = _emailController.text;
      final String phone = _phoneController.text;
      final String ohip = _ohipController.text;
      final String service = _selectedService ?? 'Not Selected';
      final String concern = _concernController.text;
      final String urgency = _isUrgent ? 'Urgent' : 'Not Urgent';

      // Create the email body
      final String emailBody = '''
        First Name: $firstName
        Last Name: $lastName
        Date of Birth: $dob
        Email: $email
        Phone Number: $phone
        OHIP Number: $ohip
        Selected Service: $service
        Eye Health Concern: $concern
        Urgency: $urgency
      ''';

      // Encode the email subject and body
      final String subject = 'New Appointment Booking';
      final String body = emailBody;

      final emailService = GoogleEmail
      (
        serviceAccountJson: serviceAccountJson,
        //senderEmail: "kwon.younggu@gmail.com"
        senderEmail: "gmail-api-sender@personal-eye-care-site.iam.gserviceaccount.com"
      );

      try
      {
        await emailService.sendEmail(to: "webmonster.ca@gmail.com", subject: subject, body: body);
        print("mail sent ...");
      }
      catch (e)
      {
        print("Error: $e");
      }
    } 
    else if (!_isRobot) 
    {
      ScaffoldMessenger.of(context).showSnackBar
      (
        SnackBar(content: Text('Please verify that you are not a robot.')),
      );
    }
  }

  /*
  Future<void> _sendEmailToEmailJS() async 
  {
    if (_formKey.currentState!.validate() && _isRobot) 
    {
      // Collect all form data
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String dob = _dobController.text;
      final String email = _emailController.text;
      final String phone = _phoneController.text;
      final String ohip = _ohipController.text;
      final String service = _selectedService ?? 'Not Selected';
      final String concern = _concernController.text;
      final String urgency = _isUrgent ? 'Urgent' : 'Not Urgent';

      final response = await http.post
      (
        Uri.parse('https://formspree.io/f/mdkajbdd'), // Replace with your Formspree URL
        body: 
        {
          'First Name': firstName,
        'Last Name': lastName,
        'Date of Birth': dob,
        'Email': email,
        'Phone Number': phone,
        'OHIP Number': ohip,
        'Selected Service': service,
        'Eye Health Concern': concern,
        'Urgency': urgency
        },
      );

      if (mounted) // Check if the widget is still mounted after await returns
      { 
        if (response.statusCode == 200) 
        {
          ScaffoldMessenger.of(context).showSnackBar //context will be null if not mounted
          (
            SnackBar(content: Text('Form submitted successfully!')), 
          );
          //Form Reset
          _firstNameController.clear();
          _lastNameController.clear();
          _dobController.clear();
          _ohipController.clear();
          _concernController.clear();
          _emailController.clear();
          _phoneController.clear();
        } 
        else 
        {
          ScaffoldMessenger.of(context).showSnackBar
          (
            SnackBar(content: Text('Error submitting form.')),
          );
        }
      }
      else 
      {
        // Handle the case where the widget is no longer mounted
        print('Widget was unmounted before SnackBar could be shown.');
      }
    } 
    else if (!_isRobot) 
    {
      ScaffoldMessenger.of(context).showSnackBar
      (
        SnackBar(content: Text('Please verify that you are not a robot.')),
      );
    }
  }*/
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      //appBar: AppBar
      //(
      //  title: Text('Book an Appointment'),
      //),
      body: Padding
      (
        padding: EdgeInsets.all(20),
        child: Form
        (
          key: _formKey,
          child: ListView
          (
            children: 
            [
              // First Name
              TextFormField
              (
                controller: _firstNameController,
                decoration: InputDecoration
                (
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Last Name
              TextFormField
              (
                controller: _lastNameController,
                decoration: InputDecoration
                (
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Date of Birth (DOB)
              TextFormField
              (
                controller: _dobController,
                decoration: InputDecoration
                (
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton
                  (
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Email
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
                  // Validate email format
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) 
                  {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Phone Number
              TextFormField
              (
                controller: _phoneController,
                decoration: InputDecoration
                (
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please enter your phone number';
                  }
                  // Validate phone number format (10 digits)
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Services Dropdown
              DropdownButtonFormField<String>
              (
                value: _selectedService,
                decoration: InputDecoration
                (
                  labelText: 'Select Service',
                  border: OutlineInputBorder(),
                ),
                items: _services.map((String service) 
                {
                  return DropdownMenuItem<String>
                  (
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (String? value) 
                {
                  setState
                  (
                    () 
                    {
                    _selectedService = value;
                    }
                  );
                },
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // OHIP Number
              TextFormField
              (
                controller: _ohipController,
                decoration: InputDecoration
                (
                  labelText: 'OHIP Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please enter your OHIP number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Eye Health Concern (Text Area)
              TextFormField
              (
                controller: _concernController,
                decoration: InputDecoration
                (
                  labelText: 'What is your current eye health concern?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please provide details about your eye health concern';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Urgent or Not Checkbox
              Row
              (
                children: 
                [
                  Checkbox
                  (
                    value: _isUrgent,
                    onChanged: (bool? value) 
                    {
                      setState
                      (
                        () 
                        {
                          _isUrgent = value ?? false;
                        }
                      );
                    },
                  ),
                  Text('Is this appointment urgent?'),
                ],
              ),
              SizedBox(height: 20),
              // reCAPTCHA Verification
              Row
              (
                children: 
                [
                  Checkbox
                  (
                    value: _isRobot,
                    onChanged: (bool? value) 
                    {
                      setState
                      (
                        () 
                        {
                        _isRobot = value ?? false;
                        }
                      );
                    },
                  ),
                  Text('I am not a robot'),
                ],
              ),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton
              (
                onPressed: _sendEmail,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}