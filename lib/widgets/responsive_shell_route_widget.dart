
import 'dart:async';

import 'package:drkwon/model/menu.dart';
import 'package:drkwon/pages/admin/message_model.dart';
import 'package:drkwon/riverpod_providers/admin_providers.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
import 'package:drkwon/pages/search/desktop_search_bar.dart';
import 'package:drkwon/widgets/app_drawer_widget.dart';
import 'package:drkwon/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  final Debouncer _debouncer = Debouncer();
  String _searchQuery = '';

 
 @override
  void dispose() 
  {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    //final showBanner = ref.watch(adminBannerProvider);
    //final authState = ref.watch(authNotifierProvider);

    return Scaffold
    (
      appBar: ResponsiveWidget.isMobile(context) ? _mobileAppBar() : _desktopAppBar(),

      drawer: ResponsiveWidget.isMobile(context) ? const Drawer(child: AppDrawerWidget(isMobile: true)) : null,

      body: Column
      (
        children: 
        [
          _adminBanner(ref),
          Expanded
          (
            child: ResponsiveWidget
            (
              mobile: buildMobile(),
              tablet: buildTablet(),
              desktop: buildDesktop(),
            ),
          )
        ]
      ),
    );



  }

  Widget buildMobile() => widget.child;

  Widget buildTablet() => Center
  ( 
    child: ConstrainedBox
    (
      constraints: BoxConstraints(maxWidth: 840),
      child: Row
      (
            children: 
            [
              const Expanded(flex: 2, child: AppDrawerWidget(isMobile: false)),
              Expanded
              (
                flex: 5,
                child: widget.child,
              ),
            ],
      )
    )
  );

  Widget buildDesktop() => Center
  (
    child: ConstrainedBox
    (
      constraints: BoxConstraints(maxWidth: 1600),
      child: Row
      (
        children: 
        [
          const Expanded(child: AppDrawerWidget(isMobile: false)),
          Expanded(flex: 3, child: buildBody()),
        ],
      )
    )
  );

  Widget buildBody() => Container
  (
        color: Colors.grey[200],
        //padding: const EdgeInsets.all(8.0),
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

  PreferredSizeWidget _mobileAppBar() 
  {
    return  AppBar
    (
      title: Row
      (
        children: 
        [
          Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Text('Optometrist Dr. S Kwon', style: TextStyle(fontSize: 16)),
              SizedBox
              (
                width: 200,
                child: Text
                (
                  routeTitles[widget.currentPath] ?? widget.currentPath,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis, // Adds "..." when text overflows
                  maxLines: 1, // Limits the text to a single line
                ),
              )
            ],
          ),
        ],
      ),
      actions: 
      [
        IconButton
        (
          icon: const Icon(Icons.search),
          onPressed: ()
          {
            //final currentPath = GoRouter.of(context).routeInformationProvider.value.uri.toString();
            if (widget.currentPath != '/search')
            {
              context.go
              (
                '/search',
                extra: 
                {
                  'onSearchChanged': (String query) 
                  {
                    print('Search query in parent: $query');
                    // Implement your search logic here
                  },
                  'onCancelSearch': () 
                  {
                    print('Search cancelled in parent');
                    // Implement any cancellation logic here
                  },

                  'previousPath' : widget.currentPath,
                  'device': 'mobile'
                },
              );
            }
          }
        ),
        IconButton(icon: Icon(Icons.person), onPressed: () => context.push('/profile')),
      ],
    );
  }
  //https://chat.deepseek.com/a/chat/s/39d82bae-d26c-4ffc-990a-137558b4cf09
  PreferredSizeWidget _desktopAppBar() 
  {
    return AppBar
    (
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Row
      (
        mainAxisAlignment: MainAxisAlignment.start,
        children: 
        [
          Image.asset('assets/images/logo.jpg', height: 40), // Logo
          SizedBox(width: 10),
          Text('Optometrist Dr. S Kwon  ', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal, color: Colors.black)),
          Expanded
          (
            child: Center
            (
              child: DesktopSearchBar
              (
                initialQuery: _searchQuery,
                onSearchChanged: (query) 
                {
                  _debouncer.run
                  (
                    () 
                    {
                      if (mounted && query.isNotEmpty) 
                      {
                        setState(() => _searchQuery = query);
                        context.go
                        (
                          '/search', 
                          extra: 
                          {
                            'query': query,
                            'previousPath': widget.currentPath,
                            'device': 'desktop'
                          },

                        );
                      }
                  });
                },
                onCancelSearch: () 
                {
                  if (mounted) 
                  {
                    setState(() => _searchQuery = '');
                    context.go(widget.currentPath);
                  }
                }
              )
            )
          )
        ],
      ),
    );
  }
  // See https://chat.deepseek.com/a/chat/s/c3ef9df0-f518-458f-9a0d-fbdfc47d4218
  Widget _adminBanner(WidgetRef ref) 
  {
    return Container
    (
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.blue[800],
      child: Row
      (
        children: 
        [
          const Icon(Icons.security, color: Colors.white),
          const SizedBox(width: 12),
          Expanded
          (
            child: Text
            (
              'System development is under construction',
              style: TextStyle
              (
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
              ),
            ),
          ),
          IconButton
          (
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => ref.read(adminBannerProvider.notifier).state = false,
          ),
        ],
      ),
    );
  }

  // See https://chat.deepseek.com/a/chat/s/c3ef9df0-f518-458f-9a0d-fbdfc47d4218
  Widget _buildMessages(WidgetRef ref) 
  {
    final messages = ref.watch(messageProvider);
    final authState = ref.watch(authNotifierProvider);

    return Column
    (
      children: 
      [
        for (final message in messages)
          Container
          (
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: _getMessageColor(message.type),
            child: Row
            (
              children: 
              [
                Icon(_getMessageIcon(message.type), color: Colors.white),
                const SizedBox(width: 12),
                Expanded
                (
                  child: Text
                  (
                    message.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (authState.isLoggedIn && authState.userType == 'admin')
                  IconButton
                  (
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => ref.read(messageProvider.notifier).removeMessage(message.id),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getMessageColor(MessageType type) 
  {

    switch (type) 
    {
      case MessageType.info:
        return Colors.blue;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.critical:
        return Colors.red;
    }
  }

  IconData _getMessageIcon(MessageType type) 
  {
    switch (type) 
    {
      case MessageType.info:
        return Icons.info;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.critical:
        return Icons.error;
    }
  }
}

// Debouncer class for Search
class Debouncer 
{
  final Duration duration;
  Timer? _timer;

  Debouncer({this.duration = const Duration(milliseconds: 500)});

  void run(void Function() callback) 
  {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void cancel() 
  {
    _timer?.cancel();
  }

  void dispose() 
  {
    cancel();
  }
}

/*
// Search handler
final _debouncer = Debouncer();
List<SearchResult> _searchResults = [];

void _debounceSearch(String query) async 
{
  _debouncer.call
  (
    () async 
    {
      if (query.isEmpty) 
      {
        setState(() => _searchResults = []);
        return;
      }
      
      final response = await http.get
      (
        Uri.parse('https://api.example.com/search?q=$query'),
      );
      
      if (response.statusCode == 200) 
      {
        setState
        (
          () 
          {
            _searchResults = jsonDecode(response.body);
          });
      }
    }
  );
}
*/
