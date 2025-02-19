import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProfileScreen extends StatefulWidget 
{
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> 
{
  Map<String, dynamic>? profile;

  @override
  void initState() 
  {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async 
  {
    String jsonString = await rootBundle.loadString('data_files/profile.json');
    setState
    (
      () 
      {
        profile = json.decode(jsonString);
      }
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    if (profile == null) 
    {
      return Scaffold
      (
        appBar: AppBar(title: Text("Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(profile!['name'])),
      body: Padding
      (
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView
        (
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              buildSectionTitle("Contact"),
              buildText("LinkedIn: ${profile!['contact']['linkedin']}", true),
              SizedBox(height: 10),
              buildSectionTitle("Languages"),
              buildText(profile!['languages'].join(', '), false),
              SizedBox(height: 10),
              buildSectionTitle("Certifications"),
              ...profile!['certifications'].map<Widget>((cert) => buildText("- $cert", false)).toList(),
              SizedBox(height: 10),
              buildSectionTitle("Honors & Awards"),
              ...profile!['honors_awards'].map<Widget>((award) => buildText("- $award", false)).toList(),
              SizedBox(height: 10),
              buildSectionTitle("Experience"),
              ...profile!['experience'].map<Widget>((exp) => buildExperience(exp)).toList(),
              SizedBox(height: 10),
              buildSectionTitle("Education"),
              ...profile!['education'].map<Widget>((edu) => buildEducation(edu)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) 
  {
    return AutoSizeText
    (
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      maxLines: 1,
    );
  }

  Widget buildText(String text, bool isLink) 
  {
    return AutoSizeText
    (
      text,
      style: TextStyle(fontSize: 16, color: isLink ? Colors.blue : Colors.black),
      maxLines: 2,
    );
  }

  Widget buildExperience(Map<String, dynamic> exp) 
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          buildText("${exp['position']} at ${exp['organization']}", true),
          buildText("${exp['duration']}", false),
          ...exp['responsibilities'].map<Widget>((resp) => buildText("- $resp", false)).toList(),
        ],
      ),
    );
  }

  Widget buildEducation(Map<String, dynamic> edu) 
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          buildText("${edu['degree']}", true),
          buildText("${edu['institution']} (${edu['years']})", false),
        ],
      ),
    );
  }
}
