// (external)
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// (all)
import 'apis/api_main_server.dart' as api_main_server;
import 'package:flutter_template/global_data/gd_const_config.dart'
    as gd_const_config;
import 'package:flutter_template/repositories/spws/spw_auth_info.dart'
    as spw_auth_info;

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
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),

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
  if (gd_const_config.isDebugMode) {
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
  mainServerDio.interceptors.add(
    InterceptorsWrapper(
      onRequest:
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
      },
      onResponse: (Response<dynamic> response,
          ResponseInterceptorHandler handler) async {
        // (매 네트워크 응답이 왔을 때 실행되어 여기를 거친 후 요청을 보냈던 코드로 복귀)
        // 응답 코드 (ex : 200)
        int? responseStatusCode = response.statusCode;

        // 응답 바디 (ex : {"testBody" : "test text body"})
        // dynamic responseBody = response.data;

        // !!!매 네트워크 응답마다 수행할 로직 설정!!!

        if (responseStatusCode == 401) {
          // 미인증 응답 신호 발생

          // (Authorization JWT 토큰 관련 처리)
          // 본 인터셉터를 통과한 API 는 401 코드가 발생했을 때, 로그인이 필요하다는 처리만 하면 되도록 처리 하였습니다.

          // 응답 헤더 (ex : {"Authorization" : "Bearer 12345"})
          Map<String, dynamic> responseHeaderMap = response.headers.map;

          // 가정 : 서버는 RequestHeaders 로 {"Authorization" : "Bearer aaaaaaaaaa"} 와 같이 JWT 를 보냈을 때는 토큰 적합성 검사를 하며,
          // 검사 결과에 대한 ResponseHeaders 에 "api-result-code" 라는 키로 결과 코드가 반환됩니다.
          // (api-result-code) - Nullable
          // 반환 안됨 : 인증 토큰을 입력하지 않았습니다. (로그인 필요)
          // 1 : Request Header 에 Authorization 키로 넣어준 토큰이 올바르지 않습니다. (재 로그인 필요)
          // 2 : Request Header 에 Authorization 키로 넣어준 토큰의 유효시간이 만료되었습니다. (Refresh Token 으로 재발급 필요)
          // 3 : Request Header 에 Authorization 키로 넣어준 토큰의 멤버가 탈퇴 된 상태입니다. (다른 계정으로 재 로그인 필요)
          // 4 : Request Header 에 Authorization 키로 넣어준 토큰이 로그아웃 처리된 상태입니다. (재 로그인 필요)
          if (responseHeaderMap.containsKey("api-result-code")) {
            // JWT 토큰 관련 서버 에러 발생
            String apiResultCode = responseHeaderMap["api-result-code"][0];

            switch (apiResultCode) {
              // 2 : Request Header 에 Authorization 키로 넣어준 토큰의 유효시간이 만료되었습니다. (Refresh Token 으로 재발급 필요)
              case "2":
                {
                  // 액세스 토큰 재발급
                  spw_auth_info.SharedPreferenceWrapperVo? authInfo =
                      spw_auth_info.SharedPreferenceWrapper.get();

                  if (authInfo == null) {
                    // 로그인 필요
                    handler.next(response);
                    return;
                  }

                  // 리플레시 토큰 만료 여부 확인
                  bool isRefreshTokenExpired =
                      DateFormat("yyyy_MM_dd_'T'_HH_mm_ss_SSS_z")
                          .parse(authInfo.refreshTokenExpireWhen)
                          .isBefore(DateTime.now());

                  if (isRefreshTokenExpired) {
                    // 리플래시 토큰이 사용 불가이므로 로그아웃 처리

                    // login_user_info SSW 비우기 (= 로그아웃 처리)
                    spw_auth_info.SharedPreferenceWrapper.set(value: null);
                    handler.next(response);
                    return;
                  }

                  // 리플레시 토큰 아직 만료되지 않음

                  // 액세스 토큰 재발급 요청
                  // onResponse 가 다시 실행 되어 handler.next 가 실행된 이후에 다시 여기로 복귀하는 것을 주의할것.
                  var postReissueResponse =
                      await api_main_server.postService1TkV1AuthReissueAsync(
                    requestHeaderVo: api_main_server
                        .PostService1TkV1AuthReissueAsyncRequestHeaderVo(
                            authorization:
                                "${authInfo.tokenType} ${authInfo.accessToken}"),
                    requestBodyVo: api_main_server
                        .PostService1TkV1AuthReissueAsyncRequestBodyVo(
                            refreshToken:
                                "${authInfo.tokenType} ${authInfo.refreshToken}"),
                  );

                  // 네트워크 요청 결과 처리
                  if (postReissueResponse.dioException != null) {
                    // Dio 네트워크 에러 발생
                    handler.reject(DioException(
                        error: "Network Error",
                        requestOptions: RequestOptions()));
                    return;
                  }

                  // Dio 네트워크 응답
                  var networkResponseObjectOk =
                      postReissueResponse.networkResponseObjectOk!;

                  if (networkResponseObjectOk.responseStatusCode == 200) {
                    // 정상 응답 = 새로운 토큰을 받아옴

                    // 응답 Body
                    var postReissueResponseBody =
                        networkResponseObjectOk.responseBody! as api_main_server
                            .PostService1TkV1AuthReissueAsyncResponseBodyVo;

                    // 새 토큰으로 SSW 정보 갱신
                    authInfo.memberUid = postReissueResponseBody.memberUid;
                    authInfo.tokenType = postReissueResponseBody.tokenType;
                    authInfo.accessToken = postReissueResponseBody.accessToken;
                    authInfo.accessTokenExpireWhen =
                        postReissueResponseBody.accessTokenExpireWhen;
                    authInfo.refreshToken =
                        postReissueResponseBody.refreshToken;
                    authInfo.refreshTokenExpireWhen =
                        postReissueResponseBody.refreshTokenExpireWhen;

                    spw_auth_info.SharedPreferenceWrapper.set(value: authInfo);

                    // 새로운 AccessToken 으로 재요청
                    try {
                      // 기존 Authorization 헤더를 지우고, 이전 요청과 동일한 요청 수행
                      RequestOptions options = response.requestOptions;
                      options.headers.remove("Authorization");
                      options.headers["Authorization"] =
                          "${authInfo.tokenType} ${authInfo.accessToken}";
                      Response retryResponse = await mainServerDio.request(
                        options.path,
                        data: options.data,
                        options: Options(
                          method: options.method,
                          headers: options.headers,
                          contentType: options.contentType,
                        ),
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
                  }

                  // reissue API 정상 처리 안됨
                  // login_user_info SSW 비우기 (= 로그아웃 처리)
                  spw_auth_info.SharedPreferenceWrapper.set(value: null);
                  handler.next(response);
                  return;
                }
              default:
                {
                  // 처리할 필요가 없는 401 결과 코드
                  // 1 : Request Header 에 Authorization 키로 넣어준 토큰이 올바르지 않습니다. (재 로그인 필요)
                  // 3 : Request Header 에 Authorization 키로 넣어준 토큰의 멤버가 탈퇴 된 상태입니다. (다른 계정으로 재 로그인 필요)
                  // 4 : Request Header 에 Authorization 키로 넣어준 토큰이 로그아웃 처리된 상태입니다. (재 로그인 필요)
                  // login_user_info SSW 비우기 (= 로그아웃 처리)
                  spw_auth_info.SharedPreferenceWrapper.set(value: null);
                  handler.next(response);
                  return;
                }
            }
          } else {
            // 반환 안됨 : 인증 토큰을 입력하지 않았습니다. (로그인 필요)
            handler.next(response);
            return;
          }
        }

        // 코드 401 이외일 경우에 대한 처리
        handler.next(response);
        return;
      },
    ),
  );
}
