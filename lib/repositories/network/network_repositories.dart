// (external)
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// (all)
import 'apis/api_main_server.dart' as api_main_server;
import 'package:flutter_template/global_data/gd_const_config.dart'
    as gd_const_config;
import 'package:flutter_template/repositories/spws/spw_auth_member_info.dart'
    as spw_auth_member_info;

// [네트워크 요청 객체 파일]
// 네트워크 요청 객체 선언, 생성, 설정 파일
// 로컬 주소 사용시 윈도우 환경이라면 127.0.0.1, 그외 환경이라면 라우터 내의 ip 를 사용해야합니다.

// 요청 객체는 아래에 선언 및 초기 설정 이후, api_ dart 파일에서 사용됨

// -----------------------------------------------------------------------------
// !!!서버별 네트워크 요청 객체를 선언, 생성합니다.!!!
// (메인 서버 Dio)
var mainServerDio = Dio(BaseOptions(
    baseUrl: (gd_const_config.isDebugMode)
        // 개발 서버
        ? "http://127.0.0.1:8080"
        // 배포 서버
        : "http://127.0.0.1:8080",

    // 기본 타임아웃 설정
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),

    // Dio는 상태 코드가 200부터 299까지인 경우에만 응답 데이터를 받기에 그외에도 데이터를 받기 위한 설정
    receiveDataWhenStatusError: true,
    validateStatus: (status) {
      // 모든 status 를 에러로 인식하지 않도록 처리
      // 301, 1003 등의 코드는 여전히 에러로 인식하므로 일반적으로 사용되는 코드만 사용하도록 서버 측과의 협의가 필요
      return true;
    }));

