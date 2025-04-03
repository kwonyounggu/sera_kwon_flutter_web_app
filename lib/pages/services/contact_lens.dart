import 'package:drkwon/utils/constants.dart';
import 'package:drkwon/widgets/components/consultation_form.dart';
import 'package:drkwon/widgets/components/footer.dart';
import 'package:drkwon/widgets/components/responsive_and_diagnostic_item.dart';
import 'package:drkwon/widgets/components/section_wrapper.dart';
import 'package:drkwon/widgets/components/title_subtitle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class ContactLensScreen extends ConsumerStatefulWidget {
  const ContactLensScreen({super.key});

  @override
  ConsumerState<ContactLensScreen> createState() => _ContactLensFittingsScreenState();
}

class _ContactLensFittingsScreenState extends ConsumerState<ContactLensScreen> {
  final _consultationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 500,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          //Image.asset('images/contact_lens_fitting.jpg', fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade900.withValues(alpha: 0.6),
                                  Colors.teal.shade300.withValues(alpha: 0.3)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Professional Contact Lens Fittings',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    'Precision Measurements for Optimal Vision & Comfort',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  FilledButton.icon(
                                    icon: const Icon(Icons.visibility),
                                    label: const Text('Schedule Fitting'),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue.shade900,
                                      textStyle: const TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () => _showConsultationForm(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SectionWrapper(
                        children: [
                          SectionTitle(title: 'Comprehensive Contact Lens Services'),
                          const FittingProcessSection(),
                          SectionTitle(title: 'Advanced Fitting Technologies'),
                          const TechnologySection(),
                          SectionTitle(title: 'Specialty Lens Options'),
                          const LensTypesSection(),
                          SectionTitle(title: 'Aftercare & Maintenance'),
                          const CareSection(),
                        ],
                      ),
                    const Footer(),
                  ]))
                ],
              ),
      );
  }

  void _showConsultationForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ConsultationForm(formKey: _consultationFormKey),
    );
  }
}

class FittingProcessSection extends StatelessWidget {
  const FittingProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'Our 7-step precision fitting process ensures optimal vision correction and ocular health:',
            style: TextStyle(fontSize: 16, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: _getCrossAxisCount(context),
            childAspectRatio: 1.1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: const [
              FeatureCard(
                icon: FontAwesomeIcons.eye,
                title: 'Ocular Health Exam',
                subtitle: 'Complete anterior segment evaluation',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.ruler,
                title: 'Corneal Topography',
                subtitle: 'Digital mapping of corneal curvature',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.tape,
                title: 'Pupillometry',
                subtitle: 'Precise pupil size measurement',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.vial,
                title: 'Tear Film Analysis',
                subtitle: 'TBUT, Schirmer\'s, and osmolarity tests',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.magnifyingGlass,
                title: 'Lens Selection',
                subtitle: 'Material, diameter, and base curve matching',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.handHoldingMedical,
                title: 'Trial Fitting',
                subtitle: 'Real-time assessment with trial lenses',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.book,
                title: 'Education',
                subtitle: 'Insertion/removal training & care instructions',
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.breakpoints['sm']!) return 1;
    if (width < AppConstants.breakpoints['md']!) return 2;
    return 3;
  }
}

class TechnologySection extends StatelessWidget {
  const TechnologySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'State-of-the-art diagnostic equipment:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              DiagnosticItem(text: 'Corneal Topographer', icon: FontAwesomeIcons.map),
              DiagnosticItem(text: 'Wavefront Aberrometry', icon: FontAwesomeIcons.waveSquare),
              DiagnosticItem(text: 'Anterior OCT', icon: FontAwesomeIcons.circleNodes),
              DiagnosticItem(text: 'Meibography', icon: FontAwesomeIcons.cameraRetro),
              DiagnosticItem(text: 'Digital Pupillometer', icon: FontAwesomeIcons.rulerCombined),
              DiagnosticItem(text: 'TearLab Osmolarity', icon: FontAwesomeIcons.vialVirus),
            ],
          ),
        ],
      ),
    );
  }
}

class LensTypesSection extends StatelessWidget {
  const LensTypesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          ExpansionTile(
            title: const Text('Specialty Lenses'),
            children: const [
              ListTile(
                leading: Icon(FontAwesomeIcons.circle, size: 20),
                title: Text('Scleral Lenses'),
                subtitle: Text('For irregular corneas and severe dry eye'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.leaf, size: 20),
                title: Text('Hybrid Lenses'),
                subtitle: Text('RGP center with soft lens periphery'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.hourglass, size: 20),
                title: Text('Ortho-K Lenses'),
                subtitle: Text('Overnight corneal reshaping'),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.palette, size: 20),
                title: Text('Toric Lenses'),
                subtitle: Text('Astigmatism correction'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Advanced Materials'),
            children: const [
              ListTile(title: Text('Silicon Hydrogel (High Oxygen Permeability)')),
              ListTile(title: Text('UV-Blocking Lenses')),
              ListTile(title: Text('Moisture-Enhanced Surfaces')),
              ListTile(title: Text('Photochromic Options')),
            ],
          ),
        ],
      ),
    );
  }
}

class CareSection extends StatelessWidget {
  const CareSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'Comprehensive aftercare program includes:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              DiagnosticItem(text: '24/7 Emergency Support', icon: FontAwesomeIcons.phone),
              DiagnosticItem(text: '3-Month Follow-ups', icon: FontAwesomeIcons.calendarCheck),
              DiagnosticItem(text: 'Lens Care Workshops', icon: FontAwesomeIcons.peopleGroup),
              DiagnosticItem(text: 'Digital Reminders', icon: FontAwesomeIcons.bell),
              DiagnosticItem(text: 'Compliance Monitoring', icon: FontAwesomeIcons.clipboardCheck),
              DiagnosticItem(text: 'Annual Ocular Health Review', icon: FontAwesomeIcons.eye),
            ],
          ),
        ],
      ),
    );
  }
}