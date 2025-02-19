
import 'package:drkwon/widgets/app_drawer_widget.dart';
import 'package:drkwon/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResponsiveShellRouteWidget extends ConsumerStatefulWidget 
{
  final Widget child;
  final String currentPath;
  const ResponsiveShellRouteWidget({super.key, required this.currentPath, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _ResponsiveShellRouteWidgetState createState() => _ResponsiveShellRouteWidgetState();
}

class _ResponsiveShellRouteWidgetState extends ConsumerState<ResponsiveShellRouteWidget>
{
 
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        leading: Padding
        (
          padding: EdgeInsets.only(left: 16.0), // Add padding to fit the logo
          //child: Image.asset('images/logo.png', fit: BoxFit.contain), // Local image
          child: Row
          (
            mainAxisSize: MainAxisSize.min, // Prevent extra space
            children: [
              Image.asset(
                'images/logo.png', // Local image
                //height: 30, // Adjust size
              ),
              SizedBox(width: 8), // Space between logo and text
              Text(
                'Company',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        title: Text(widget.currentPath),
      ),
      drawer: ResponsiveWidget.isMobile(context) ? const Drawer(child: AppDrawerWidget(isMobile: true)) : null,
      body: ResponsiveWidget
      (
        mobile: buildMobile(),
        tablet: buildTablet(),
        desktop: buildDesktop(),
      ),
    );
  }

  Widget buildMobile() => widget.child;

  Widget buildTablet() => Row
  (
        children: 
        [
          const Expanded(flex: 2, child: AppDrawerWidget(isMobile: false)),
          Expanded
          (
            flex: 5,
            //child: PlaceGalleryWidget(onPlaceChanged: changePlace),
            child: widget.child,
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
              child: widget.child,
            )
          ],
        ),
      );
}