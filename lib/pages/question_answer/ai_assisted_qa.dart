import 'package:drkwon/pages/question_answer/services/api_service.dart';
import 'package:flutter/material.dart';


class AiAssistedQaPage extends StatefulWidget {
  const AiAssistedQaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AiAssistedQaPageState createState() => _AiAssistedQaPageState();
}

class _AiAssistedQaPageState extends State<AiAssistedQaPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI-Assisted Q&A'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Ask a question',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _askQuestion,
              child: Text('Ask'),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(_answer),
          ],
        ),
      ),
    );
  }

  Future<void> _askQuestion() async {
    setState(() {
      _isLoading = true;
    });
    final answer = await _apiService.askQuestion(_questionController.text);
    setState(() {
      _answer = answer;
      _isLoading = false;
    });
  }
}
