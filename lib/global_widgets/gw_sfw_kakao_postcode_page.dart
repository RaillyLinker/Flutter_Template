import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter_template/global_functions/web_message_bridge_stub.dart'
    if (dart.library.html) 'package:flutter_template/global_functions/web_message_bridge_web.dart';

class GwSfwKakaoPostcodePage extends StatefulWidget {
  const GwSfwKakaoPostcodePage({Key? key}) : super(key: key);

  @override
  State<GwSfwKakaoPostcodePage> createState() => _GwSfwKakaoPostcodePageState();
}

class _GwSfwKakaoPostcodePageState extends State<GwSfwKakaoPostcodePage> {
  late InAppWebViewController _controller;
  PullToRefreshController? _pullToRefreshController;
  bool _popped = false;
  HttpServer? _server; // Windows용 로컬 서버
  String? _serverUrl; // 예: http://127.0.0.1:PORT/index
  bool _controllerReady = false;
  Timer? _pollTimer; // Windows 폴링

  void _safePop(Map<String, dynamic> data, {String via = '', bool deferToFrame = true}) {
    if (_popped || !mounted) return;
    _popped = true;
    debugPrint('[Kakao] popping via: ' + via);
    if (deferToFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop<Map<String, dynamic>>(context, data);
        }
      });
    } else {
      Navigator.pop<Map<String, dynamic>>(context, data);
    }
  }

  @override
  void initState() {
    super.initState();

    // 모바일(Android/iOS)에서만 PullToRefresh 사용
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      _pullToRefreshController = PullToRefreshController(
        onRefresh: () async {
          _controller.reload();
        },
      );
    }

    // Windows에서 about:blank/data URL 기원 문제를 회피하기 위해 로컬 HTTP 서버 사용
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      _startLocalServer();
      _startWindowsPolling();
    }
  }

  void _startWindowsPolling() {
    // 주기적으로 window.name 또는 전역 변수(__kakaoPayload)를 확인하여 결과 회수
    _pollTimer?.cancel();
    final intervalMs = kIsWeb ? 50 : 200;
    _pollTimer = Timer.periodic(Duration(milliseconds: intervalMs), (t) async {
      if (!mounted || _popped || !_controllerReady) return;
      try {
        // Web에서는 localStorage만 확인하여 중복 pop을 방지
        if (!kIsWeb) {
          // document.title 확인 (kakao_result:...)
          final titleRes = await _controller.evaluateJavascript(
            source: 'document.title || ""',
          );
          if (titleRes is String && titleRes.startsWith('kakao_result:')) {
            final enc = titleRes.substring('kakao_result:'.length);
            final jsonStr = Uri.decodeComponent(enc);
            final data = jsonDecode(jsonStr);
            _safePop(data, via: 'poll:title');
            return;
          }

          // location.hash 확인 (#kakao_result=...)
          final hashRes = await _controller.evaluateJavascript(
            source: 'location.hash || ""',
          );
          if (hashRes is String && hashRes.startsWith('#kakao_result=')) {
            final enc = hashRes.substring('#kakao_result='.length);
            final jsonStr = Uri.decodeComponent(enc);
            final data = jsonDecode(jsonStr);
            _safePop(data, via: 'poll:payload');
            return;
          }

          // window.name 확인
          final nameRes = await _controller.evaluateJavascript(
            source: 'window.name || ""',
          );
          if (nameRes is String && nameRes.startsWith('kakao_result:')) {
            final enc = nameRes.substring('kakao_result:'.length);
            final jsonStr = Uri.decodeComponent(enc);
            final data = jsonDecode(jsonStr);
            _safePop(data, via: 'poll:name');
            return;
          }
          // 전역 변수 확인
          final payloadRes = await _controller.evaluateJavascript(
            source: 'window.__kakaoPayload || null',
          );
          if (payloadRes is String && payloadRes.isNotEmpty) {
            final data = jsonDecode(payloadRes);
            _safePop(data, via: 'poll:payload');
            return;
          }
        }
        // Web: localStorage 검사
        if (kIsWeb) {
          final ls = await _controller.evaluateJavascript(
            source: 'localStorage.getItem("kakao_result")',
          );
          if (ls is String && ls.isNotEmpty) {
            final data = jsonDecode(ls);
            // 재발화 방지
            await _controller.evaluateJavascript(
              source: 'localStorage.removeItem("kakao_result")',
            );
            _safePop(data, via: 'poll:localStorage');
            return;
          }
        }
      } catch (_) {
        // ignore polling errors
      }
    });
  }

  Future<void> _startLocalServer() async {
    try {
      final srv = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      _server = srv;
      final port = srv.port;
      _serverUrl = 'http://127.0.0.1:$port/index';

      // 미리 HTML 로드
      final htmlData = await rootBundle.loadString(
        'lib/assets/web/kakao_postcode.html',
      );
      srv.listen((HttpRequest req) async {
        try {
          if (req.uri.path == '/index') {
            req.response.headers.contentType = ContentType(
              'text',
              'html',
              charset: 'utf-8',
            );
            req.response.write(htmlData);
            await req.response.close();
          } else {
            req.response.statusCode = HttpStatus.notFound;
            await req.response.close();
          }
        } catch (_) {
          try {
            await req.response.close();
          } catch (_) {}
        }
      });
      if (mounted) {
        // 컨트롤러가 이미 준비된 경우 바로 로드
        try {
          await _controller.loadUrl(
            urlRequest: URLRequest(url: WebUri(_serverUrl!)),
          );
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('[Kakao] Failed to start local server: $e');
    }
  }

  @override
  void dispose() {
    try {
      _pollTimer?.cancel();
    } catch (_) {}
    try {
      _server?.close(force: true);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("주소 검색")),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('lib/assets/web/kakao_postcode.html'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final htmlData = snapshot.data!;
          return InAppWebView(
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              // Android 전용 설정도 Settings로 통합됨
              useHybridComposition: true,
            ),
            pullToRefreshController: _pullToRefreshController,
            onWebViewCreated: (controller) async {
              _controller = controller;
              _controllerReady = true;
              // JS -> Flutter 브릿지 (Web 미지원: addJavaScriptHandler는 Web에서 미구현)
              if (!kIsWeb) {
                _controller.addJavaScriptHandler(
                  handlerName: 'SendMessage',
                  callback: (args) {
                    try {
                      final data = jsonDecode(args.first);
                      _safePop(data, via: 'handler:SendMessage');
                    } catch (_) {
                      _safePop({'raw': args}, via: 'handler:SendMessage(raw)');
                    }
                  },
                );
              }

              // Web에서는 폴링 기반으로 결과 회수
              if (kIsWeb) {
                _startWindowsPolling();
                // 추가: window.postMessage 수신 즉시 pop
                registerKakaoMessageListener((data) async {
                  if (_popped || !mounted) return;
                  try {
                    // 중복 방지: localStorage 값 제거 시도
                    await _controller.evaluateJavascript(
                      source:
                          'try{localStorage.removeItem("kakao_result")}catch(e){}',
                    );
                  } catch (_) {}
                  // Web에서는 postMessage 수신 즉시 pop하여 지연 최소화
                  _safePop(data, via: 'postMessage', deferToFrame: false);
                });
              }

              // 플랫폼별 로드 방식 분기
              if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
                // 로컬 서버 URL로 로드 (정상적인 http origin 확보)
                if (_serverUrl != null) {
                  await _controller.loadUrl(
                    urlRequest: URLRequest(url: WebUri(_serverUrl!)),
                  );
                } else {
                  // 서버 준비 전이라면 약간 지연 후 재시도
                  Future.delayed(const Duration(milliseconds: 100), () async {
                    if (mounted && _serverUrl != null) {
                      try {
                        await _controller.loadUrl(
                          urlRequest: URLRequest(url: WebUri(_serverUrl!)),
                        );
                      } catch (_) {}
                    }
                  });
                }
              } else if (kIsWeb) {
                // Web: 앱 자산 URL로 직접 로드 (동일 오리진 확보)
                await _controller.loadUrl(
                  urlRequest: URLRequest(
                    url: WebUri("/assets/lib/assets/web/kakao_postcode.html"),
                  ),
                );
              } else {
                // 모바일 등: data 로드 + baseUrl 지정
                await _controller.loadData(
                  data: htmlData,
                  baseUrl: WebUri("https://t1.daumcdn.net"),
                  mimeType: "text/html",
                  encoding: "utf-8",
                );
              }
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final req = navigationAction.request;
              final u = req.url;
              // Web: 내부 네비게이션은 허용 (우리가 parent hash/title 변경을 막았으므로 안전)
              if (kIsWeb) {
                return NavigationActionPolicy.ALLOW;
              }
              if (u != null &&
                  (u.scheme == 'kakao' || u.scheme == 'postmessage')) {
                try {
                  // 예: kakao://send?payload=<urlencoded json>
                  final qp = u.queryParameters;
                  final payload = qp['payload'];
                  if (payload != null && payload.isNotEmpty) {
                    final decoded = Uri.decodeComponent(payload);
                    final data = jsonDecode(decoded);
                    _safePop(data, via: 'scheme:kakao|postmessage');
                  } else {
                    if (!_popped && mounted) {
                      _popped = true;
                      Navigator.pop<Map<String, dynamic>>(context, {
                        'rawUrl': u.toString(),
                      });
                    }
                  }
                } catch (_) {
                  if (!_popped && mounted) {
                    _popped = true;
                    Navigator.pop<Map<String, dynamic>>(context, {
                      'rawUrl': u.toString(),
                    });
                  }
                }
                return NavigationActionPolicy.CANCEL;
              }
              // HTTPS sentinel host fallback
              if (!kIsWeb && u != null && u.host == 'kakao.result.local') {
                try {
                  final frag = u.fragment; // e.g., kakao_result=%7B...%7D
                  if (frag.startsWith('kakao_result=')) {
                    final enc = frag.substring('kakao_result='.length);
                    final jsonStr = Uri.decodeComponent(enc);
                    final data = jsonDecode(jsonStr);
                    _safePop(data, via: 'visitedHistory');
                  }
                } catch (_) {}
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            onTitleChanged: (controller, title) {
              if (title == null) return;
              if (kIsWeb) return; // Web에서는 title 기반 pop 금지
              if (title.startsWith('kakao_result:')) {
                try {
                  final enc = title.substring('kakao_result:'.length);
                  final jsonStr = Uri.decodeComponent(enc);
                  final data = jsonDecode(jsonStr);
                  _safePop(data, via: 'https:sentinel');
                } catch (_) {
                  // ignore parsing errors
                }
              }
            },
            onLoadStart: (controller, url) {
              _pullToRefreshController?.beginRefreshing();
            },
            onLoadStop: (controller, url) {
              _pullToRefreshController?.endRefreshing();
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              if (kIsWeb) return; // Web에서는 hash 기반 pop 금지
              try {
                final u = url?.toString() ?? '';
                final idx = u.indexOf('#');
                if (idx >= 0) {
                  final frag = u.substring(idx + 1);
                  if (frag.startsWith('kakao_result=')) {
                    final enc = frag.substring('kakao_result='.length);
                    final jsonStr = Uri.decodeComponent(enc);
                    final data = jsonDecode(jsonStr);
                    if (!_popped && mounted) {
                      _popped = true;
                      Navigator.pop<Map<String, dynamic>>(context, data);
                    }
                  }
                }
              } catch (_) {
                // ignore
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              debugPrint(
                '[WebView][${consoleMessage.messageLevel}] ${consoleMessage.message}',
              );
              if (kIsWeb) return; // Web에서는 console 기반 pop 금지
              final msg = consoleMessage.message;
              const pfx = 'KAKAO_RESULT:';
              if (msg.startsWith(pfx)) {
                try {
                  final jsonStr = Uri.decodeComponent(
                    msg.substring(pfx.length),
                  );
                  final data = jsonDecode(jsonStr);
                  _safePop(data, via: 'console');
                } catch (_) {}
              }
            },
          );
        },
      ),
    );
  }
}
