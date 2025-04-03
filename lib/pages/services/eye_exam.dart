import 'package:drkwon/utils/constants.dart';
import 'package:drkwon/widgets/components/consultation_form.dart';
import 'package:drkwon/widgets/components/footer.dart';
import 'package:drkwon/widgets/components/responsive_and_diagnostic_item.dart';
import 'package:drkwon/widgets/components/section_wrapper.dart';
import 'package:drkwon/widgets/components/title_subtitle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final examLoadingProvider = StateProvider<bool>((ref) => false);

class EyeExamScreen extends ConsumerStatefulWidget 
{
  const EyeExamScreen({super.key});

  @override
  ConsumerState<EyeExamScreen> createState() => _ComprehensiveExamScreenState();
}

class _ComprehensiveExamScreenState extends ConsumerState<EyeExamScreen> {
  final _consultationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(examLoadingProvider);
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
                          //Image.asset('images/eye_exam_hero.png', fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade900.withValues(alpha: 0.6),
                                  Colors.teal.shade300.withValues(alpha: 0.3),
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
                                    'Comprehensive Ocular Evaluation',
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
                                    'Advanced Diagnostic Precision & Preventative Care',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  FilledButton.icon(
                                    icon: const Icon(Icons.calendar_today),
                                    label: const Text('Schedule Evaluation'),
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
                          SectionTitle(title: 'The Gold Standard in Eye Care'),
                          const ExamOverviewSection(),
                          SectionTitle(title: 'Diagnostic Technologies'),
                          const DiagnosticTechSection(),
                          SectionTitle(title: 'Clinical Evaluation Protocol'),
                          const ExamProtocolSection(),
                          SectionTitle(title: 'Post-Exam Management'),
                          const ManagementSection(),
                        ],
                      ),
                      const Footer(),
                    ]),
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

class ExamOverviewSection extends StatelessWidget {
  const ExamOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'Our comprehensive eye examination exceeds standard screenings, employing a systematic approach '
            'to assess ocular health, visual function, and systemic correlations. The 90-minute evaluation '
            'includes 25+ discrete tests analyzed through evidence-based diagnostic algorithms.',
            style: TextStyle(fontSize: 16, height: 1.6),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: _getCrossAxisCount(context),
            childAspectRatio: 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: const [
              FeatureCard(
                icon: FontAwesomeIcons.eyeLowVision,
                title: 'Refractive Analysis',
                subtitle: 'Wavefront aberrometry & subjective refinement',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.brain,
                title: 'Neurological Assessment',
                subtitle: 'Pupillary reflexes & ocular motility evaluation',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.prescriptionBottle,
                title: 'Therapeutic Planning',
                subtitle: 'Personalized management algorithms',
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

class DiagnosticTechSection extends StatelessWidget {
  const DiagnosticTechSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'Multimodal Imaging & Functional Testing:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              DiagnosticItem(text: 'OCT Angiography', icon: FontAwesomeIcons.eye),
              DiagnosticItem(text: 'Corneal Topography', icon: FontAwesomeIcons.globe),
              DiagnosticItem(text: 'Visual Field Analyzer', icon: FontAwesomeIcons.binoculars),
              DiagnosticItem(text: 'Electroretinography', icon: FontAwesomeIcons.bolt),
              DiagnosticItem(text: 'Ultrasonic Pachymetry', icon: FontAwesomeIcons.waveSquare),
              DiagnosticItem(text: 'Dynamic Contour Tonometry', icon: FontAwesomeIcons.gaugeHigh),
            ],
          ),
        ],
      ),
    );
  }
}

class ExamProtocolSection extends StatelessWidget {
  const ExamProtocolSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          ExpansionTile(
            title: const Text('Phase 1: Anterior Segment Analysis'),
            children: const [
              ListTile(title: Text('• Slit-lamp biomicroscopy with digital documentation')),
              ListTile(title: Text('• Tear film interferometry & meibography')),
              ListTile(title: Text('• Endothelial cell density mapping')),
            ],
          ),
          ExpansionTile(
            title: const Text('Phase 2: Posterior Segment Evaluation'),
            children: const [
              ListTile(title: Text('• 120° ultra-widefield retinal imaging')),
              ListTile(title: Text('• OCT macular cube & RNFL analysis')),
              ListTile(title: Text('• Autofluorescence imaging for RPE health')),
            ],
          ),
          ExpansionTile(
            title: const Text('Phase 3: Functional Assessment'),
            children: const [
              ListTile(title: Text('• Contrast sensitivity under mesopic/photopic conditions')),
              ListTile(title: Text('• Color vision quantification (Farnsworth-Munsell 100 Hue)')),
              ListTile(title: Text('• Stereoacuity measurement (Randot test)')),
            ],
          ),
        ],
      ),
    );
  }
}

class ManagementSection extends StatelessWidget {
  const ManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'Post-Exam Care Pathway:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            childAspectRatio: 2.5,
            children: const [
              FactHCard(
                icon: FontAwesomeIcons.fileWaveform,
                title: 'Digital Health Record',
                text: 'Secure cloud-based results portal with AI analysis',
              ),
              FactHCard(
                icon: FontAwesomeIcons.video,
                title: 'Telemedicine Follow-up',
                text: 'Virtual consultation within 72 hours of exam',
              ),
            ],
          ),
        ],
      ),
    );
  }
}