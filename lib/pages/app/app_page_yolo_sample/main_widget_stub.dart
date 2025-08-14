import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Stub for web or platforms where tflite is unsupported
const pageName = 'app_page_yolo_sample';

Widget Function(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child)
    pageTransitionsBuilder = (context, animation, secondaryAnimation, child) {
  return FadeTransition(opacity: animation, child: child);
};

class MainWidget extends StatelessWidget {
  const MainWidget({super.key, required this.goRouterState});
  final GoRouterState goRouterState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YOLO Sample (Stub)')),
      body: const Center(
        child: Text('이 샘플은 현재 플랫폼에서 지원되지 않습니다.'),
      ),
    );
  }
}
