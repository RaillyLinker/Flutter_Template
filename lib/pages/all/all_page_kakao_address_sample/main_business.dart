// (external)
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// (inner_folder)
import 'main_widget.dart' as main_widget;

// (all)
import 'package:flutter_template/global_widgets/gw_slw_page_outer_frame.dart'
    as gw_slw_page_outer_frame;

// [위젯 비즈니스]

//------------------------------------------------------------------------------
class MainBusiness {
  // [CallBack 함수]
  // (inputVo 확인 콜백)
  // State 클래스의 initState 에서 실행 되며, Business 클래스의 initState 실행 전에 실행 됩니다.
  // 필수 정보 누락시 null 을 반환, null 이 반환 되었을 때는 inputError 가 true 가 됩니다.
  main_widget.InputVo? onCheckPageInputVo({
    required GoRouterState goRouterState,
  }) {
    // !!!pageInputVo 체크!!!
    // ex :
    // if (!goRouterState.uri.queryParameters.containsKey("inputValueString")) {
    //   return null;
    // }

    // !!!PageInputVo 입력!!!
    return const main_widget.InputVo();
  }

  // (진입 최초 단 한번 실행) - 아직 위젯이 생성 되기 전
  void initState() {
    // !!!initState 로직 작성!!!
  }

  // (종료 시점 단 한번 실행)
  void dispose() {
    // !!!dispose 로직 작성!!!
  }

  // (최초 실행시 단 한번 실행) - 위젯 build 바로 직전, 모든 것이 준비 되었을 때
  void onCreate() {
    // !!!onCreate 로직 작성!!!
  }

  Future<void> onFocusGainedAsync() async {
    // !!!onFocusGainedAsync 로직 작성!!!
  }

  Future<void> onFocusLostAsync() async {
    // !!!onFocusLostAsync 로직 작성!!!
  }

  Future<void> onVisibilityGainedAsync() async {
    // !!!onVisibilityGainedAsync 로직 작성!!!
  }

  Future<void> onVisibilityLostAsync() async {
    // !!!onVisibilityLostAsync 로직 작성!!!
  }

  Future<void> onForegroundGainedAsync() async {
    // !!!onForegroundGainedAsync 로직 작성!!!
  }

  Future<void> onForegroundLostAsync() async {
    // !!!onForegroundLostAsync 로직 작성!!!
  }

  //----------------------------------------------------------------------------
  // !!!메인 위젯에서 사용할 변수는 이곳에서 저장하여 사용하세요.!!!
  // [public 변수]
  // (위젯 입력값)
  late main_widget.InputVo inputVo;

  // (페이지 pop 가능 여부 변수) - false 로 설정시 pop 불가
  bool canPop = true;

  // (입력값 미충족 여부)
  bool inputError = false;

  // (context 객체)
  late BuildContext mainContext;

  // (최초 실행 플래그)
  bool pageInitFirst = true;

  // (pageOutFrameBusiness)
  final gw_slw_page_outer_frame.SlwPageOuterFrameBusiness pageOutFrameBusiness =
      gw_slw_page_outer_frame.SlwPageOuterFrameBusiness();

  // Kakao 결과 저장
  Map<String, dynamic>? selectedAddress;

  // [private 변수]

  //----------------------------------------------------------------------------
  // !!!비즈니스 함수는 이 곳에서 저장 하여 사용 하세요.!!!
  // [public 함수]
  // (메인 위젯 화면 갱신)
  late VoidCallback refreshUi;

  // ----------------------------- ViewModel helpers ---------------------------
  String buildFullAddress(Map<String, dynamic> m) {
    final addressType = (m['addressType'] ?? '').toString();
    final road = (m['roadAddress'] ?? '').toString();
    final jibun = (m['jibunAddress'] ?? '').toString();
    final buildingName = (m['buildingName'] ?? '').toString();
    String base;
    if (addressType == 'R' && road.isNotEmpty) {
      base = road;
    } else if (jibun.isNotEmpty) {
      base = jibun;
    } else {
      base = road.isNotEmpty ? road : (m['address'] ?? '').toString();
    }
    if (buildingName.isNotEmpty) {
      base = '$base ($buildingName)';
    }
    return base;
  }

  List<MapEntry<String, String>> buildPrettyEntries(Map<String, dynamic> m) {
    String v(dynamic x) => (x ?? '').toString();
    final entries = <MapEntry<String, String>>[];
    final zonecode = v(m['zonecode']);
    final fullAddress = buildFullAddress(m);
    if (zonecode.isNotEmpty) entries.add(const MapEntry('우편번호', ''));
    entries.add(MapEntry('주소', fullAddress));
    final road = v(m['roadAddress']);
    final jibun = v(m['jibunAddress']);
    final detail = v(m['buildingName']);
    final sido = v(m['sido']);
    final sigungu = v(m['sigungu']);
    final bname = v(m['bname']);
    final roadname = v(m['roadname']);
    final addressType = v(m['addressType']);

    if (zonecode.isNotEmpty) entries.add(MapEntry('우편번호', zonecode));
    if (addressType.isNotEmpty) {
      entries.add(MapEntry('주소유형', addressType == 'R' ? '도로명' : '지번'));
    }
    if (detail.isNotEmpty) entries.add(MapEntry('건물명', detail));
    if (road.isNotEmpty) entries.add(MapEntry('도로명주소', road));
    if (jibun.isNotEmpty) entries.add(MapEntry('지번주소', jibun));
    if (sido.isNotEmpty) entries.add(MapEntry('시/도', sido));
    if (sigungu.isNotEmpty) entries.add(MapEntry('시/군/구', sigungu));
    if (bname.isNotEmpty) entries.add(MapEntry('법정동', bname));
    if (roadname.isNotEmpty) entries.add(MapEntry('도로명', roadname));
    return entries;
  }

  String stringify(dynamic v) {
    if (v == null) return 'null';
    if (v is String) return v;
    try {
      return const JsonEncoder.withIndent('  ').convert(v);
    } catch (_) {
      return v.toString();
    }
  }

  List<MapEntry<String, String>> buildAllEntries(Map<String, dynamic> m) {
    final list = <MapEntry<String, String>>[];
    for (final e in m.entries) {
      list.add(MapEntry(e.key, stringify(e.value)));
    }
    return list;
  }

  // [private 함수]
  void _doNothing() {}
}
