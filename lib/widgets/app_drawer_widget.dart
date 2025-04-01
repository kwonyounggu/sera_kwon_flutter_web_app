import 'package:auto_size_text/auto_size_text.dart';
import 'package:drkwon/model/menu.dart';
import 'package:drkwon/pages/admin/message_creation_dialog.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import '../data/states.dart';

class AppDrawerWidget extends ConsumerWidget 
{
  final bool isMobile;
  const AppDrawerWidget({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final authState = ref.watch(authNotifierProvider);
    final fontSize = MediaQuery.of(context).size.width * 0.025;

    return Column
    (
      children: <Widget>
      [
        Expanded
        (
          child: ListView
          (
            padding: EdgeInsets.zero,
            children: <Widget>
            [ 
              if (isMobile) buildHeader(context, ref, fontSize),
              buildMenuItem(context, ref, MenuItem.home, fontSize),
              //expantiontile and buildMenuItem
              ExpansionTile
              (
                leading: Icon(drawerItems[MenuItem.services]!.icon),
                
                title: AutoSizeText
                (
                  drawerItems[MenuItem.services]!.title,
                  minFontSize: 16,
                  maxFontSize: 18,
                  style: TextStyle(fontSize: fontSize),
                  maxLines: 2,
                ),
                /*initiallyExpanded: _isServicesExpanded,
                onExpansionChanged: (expanded) 
                {
                  setState(() 
                  {
                    _isServicesExpanded = expanded;
                  });
                },*/
                childrenPadding: EdgeInsets.only(left:20),
                children: <Widget>
                [
                  for (MenuItem item in [MenuItem.cataracts, 
                                        MenuItem.eye_exam,
                                        MenuItem.contact_lens,
                                        MenuItem.dry_eyes,
                                        MenuItem.other_diseases
                                        ])
                    buildMenuItem(context, ref, item, fontSize),
                ],
              ),
              ExpansionTile
              (
                leading: Icon(drawerItems[MenuItem.blogs]!.icon),
                title: AutoSizeText
                (
                  drawerItems[MenuItem.blogs]!.title,
                  minFontSize: 16,
                  maxFontSize: 18,
                  style: TextStyle(fontSize: fontSize),
                  maxLines: 2,
                ),
                /*initiallyExpanded: _isServicesExpanded,
                onExpansionChanged: (expanded) 
                {
                  setState(() 
                  {
                    _isServicesExpanded = expanded;
                  });
                },*/
                childrenPadding: EdgeInsets.only(left:20),
                children: <Widget>
                [
                  buildMenuItem(context, ref, MenuItem.blog_list, fontSize),
                  if (authState.isLoggedIn && authState.userType!.toLowerCase() != 'general')
                    buildMenuItem(context, ref, MenuItem.blog_writing, fontSize)
                  else
                    buildMenuItemDisabled(context, ref, MenuItem.blog_writing, fontSize),
                ],
              ),
              for (MenuItem item in [
                                    MenuItem.faq, 
                                    MenuItem.contact,
                                    MenuItem.aboutme
                                    ])
                  buildMenuItem(context, ref, item, fontSize),

              authState.isLoggedIn?
                ExpansionTile
                (
                  leading: Icon(drawerItems[MenuItem.settings]!.icon),
                  title: AutoSizeText
                  (
                    drawerItems[MenuItem.settings]!.title,
                    minFontSize: 16,
                    maxFontSize: 18,
                    style: TextStyle(fontSize: fontSize),
                    maxLines: 2,
                  ),
                  /*initiallyExpanded: _isServicesExpanded,
                  onExpansionChanged: (expanded) 
                  {
                    setState(() 
                    {
                      _isServicesExpanded = expanded;
                    });
                  },*/
                  childrenPadding: EdgeInsets.only(left:20),
                  children: <Widget>
                  [
                    for (MenuItem item in [MenuItem.profile, 
                                          ])
                      buildMenuItem(context, ref, item, fontSize),
                  ],
                ):
                ListTile
                (
                  hoverColor: Colors.blue[50],
                  leading: Icon(drawerItems[MenuItem.settings]!.icon, color: Colors.grey,),
                  title: AutoSizeText
                  (
                    drawerItems[MenuItem.settings]!.title,
                    minFontSize: 16,
                    maxFontSize: 18,
                    style: TextStyle(fontSize: fontSize, color: Colors.grey),
                    maxLines: 2,
                  ),
                  selected: false,
                  onTap: null
                ),
            ]
          )
        ),
        if (authState.isLoggedIn && authState.userType == 'admin')
            ListTile
            (
              leading: const Icon(Icons.announcement),
              title: const Text('Post Announcement'),
              onTap: () => showDialog
              (
                context: context,
                builder: (context) => const MessageCreationDialog(),
              ),
            ),
        if (authState.isLoggedIn) buildMenuItem(context, ref, MenuItem.logout, fontSize)

      ]
    );
  }

  Widget buildMenuItem(BuildContext context, WidgetRef ref,  MenuItem item, double fontSize) 
  {
    return ListTile
    (
      hoverColor: Colors.blue[50],
      leading: Icon(drawerItems[item]!.icon),
      title: AutoSizeText
      (
        drawerItems[item]!.title,
        minFontSize: 16,
        maxFontSize: 18,
        style: TextStyle(fontSize: fontSize),
        maxLines: 2,
      ),
      selected: false,
      onTap: ()
      {
        if (isMobile) Navigator.pop(context);
        context.go(drawerItems[item]!.routingPath);
      },
    );
  }

  Widget buildMenuItemDisabled(BuildContext context, WidgetRef ref,  MenuItem item, double fontSize) 
  {
    return ListTile
    (
      hoverColor: Colors.blue[50],
      leading: Icon(drawerItems[item]!.icon, color: Colors.grey,),
      title: AutoSizeText
      (
        drawerItems[item]!.title,
        minFontSize: 16,
        maxFontSize: 18,
        style: TextStyle(fontSize: fontSize, color: Colors.grey),
        maxLines: 2,
      ),
      selected: false,
      onTap: null
    );
  }

  Widget buildHeader(BuildContext context, WidgetRef ref, double fontSize) 
  {
    return DrawerHeader
    (
      decoration: const BoxDecoration
      (
        image: DecorationImage
        (
          fit: BoxFit.cover,
          image: ExactAssetImage('assets/images/logo.jpg'),
        ),
      ),
      child: Container
      (
        alignment: AlignmentDirectional.bottomStart,
        child: Stack
        (
          children: <Widget>
          [
            // Header Content
            Center
            (
              child: AutoSizeText
              (
                'My Drawer Header',
                minFontSize: 16,
                maxFontSize: 18,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
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
    );
  }
}
