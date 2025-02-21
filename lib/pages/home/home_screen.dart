
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
    return Scaffold(
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
            _buildAboutSection(),
            // Clinic Overview Section
            _buildClinicOverviewSection(),
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
            'Comprehensive eye care services for cataracts, glaucoma, dry eyes, and more.',
            style: TextStyle
            (
              fontSize: 18,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () 
            {
              // Navigate to appointment booking
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

    Widget _buildAboutSection() 
    {
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
            'About Dr. S Kwon',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          Text
          (
            'Dr. S Kwon is a highly skilled and compassionate optometrist with over 10 years of experience in advanced eye care. She holds a Doctor of Optometry (O.D.) degree from the University of Waterloo, School of Optometry and Vision Science, and an Honours Bachelor of Science in Neuroscience from the University of Toronto.',
            style: TextStyle
            (
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Text
          (
            'Dr. Kwon specializes in a wide range of eye care services, including cataract management, glaucoma treatment, dry eye therapy, and custom contact lens fitting. She is certified in Paragon CRT Orthokeratology Lens, Valley Contax Custom Stable Scleral Contact Lens Fitting, and BE FREE Orthokeratology Lens. Her dedication to patient care and her expertise in ocular disease management have earned her numerous accolades, including the Scholar\'s Award and the Queen Elizabeth II Aiming For the Top Scholarship.',
            style: TextStyle
            (
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Text
          (
            'Dr. Kwon is passionate about improving her patients\' quality of life through personalized eye care. She believes in educating her patients about their eye health and providing them with the best possible treatment options.',
            style: TextStyle
            (
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildClinicOverviewSection() 
  {
    return Container
    (
      padding: EdgeInsets.all(20),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: 
        [
          Text(
            'About Our Clinic',
            style: TextStyle
            (
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          Text
          (
            'Our clinic is a leading eye care center in Toronto, dedicated to providing exceptional vision care services. We specialize in diagnosing and treating a wide range of eye conditions, including cataracts, glaucoma, dry eye syndrome, and retinal diseases. Our mission is to deliver personalized, patient-centered care using the latest advancements in optometry and ophthalmology.',
            style: TextStyle
            (
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Text
          (
            'We collaborate closely with renowned eye surgeons in Toronto to ensure seamless care for our patients. Whether you need routine eye exams, advanced diagnostic testing, or surgical co-management, our team is here to support you every step of the way.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),
          Text
          (
            'At our clinic, we prioritize your comfort and well-being. Our state-of-the-art facility is equipped with cutting-edge technology, and our friendly staff is committed to making your visit as pleasant as possible.',
            style: TextStyle
            (
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.justify,
          ),
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
            'Our Major Services',
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
              _buildServiceCard('Cornea', Icons.remove_red_eye),
              _buildServiceCard('Dry Eye', Icons.water_drop),
              _buildServiceCard('Glaucoma', Icons.health_and_safety),
              _buildServiceCard('Retina', Icons.visibility),
              _buildServiceCard('Uveitis', Icons.healing),
              _buildServiceCard('Cosmetics', Icons.spa),
              _buildServiceCard('LASIK', Icons.airline_seat_flat),
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