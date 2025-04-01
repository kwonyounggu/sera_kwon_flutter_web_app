import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';

class BlogCreationPage extends ConsumerStatefulWidget 
{
  const BlogCreationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlogCreationPageState createState() => _BlogCreationPageState();
}

class _BlogCreationPageState extends ConsumerState<BlogCreationPage> 
{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();
  final FocusNode _editorFocusNode = FocusNode();
  String _visibility = 'Public';
  bool _isLoading = false;

  Future<void> createBlog() async 
  {
    if (_formKey.currentState!.validate()) 
    {
      setState(() => _isLoading = true);

      // Convert Quill content to Delta JSON
      final contentJson = jsonEncode(_quillController.document.toDelta().toJson());

      final response = await http.post
      (
        Uri.parse('YOUR_FASTAPI_URL/blogs'), // Replace with your FastAPI endpoint
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>
        {
          'title': _titleController.text,
          'content': contentJson,
          'visibility': _visibility,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) 
      {
        Navigator.pop(context);
      } 
      else 
      {
        ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(content: Text('Failed to create blog: ${response.statusCode}')),
        );
      }
    }
  }
  @override
  void dispose() {
    _quillController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Create New Blog Post'),
        centerTitle: true,
        elevation: 0,
        //backgroundColor: Colors.blueGrey[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),
              Expanded
              (
                child: Card
                (
                  elevation: 4,
                  child: Padding
                  (
                    padding: const EdgeInsets.all(8.0),
                    child: Column
                    (
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: 
                      [
                        const Text('Content', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded
                        ( // Makes the editor take remaining vertical space
                          child: Container
                          (
                            decoration: BoxDecoration
                            (
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column
                            (
                              children: 
                              [
                                QuillSimpleToolbar
                                (
                                  configurations: QuillSimpleToolbarConfigurations(controller: _quillController),
                                ),
                                Expanded
                                (
                                  child: QuillEditor.basic
                                  (
                                    configurations: QuillEditorConfigurations
                                    (
                                      controller: _quillController,
                                      padding: const EdgeInsets.all(16.0),
                                      scrollable: true,
                                      autoFocus: false,
                                      expands: true, // Makes the editor expand fully
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Segmented Buttons for Visibility
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Visibility',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
                    segments: const <ButtonSegment<String>>[
                      ButtonSegment<String>(
                        value: 'Public',
                        label: Text('Public'),
                      ),
                      ButtonSegment<String>(
                        value: 'Doctors Only',
                        label: Text('Doctors Only'),
                      ),
                    ],
                    selected: <String>{_visibility},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _visibility = newSelection.first;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : createBlog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Publish Blog', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
