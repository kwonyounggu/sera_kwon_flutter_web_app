import 'package:auto_size_text/auto_size_text.dart';
import 'package:drkwon/model/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/states.dart';

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
        buildHeader(context, ref, fontSize),
        buildMenuItem(context, ref, MenuItem.home, fontSize),
        //expantiontile and buildMenuItem
      ],
    );
  }
  void _onMenuItemSelected(MenuItem item, BuildContext context) 
  {
    switch (item) 
    {
      case MenuItem.home:
        context.goNamed(drawerItems[MenuItem.home]!.routingName);
        break;
      case MenuItem.services:
        context.goNamed(drawerItems[MenuItem.services]!.routingName);
        break;
      case MenuItem.cataracts:
        context.goNamed(drawerItems[MenuItem.cataracts]!.routingName);
        break;
      case MenuItem.glaucoma:
        context.goNamed(drawerItems[MenuItem.glaucoma]!.routingName);
        break;
      case MenuItem.diabetic_retinopathy:
        context.goNamed(drawerItems[MenuItem.diabetic_retinopathy]!.routingName);
        break;
      case MenuItem.macular_degeneration:
        context.goNamed(drawerItems[MenuItem.macular_degeneration]!.routingName);
        break;
      case MenuItem.lazy_eye:
        context.goNamed(drawerItems[MenuItem.lazy_eye]!.routingName);
        break;
      case MenuItem.pink_eye:
        context.goNamed(drawerItems[MenuItem.pink_eye]!.routingName);
        break;
      case MenuItem.dry_eyes:
        context.goNamed(drawerItems[MenuItem.dry_eyes]!.routingName);
        break;
      case MenuItem.other_diseases:
        context.goNamed(drawerItems[MenuItem.other_diseases]!.routingName);
        break;
      case MenuItem.blog:
        context.goNamed(drawerItems[MenuItem.blog]!.routingName);
        break;
      case MenuItem.faq:
        context.goNamed(drawerItems[MenuItem.home]!.routingName);
        break;
      case MenuItem.contact:
        context.goNamed(drawerItems[MenuItem.contact]!.routingName);
        break;
      case MenuItem.settings:
        context.goNamed(drawerItems[MenuItem.settings]!.routingName);
        break;
      case MenuItem.profile:
        context.goNamed(drawerItems[MenuItem.profile]!.routingName);
        break;
      case MenuItem.logout:
        // Handle logout logic
        break;
      default:
        break;
    }
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
        context.goNamed(drawerItems[item]!.routingName);
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
