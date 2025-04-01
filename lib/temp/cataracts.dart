
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CataractsScreen extends ConsumerStatefulWidget 
{
  const CataractsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CataractsScreenState createState() => _CataractsScreenState();
}

class _CataractsScreenState extends ConsumerState<CataractsScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.teal.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See the World Clearly Again',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to consultation page or form
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade700,
                    ),
                    child: Text(
                      'Schedule a Consultation',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            // What Are Cataracts Section
            Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Text(
                    'What Are Cataracts?',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'A cataract occurs when the natural lens in your eye becomes cloudy, often due to aging, UV exposure, or genetics. This can blur your vision, making everyday tasks like reading or driving difficult. The good news? It’s treatable!',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Symptoms Section
            Container(
              color: Colors.grey.shade100,
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Text(
                    'Common Symptoms',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      SymptomCard('Blurry Vision', 'Things look hazy even with glasses.'),
                      SymptomCard('Glare Sensitivity', 'Lights feel too bright or cause halos.'),
                      SymptomCard('Faded Colors', 'Colors appear less vibrant.'),
                      SymptomCard('Night Vision Issues', 'Driving at night becomes tough.'),
                    ],
                  ),
                ],
              ),
            ),

            // Treatment Options Section
            Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Text(
                    'Treatment Options',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cataract surgery is the most effective treatment, replacing the cloudy lens with a clear artificial one. Modern techniques, like laser-assisted surgery, offer precision and faster recovery.',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue.shade900,
              child: Column(
                children: [
                  Text(
                    'Contact Us: info@yourclinic.com | (123) 456-7890',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '© 2025 Your Clinic. All Rights Reserved.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Symptom Card Widget
class SymptomCard extends StatelessWidget {
  final String title;
  final String description;

  const SymptomCard(this.title, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 250,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}