// (external)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// (inner_folder)
import 'main_widget.dart' as main_widget;

// (all)
import 'package:flutter_template/global_widgets/gw_slw_page_outer_frame.dart'
    as gw_slw_page_outer_frame;
import 'package:flutter_template/global_widgets/gw_sfw_wrapper.dart'
    as gw_sfw_wrapper;
import 'package:flutter_template/global_functions/gf_my_functions.dart'
    as gf_my_functions;
import 'package:flutter_template/repositories/network/apis/api_main_server.dart'
    as api_main_server;
import 'package:flutter_template/repositories/spws/spw_auth_info.dart'
    as spw_auth_info;
import 'package:flutter_template/dialogs/all/all_dialog_info/main_widget.dart'
    as all_dialog_info;
import 'package:flutter_template/dialogs/all/all_dialog_loading_spinner/main_widget.dart'
    as all_dialog_loading_spinner;
import 'package:flutter_template/pages/all/all_page_login/main_widget.dart'
    as all_page_login;
import 'package:flutter_template/pages/all/all_page_authorization_test_sample_list/main_widget.dart'
    as all_page_authorization_test_sample_list;

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
    hoveringTileViewModelList = getNewItemWidgetList();

    memberInfoViewModel = getMemberInfoVo();
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
    hoveringTileViewModelList = getNewItemWidgetList();
    hoveringTileViewModelListAreaGk.currentState?.refreshUi();

    memberInfoViewModel = getMemberInfoVo();
    memberInfoAreaGk.currentState?.refreshUi();
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

  final GlobalKey<gw_sfw_wrapper.SfwRefreshWrapperState>
      hoveringTileViewModelListAreaGk = GlobalKey();
  late BuildContext hoveringTileListAreaContext;
  List<HoveringListTileViewModel> hoveringTileViewModelList = [];

  // (멤버 정보)
  final GlobalKey<gw_sfw_wrapper.SfwRefreshWrapperState> memberInfoAreaGk =
      GlobalKey();
  late BuildContext memberInfoAreaContext;
  MemberInfoViewModel? memberInfoViewModel;

  // [private 변수]

  //----------------------------------------------------------------------------
  // !!!비즈니스 함수는 이 곳에서 저장 하여 사용 하세요.!!!
  // [public 함수]
  // (메인 위젯 화면 갱신)
  late VoidCallback refreshUi;

  // (현 상황에 맞는 아이템 리스트 반환)
  List<HoveringListTileViewModel> getNewItemWidgetList() {
    List<HoveringListTileViewModel> hoveringListTileViewModel = [];
    hoveringListTileViewModel.add(
      HoveringListTileViewModel(
          itemTitle: "인증 / 인가 네트워크 요청 테스트 샘플 리스트",
          itemDescription: "인증 / 인가 상태에서 네트워크 요청 및 응답 처리 테스트 샘플 리스트",
          onItemClicked: () {
            // 인증/인가 테스트 샘플 페이지로 이동
            mainContext
                .pushNamed(all_page_authorization_test_sample_list.pageName);
          }),
    );

    // 검증된 현재 회원 정보 가져오기 (비회원이라면 null)
    spw_auth_info.SharedPreferenceWrapperVo? nowauthInfo =
        gf_my_functions.getNowAuthInfo();

    if (nowauthInfo == null) {
      // 비 로그인 상태
      hoveringListTileViewModel.add(
        HoveringListTileViewModel(
            itemTitle: "로그인 페이지",
            itemDescription: "로그인 페이지로 이동합니다.",
            onItemClicked: () {
              // 계정 로그인 페이지로 이동
              mainContext.pushNamed(all_page_login.pageName);
            }),
      );
    } else {
      // 로그인 상태
      hoveringListTileViewModel.add(
        HoveringListTileViewModel(
            itemTitle: "로그아웃",
            itemDescription: "로그아웃 처리를 합니다.",
            onItemClicked: () async {
              GlobalKey<all_dialog_loading_spinner.MainWidgetState>
                  allDialogLoadingSpinnerStateGk = GlobalKey();

              showDialog(
                  barrierDismissible: false,
                  context: mainContext,
                  builder: (context) => all_dialog_loading_spinner.MainWidget(
                        key: allDialogLoadingSpinnerStateGk,
                        inputVo: all_dialog_loading_spinner.InputVo(
                            onDialogCreated: () async {}),
                      )).then((outputVo) {});

              // 검증된 현재 회원 정보 가져오기 (비회원이라면 null)
              spw_auth_info.SharedPreferenceWrapperVo? authInfo =
                  gf_my_functions.getNowAuthInfo();

              if (authInfo != null) {
                // 서버 Logout API 실행
                await api_main_server.deleteService1TkV1AuthLogoutAsync(
                    requestHeaderVo: api_main_server
                        .DeleteService1TkV1AuthLogoutAsyncRequestHeaderVo(
                            authorization:
                                "${authInfo.tokenType} ${authInfo.accessToken}"));

                // login_user_info SPW 비우기
                spw_auth_info.SharedPreferenceWrapper.set(value: null);
              }

              allDialogLoadingSpinnerStateGk.currentState?.mainBusiness
                  .closeDialog();

              // 화면 정보 갱신
              hoveringTileViewModelList = getNewItemWidgetList();
              hoveringTileViewModelListAreaGk.currentState?.refreshUi();

              memberInfoViewModel = null;
              memberInfoAreaGk.currentState?.refreshUi();
            }),
      );

      hoveringListTileViewModel.add(
        HoveringListTileViewModel(
            itemTitle: "인증 토큰 갱신",
            itemDescription: "인증 토큰을 갱신합니다.",
            onItemClicked: () async {
              GlobalKey<all_dialog_loading_spinner.MainWidgetState>
                  allDialogLoadingSpinnerStateGk = GlobalKey();

              showDialog(
                  barrierDismissible: false,
                  context: mainContext,
                  builder: (context) => all_dialog_loading_spinner.MainWidget(
                        key: allDialogLoadingSpinnerStateGk,
                        inputVo: all_dialog_loading_spinner.InputVo(
                            onDialogCreated: () async {}),
                      )).then((outputVo) {});

              // 검증된 현재 회원 정보 가져오기 (비회원이라면 null)
              spw_auth_info.SharedPreferenceWrapperVo? authInfo =
                  gf_my_functions.getNowAuthInfo();

              if (authInfo == null) {
                hoveringTileViewModelList = getNewItemWidgetList();
                hoveringTileViewModelListAreaGk.currentState?.refreshUi();

                memberInfoViewModel = null;
                memberInfoAreaGk.currentState?.refreshUi();
              } else {
                // 리플레시 토큰 만료 여부 확인
                bool isRefreshTokenExpired =
                    DateFormat("yyyy_MM_dd_'T'_HH_mm_ss_SSS_z")
                        .parse(authInfo.refreshTokenExpireWhen)
                        .isBefore(DateTime.now());

                if (isRefreshTokenExpired) {
                  // 리플래시 토큰이 사용 불가이므로 로그아웃 처리
                  // login_user_info SPW 비우기
                  spw_auth_info.SharedPreferenceWrapper.set(value: null);
                  allDialogLoadingSpinnerStateGk.currentState?.mainBusiness
                      .closeDialog();

                  hoveringTileViewModelList = getNewItemWidgetList();
                  hoveringTileViewModelListAreaGk.currentState?.refreshUi();

                  memberInfoViewModel = null;
                  memberInfoAreaGk.currentState?.refreshUi();
                } else {
                  var postReissueResponse =
                      await api_main_server.postService1TkV1AuthReissueAsync(
                          requestHeaderVo: api_main_server
                              .PostService1TkV1AuthReissueAsyncRequestHeaderVo(
                                  authorization:
                                      "${authInfo.tokenType} ${authInfo.accessToken}"),
                          requestBodyVo: api_main_server
                              .PostService1TkV1AuthReissueAsyncRequestBodyVo(
                                  refreshToken:
                                      "${authInfo.tokenType} ${authInfo.refreshToken}"));

                  // 네트워크 요청 결과 처리
                  if (postReissueResponse.dioException == null) {
                    // Dio 네트워크 응답
                    var networkResponseObjectOk =
                        postReissueResponse.networkResponseObjectOk!;

                    if (networkResponseObjectOk.responseStatusCode == 200) {
                      // 정상 응답

                      // 응답 Body
                      var postReissueResponseBody = networkResponseObjectOk
                              .responseBody! as api_main_server
                          .PostService1TkV1AuthReissueAsyncResponseBodyVo;

                      if (postReissueResponseBody.lockedOutputList != null) {
                        var lockedInfo =
                            postReissueResponseBody.lockedOutputList![0];

                        allDialogLoadingSpinnerStateGk
                            .currentState?.mainBusiness
                            .closeDialog();

                        // Dio 네트워크 에러
                        final GlobalKey<all_dialog_info.MainWidgetState>
                            allDialogInfoStateGk =
                            GlobalKey<all_dialog_info.MainWidgetState>();
                        if (!mainContext.mounted) return;
                        showDialog(
                            barrierDismissible: false,
                            context: mainContext,
                            builder: (context) => all_dialog_info.MainWidget(
                                  key: allDialogInfoStateGk,
                                  inputVo: all_dialog_info.InputVo(
                                    dialogTitle: "계정 정지",
                                    dialogContent: "회원님의 계정이\n"
                                        "관리자에 의해 정지되었습니다.\n"
                                        "계정 정리 시작 시간 : ${lockedInfo.lockStart}\n"
                                        "계정 정리 만료 시간 : ${lockedInfo.lockBefore}\n"
                                        "계정 정지 이유 :\n"
                                        "${lockedInfo.lockReason}",
                                    checkBtnTitle: "확인",
                                    onDialogCreated: () {},
                                  ),
                                ));
                        return;
                      }

                      // SPW 정보 갱신
                      authInfo.memberUid =
                          postReissueResponseBody.loggedInOutput!.memberUid;
                      authInfo.tokenType =
                          postReissueResponseBody.loggedInOutput!.tokenType;
                      authInfo.accessToken =
                          postReissueResponseBody.loggedInOutput!.accessToken;
                      authInfo.accessTokenExpireWhen = postReissueResponseBody
                          .loggedInOutput!.accessTokenExpireWhen;
                      authInfo.refreshToken =
                          postReissueResponseBody.loggedInOutput!.refreshToken;
                      authInfo.refreshTokenExpireWhen = postReissueResponseBody
                          .loggedInOutput!.refreshTokenExpireWhen;

                      spw_auth_info.SharedPreferenceWrapper.set(
                          value: authInfo);

                      allDialogLoadingSpinnerStateGk.currentState?.mainBusiness
                          .closeDialog();

                      hoveringTileViewModelList = getNewItemWidgetList();
                      hoveringTileViewModelListAreaGk.currentState?.refreshUi();

                      memberInfoViewModel = getMemberInfoVo();
                      memberInfoAreaGk.currentState?.refreshUi();
                    } else {
                      // 리플래시 토큰이 사용 불가이므로 로그아웃 처리
                      // login_user_info SPW 비우기
                      spw_auth_info.SharedPreferenceWrapper.set(value: null);

                      allDialogLoadingSpinnerStateGk.currentState?.mainBusiness
                          .closeDialog();

                      hoveringTileViewModelList = getNewItemWidgetList();
                      hoveringTileViewModelListAreaGk.currentState?.refreshUi();

                      memberInfoViewModel = null;
                      memberInfoAreaGk.currentState?.refreshUi();
                    }
                  } else {
                    allDialogLoadingSpinnerStateGk.currentState?.mainBusiness
                        .closeDialog();

                    // Dio 네트워크 에러
                    final GlobalKey<all_dialog_info.MainWidgetState>
                        allDialogInfoStateGk =
                        GlobalKey<all_dialog_info.MainWidgetState>();
                    if (!mainContext.mounted) return;
                    showDialog(
                        barrierDismissible: false,
                        context: mainContext,
                        builder: (context) => all_dialog_info.MainWidget(
                              key: allDialogInfoStateGk,
                              inputVo: all_dialog_info.InputVo(
                                dialogTitle: "네트워크 에러",
                                dialogContent: "네트워크 상태가 불안정합니다.\n다시 시도해주세요.",
                                checkBtnTitle: "확인",
                                onDialogCreated: () {},
                              ),
                            ));
                  }
                }
              }
            }),
      );
    }

    return hoveringListTileViewModel;
  }

  // (멤버 정보 반환)
  MemberInfoViewModel? getMemberInfoVo() {
    // 검증된 현재 회원 정보 가져오기 (비회원이라면 null)
    spw_auth_info.SharedPreferenceWrapperVo? authInfo =
        gf_my_functions.getNowAuthInfo();

    if (authInfo == null) {
      return null;
    } else {
      return MemberInfoViewModel(
        memberUid: authInfo.memberUid.toString(),
        tokenType: authInfo.tokenType.toString(),
        accessToken: authInfo.accessToken.toString(),
        accessTokenExpireWhen: authInfo.accessTokenExpireWhen.toString(),
        refreshToken: authInfo.refreshToken.toString(),
        refreshTokenExpireWhen: authInfo.refreshTokenExpireWhen.toString(),
      );
    }
  }

  // [private 함수]
  void _doNothing() {}
}

class HoveringListTileViewModel {
  HoveringListTileViewModel(
      {required this.itemTitle,
      required this.itemDescription,
      required this.onItemClicked});

  // [public 변수]
  final GlobalKey<gw_sfw_wrapper.SfwRefreshWrapperState> hoveringTileAreaGk =
      GlobalKey();
  late BuildContext hoveringTileAreaContext;
  bool isHovering = false;

  final String itemTitle;
  final String itemDescription;
  final void Function() onItemClicked;
}

class MemberInfoViewModel {
  const MemberInfoViewModel(
      {required this.memberUid,
      required this.tokenType,
      required this.accessToken,
      required this.accessTokenExpireWhen,
      required this.refreshToken,
      required this.refreshTokenExpireWhen});

  final String memberUid;
  final String tokenType;
  final String accessToken;
  final String accessTokenExpireWhen;
  final String refreshToken;
  final String refreshTokenExpireWhen;
}
