import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';

class AppDrawer extends ConsumerWidget 
{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    return Drawer
    (
      child: Column
      (
        children:<Widget>
        [
           Expanded
          (
            child: ListView
            (
              padding: EdgeInsets.zero,
              children: <Widget>
              [
                // Custom DrawerHeader with Close Button
                Container
                (
                  height: 150, // Height of the DrawerHeader
                  decoration: BoxDecoration
                  (
                    color: Colors.blue, // Background color of the header
                  ),
                  child: Stack
                  (
                    children: <Widget>
                    [
                      // Header Content
                      Center
                      (
                        child: Text
                        (
                          'My Drawer Header',
                          style: TextStyle
                          (
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // Close Button
                      Positioned
                      (
                        right: 10,
                        top: 10,
                        child: IconButton
                        (
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () 
                          {
                            // Close the drawer
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                /*(const DrawerHeader
                (
                  decoration: BoxDecoration
                  (
                    color: Colors.blue,
                  ),
                  child: Text
                  (
                    'Menu',
                    style: TextStyle
                    (
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),*/
                ListTile
                (
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () 
                  {
                    context.goNamed('home');
                  },
                ),
                ExpansionTile
                (
                  leading: const Icon(Icons.person),
                  title: const Text('Services'),
                  childrenPadding: EdgeInsets.only(left:20),
                  children: <Widget>
                  [
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Cataracts'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Glaucoma'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Diabetic retinopathy'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Macular degeneration'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Amblyopia'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Pink eye'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Dry eyes'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                    ListTile
                    (
                      leading: const Icon(Icons.task),
                      title: const Text('Other eye diseases'),
                      onTap: () 
                      {
                        context.goNamed('task1');
                      },
                    ),
                  ],
                ),
                ListTile
                (
                  leading: const Icon(Icons.task),
                  title: const Text('Blog'),
                  onTap: () 
                  {
                    context.goNamed('task1');
                  },
                ),
                ListTile
                (
                  leading: const Icon(Icons.task),
                  title: const Text('FAQ'),
                  onTap: () 
                  {
                    context.goNamed('task2');
                  },
                ),
                ListTile
                (
                  leading: const Icon(Icons.task),
                  title: const Text('Color Mixer'),
                  onTap: () 
                  {
                    context.goNamed('colorMixer');
                  },
                ),
                ListTile
                (
                  leading: const Icon(Icons.task),
                  title: const Text('Contact'),
                  onTap: () 
                  {
                    context.goNamed('task2');
                  },
                ),
                
                
                
              ],
            ),
          ),
          ListTile
            (
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () 
              {
                final authNotifier = ref.read(authNotifierProvider.notifier);
                authNotifier.logout();
                context.goNamed('home');
              },
            ),
        ]
      )
    );
  }
}