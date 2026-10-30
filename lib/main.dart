import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF19B971),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const GreenLeafPreviewApp());
}

class GreenLeafPreviewApp extends StatelessWidget {
  const GreenLeafPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenLeaf Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF19C66B)),
      home: const MobilePreviewPage(),
    );
  }
}

class MobilePreviewPage extends StatefulWidget {
  const MobilePreviewPage({super.key});

  @override
  State<MobilePreviewPage> createState() => _MobilePreviewPageState();
}

class _MobilePreviewPageState extends State<MobilePreviewPage> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF6F6F8))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) { if (mounted) setState(() => _loading = false); },
        onWebResourceError: (error) {
          // Only report errors for the main document; incidental resources
          // should not replace an otherwise successfully loaded preview.
          if (error.isForMainFrame == true && mounted) {
            setState(() { _loading = false; _error = error.description; });
          }
        },
      ))
      ..loadFlutterAsset('assets/index.html');
  }

  Future<void> _handleBack() async {
    await _controller.runJavaScript('''
      (() => {
        const sheet = document.getElementById('modalOverlay');
        const conversation = document.getElementById('conversation');
        if (sheet?.classList.contains('show')) sheet.classList.remove('show');
        else if (conversation?.classList.contains('open')) conversation.classList.remove('open');
        else if (window.showPage) window.showPage('home');
      })();
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_loading && _error == null) _handleBack();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F8),
        body: SafeArea(
          child: Stack(children: [
            WebViewWidget(controller: _controller),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not open the preview: $_error', textAlign: TextAlign.center),
              )),
          ]),
        ),
      ),
    );
  }
}
