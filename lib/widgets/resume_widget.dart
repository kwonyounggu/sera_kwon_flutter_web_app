//import 'package:drkwon/data/resume_data.dart';
import 'dart:convert';

import 'package:drkwon/riverpod_providers/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';


class ResumeWidget extends ConsumerStatefulWidget
{
  const ResumeWidget({super.key});

  @override
  ConsumerState<ResumeWidget> createState() => _ResumeWidgetState();
    
}

class _ResumeWidgetState extends ConsumerState<ResumeWidget>
{
  /*
  final PlatformWebViewController _controller = PlatformWebViewController
  (
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest
  (
      LoadRequestParams
      (
        uri: Uri.parse('https://google.com'),
      ),
  );
  @override
  void initState() 
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    return  PlatformWebViewWidget
      (
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context);
  }
  */

  late final WebViewController _controller;
  PlatformWebViewWidget? _webViewWidget; // Nullable to avoid LateInitializationError

  @override
  void initState() 
  {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() async 
  {
    String fileHtmlContent = await rootBundle.loadString('assets/htmls/resume.html');
    final encodedHtml = base64Encode(utf8.encode(fileHtmlContent));
    final String dataUrl = 'data:text/html;base64,$encodedHtml';

    _controller = WebViewController();

    // Enable JavaScript
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    // Listen for JavaScript messages (From `window.navigator.postMessage('/home')`)
    _controller.addJavaScriptChannel
    (
      'postMessage',
      onMessageReceived: (JavaScriptMessage message) 
      {
        final String route = message.message;
        if (mounted) 
        {
          logger.d("here route: $route");
          //context.go(route); // Navigate in Flutter using GoRouter
        }
      },
    );
    await _controller.loadRequest(Uri.parse(dataUrl));

    final PlatformWebViewControllerCreationParams params = const PlatformWebViewControllerCreationParams();

    final PlatformWebViewController platformController = PlatformWebViewController(params);

    

    
    
    
    await platformController.loadRequest(LoadRequestParams(uri: Uri.parse(dataUrl)));

    final PlatformWebViewWidgetCreationParams widgetParams = PlatformWebViewWidgetCreationParams(controller: platformController);

    setState
    (
      () 
      {
        _webViewWidget = PlatformWebViewWidget(widgetParams);
      }
    ); // Trigger rebuild to display WebView
  }

  @override
  Widget build(BuildContext context) 
  {
    return _webViewWidget != null
          ? _webViewWidget!.build(context) // Show WebView when ready
          : const Center(child: CircularProgressIndicator()); // Show loader until WebView is ready
  }
}