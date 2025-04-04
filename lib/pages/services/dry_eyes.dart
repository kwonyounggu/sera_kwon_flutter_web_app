import 'package:drkwon/utils/constants.dart';
import 'package:drkwon/widgets/components/consultation_form.dart';
import 'package:drkwon/widgets/components/footer.dart';
import 'package:drkwon/widgets/components/responsive_and_diagnostic_item.dart';
import 'package:drkwon/widgets/components/section_wrapper.dart';
import 'package:drkwon/widgets/components/title_subtitle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// Providers for state management
final loadingProvider = StateProvider<bool>((ref) => false);

class DryEyesScreen extends ConsumerStatefulWidget 
{
  const DryEyesScreen({super.key});

  @override
  ConsumerState<DryEyesScreen> createState() => _DryEyesScreenState();
}

class _DryEyesScreenState extends ConsumerState<DryEyesScreen> 
{
  final _consultationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) 
  {
    final isLoading = ref.watch(loadingProvider);
    return Scaffold(
        //appBar: _buildAppBar(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView
            (
                //controller: _scrollController,
                slivers:                   
                [
                  SliverAppBar
                  (
                    expandedHeight: 500,
                    flexibleSpace: FlexibleSpaceBar
                    (
                      background: Stack
                      (
                        fit: StackFit.expand,
                        children: 
                        [
                          Image.asset('assets/images/dry_eyes.jpg', fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade900.withValues(alpha: 0.0),
                                  Colors.teal.shade300.withValues(alpha: 0.1)
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
                                children: 
                                [
                                  const Text(
                                    '',//empty now
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromARGB(255, 235, 158, 158),
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  const Text
                                  (
                                    '',//'Evidence-Based Surgical & Medical Solutions',
                                    style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 230, 178, 178)),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  FilledButton.icon(
                                    icon: const Icon(Icons.calendar_today),
                                    label: const Text('Book Expert Consultation'),
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
                  SliverList
                  (
                    delegate: SliverChildListDelegate
                    (
                      [
                        SectionWrapper
                        (
                          children:
                          [
                            //const HeroSection(),
                            SectionTitle(title: 'Understanding Dry Eye Disease'),
                            const ContentSection(),
                            SectionTitle(title: 'Advanced Diagnostic Methods'),
                            const DiagnosticsSection(),
                            SectionTitle(title: 'Surgical & Medical Treatments'),
                            const TreatmentsSection(),
                            //const ContactSection(),
                            
                          ]
                        ),
                        const Footer(),
                      ]
                    )
                  )
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

/// Content section widget
class ContentSection extends StatelessWidget 
{
  const ContentSection({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return ResponsivePadding
    (
      child: Column
      (
        children: 
        [
          const Text
          (
            'Dry Eye Disease (DED) is a multifactorial disorder of the ocular surface characterized by loss of homeostasis of the tear film...',
            style: TextStyle(fontSize: 16, height: 1.6),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 40),
          GridView.count
          (
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: _getCrossAxisCount(context),
            childAspectRatio: 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: const [
              FeatureCard
              (
                icon: FontAwesomeIcons.gear,
                title: 'Aqueous Deficiency',
                subtitle: 'Reduced lacrimal gland secretion',
              ),
              FeatureCard
              (
                icon: FontAwesomeIcons.oilCan,
                title: 'Evaporative DED',
                subtitle: 'Meibomian gland dysfunction (MGD)',
              ),
              FeatureCard
              (
                icon: FontAwesomeIcons.eyeDropper,
                title: 'Ocular Surface Damage',
                subtitle: 'Corneal/conjunctival epitheliopathy',
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

/// Diagnostics section widget
class DiagnosticsSection extends StatelessWidget 
{
  const DiagnosticsSection({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return ResponsivePadding
    (
      child: Column
      (
        children: 
        [
          const Text
          (
            'Our comprehensive diagnostic approach includes:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Wrap
          (
            spacing: 20,
            runSpacing:  20,
            children: const 
            [
              DiagnosticItem(text: 'Tear Osmolarity', icon: FontAwesomeIcons.vial),
              DiagnosticItem(text: 'Meibography', icon: FontAwesomeIcons.camera),
              DiagnosticItem(text: 'Inflammadry', icon: FontAwesomeIcons.microscope),
              DiagnosticItem(text: 'TBUT Measurement', icon: FontAwesomeIcons.clock),
              DiagnosticItem(text: 'Schirmer\'s Test', icon: FontAwesomeIcons.vialCircleCheck),
              DiagnosticItem(text: 'Ocular Surface Staining', icon: FontAwesomeIcons.eye),
            ],
          ),
        ],
      ),
    );
  }
}

/// Treatments section widget
class TreatmentsSection extends StatelessWidget 
{
  const TreatmentsSection({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return ResponsivePadding
    (
      child: Column
      (
        children: 
        [
          ExpansionTile
          (
            title: const Text('Medical Management'),
            initiallyExpanded: true,
            children: const 
            [
              ListTile(title: Text('• Preservative-free artificial tears')),
              ListTile(title: Text('• Topical immunomodulators (Cyclosporine, Lifitegrast)')),
              ListTile(title: Text('• Autologous serum eye drops')),
              ListTile(title: Text('• Omega-3 supplementation (Pharmaceutical grade)')),
            ],
          ),
          ExpansionTile
          (
            title: const Text('Advanced Procedures'),
            initiallyExpanded: true,
            children: const [
              ListTile(title: Text('• LipiFlow Thermal Pulsation System')),
              ListTile(title: Text('• Intense Pulsed Light (IPL) Therapy')),
              ListTile(title: Text('• Punctal Occlusion (Collagen/Silicone plugs)')),
              ListTile(title: Text('• Amniotic Membrane Transplantation')),
            ],
          ),
        ],
      ),
    );
  }
}

/// Contact section widget
class ContactSection extends StatelessWidget 
{
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      margin: const EdgeInsets.only(top: AppConstants.sectionSpacing),
      padding: const EdgeInsets.all(40),
      color: AppConstants.backgroundColor,
      child: Column
      (
        children: 
        [
          const Text
          (
            'Schedule Your Consultation',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Text
          (
            'Center for Ocular Surface Disorders\n'
            '123 Ophthalmology Way, Suite 450\n'
            'Surgery Center Tower, New York, NY 10001\n'
            'Phone: (555) 123-4567 | Fax: (555) 123-4568',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton
          (
            onPressed: () => Navigator.pushNamed(context, '/appointment'),
            child: const Text('Request Appointment'),
          ),
        ],
      ),
    );
  }
}

