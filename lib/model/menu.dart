import 'package:flutter/material.dart';

enum MenuItem 
{
  home,
  services,
  cataracts,
  glaucoma,
  // ignore: constant_identifier_names
  diabetic_retinopathy,
  // ignore: constant_identifier_names
  macular_degeneration,
  // ignore: constant_identifier_names
  contact_lens,
  // ignore: constant_identifier_names
  eye_exam,
  // ignore: constant_identifier_names
  dry_eyes,
  // ignore: constant_identifier_names
  other_diseases,
  blogs,
  blog_list,
  blog_writing,
  faq,
  contact,
  settings,
  aboutme,
  profile,
  logout,
}

class DrawerItem 
{
  final String title;
  final IconData icon;
  final String routingPath;
  final String routingName;

  DrawerItem(this.title, this.icon, this.routingPath, this.routingName);
}

final Map<MenuItem, DrawerItem> drawerItems = 
{
  MenuItem.home: DrawerItem('Home', Icons.home, '/', 'home'),
  MenuItem.services: DrawerItem('Services', Icons.person, '/services', 'services'),
  MenuItem.cataracts: DrawerItem('Cataracts', Icons.person, '/cataracts', 'cataracts'),
  MenuItem.glaucoma: DrawerItem('Glaucoma', Icons.person, '/glaucoma', 'glaucoma'),
  MenuItem.diabetic_retinopathy: DrawerItem('Diabetic retinopathy', Icons.person, '/diabetic_retinopathy', 'diabetic_retinopathy'),
  MenuItem.macular_degeneration: DrawerItem('Macular degeneration', Icons.person, '/macular_degeneration', 'macular_degeneration'),
  MenuItem.contact_lens: DrawerItem('Contact lens', Icons.person, '/contact_lens', 'contact_lens'),
  MenuItem.eye_exam: DrawerItem('Eye exam', Icons.person, '/eye_exam', 'eye_exam'),
  MenuItem.dry_eyes: DrawerItem('Dry eyes', Icons.person, '/dry_eyes', 'dry_eyes'),
  MenuItem.other_diseases: DrawerItem('Other diseases', Icons.person, '/other_diseases', 'other_diseases'),
  MenuItem.blogs: DrawerItem('Blog', Icons.person, '/blog', 'blog'),
  MenuItem.blog_list: DrawerItem('List of Blogs', Icons.person, '/blog_list', 'blog_list'),
  MenuItem.blog_writing: DrawerItem('Write A Blog', Icons.person, '/blog_writing', 'blog_writing'),
  MenuItem.faq: DrawerItem('FAQ', Icons.person, '/faq', 'faq'),
  MenuItem.contact: DrawerItem('Contact', Icons.person, '/contact', 'contact'),
  MenuItem.settings: DrawerItem('My Settings', Icons.person, '/settings', 'settings'),
  MenuItem.profile: DrawerItem('Profile', Icons.settings, '/profile', 'profile'),
  MenuItem.aboutme: DrawerItem('AboutMe', Icons.account_box, '/aboutme', 'aboutme'),
  MenuItem.logout: DrawerItem('Logout', Icons.exit_to_app, '/logout', 'logout'),
};

final Map<String, String> routeTitles = 
{
  '/': 'Home',
  '/cataracts': 'Cataracts Services',
  '/eye_exam' : 'Comprehensive Eye Exam',
  '/dry_eyes' : 'Dry Eyes Services',
  '/contact_lens' : 'Contact Lens Services',
  '/other_diseases' : 'Other Eye Diseases',
  '/blog_list' : 'Blog List',
  '/blog_writing': 'New Blog Post',
  '/faq' : 'Frequently Asked Questions',
  '/contact' : 'Contact Me',
  '/aboutme' : 'About Me',
  '/profile' : 'Update My Profile',
  '/login' : 'Your Login',
};
