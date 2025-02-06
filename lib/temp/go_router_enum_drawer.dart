import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() 
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget 
{
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: 
    [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

enum MenuItem 
{
  home,
  profile,
  settings,
  logout,
}

class DrawerItem 
{
  final String title;
  final IconData icon;

  DrawerItem(this.title, this.icon);
}

final Map<MenuItem, DrawerItem> drawerItems = 
{
  MenuItem.home: DrawerItem('Home', Icons.home),
  MenuItem.profile: DrawerItem('Profile', Icons.person),
  MenuItem.settings: DrawerItem('Settings', Icons.settings),
  MenuItem.logout: DrawerItem('Logout', Icons.exit_to_app),
};

class HomeScreen extends StatelessWidget 
{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            for (var item in MenuItem.values)
              ListTile(
                leading: Icon(drawerItems[item]!.icon),
                title: Text(drawerItems[item]!.title),
                onTap: () {
                  Navigator.pop(context);
                  _onMenuItemSelected(item, context);
                },
              ),
          ],
        ),
      ),
      body: const Center(child: Text('Welcome to the Home Screen!')),
    );
  }

  void _onMenuItemSelected(MenuItem item, BuildContext context) {
    switch (item) {
      case MenuItem.home:
        context.go('/');
        break;
      case MenuItem.profile:
        context.go('/profile');
        break;
      case MenuItem.settings:
        context.go('/settings');
        break;
      case MenuItem.logout:
        // Handle logout logic
        break;
    }
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Welcome to the Profile Screen!')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Welcome to the Settings Screen!')),
    );
  }
}