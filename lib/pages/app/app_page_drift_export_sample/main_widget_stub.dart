import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Stub for web where file I/O export/import is unsupported
const pageName = 'app_page_drift_export_sample';

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
      appBar: AppBar(title: const Text('Drift Export (Stub)')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('이 샘플은 웹에서 파일 시스템 접근이 제한되어 스텁 화면으로 대체됩니다.'),
        ),
      ),
    );
  }
}
