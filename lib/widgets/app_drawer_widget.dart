import 'package:auto_size_text/auto_size_text.dart';
import 'package:drkwon/model/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import '../data/states.dart';

class AppDrawerWidget extends ConsumerWidget 
{
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final fontSize = MediaQuery.of(context).size.width * 0.025;

    /*
    return ListView.builder
    (
      itemCount: allStates.length + 1,
      itemBuilder: (context, index) 
      {
        return index == 0
            ? buildHeader(fontSize)
            : buildMenuItem(index, fontSize);
      },
    );*/

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
              buildHeader(context, ref, fontSize),
              buildMenuItem(context, ref, MenuItem.home, fontSize),
              //expantiontile and buildMenuItem
              ExpansionTile
              (
                leading: Icon(drawerItems[MenuItem.services]!.icon),
                title: AutoSizeText
                (
                  drawerItems[MenuItem.services]!.title,
                  minFontSize: 18,
                  maxFontSize: 28,
                  style: TextStyle(fontSize: fontSize),
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
                                                      MenuItem.glaucoma, 
                                                      MenuItem.diabetic_retinopathy,
                                                      MenuItem.macular_degeneration,
                                                      MenuItem.lazy_eye,
                                                      MenuItem.pink_eye,
                                                      MenuItem.dry_eyes,
                                                      MenuItem.other_diseases
                                                      ])
                    buildMenuItem(context, ref, item, fontSize),
                ],
              ),
              for (MenuItem item in [MenuItem.blog, 
                                              MenuItem.faq, 
                                              MenuItem.contact,
                                              MenuItem.settings,
                                              MenuItem.profile,
                                              ])
                  buildMenuItem(context, ref, item, fontSize),
            ]
          )
        ),
        buildMenuItem(context, ref, MenuItem.logout, fontSize)
      ]
    );
  }

  Widget buildMenuItem(BuildContext context, WidgetRef ref,  MenuItem item, double fontSize) 
  {
    return ListTile
    (
      leading: Icon(drawerItems[item]!.icon),
      title: AutoSizeText
      (
        drawerItems[item]!.title,
        minFontSize: 18,
        maxFontSize: 28,
        style: TextStyle(fontSize: fontSize),
      ),
      selected: false,
      onTap: ()
      {
        Navigator.pop(context);
        context.go(drawerItems[item]!.routingName);
      },
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
          image: ExactAssetImage('assets/images/swat.jpg'),
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
                minFontSize: 22,
                maxFontSize: 30,
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
