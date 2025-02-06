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
  lazy_eye,
  // ignore: constant_identifier_names
  pink_eye,
  // ignore: constant_identifier_names
  dry_eyes,
  // ignore: constant_identifier_names
  other_diseases,
  blog,
  faq,
  contact,
  settings,
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
  MenuItem.lazy_eye: DrawerItem('Lazy eye', Icons.person, '/lazy_eye', 'lazy_eye'),
  MenuItem.pink_eye: DrawerItem('Pink eye', Icons.person, '/pink_eye', 'pink_eye'),
  MenuItem.dry_eyes: DrawerItem('Dry eyes', Icons.person, '/dry_eyes', 'dry_eyes'),
  MenuItem.other_diseases: DrawerItem('Other diseases', Icons.person, '/other_diseases', 'other_diseases'),
  MenuItem.blog: DrawerItem('Blog', Icons.person, '/blog', 'blog'),
  MenuItem.faq: DrawerItem('FAQ', Icons.person, '/faq', 'faq'),
  MenuItem.contact: DrawerItem('Contact', Icons.person, '/contact', 'contact'),
  MenuItem.settings: DrawerItem('Settings', Icons.person, '/settings', 'settings'),
  MenuItem.profile: DrawerItem('Profile', Icons.settings, '/profile', 'profile'),
  MenuItem.logout: DrawerItem('Logout', Icons.exit_to_app, '/logout', 'logout'),
};
