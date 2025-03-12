import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlogCreationPage extends StatefulWidget {
  @override
  _BlogCreationPageState createState() => _BlogCreationPageState();
}

class _BlogCreationPageState extends State<BlogCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _visibility = 'Public';

  Future<void> createBlog() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('YOUR_FASTAPI_URL/blogs'), // Replace with your FastAPI endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': _titleController.text,
          'content': _contentController.text,
          'visibility': _visibility,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Go back to the blog list
      } else {
        // Handle error
        print('Failed to create blog: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _visibility,
                decoration: InputDecoration(labelText: 'Visibility'),
                items: <String>['Public', 'Doctors Only']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _visibility = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createBlog,
                child: Text('Publish Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
