import 'package:drkwon/widgets/components/consultation_form.dart';
import 'package:drkwon/widgets/components/footer_item.dart';
import 'package:drkwon/widgets/components/process_step.dart';
import 'package:drkwon/widgets/components/time_line.dart';
import 'package:drkwon/widgets/components/type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CataractsScreen extends ConsumerStatefulWidget 
{
  const CataractsScreen({super.key});

  @override
  CataractsScreenState createState() => CataractsScreenState();
}

class CataractsScreenState extends ConsumerState<CataractsScreen> 
{
  final _consultationFormKey = GlobalKey<FormState>();

  int _getColumnCount()
  {
    if (MediaQuery.of(context).size.width < 400 ) return 1;
    if (MediaQuery.of(context).size.width < 800 ) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) 
  {
    //debugPrint("INFO: columnCount = ${_getColumnCount()} , width = ${MediaQuery.of(context).size.width}");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section with Parallax
          SliverAppBar(
            expandedHeight: 500,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'images/cataract_hero.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade900.withValues(alpha: 0.0),
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
                            'Advanced Cataract Treatment\n& Surgery',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
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

          // Content Sections
          SliverList
          (
            delegate: SliverChildListDelegate
            (
              [
              // Understanding Cataracts
              _SectionWrapper
              (
                children: 
                [
                  const SectionTitle('Understanding Cataracts'),
                  const SizedBox(height: 20),
                  const SectionText
                  (
                    'Cataracts are the leading cause of preventable blindness worldwide, affecting over 24 million Americans aged 40+.\nA cataract develops when proteins in the eye\'s natural lens break down, causing clouding that impairs vision.',
                  ),
                  const SizedBox(height: 30),
                  GridView.count
                  (
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: _getColumnCount(), 
                    childAspectRatio: 1,
                    children: const 
                    [
                      FactCard
                      (
                        icon: Icons.access_time,
                        title: 'Development Stage',
                        text: 'Typically develops slowly over years\nInitial stages often go unnoticed',
                      ),
                      FactCard
                      (
                        icon: Icons.analytics,
                        title: 'Risk Factors',
                        text: 'Aging (most common)\nDiabetes\nUV Exposure\nSmoking\nTrauma',
                      ),
                      FactCard
                      (
                        icon: Icons.visibility_off,
                        title: 'Prevalence',
                        text: '50% of people develop cataracts by age 75\n24.4 million Americans affected',
                      ),
                    ],
                  ),
                ],
              ),

              // Types Section
              Container(
                color: Colors.grey.shade50,
                child: _SectionWrapper(
                  children: [
                    const SectionTitle('Cataract Types & Characteristics'),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: const [
                        TypeCard(
                          title: 'Nuclear Sclerotic',
                          description:
                              'Most common age-related type\nForms in lens nucleus\nCauses yellow/brown discoloration',
                          color: Colors.blueAccent,
                        ),
                        TypeCard(
                          title: 'Cortical',
                          description:
                              'Wedge-shaped opacities\nStarts in lens periphery\nCommon in diabetic patients',
                          color: Colors.green,
                        ),
                        TypeCard(
                          title: 'Posterior Subcapsular',
                          description:
                              'Forms at back of lens\nFast progression\nAffects near vision first',
                          color: Colors.orange,
                        ),
                        TypeCard(
                          title: 'Congenital',
                          description:
                              'Present at birth\nGenetic or infection-related\nRequires early detection',
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Surgical Options
              _SectionWrapper(
                children: [
                  const SectionTitle('Advanced Treatment Options'),
                  const SizedBox(height: 30),
                  const ProcessStep(
                    step: '1',
                    title: 'Preoperative Evaluation',
                    content:
                        'Comprehensive eye exam\nOptical Biometry measurements\nIOL Master calculations\nCustom lens selection',
                  ),
                  const ProcessStep(
                    step: '2',
                    title: 'Surgical Techniques',
                    content:
                        'Phacoemulsification (Ultrasound)\nFemtosecond Laser-Assisted\nExtracapsular Extraction\nIntraocular Lens (IOL) Implantation',
                  ),
                  const ProcessStep(
                    step: '3',
                    title: 'Lens Options',
                    content:
                        'Monofocal\nMultifocal\nToric (Astigmatism)\nExtended Depth of Focus\nLight Adjustable Lenses',
                  ),
                  const SizedBox(height: 40),
                  Image.asset('images/surgery_tech.jpg'),
                ],
              ),

              // Recovery Timeline
              Container(
                color: Colors.blue.shade50,
                child: _SectionWrapper(
                  children: [
                    const SectionTitle('Recovery Timeline & Care'),
                    const SizedBox(height: 30),
                    Timeline(
                      children: [
                        TimelineEvent(
                          time: '24 Hours',
                          title: 'Initial Recovery',
                          content:
                              'Mild irritation normal\nUse protective shield\nAvoid rubbing eyes',
                        ),
                        TimelineEvent(
                          time: '1 Week',
                          title: 'Follow-up Exam',
                          content:
                              'Check visual acuity\nMonitor healing\nBegin eye drop regimen',
                        ),
                        TimelineEvent(
                          time: '1 Month',
                          title: 'Stabilization',
                          content:
                              'Final vision assessment\nPossible glasses prescription\nResume normal activities',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                color: Colors.blue.shade900,
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text(
                      'North Toronto Eye Surgery Centre',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 40,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: const [
                        FooterItem(
                          icon: Icons.location_on,
                          title: 'Locations',
                          content: '2 Champagne Dr\nUnit C2 East Entrance\nToronto, Ontario M3J 0K2',
                        ),
                        FooterItem(
                          icon: Icons.phone,
                          title: 'Contact',
                          content: '416.792.3043\n24/7 Emergency: (416) 792-3043r',
                        ),
                        FooterItem(
                          icon: Icons.access_time,
                          title: 'Hours',
                          content: 'Mon-Fri: 9am-5pm\nSat: 9am-3pm',
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      '© 2024 Advanced Eye Care. All Rights Reserved.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ]),
          ),
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

// Reusable Components
class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: Colors.blueGrey,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;

  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        height: 1.6,
        color: Colors.grey.shade700,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class FactCard extends StatelessWidget 
{
  final IconData icon;
  final String title;
  final String text;

  const FactCard
  (
    {
      super.key,
      required this.icon,
      required this.title,
      required this.text,
    }
  );

  @override
  Widget build(BuildContext context) 
  {
    return Card
    (
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding
      (
        padding: const EdgeInsets.all(20),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            Icon(icon, size: 40, color: Colors.blue.shade700),
            const SizedBox(height: 15),
            
            Flexible
            (
              child: Text
              ( title, 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                //maxLines: 2,
                //overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 10),
            Expanded
            (
              flex: 2,
              child:Text
              ( text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
                //overflow: TextOverflow.ellipsis,
              )
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: slash_for_doc_comments
/**
 * // In the Surgical Options section
_SectionWrapper(
  children: [
    const SectionTitle('Advanced Treatment Options'),
    const SizedBox(height: 30),
    const ProcessStep(...),
    const ProcessStep(...),
    const ProcessStep(...),
    const SizedBox(height: 40),
    Image.asset('assets/images/surgery_tech.png'),
  ],
),
 */
class _SectionWrapper extends ConsumerWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  const _SectionWrapper({
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...children.expand((widget) => [
                      widget,
                      if (widget != children.last)
                        const SizedBox(height: 30),
                    ])
              ],
            ),
          );
        },
      ),
    );
  }
}
// Add other components (TypeCard, ProcessStep, Timeline, FooterItem, ConsultationForm) similarly
// with proper styling and functionality