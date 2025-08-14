import 'dart:html' as html;
import 'dart:convert';

typedef KakaoMessageCallback = void Function(Map<String, dynamic> data);

void registerKakaoMessageListener(KakaoMessageCallback onData) {
  html.window.onMessage.listen((event) {
    try {
      final data = event.data;
      if (data is Map && data['type'] == 'kakao_result') {
        final payload = data['payload'];
        if (payload is String && payload.isNotEmpty) {
          final parsed = _tryParseJson(payload);
          if (parsed != null) onData(parsed);
          return;
        }
        if (payload is Map) {
          onData(payload.cast<String, dynamic>());
          return;
        }
      }
      if (data is String && data.isNotEmpty) {
        final parsed = _tryParseJson(data);
        if (parsed != null && parsed.containsKey('address')) {
          onData(parsed);
          return;
        }
      }
    } catch (_) {}
  });
}

Map<String, dynamic>? _tryParseJson(String s) {
  try {
    final obj = jsonDecode(s);
    if (obj is Map) return obj.cast<String, dynamic>();
  } catch (_) {}
  return null;
}
