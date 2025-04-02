
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class GlaucomaScreen extends ConsumerStatefulWidget 
{
  const GlaucomaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GlaucomaScreenState createState() => _GlaucomaScreenState();
}

class _GlaucomaScreenState extends ConsumerState<GlaucomaScreen>
{
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dry Eye Solutions'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              color: Colors.blue[50],
              child: const Column(
                children: [
                  Text(
                    'Expert Dry Eye Care at Our Eye Surgery Center',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Dr. [Your Name], Ophthalmologist Specializing in Ocular Surface Health',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Column(
                children: [
                  _buildSection(
                    title: 'What is Dry Eye?',
                    content:
                        'Dry eye syndrome occurs when your eyes don’t produce enough tears or when tears evaporate too quickly. As an eye surgeon, I see this condition frequently, especially post-surgery like LASIK or cataract procedures.',
                  ),
                  _buildSection(
                    title: 'Symptoms',
                    content:
                        '- Burning or stinging sensation\n- Grittiness or foreign body feeling\n- Blurred vision\n- Excessive tearing (paradoxically)\n- Light sensitivity',
                  ),
                  _buildSection(
                    title: 'Causes',
                    content:
                        '- Post-surgical changes (e.g., LASIK, cataract surgery)\n- Meibomian gland dysfunction\n- Aging or hormonal changes\n- Environmental factors (dry air, screen time)\n- Medications or systemic conditions',
                  ),
                  _buildSection(
                    title: 'Advanced Treatments',
                    content:
                        'At our Eye Surgery Center, we offer:\n- **Artificial Tears & Lubricants**: For mild cases.\n- **Punctal Plugs**: To retain natural tears.\n- **Meibomian Gland Probing**: For oil gland blockages.\n- **Surgical Options**: Like amniotic membrane grafts for severe cases.\n- Personalized post-surgical dry eye management.',
                  ),
                  // Call to Action
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add navigation or link logic here (e.g., to a contact form)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact form coming soon!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        backgroundColor: Colors.blue[800],
                      ),
                      child: const Text(
                        'Book a Consultation',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: const Text(
                '© 2025 [Your Eye Surgery Center Name]. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}