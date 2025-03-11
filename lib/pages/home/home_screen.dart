
import 'dart:convert';

import 'package:drkwon/data/home_page.dart';
import 'package:drkwon/utils/mla_paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class HomeScreen extends ConsumerStatefulWidget 
{
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> 
{
  @override
  Widget build(BuildContext context) 
  {
    final jsonData = jsonDecode(homePageJson);
    return Scaffold
    (
      /*appBar: AppBar
      (
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('Eye Care Clinic'),
        actions: 
        [
          //IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),*/
      body: SingleChildScrollView
      (
        child: Column
        (
          children: 
          [
            // Hero Section
            _buildHeroSection(),
            // About the Optometrist Section
            _buildAboutSection(jsonData['about_dr_kwon']),
            // Clinic Overview Section
            //_buildClinicOverviewSection(jsonData['about_our_clinic']),
            SizedBox(height: 20),
            // Services Overview
            _buildServicesSection(),
            // Blog Highlights
            _buildBlogSection(),
            // Testimonials
            _buildTestimonialsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton
      (
        onPressed: () 
        {
          // Navigate to appointment booking
          context.go('/book-an-appointment');
        },
        child: Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildHeroSection() 
  {
    return Container
    (
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration
      (
        color: Colors.blue[50],
        borderRadius: BorderRadius.only
        (
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column
      (
        children: 
        [
          Text
          (
            'Your Vision, My Care',
            style: TextStyle
            (
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text
          (
            'Comprehensive eye care services for cataracts, dry eyes, contact lens fitting and more.',
            style: TextStyle
            (
              fontSize: 18,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton
          (
            // ignore: dead_code
            onPressed: true? null : () 
            {
              context.go('/book-an-appointment');
            },
            
            style: ElevatedButton.styleFrom
            (
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
            child: Text('Book an Appointment'),
          ),
        ],
      ),
    );
  }

    Widget _buildAboutSection(List paragraphs) 
    {
      //for (var item in paragraphs)
      //{
      //    debugPrint(item);
      //}

      return Container
      (
        padding: EdgeInsets.all(20),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: 
          [
            Text
            (
              'About Optometrist Dr. S Kwon',
              style: TextStyle
              (
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 20),
            MLAParagraph(text: paragraphs[0]),
            SizedBox(height: 10),
            MLAParagraph(text: paragraphs[1]),
            SizedBox(height: 10),
            MLAParagraph(text: paragraphs[2]),
          ],
        ),
      );
  }

  // ignore: unused_element
  Widget _buildClinicOverviewSection(List paragraphs) 
  {
    return Container
    (
      padding: EdgeInsets.all(20),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: 
        [
          Text
          (
            'About Our Clinic',
            style: TextStyle
            (
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          MLAParagraph(text: paragraphs[0]),
          SizedBox(height: 10),
          MLAParagraph(text: paragraphs[1]),
          SizedBox(height: 10),
          MLAParagraph(text: paragraphs[2]),
        ],
      ),
    );
  }

  Widget _buildServicesSection() 
  {
    return Container
    (
      padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
      color: Colors.grey[100],
      child: Column
      (
        children: 
        [
          Text
          (
            'Major Services',
            style: TextStyle
            (
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          Wrap
          (
            spacing: 20,
            runSpacing: 20,
            children: 
            [
              _buildServiceCard('Cataract', Icons.visibility_off),
              //_buildServiceCard('Cornea', Icons.remove_red_eye),
              _buildServiceCard('Dry Eye', Icons.water_drop),
              _buildServiceCard('Contact lens', Icons.healing),
              _buildServiceCard('Eye Exam', Icons.visibility),
              //_buildServiceCard('Uveitis', Icons.healing),
              //_buildServiceCard('Cosmetics', Icons.spa),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon) 
  {
    return Card
    (
      elevation: 5,
      child: Container
      (
        width: 150,
        padding: EdgeInsets.all(20),
        child: Column
        (
          children: 
          [
            Icon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text
            (
              title,
              style: TextStyle
              (
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogSection() 
  {
    return Container
    (
      padding: EdgeInsets.all(20),
      child: Column
      (
        children: 
        [
          Text
          (
            'Latest Blog Posts',
            style: TextStyle
            (
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          _buildBlogPost('Understanding Cataracts', 'Learn about the causes and treatments for cataracts.'),
          _buildBlogPost('Managing Dry Eyes', 'Tips and treatments for managing dry eye syndrome.'),
        ],
      ),
    );
  }

  Widget _buildBlogPost(String title, String description) 
  {
    return Card
    (
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Icon(Icons.article, size: 40, color: Colors.blue),
        title: Text
        (
          title,
          style: TextStyle
          (
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        onTap: () 
        {
          // Navigate to blog post
        },
      ),
    );
  }

  Widget _buildTestimonialsSection() 
  {
    return Container
    (
      padding: EdgeInsets.all(20),
      color: Colors.blue[50],
      child: Column
      (
        children: 
        [
          Text
          (
            'What Our Patients Say',
            style: TextStyle
            (
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          _buildTestimonial('John Doe', 'Dr. Kwon is amazing! She explained everything clearly and made me feel comfortable.'),
          _buildTestimonial('Jane Smith', 'The clinic is very professional, and the staff is friendly. Highly recommend!'),
        ],
      ),
    );
  }

  Widget _buildTestimonial(String name, String review) 
  {
    return Card
    (
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile
      (
        contentPadding: EdgeInsets.all(20),
        leading: Icon(Icons.person, size: 40, color: Colors.blue),
        title: Text
        (
          name,
          style: TextStyle
          (
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(review),
      ),
    );
  }
}