import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final resumeProvider = Provider.of<ResumeProvider>(context);
    //final resumeProvider = null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("")//ResumeEditor(resumeProvider: resumeProvider),
      ),
    );
  }
}