// -----------------------------------------------------------------------------
// !!!네트워크 요청 객체에 대한 초기 설정을 해줍니다.!!!
// 아래 함수는 main 함수에서 실행됩니다.
void setDioObjects() {
  // (로깅 인터셉터 설정)
  if(gd_const_config.isDebugMode){
    mainServerDio.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }

  // (커스텀 인터셉터 설정)
  mainServerDio.interceptors.add(InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler handler) async {
    // (매 네트워크 요청마다 실행되어 여기를 거친 후 서버로 요청을 보냄)
    // 요청 경로 (ex : http://127.0.0.1:8080/tk/ra/test/request/post-request)
    // String requestPath = options.path;

    // 요청 헤더 (ex : {"Authorization" : "Bearer 12345"})
    // Map<String, dynamic> requestHeaderMap = options.headers;

    // 요청 바디 (ex : {"testBody" : "test text body"})
    // dynamic requestBody = options.data;

    // !!!매 네트워크 요청마다 수행할 로직 설정!!!

    // 서버로 요청 전송
    handler.next(options);
  }, onResponse:
      (Response<dynamic> response, ResponseInterceptorHandler handler) async {
    // (매 네트워크 응답이 왔을 때 실행되어 여기를 거친 후 요청을 보냈던 코드로 복귀)
    // 응답 코드 (ex : 200)
    // int? responseStatusCode = response.statusCode;

    // 응답 헤더 (ex : {"Authorization" : "Bearer 12345"})
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    // 응답 바디 (ex : {"testBody" : "test text body"})
    // dynamic responseBody = response.data;

    // !!!매 네트워크 응답마다 수행할 로직 설정!!!

    // (Authorization JWT 토큰 관련 처리)
    // 가정 : 서버는 RequestHeader 로 {"Authorization" : "Bearer aaaaaaaaaa"} 와 같이 JWT 를 보냈을 때는 토큰 적합성 검사를 합니다.
    // 만약 Authorization 헤더를 보내지 않았다면 적합성 검사를 하지 않습니다.
    // 적합성 검사 수행시 올바르지 않은 Authorization Token 이라면 responseHeader 로 {"api-result-code" : "a"} 가 반환이 되고,
    // 만료된 AccessToken 이라면 responseHeader 로 {"api-result-code", "b"} 가 반환이 됩니다.
    // 아래 인터셉터 로직의 결과로 로그인이 만료되었다면, spw_auth_member_info 가 null 로 변경됩니다.
    if (responseHeaderMap.containsKey("api-result-code")) {
      // JWT 토큰 관련 서버 에러 발생

      String apiResultCode = responseHeaderMap["api-result-code"][0];

      switch (apiResultCode) {
        case "a":
          {
            // 올바르지 않은 Authorization Token

            // login_user_info SSW 비우기 (= 로그아웃 처리)
            spw_auth_member_info.SharedPreferenceWrapper.set(value: null);

            // 호출 코드로 응답 전달
            handler.resolve(response);
            return;
          }
        case "b":
          {
            // Request Header 에 Authorization 입력시, 만료된 AccessToken. (reissue, logout API 는 제외)

            // 액세스 토큰 재발급
            spw_auth_member_info.SharedPreferenceWrapperVo? loginMemberInfo =
                spw_auth_member_info.SharedPreferenceWrapper.get();

            if (loginMemberInfo == null) {
              // 정상적으로 프로세스를 진행할 수 없으므로 그냥 스킵
              // 호출 코드로 응답 전달
              handler.next(response);
              return;
            } else {
              // 리플레시 토큰 만료 여부 확인
              bool isRefreshTokenExpired = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                  .parse(loginMemberInfo.refreshTokenExpireWhen)
                  .isBefore(DateTime.now());

              if (isRefreshTokenExpired) {
                // 리플래시 토큰이 사용 불가이므로 로그아웃 처리

                // login_user_info SSW 비우기 (= 로그아웃 처리)
                spw_auth_member_info.SharedPreferenceWrapper.set(value: null);

                // 호출 코드로 응답 전달
                handler.resolve(response);
                return;
              } else {
                // 리플레시 토큰 아직 만료되지 않음

                // 액세스 토큰 재발급 요청
                // onResponse 가 다시 실행 되어 handler.next 가 실행된 이후에 다시 여기로 복귀하는 것을 주의할것.
                var postReissueResponse =
                    await api_main_server.postService1TkV1AuthReissueAsync(
                        requestHeaderVo: api_main_server
                            .PostService1TkV1AuthReissueAsyncRequestHeaderVo(
                                authorization:
                                    "${loginMemberInfo.tokenType} ${loginMemberInfo.accessToken}"),
                        requestBodyVo: api_main_server
                            .PostService1TkV1AuthReissueAsyncRequestBodyVo(
                                refreshToken:
                                    "${loginMemberInfo.tokenType} ${loginMemberInfo.refreshToken}"));

                // 네트워크 요청 결과 처리
                if (postReissueResponse.dioException == null) {
                  // Dio 네트워크 응답
                  var networkResponseObjectOk =
                      postReissueResponse.networkResponseObjectOk!;

                  if (networkResponseObjectOk.responseStatusCode == 200) {
                    // 정상 응답

                    // 응답 Body
                    var postReissueResponseBody =
                        networkResponseObjectOk.responseBody! as api_main_server
                            .PostService1TkV1AuthReissueAsyncResponseBodyVo;

                    // SSW 정보 갱신
                    List<
                            spw_auth_member_info
                            .SharedPreferenceWrapperVoOAuth2Info>
                        myOAuth2ObjectList = [];
                    for (api_main_server
                        .PostReissueAsyncResponseBodyVoOAuth2Info myOAuth2
                        in postReissueResponseBody.myOAuth2List) {
                      myOAuth2ObjectList.add(spw_auth_member_info
                          .SharedPreferenceWrapperVoOAuth2Info(myOAuth2.uid,
                              myOAuth2.oauth2TypeCode, myOAuth2.oauth2Id));
                    }

                    List<
                            spw_auth_member_info
                            .SharedPreferenceWrapperVoProfileInfo>
                        myProfileList = [];
                    for (api_main_server
                        .PostReissueAsyncResponseBodyVoProfile myProfile
                        in postReissueResponseBody.myProfileList) {
                      myProfileList.add(spw_auth_member_info
                          .SharedPreferenceWrapperVoProfileInfo(myProfile.uid,
                              myProfile.imageFullUrl, myProfile.front));
                    }

                    List<
                        spw_auth_member_info
                        .SharedPreferenceWrapperVoEmailInfo> myEmailList = [];
                    for (api_main_server
                        .PostReissueAsyncResponseBodyVoEmail myEmail
                        in postReissueResponseBody.myEmailList) {
                      myEmailList.add(spw_auth_member_info
                          .SharedPreferenceWrapperVoEmailInfo(
                              uid: myEmail.uid,
                              emailAddress: myEmail.emailAddress,
                              isFront: myEmail.front));
                    }

                    List<
                            spw_auth_member_info
                            .SharedPreferenceWrapperVoPhoneInfo>
                        myPhoneNumberList = [];
                    for (api_main_server
                        .PostReissueAsyncResponseBodyVoPhone myPhone
                        in postReissueResponseBody.myPhoneNumberList) {
                      myPhoneNumberList.add(spw_auth_member_info
                          .SharedPreferenceWrapperVoPhoneInfo(
                              uid: myPhone.uid,
                              phoneNumber: myPhone.phoneNumber,
                              isFront: myPhone.front));
                    }

                    loginMemberInfo.memberUid =
                        postReissueResponseBody.memberUid;
                    loginMemberInfo.nickName = postReissueResponseBody.nickName;
                    loginMemberInfo.roleList = postReissueResponseBody.roleList;
                    loginMemberInfo.tokenType =
                        postReissueResponseBody.tokenType;
                    loginMemberInfo.accessToken =
                        postReissueResponseBody.accessToken;
                    loginMemberInfo.accessTokenExpireWhen =
                        postReissueResponseBody.accessTokenExpireWhen;
                    loginMemberInfo.refreshToken =
                        postReissueResponseBody.refreshToken;
                    loginMemberInfo.refreshTokenExpireWhen =
                        postReissueResponseBody.refreshTokenExpireWhen;
                    loginMemberInfo.myOAuth2List = myOAuth2ObjectList;
                    loginMemberInfo.myProfileList = myProfileList;
                    loginMemberInfo.myEmailList = myEmailList;
                    loginMemberInfo.myPhoneNumberList = myPhoneNumberList;
                    loginMemberInfo.authPasswordIsNull =
                        postReissueResponseBody.authPasswordIsNull;

                    spw_auth_member_info.SharedPreferenceWrapper.set(
                        value: loginMemberInfo);

                    // 새로운 AccessToken 으로 재요청
                    try {
                      // 기존 Authorization 헤더를 지우고, 이전 요청과 동일한 요청 수행
                      RequestOptions options = response.requestOptions;
                      options.headers.remove("Authorization");
                      options.headers["Authorization"] =
                          "${loginMemberInfo.tokenType} ${loginMemberInfo.accessToken}";
                      Response retryResponse = await mainServerDio.request(
                        options.path,
                        data: options.data,
                        options: Options(
                            method: options.method,
                            headers: options.headers,
                            contentType: options.contentType),
                      );

                      // 재요청이 정상 완료 되었으므로 결과를 본 request 코드에 넘겨주기
                      handler.resolve(retryResponse);
                      return;
                    } on DioException {
                      // 재요청 실패
                      handler.reject(DioException(
                          error: "Network Error",
                          requestOptions: RequestOptions()));
                      return;
                    }
                  } else {
                    var postReissueResponseHeader = networkResponseObjectOk
                            .responseHeaders! as api_main_server
                        .PostService1TkV1AuthReissueAsyncResponseHeaderVo;

                    // 비정상 응답
                    if (postReissueResponseHeader.apiResultCode == null) {
                      // 비정상 응답이면서 서버에서 에러 원인 코드가 전달되지 않았을 때
                      handler.reject(DioException(
                          error: "Network Error",
                          requestOptions: RequestOptions()));
                      return;
                    } else {
                      // 서버 지정 에러 코드를 전달 받았을 때
                      String apiResultCode =
                          postReissueResponseHeader.apiResultCode!;

                      switch (apiResultCode) {
                        case "1": // 탈퇴된 회원
                        case "2": // 유효하지 않은 리프레시 토큰
                        case "3": // 리프레시 토큰 만료
                        case "4": // 리프레시 토큰이 액세스 토큰과 매칭되지 않음
                          {
                            // 리플래시 토큰이 사용 불가이므로 로그아웃 처리

                            // login_user_info SSW 비우기 (= 로그아웃 처리)
                            spw_auth_member_info.SharedPreferenceWrapper.set(
                                value: null);

                            // 호출 코드로 응답 전달
                            handler.resolve(response);
                            return;
                          }
                        default:
                          {
                            // 알 수 없는 코드일 때
                            handler.reject(DioException(
                                error: "Network Error",
                                requestOptions: RequestOptions()));
                            return;
                          }
                      }
                    }
                  }
                } else {
                  // Dio 네트워크 에러
                  handler.reject(DioException(
                      error: "Network Error",
                      requestOptions: RequestOptions()));
                  return;
                }
              }
            }
          }
        default:
          {
            // 처리할 필요가 없는 에러 코드
            // 호출 코드로 응답 전달
            handler.next(response);
            return;
          }
      }
    } else {
      // JWT 토큰 관련 정보가 반환되는 서버의 신호가 없음
      // 호출 코드로 응답 전달
      handler.next(response);
      return;
    }
  }));
}
