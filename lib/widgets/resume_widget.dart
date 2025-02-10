@JS() // ✅ Add this to enable JavaScript interop
library my_flutter_app; // ✅ Required for JS interop

import 'dart:convert';
import 'dart:js';
import 'dart:js_util' as js_util; // ✅ Import dart:js_util
import 'package:drkwon/riverpod_providers/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:js/js.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

// ✅ Expose a JavaScript function globally
@JS('updateFromJs')
external set _jsUpdateMessage(void Function(String message) f);

class ResumeWidget extends ConsumerStatefulWidget
{
  const ResumeWidget({super.key});

  @override
  ConsumerState<ResumeWidget> createState() => _ResumeWidgetState();
    
}

class _ResumeWidgetState extends ConsumerState<ResumeWidget>
{
  String _path = '/'; //This path is from html file

  late final WebViewController _controller;
  PlatformWebViewWidget? _webViewWidget; // Nullable to avoid LateInitializationError

  @override
  void initState() 
  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback
    (
      (_) 
      {
        _exposeToJs(); // ✅ Ensure it's registered after Flutter loads
      }
    );

    _initializeWebView();
  }

  void _initializeWebView() async 
  {
    String fileHtmlContent = await rootBundle.loadString('assets/htmls/resume.html');
    final encodedHtml = base64Encode(utf8.encode(fileHtmlContent));
    final String dataUrl = 'data:text/html;base64,$encodedHtml';

    _controller = WebViewController();
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

  void updateMessage(String path) 
  {
    setState
    (
      () 
      {
        _path = path;
        print("_path=$_path");
      }
    );
  }
  void _exposeToJs() 
  {
    // Make Dart function callable from JavaScript
    _jsUpdateMessage = allowInterop(updateMessage);
   

    // ✅ Explicitly attach the function to `window`
    js_util.setProperty(js_util.globalThis, 'updateFromJs', allowInterop(updateMessage));

    debugPrint("Dart function registered!");
  }

  @override
  Widget build(BuildContext context) 
  {
    return _webViewWidget != null
          ? _webViewWidget!.build(context) // Show WebView when ready
          : const Center(child: CircularProgressIndicator()); // Show loader until WebView is ready
  }
}