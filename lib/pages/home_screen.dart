import 'package:drkwon/data/places.dart';
import 'package:drkwon/model/place.dart';
import 'package:drkwon/widgets/app_drawer_widget.dart';
import 'package:drkwon/widgets/drawer_widget.dart';
import 'package:drkwon/widgets/place_details_widget.dart';
import 'package:drkwon/widgets/place_gallery_widget.dart';
import 'package:drkwon/widgets/responsive_widget.dart';
import 'package:drkwon/widgets/resume_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drkwon/widgets/app_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget 
{
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
{
  //Place selectedPlace = allPlaces[0];
  //void changePlace(Place place) => setState(() => selectedPlace = place);
  
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Home'),
      ),
      //drawer: const AppDrawer(), // Add the drawer here
      //drawer: ResponsiveWidget.isMobile(context) ? const Drawer(child: DrawerWidget()) : null,
      drawer: ResponsiveWidget.isMobile(context) ? const Drawer(child: AppDrawerWidget(isMobile: true)) : null,
      body: ResponsiveWidget
      (
        mobile: buildMobile(),
        tablet: buildTablet(),
        desktop: buildDesktop(),
      ),
    );
  }

  //********************************************** */
  //Widget buildMobile() => PlaceGalleryWidget(onPlaceChanged: changePlace);
  Widget buildMobile() => ResumeWidget();

  Widget buildTablet() => Row
  (
        children: 
        [
          const Expanded(flex: 2, child: AppDrawerWidget(isMobile: false)),
          Expanded
          (
            flex: 5,
            //child: PlaceGalleryWidget(onPlaceChanged: changePlace),
            child: ResumeWidget(),
          ),
        ],
  );

  Widget buildDesktop() => Row
  (
        children: 
        [
          const Expanded(child: AppDrawerWidget(isMobile: false)),
          Expanded(flex: 3, child: buildBody()),
        ],
      );

  Widget buildBody() => Container
  (
        color: Colors.grey[200],
        padding: const EdgeInsets.all(8.0),
        child: Column
        (
          children: 
          [
            Expanded
            (
              //child: PlaceGalleryWidget
              //(
              // onPlaceChanged: changePlace,
              //  isHorizontal: true,
              //),
              child: ResumeWidget(),
            ),
            //Expanded
            //(
            //  flex: 2,
            //  child: PlaceDetailsWidget(place: selectedPlace),
            //)
          ],
        ),
      );
}