
import 'package:drkwon/model/menu.dart';
import 'package:drkwon/pages/admin/message_model.dart';
import 'package:drkwon/riverpod_providers/admin_providers.dart';
import 'package:drkwon/riverpod_providers/auth_state_provider.dart';
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
 
  @override
  Widget build(BuildContext context) 
  {
    //final showBanner = ref.watch(adminBannerProvider);
    //final authState = ref.watch(authNotifierProvider);

    return Scaffold
    (
      appBar: ResponsiveWidget.isMobile(context) ? 
      AppBar(
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Optometrist Dr. S Kwon', style: TextStyle(fontSize: 16)),
                    Text(
                      routeTitles[widget.currentPath] ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            actions: 
            [
              IconButton(icon: Icon(Icons.person), onPressed: () => context.go('/profile')),
            ],
          )
          :
        AppBar
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
              Text('Optometrist Dr. S Kwon', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal, color: Colors.black)),
              Expanded
              (
                child: Center
                (
                  child: Text
                  (
                    routeTitles[widget.currentPath] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    overflow: TextOverflow.ellipsis, // Prevent overflow issues
                  )
                )
              )
            ],
          ),
        ),

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
      constraints: BoxConstraints(maxWidth: 1600),
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