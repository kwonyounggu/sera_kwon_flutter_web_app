import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Constants class
class AppConstants {
  static const primaryColor = Color(0xFF0A2463);
  static const secondaryColor = Color(0xFF3A506B);
  static const backgroundColor = Color(0xFFF8F9FA);
  static const sectionSpacing = 60.0;
  static const horizontalPadding = 100.0;
  static const heroHeight = 500.0;
  static const breakpoints = {
    'sm': 600.0,
    'md': 900.0,
    'lg': 1200.0,
  };
}

// Theme configuration
class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16, height: 1.6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      );
}

// Providers for state management
final loadingProvider = StateProvider<bool>((ref) => false);

class DryEyesScreen extends ConsumerStatefulWidget {
  const DryEyesScreen({super.key});

  @override
  ConsumerState<DryEyesScreen> createState() => _DryEyesScreenState();
}

class _DryEyesScreenState extends ConsumerState<DryEyesScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<double> _sectionPositions = [0.0, 600.0, 1200.0, 1800.0];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    if (index >= 0 && index < _sectionPositions.length) {
      _scrollController.animateTo(
        _sectionPositions[index],
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    return Theme(
      data: AppTheme.theme,
      child: Scaffold(
        //appBar: _buildAppBar(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const HeroSection(),
                    SectionTitle(title: 'Understanding Dry Eye Disease'),
                    const ContentSection(),
                    SectionTitle(title: 'Advanced Diagnostic Methods'),
                    const DiagnosticsSection(),
                    SectionTitle(title: 'Surgical & Medical Treatments'),
                    const TreatmentsSection(),
                    const ContactSection(),
                    const Footer(),
                  ],
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: AppBar(
          title: Image.asset('assets/logo.png', height: 60),
          centerTitle: true,
          elevation: 0,
          actions: [
            NavButton(text: 'Home', onPressed: () => _scrollToSection(0)),
            NavButton(text: 'Symptoms', onPressed: () => _scrollToSection(1)),
            NavButton(text: 'Treatments', onPressed: () => _scrollToSection(2)),
            NavButton(text: 'Contact', onPressed: () => _scrollToSection(3)),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

/// Navigation button widget
class NavButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NavButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: AppConstants.secondaryColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// Hero section widget
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.heroHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/eye_banner.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
          onError: (exception, stackTrace) => const Icon(Icons.error),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Advanced Dry Eye Management',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              'Evidence-Based Surgical & Medical Solutions',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(FontAwesomeIcons.calendarCheck, size: 18),
              label: const Text('Schedule Consultation'),
              onPressed: () => Navigator.pushNamed(context, '/appointment'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section title widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppConstants.sectionSpacing),
      child: Text(title, style: Theme.of(context).textTheme.displayLarge),
    );
  }
}

/// Content section widget
class ContentSection extends StatelessWidget {
  const ContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'Dry Eye Disease (DED) is a multifactorial disorder of the ocular surface characterized by loss of homeostasis of the tear film...',
            style: TextStyle(fontSize: 16, height: 1.6),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: _getCrossAxisCount(context),
            childAspectRatio: 1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: const [
              FeatureCard(
                icon: FontAwesomeIcons.gear,
                title: 'Aqueous Deficiency',
                subtitle: 'Reduced lacrimal gland secretion',
              ),
              FeatureCard(
                icon: FontAwesomeIcons.oilCan,
                title: 'Evaporative DED',
                subtitle: 'Meibomian gland dysfunction (MGD)',
              ),
              FeatureCard(
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
class DiagnosticsSection extends StatelessWidget {
  const DiagnosticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          const Text(
            'Our comprehensive diagnostic approach includes:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing:  20,
            children: const [
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
class TreatmentsSection extends StatelessWidget {
  const TreatmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: Column(
        children: [
          ExpansionTile(
            title: const Text('Medical Management'),
            children: const [
              ListTile(title: Text('• Preservative-free artificial tears')),
              ListTile(title: Text('• Topical immunomodulators (Cyclosporine, Lifitegrast)')),
              ListTile(title: Text('• Autologous serum eye drops')),
              ListTile(title: Text('• Omega-3 supplementation (Pharmaceutical grade)')),
            ],
          ),
          ExpansionTile(
            title: const Text('Advanced Procedures'),
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
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.sectionSpacing),
      padding: const EdgeInsets.all(40),
      color: AppConstants.backgroundColor,
      child: Column(
        children: [
          const Text(
            'Schedule Your Consultation',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Text(
            'Center for Ocular Surface Disorders\n'
            '123 Ophthalmology Way, Suite 450\n'
            'Surgery Center Tower, New York, NY 10001\n'
            'Phone: (555) 123-4567 | Fax: (555) 123-4568',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/appointment'),
            child: const Text('Request Appointment'),
          ),
        ],
      ),
    );
  }
}

/// Footer widget
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppConstants.primaryColor,
      child: const Text(
        '© 2023 Advanced Dry Eye Center | Board Certified Ophthalmologists | All surgical procedures performed in AAAHC-accredited ambulatory surgery center',
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Feature card widget
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppConstants.primaryColor),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Diagnostic item widget
class DiagnosticItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const DiagnosticItem({required this.text, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePadding({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double padding = AppConstants.horizontalPadding;
    
    if (width < AppConstants.breakpoints['sm']!) {
      padding = 20.0;
    } else if (width < AppConstants.breakpoints['md']!) {
      padding = 50.0;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: child,
    );
  }
}