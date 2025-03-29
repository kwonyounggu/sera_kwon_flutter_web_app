/*import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact")),
      body: const Center(child: Text("Contact Information")),
    );
  }
}
*/
import 'package:flutter/material.dart';



class AboutMeScreen extends StatelessWidget 
{
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Section
            _buildSectionTitle('Contact'),
            _buildContactInfo(),
            SizedBox(height: 20),

            // Language Section
            _buildSectionTitle('Language'),
            _buildLanguageInfo(),
            SizedBox(height: 20),

            // Certifications Section
            _buildSectionTitle('Certifications'),
            _buildCertifications(),
            SizedBox(height: 20),

            // Honors & Awards Section
            _buildSectionTitle('Honors & Awards'),
            _buildHonorsAwards(),
            SizedBox(height: 20),

            // Work Experience Section
            _buildSectionTitle('Work Experience'),
            _buildWorkExperience(),
            SizedBox(height: 20),

            // Education Section
            _buildSectionTitle('Education'),
            _buildEducation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LinkedIn: www.linkedin.com/in/serakwon-48107880',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildLanguageInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'English (Native or Bilingual)',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Korean (Native or Bilingual)',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCertifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency First Aid, CPR and AED, Health Care Provider Level',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Paragon CRT Orthokeratology Lens Certification',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Valley Contax Custom Stable Scleral Contact Lens Fitting Certification',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'BE FREE Orthokeratology Lens',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildHonorsAwards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scholar's Award",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Queen Elizabeth II Aiming For the Top Scholarship',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWorkExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExperienceItem(
          'Scarborough Optometric Clinic',
          'Optometry Intern',
          'September 2018 - December 2018 (4 months)',
          'Supervisor: Dr. Lorina Yip, OD\n'
              'Provided a variety of eye examinations in a primary care setting including: comprehensive, ocular emergencies, glaucoma work-up, dry eye work-up, contact lens fitting, and diabetic eye examinations.',
        ),
        SizedBox(height: 10),
        _buildExperienceItem(
          'Scarborough Eye Associates',
          'Optometry Intern',
          'May 2018 - August 2018 (4 months)',
          'Supervisor: Dr. Jordan Cheskes, MD\n'
              'Provided ocular care in a tertiary care setting for patients who required: postoperative care (cataract/vitreoretinal), diabetic examination, retinal pathology management, secondary glaucoma/uveitis management, ocular work-up for neurology, rheumatology, immunology, and endocrinology.',
        ),
        SizedBox(height: 10),
        _buildExperienceItem(
          'Vision Care Centre',
          'Optometric Assistant',
          'June 2017 - August 2018 (1 year 3 months)',
          '',
        ),
        SizedBox(height: 10),
        _buildExperienceItem(
          'North York Eye Clinic',
          'Optometric Assistant',
          'May 2016 - December 2016 (8 months)',
          '',
        ),
        SizedBox(height: 10),
        _buildExperienceItem(
          'Toronto Public Library',
          'Library Page',
          '2008 - 2011 (3 years)',
          '',
        ),
      ],
    );
  }

  Widget _buildExperienceItem(String organization, String position, String duration, String description) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              organization,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              position,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 5),
            Text(
              duration,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            if (description.isNotEmpty)
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEducationItem(
          'University of Waterloo, School of Optometry and Vision Science',
          'Doctor of Optometry (O.D.)',
          '2015 - 2019',
        ),
        SizedBox(height: 10),
        _buildEducationItem(
          'University of Toronto',
          'Honours Bachelor of Science (H.B.Sc.), Neuroscience',
          '2011 - 2015',
        ),
      ],
    );
  }

  Widget _buildEducationItem(String institution, String degree, String duration) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              institution,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              degree,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 5),
            Text(
              duration,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}