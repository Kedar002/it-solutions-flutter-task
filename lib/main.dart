import 'package:flutter/material.dart';
import 'dart:js' as js;

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image and buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String imageUrl = '';
  bool isMenuVisible = false;

  void _updateImage() {
    setState(() {
      imageUrl = _controller.text;
    });
  }

  void _toggleFullScreen() {
    js.context.callMethod('eval', [
      "if (!document.fullscreenElement) { document.documentElement.requestFullscreen(); } else { document.exitFullscreen(); }"
    ]);
  }

  void _enterFullScreen() {
    js.context
        .callMethod('eval', ["document.documentElement.requestFullscreen();"]);
    _closeMenu();
  }

  void _exitFullScreen() {
    js.context.callMethod('eval', ["document.exitFullscreen();"]);
    _closeMenu();
  }

  void _toggleMenu() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }

  void _closeMenu() {
    setState(() {
      isMenuVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: _closeMenu,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GestureDetector(
                        onDoubleTap: _toggleFullScreen,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                            image: imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration:
                              const InputDecoration(hintText: 'Image URL'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _updateImage,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
            if (isMenuVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenu,
                  child: Container(
                    color: Colors.black54,
                  ),
                ),
              ),
            if (isMenuVisible)
              Positioned(
                right: 16,
                bottom: 80,
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: _enterFullScreen,
                      child: const Icon(Icons.fullscreen),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      onPressed: _exitFullScreen,
                      child: const Icon(Icons.fullscreen_exit),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        child: const Icon(Icons.add),
      ),
    );
  }
}
