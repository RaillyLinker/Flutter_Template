// (external)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

// (inner_folder)
import 'main_widget.dart' as main_widget;

// (all)
import 'package:flutter_template/global_widgets/gw_slw_page_outer_frame.dart'
    as gw_slw_page_outer_frame;
import 'package:flutter_template/global_widgets/gw_sfw_wrapper.dart'
    as gw_sfw_wrapper;

// [위젯 비즈니스]

//------------------------------------------------------------------------------
class MainBusiness {
  // [CallBack 함수]
  // (inputVo 확인 콜백)
  // State 클래스의 initState 에서 실행 되며, Business 클래스의 initState 실행 전에 실행 됩니다.
  // 필수 정보 누락시 null 을 반환, null 이 반환 되었을 때는 inputError 가 true 가 됩니다.
  main_widget.InputVo? onCheckPageInputVo(
      {required GoRouterState goRouterState}) {
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
    urlTextFieldController.dispose();
    urlTextFieldFocus.dispose();
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

  final GlobalKey<gw_sfw_wrapper.SfwRefreshWrapperState> urlTextFieldAreaGk =
      GlobalKey();
  late BuildContext urlTextFieldContext;
  final TextEditingController urlTextFieldController = TextEditingController();
  final FocusNode urlTextFieldFocus = FocusNode();
  String? urlTextFieldErrorMsg;

  // [private 변수]

  //----------------------------------------------------------------------------
  // !!!비즈니스 함수는 이 곳에서 저장 하여 사용 하세요.!!!
  // [public 함수]
  // (메인 위젯 화면 갱신)
  late VoidCallback refreshUi;

  // (url 입력창에 텍스트가 입력될 때마다)
  void urlTextFieldOnChanged(String value) {
    urlTextFieldErrorMsg = null;
    urlTextFieldAreaGk.currentState?.refreshUi();
  }

  // (일반 열기)
  // 모바일에서 앱 자체로 실행됩니다.
  Future<void> launchUrlInAppAsync() async {
    String urlString = urlTextFieldController.text;

    if (urlString != "") {
      // 필요 값이 모두 충족 되었을 때
      urlTextFieldErrorMsg = null;
      urlTextFieldAreaGk.currentState?.refreshUi();

      // url 띄우기
      if (!await launchUrl(Uri.parse(urlString))) {
        throw Exception('$urlString 를 열 수 없습니다.');
      }
    } else {
      // 필요 값 미충족
      if (urlString == "") {
        urlTextFieldErrorMsg = "필수";
        urlTextFieldAreaGk.currentState?.refreshUi();
      }
    }
  }

  // (브라우저에서 열기)
  // 모바일에서도 브라우저로 실행됩니다.
  Future<void> launchUrlInBrowserAsync() async {
    String urlString = urlTextFieldController.text;

    if (urlString != "") {
      // 필요 값이 모두 충족 되었을 때
      urlTextFieldErrorMsg = null;
      urlTextFieldAreaGk.currentState?.refreshUi();

      // url 띄우기
      if (!await launchUrl(
        Uri.parse(urlString),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('$urlString 를 열 수 없습니다.');
      }
    } else {
      // 필요 값 미충족
      if (urlString == "") {
        urlTextFieldErrorMsg = "필수";
        urlTextFieldAreaGk.currentState?.refreshUi();
      }
    }
  }

  // [private 함수]
  void _doNothing() {}
}
