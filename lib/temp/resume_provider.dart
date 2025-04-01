import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Resume 
{
  final String name;
  final String address;
  final String phone;
  final String email;
  final List<Education> education;
  final List<Experience> experience;
  final List<String> skills;

  Resume
  (
    {
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      required this.education,
      required this.experience,
      required this.skills,
    }
  );

  factory Resume.fromJson(Map<String, dynamic> json) 
  {
    return Resume
    (
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      education: (json['education'] as List)
          .map((e) => Education.fromJson(e))
          .toList(),
      experience: (json['experience'] as List)
          .map((e) => Experience.fromJson(e))
          .toList(),
      skills: List<String>.from(json['skills']),
    );
  }
}

class Education 
{
  final String degree;
  final String institution;
  final String graduation;

  Education({required this.degree, required this.institution, required this.graduation});

  factory Education.fromJson(Map<String, dynamic> json) 
  {
    return Education
    (
      degree: json['degree'],
      institution: json['institution'],
      graduation: json['graduation'],
    );
  }
}

class Experience 
{
  final String title;
  final String employer;
  final String duration;
  final List<String> responsibilities;

  Experience
  (
    {
      required this.title,
      required this.employer,
      required this.duration,
      required this.responsibilities,
    }
  );

  factory Experience.fromJson(Map<String, dynamic> json) 
  {
    return Experience
    (
      title: json['title'],
      employer: json['employer'],
      duration: json['duration'],
      responsibilities: List<String>.from(json['responsibilities']),
    );
  }
}
class ResumeNotifier extends StateNotifier<Resume?> 
{
  ResumeNotifier() : super(null) 
  {
    loadResume();
  }

  Future<void> loadResume() async 
  {
    final String jsonString = await rootBundle.loadString('assets/data_files/resume.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    state = Resume.fromJson(jsonData);
  }
}

// Resume data provider using Riverpod
final resumeProvider = StateNotifierProvider<ResumeNotifier, Resume?>
(
  (ref) => ResumeNotifier(),
);
