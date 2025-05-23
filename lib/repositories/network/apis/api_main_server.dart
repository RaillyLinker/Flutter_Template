// (external)
import 'package:dio/dio.dart';

// (all)
import 'package:flutter_template/global_functions/gf_template_functions.dart'
    as gf_template_functions;
import 'package:flutter_template/repositories/network/network_repositories.dart'
    as network_repositories;
import 'package:flutter_template/global_classes/gc_template_classes.dart'
    as gc_template_classes;
import 'package:flutter_template/global_data/gd_const_config.dart'
    as gd_const_config;

// [네트워크 API 파일]
// 하나의 Dio 에 대응하는 API 함수 모음 파일

//------------------------------------------------------------------------------
// (서버 Dio 객체)
// 본 파일은 하나의 서버에 대응하며, 사용할 서버 객체는 serverDioObject 에 할당하세요.
final _serverDioObject = network_repositories.mainServerDio;

// -----------------------------------------------------------------------------
// !!!네트워크 요청 함수 작성!!!

// (Get 요청 테스트 (Query Parameter))
Future<
        gc_template_classes.NetworkResponseObject<
            GetService1TkV1RequestTestGetRequestAsyncResponseHeaderVo,
            GetService1TkV1RequestTestGetRequestAsyncResponseBodyVo>>
    getService1TkV1RequestTestGetRequestAsync({
  required GetService1TkV1RequestTestGetRequestAsyncRequestQueryVo
      requestQueryVo,
}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/request-test/get-request";
  String prodServerUrl = "/service1/tk/v1/request-test/get-request";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestQueryParams["queryParamString"] = requestQueryVo.queryParamString;
  requestQueryParams["queryParamStringNullable"] =
      requestQueryVo.queryParamStringNullable;
  requestQueryParams["queryParamInt"] = requestQueryVo.queryParamInt;
  requestQueryParams["queryParamIntNullable"] =
      requestQueryVo.queryParamIntNullable;
  requestQueryParams["queryParamDouble"] = requestQueryVo.queryParamDouble;
  requestQueryParams["queryParamDoubleNullable"] =
      requestQueryVo.queryParamDoubleNullable;
  requestQueryParams["queryParamBoolean"] = requestQueryVo.queryParamBoolean;
  requestQueryParams["queryParamBooleanNullable"] =
      requestQueryVo.queryParamBooleanNullable;
  requestQueryParams["queryParamStringList"] =
      requestQueryVo.queryParamStringList;
  requestQueryParams["queryParamStringListNullable"] =
      requestQueryVo.queryParamStringListNullable;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1RequestTestGetRequestAsyncResponseHeaderVo responseHeader;
    GetService1TkV1RequestTestGetRequestAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        GetService1TkV1RequestTestGetRequestAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody = GetService1TkV1RequestTestGetRequestAsyncResponseBodyVo(
        queryParamString: responseBodyMap["queryParamString"],
        queryParamStringNullable: responseBodyMap["queryParamStringNullable"],
        queryParamInt: responseBodyMap["queryParamInt"],
        queryParamIntNullable: responseBodyMap["queryParamIntNullable"],
        queryParamDouble: responseBodyMap["queryParamDouble"],
        queryParamDoubleNullable: responseBodyMap["queryParamDoubleNullable"],
        queryParamBoolean: responseBodyMap["queryParamBoolean"],
        queryParamBooleanNullable: responseBodyMap["queryParamBooleanNullable"],
        queryParamStringList:
            List<String>.from(responseBodyMap["queryParamStringList"]),
        queryParamStringListNullable:
            (responseBodyMap["queryParamStringListNullable"] == null)
                ? null
                : List<String>.from(
                    responseBodyMap["queryParamStringListNullable"],
                  ),
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1RequestTestGetRequestAsyncRequestQueryVo {
  GetService1TkV1RequestTestGetRequestAsyncRequestQueryVo({
    required this.queryParamString,
    required this.queryParamStringNullable,
    required this.queryParamInt,
    required this.queryParamIntNullable,
    required this.queryParamDouble,
    required this.queryParamDoubleNullable,
    required this.queryParamBoolean,
    required this.queryParamBooleanNullable,
    required this.queryParamStringList,
    required this.queryParamStringListNullable,
  });

  String queryParamString; // String 쿼리 파라미터
  String? queryParamStringNullable; // String 쿼리 파라미터 Nullable
  int queryParamInt; // int 쿼리 파라미터
  int? queryParamIntNullable; // int 쿼리 파라미터 Nullable
  double queryParamDouble; // double 쿼리 파라미터
  double? queryParamDoubleNullable; // double 쿼리 파라미터 Nullable
  bool queryParamBoolean; // bool 쿼리 파라미터
  bool? queryParamBooleanNullable; // bool 쿼리 파라미터 Nullable
  List<String> queryParamStringList; // StringList 쿼리 파라미터
  List<String>? queryParamStringListNullable; // StringList 쿼리 파라미터 Nullable
}

class GetService1TkV1RequestTestGetRequestAsyncResponseHeaderVo {
  GetService1TkV1RequestTestGetRequestAsyncResponseHeaderVo();
}

class GetService1TkV1RequestTestGetRequestAsyncResponseBodyVo {
  GetService1TkV1RequestTestGetRequestAsyncResponseBodyVo({
    required this.queryParamString,
    required this.queryParamStringNullable,
    required this.queryParamInt,
    required this.queryParamIntNullable,
    required this.queryParamDouble,
    required this.queryParamDoubleNullable,
    required this.queryParamBoolean,
    required this.queryParamBooleanNullable,
    required this.queryParamStringList,
    required this.queryParamStringListNullable,
  });

  String queryParamString; // 입력한 String 쿼리 파라미터
  String? queryParamStringNullable; // 입력한 String 쿼리 파라미터 Nullable
  int queryParamInt; // 입력한 int 쿼리 파라미터
  int? queryParamIntNullable; // 입력한 int 쿼리 파라미터 Nullable
  double queryParamDouble; // 입력한 double 쿼리 파라미터
  double? queryParamDoubleNullable; // 입력한 double 쿼리 파라미터 Nullable
  bool queryParamBoolean; // 입력한 bool 쿼리 파라미터
  bool? queryParamBooleanNullable; // 입력한 bool 쿼리 파라미터 Nullable
  List<String> queryParamStringList; // 입력한 StringList 쿼리 파라미터
  List<String>? queryParamStringListNullable; // 입력한 StringList 쿼리 파라미터 Nullable

  @override
  String toString() {
    return "queryParamString : $queryParamString, "
        "queryParamStringNullable : $queryParamStringNullable, "
        "queryParamInt : $queryParamInt, "
        "queryParamIntNullable : $queryParamIntNullable, "
        "queryParamDouble : $queryParamDouble, "
        "queryParamDoubleNullable : $queryParamDoubleNullable, "
        "queryParamBoolean : $queryParamBoolean, "
        "queryParamBooleanNullable : $queryParamBooleanNullable, "
        "queryParamStringList : $queryParamStringList, "
        "queryParamStringListNullable : $queryParamStringListNullable";
  }
}

////
// (Post 요청 테스트 (Request Body))
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseHeaderVo,
            PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseBodyVo>>
    postService1TkV1RequestTestPostRequestApplicationJsonAsync({
  required PostService1TkV1RequestTestPostRequestApplicationJsonAsyncRequestBodyVo
      requestBodyVo,
}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl =
      "/service1/tk/v1/request-test/post-request-application-json";
  String prodServerUrl =
      "/service1/tk/v1/request-test/post-request-application-json";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestBody["requestBodyString"] = requestBodyVo.requestBodyString;
  requestBody["requestBodyStringNullable"] =
      requestBodyVo.requestBodyStringNullable;
  requestBody["requestBodyInt"] = requestBodyVo.requestBodyInt;
  requestBody["requestBodyIntNullable"] = requestBodyVo.requestBodyIntNullable;
  requestBody["requestBodyDouble"] = requestBodyVo.requestBodyDouble;
  requestBody["requestBodyDoubleNullable"] =
      requestBodyVo.requestBodyDoubleNullable;
  requestBody["requestBodyBoolean"] = requestBodyVo.requestBodyBoolean;
  requestBody["requestBodyBooleanNullable"] =
      requestBodyVo.requestBodyBooleanNullable;
  requestBody["requestBodyStringList"] = requestBodyVo.requestBodyStringList;
  requestBody["requestBodyStringListNullable"] =
      requestBodyVo.requestBodyStringListNullable;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(
          headers: requestHeaders,
        ),
        data: requestBody);

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody =
          PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseBodyVo(
        requestBodyString: responseBodyMap["requestBodyString"],
        requestBodyStringNullable: responseBodyMap["requestBodyStringNullable"],
        requestBodyInt: responseBodyMap["requestBodyInt"],
        requestBodyIntNullable: responseBodyMap["requestBodyIntNullable"],
        requestBodyDouble: responseBodyMap["requestBodyDouble"],
        requestBodyDoubleNullable: responseBodyMap["requestBodyDoubleNullable"],
        requestBodyBoolean: responseBodyMap["requestBodyBoolean"],
        requestBodyBooleanNullable:
            responseBodyMap["requestBodyBooleanNullable"],
        requestBodyStringList:
            List<String>.from(responseBodyMap["requestBodyStringList"]),
        requestBodyStringListNullable:
            (responseBodyMap["requestBodyStringListNullable"] == null)
                ? null
                : List<String>.from(
                    responseBodyMap["requestBodyStringListNullable"],
                  ),
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1RequestTestPostRequestApplicationJsonAsyncRequestBodyVo {
  PostService1TkV1RequestTestPostRequestApplicationJsonAsyncRequestBodyVo({
    required this.requestBodyString,
    required this.requestBodyStringNullable,
    required this.requestBodyInt,
    required this.requestBodyIntNullable,
    required this.requestBodyDouble,
    required this.requestBodyDoubleNullable,
    required this.requestBodyBoolean,
    required this.requestBodyBooleanNullable,
    required this.requestBodyStringList,
    required this.requestBodyStringListNullable,
  });

  String requestBodyString; // String 쿼리 파라미터
  String? requestBodyStringNullable; // String 쿼리 파라미터 Nullable
  int requestBodyInt; // int 쿼리 파라미터
  int? requestBodyIntNullable; // int 쿼리 파라미터 Nullable
  double requestBodyDouble; // double 쿼리 파라미터
  double? requestBodyDoubleNullable; // double 쿼리 파라미터 Nullable
  bool requestBodyBoolean; // bool 쿼리 파라미터
  bool? requestBodyBooleanNullable; // bool 쿼리 파라미터 Nullable
  List<String> requestBodyStringList; // StringList 쿼리 파라미터
  List<String>? requestBodyStringListNullable; // StringList 쿼리 파라미터 Nullable
}

class PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseHeaderVo {
  PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseHeaderVo();
}

class PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseBodyVo {
  PostService1TkV1RequestTestPostRequestApplicationJsonAsyncResponseBodyVo({
    required this.requestBodyString,
    required this.requestBodyStringNullable,
    required this.requestBodyInt,
    required this.requestBodyIntNullable,
    required this.requestBodyDouble,
    required this.requestBodyDoubleNullable,
    required this.requestBodyBoolean,
    required this.requestBodyBooleanNullable,
    required this.requestBodyStringList,
    required this.requestBodyStringListNullable,
  });

  String requestBodyString; // 입력한 String 쿼리 파라미터
  String? requestBodyStringNullable; // 입력한 String 쿼리 파라미터 Nullable
  int requestBodyInt; // 입력한 int 쿼리 파라미터
  int? requestBodyIntNullable; // 입력한 int 쿼리 파라미터 Nullable
  double requestBodyDouble; // 입력한 double 쿼리 파라미터
  double? requestBodyDoubleNullable; // 입력한 double 쿼리 파라미터 Nullable
  bool requestBodyBoolean; // 입력한 bool 쿼리 파라미터
  bool? requestBodyBooleanNullable; // 입력한 bool 쿼리 파라미터 Nullable
  List<String> requestBodyStringList; // 입력한 StringList 쿼리 파라미터
  List<String>?
      requestBodyStringListNullable; // 입력한 StringList 쿼리 파라미터 Nullable

  @override
  String toString() {
    return "requestBodyString : $requestBodyString, "
        "requestBodyStringNullable : $requestBodyStringNullable, "
        "requestBodyInt : $requestBodyInt, "
        "requestBodyIntNullable : $requestBodyIntNullable, "
        "requestBodyDouble : $requestBodyDouble, "
        "requestBodyDoubleNullable : $requestBodyDoubleNullable, "
        "requestBodyBoolean : $requestBodyBoolean, "
        "requestBodyBooleanNullable : $requestBodyBooleanNullable, "
        "requestBodyStringList : $requestBodyStringList, "
        "requestBodyStringListNullable : $requestBodyStringListNullable";
  }
}

////
// (Post 요청 테스트 (x-www-form-urlencoded))
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseHeaderVo,
            PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseBodyVo>>
    postService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsync(
        {required PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl =
      "/service1/tk/v1/request-test/post-request-x-www-form-urlencoded";
  String prodServerUrl =
      "/service1/tk/v1/request-test/post-request-x-www-form-urlencoded";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestBody["requestFormString"] = requestBodyVo.requestFormString;
  requestBody["requestFormStringNullable"] =
      requestBodyVo.requestFormStringNullable;
  requestBody["requestFormInt"] = requestBodyVo.requestFormInt;
  requestBody["requestFormIntNullable"] = requestBodyVo.requestFormIntNullable;
  requestBody["requestFormDouble"] = requestBodyVo.requestFormDouble;
  requestBody["requestFormDoubleNullable"] =
      requestBodyVo.requestFormDoubleNullable;
  requestBody["requestFormBoolean"] = requestBodyVo.requestFormBoolean;
  requestBody["requestFormBooleanNullable"] =
      requestBodyVo.requestFormBooleanNullable;
  requestBody["requestFormStringList"] = requestBodyVo.requestFormStringList;
  requestBody["requestFormStringListNullable"] =
      requestBodyVo.requestFormStringListNullable;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(
            headers: requestHeaders,
            contentType: Headers.formUrlEncodedContentType),
        data: requestBody);

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody =
          PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseBodyVo(
        requestFormString: responseBodyMap["requestFormString"],
        requestFormStringNullable: responseBodyMap["requestFormStringNullable"],
        requestFormInt: responseBodyMap["requestFormInt"],
        requestFormIntNullable: responseBodyMap["requestFormIntNullable"],
        requestFormDouble: responseBodyMap["requestFormDouble"],
        requestFormDoubleNullable: responseBodyMap["requestFormDoubleNullable"],
        requestFormBoolean: responseBodyMap["requestFormBoolean"],
        requestFormBooleanNullable:
            responseBodyMap["requestFormBooleanNullable"],
        requestFormStringList:
            List<String>.from(responseBodyMap["requestFormStringList"]),
        requestFormStringListNullable:
            (responseBodyMap["requestFormStringListNullable"] == null)
                ? null
                : List<String>.from(
                    responseBodyMap["requestFormStringListNullable"],
                  ),
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncRequestBodyVo {
  PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncRequestBodyVo({
    required this.requestFormString,
    required this.requestFormStringNullable,
    required this.requestFormInt,
    required this.requestFormIntNullable,
    required this.requestFormDouble,
    required this.requestFormDoubleNullable,
    required this.requestFormBoolean,
    required this.requestFormBooleanNullable,
    required this.requestFormStringList,
    required this.requestFormStringListNullable,
  });

  String requestFormString; // String 쿼리 파라미터
  String? requestFormStringNullable; // String 쿼리 파라미터 Nullable
  int requestFormInt; // int 쿼리 파라미터
  int? requestFormIntNullable; // int 쿼리 파라미터 Nullable
  double requestFormDouble; // double 쿼리 파라미터
  double? requestFormDoubleNullable; // double 쿼리 파라미터 Nullable
  bool requestFormBoolean; // bool 쿼리 파라미터
  bool? requestFormBooleanNullable; // bool 쿼리 파라미터 Nullable
  List<String> requestFormStringList; // StringList 쿼리 파라미터
  List<String>? requestFormStringListNullable; // StringList 쿼리 파라미터 Nullable
}

class PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseHeaderVo {
  PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseHeaderVo();
}

class PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseBodyVo {
  PostService1TkV1RequestTestPostRequestXWwwFromUrlencodedAsyncResponseBodyVo({
    required this.requestFormString,
    required this.requestFormStringNullable,
    required this.requestFormInt,
    required this.requestFormIntNullable,
    required this.requestFormDouble,
    required this.requestFormDoubleNullable,
    required this.requestFormBoolean,
    required this.requestFormBooleanNullable,
    required this.requestFormStringList,
    required this.requestFormStringListNullable,
  });

  String requestFormString; // 입력한 String 쿼리 파라미터
  String? requestFormStringNullable; // 입력한 String 쿼리 파라미터 Nullable
  int requestFormInt; // 입력한 int 쿼리 파라미터
  int? requestFormIntNullable; // 입력한 int 쿼리 파라미터 Nullable
  double requestFormDouble; // 입력한 double 쿼리 파라미터
  double? requestFormDoubleNullable; // 입력한 double 쿼리 파라미터 Nullable
  bool requestFormBoolean; // 입력한 bool 쿼리 파라미터
  bool? requestFormBooleanNullable; // 입력한 bool 쿼리 파라미터 Nullable
  List<String> requestFormStringList; // 입력한 StringList 쿼리 파라미터
  List<String>?
      requestFormStringListNullable; // 입력한 StringList 쿼리 파라미터 Nullable

  @override
  String toString() {
    return "requestFormString : $requestFormString, "
        "requestFormStringNullable : $requestFormStringNullable, "
        "requestFormInt : $requestFormInt, "
        "requestFormIntNullable : $requestFormIntNullable, "
        "requestFormDouble : $requestFormDouble, "
        "requestFormDoubleNullable : $requestFormDoubleNullable, "
        "requestFormBoolean : $requestFormBoolean, "
        "requestFormBooleanNullable : $requestFormBooleanNullable, "
        "requestFormStringList : $requestFormStringList, "
        "requestFormStringListNullable : $requestFormStringListNullable";
  }
}

////
// (Post 요청 테스트 (multipart/form-data))
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseHeaderVo,
            PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseBodyVo>>
    postService1TkV1RequestTestPostRequestMultipartFormDataAsync(
        {required PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl =
      "/service1/tk/v1/request-test/post-request-multipart-form-data";
  String prodServerUrl =
      "/service1/tk/v1/request-test/post-request-multipart-form-data";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestFormDataMap = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestFormDataMap["requestFormString"] = requestBodyVo.requestFormString;
  if (requestBodyVo.requestFormStringNullable != null) {
    requestFormDataMap["requestFormStringNullable"] =
        requestBodyVo.requestFormStringNullable;
  }
  requestFormDataMap["requestFormInt"] = requestBodyVo.requestFormInt;
  if (requestBodyVo.requestFormIntNullable != null) {
    requestFormDataMap["requestFormIntNullable"] =
        requestBodyVo.requestFormIntNullable;
  }
  requestFormDataMap["requestFormDouble"] = requestBodyVo.requestFormDouble;
  if (requestBodyVo.requestFormDoubleNullable != null) {
    requestFormDataMap["requestFormDoubleNullable"] =
        requestBodyVo.requestFormDoubleNullable;
  }
  requestFormDataMap["requestFormBoolean"] = requestBodyVo.requestFormBoolean;
  if (requestBodyVo.requestFormBooleanNullable != null) {
    requestFormDataMap["requestFormBooleanNullable"] =
        requestBodyVo.requestFormBooleanNullable;
  }
  requestFormDataMap["requestFormStringList"] =
      requestBodyVo.requestFormStringList;
  if (requestBodyVo.requestFormStringListNullable != null) {
    requestFormDataMap["requestFormStringListNullable"] =
        requestBodyVo.requestFormStringListNullable;
  }
  requestFormDataMap["multipartFile"] = requestBodyVo.multipartFile;
  if (requestBodyVo.multipartFileNullable != null) {
    requestFormDataMap["multipartFileNullable"] =
        requestBodyVo.multipartFileNullable;
  }

  FormData requestBody = FormData.fromMap(requestFormDataMap);

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(headers: requestHeaders), data: requestBody);

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody =
          PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseBodyVo(
        requestFormString: responseBodyMap["requestFormString"],
        requestFormStringNullable: responseBodyMap["requestFormStringNullable"],
        requestFormInt: responseBodyMap["requestFormInt"],
        requestFormIntNullable: responseBodyMap["requestFormIntNullable"],
        requestFormDouble: responseBodyMap["requestFormDouble"],
        requestFormDoubleNullable: responseBodyMap["requestFormDoubleNullable"],
        requestFormBoolean: responseBodyMap["requestFormBoolean"],
        requestFormBooleanNullable:
            responseBodyMap["requestFormBooleanNullable"],
        requestFormStringList:
            List<String>.from(responseBodyMap["requestFormStringList"]),
        requestFormStringListNullable:
            (responseBodyMap["requestFormStringListNullable"] == null)
                ? null
                : List<String>.from(
                    responseBodyMap["requestFormStringListNullable"],
                  ),
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncRequestBodyVo {
  PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncRequestBodyVo({
    required this.requestFormString,
    required this.requestFormStringNullable,
    required this.requestFormInt,
    required this.requestFormIntNullable,
    required this.requestFormDouble,
    required this.requestFormDoubleNullable,
    required this.requestFormBoolean,
    required this.requestFormBooleanNullable,
    required this.requestFormStringList,
    required this.requestFormStringListNullable,
    required this.multipartFile,
    required this.multipartFileNullable,
  });

  String requestFormString; // String 쿼리 파라미터
  String? requestFormStringNullable; // String 쿼리 파라미터 Nullable
  int requestFormInt; // int 쿼리 파라미터
  int? requestFormIntNullable; // int 쿼리 파라미터 Nullable
  double requestFormDouble; // double 쿼리 파라미터
  double? requestFormDoubleNullable; // double 쿼리 파라미터 Nullable
  bool requestFormBoolean; // bool 쿼리 파라미터
  bool? requestFormBooleanNullable; // bool 쿼리 파라미터 Nullable
  List<String> requestFormStringList; // StringList 쿼리 파라미터
  List<String>? requestFormStringListNullable; // StringList 쿼리 파라미터 Nullable
  MultipartFile multipartFile; // 멀티 파트 파일
  MultipartFile? multipartFileNullable; // 멀티 파트 파일 Nullable
}

class PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseHeaderVo {
  PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseHeaderVo();
}

class PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseBodyVo {
  PostService1TkV1RequestTestPostRequestMultipartFormDataAsyncResponseBodyVo({
    required this.requestFormString,
    required this.requestFormStringNullable,
    required this.requestFormInt,
    required this.requestFormIntNullable,
    required this.requestFormDouble,
    required this.requestFormDoubleNullable,
    required this.requestFormBoolean,
    required this.requestFormBooleanNullable,
    required this.requestFormStringList,
    required this.requestFormStringListNullable,
  });

  String requestFormString; // 입력한 String 쿼리 파라미터
  String? requestFormStringNullable; // 입력한 String 쿼리 파라미터 Nullable
  int requestFormInt; // 입력한 int 쿼리 파라미터
  int? requestFormIntNullable; // 입력한 int 쿼리 파라미터 Nullable
  double requestFormDouble; // 입력한 double 쿼리 파라미터
  double? requestFormDoubleNullable; // 입력한 double 쿼리 파라미터 Nullable
  bool requestFormBoolean; // 입력한 bool 쿼리 파라미터
  bool? requestFormBooleanNullable; // 입력한 bool 쿼리 파라미터 Nullable
  List<String> requestFormStringList; // 입력한 StringList 쿼리 파라미터
  List<String>?
      requestFormStringListNullable; // 입력한 StringList 쿼리 파라미터 Nullable

  @override
  String toString() {
    return "requestFormString : $requestFormString, "
        "requestFormStringNullable : $requestFormStringNullable, "
        "requestFormInt : $requestFormInt, "
        "requestFormIntNullable : $requestFormIntNullable, "
        "requestFormDouble : $requestFormDouble, "
        "requestFormDoubleNullable : $requestFormDoubleNullable, "
        "requestFormBoolean : $requestFormBoolean, "
        "requestFormBooleanNullable : $requestFormBooleanNullable, "
        "requestFormStringList : $requestFormStringList, "
        "requestFormStringListNullable : $requestFormStringListNullable";
  }
}

////
// (Post 요청 테스트 (multipart/form-data - JsonString))
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseHeaderVo,
            PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseBodyVo>>
    postService1TkV1RequestTestPostRequestMultipartFormDataJsonAsync(
        {required PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl =
      "/service1/tk/v1/request-test/post-request-multipart-form-data-json";
  String prodServerUrl =
      "/service1/tk/v1/request-test/post-request-multipart-form-data-json";
  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  FormData requestBody;

  // !!!Request Object 를 Map 으로 만들기!!!
  if (requestBodyVo.multipartFileNullable == null) {
    requestBody = FormData.fromMap({
      "jsonString": requestBodyVo.jsonString,
      "multipartFile": requestBodyVo.multipartFile,
    });
  } else {
    requestBody = FormData.fromMap({
      "jsonString": requestBodyVo.jsonString,
      "multipartFile": requestBodyVo.multipartFile,
      "multipartFileNullable": requestBodyVo.multipartFileNullable,
    });
  }

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(headers: requestHeaders), data: requestBody);

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody =
          PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseBodyVo(
        requestFormString: responseBodyMap["requestFormString"],
        requestFormStringNullable: responseBodyMap["requestFormStringNullable"],
        requestFormInt: responseBodyMap["requestFormInt"],
        requestFormIntNullable: responseBodyMap["requestFormIntNullable"],
        requestFormDouble: responseBodyMap["requestFormDouble"],
        requestFormDoubleNullable: responseBodyMap["requestFormDoubleNullable"],
        requestFormBoolean: responseBodyMap["requestFormBoolean"],
        requestFormBooleanNullable:
            responseBodyMap["requestFormBooleanNullable"],
        requestFormStringList:
            List<String>.from(responseBodyMap["requestFormStringList"]),
        requestFormStringListNullable:
            (responseBodyMap["requestFormStringListNullable"] == null)
                ? null
                : List<String>.from(
                    responseBodyMap["requestFormStringListNullable"],
                  ),
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncRequestBodyVo {
  PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncRequestBodyVo({
    required this.jsonString,
    required this.multipartFile,
    required this.multipartFileNullable,
  });

  // "jsonString" 형식 :
  // {
  // "requestFormString" :	String, // String 바디 파라미터
  // "requestFormStringNullable" :	String?, // String 바디 파라미터 Nullable
  // "requestFormInt" : Int, // Int 바디 파라미터
  // "requestFormIntNullable" : Int?, // Int 바디 파라미터 Nullable
  // "requestFormDouble" : Double, // Double 바디 파라미터
  // "requestFormDoubleNullable" : Double?, // Double 바디 파라미터 Nullable
  // "requestFormBoolean" : boolean, // Boolean 바디 파라미터
  // "requestFormBooleanNullable" : boolean?, // Boolean 바디 파라미터 Nullable
  // "requestFormStringList" : List<String>, // StringList 바디 파라미터
  // "requestFormStringListNullable" : List<String>? // StringList 바디 파라미터 Nullable
  // }
  String jsonString; // json 형식 String
  MultipartFile multipartFile; // 멀티 파트 파일
  MultipartFile? multipartFileNullable; // 멀티 파트 파일 Nullable
}

class PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseHeaderVo {
  PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseHeaderVo();
}

class PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseBodyVo {
  PostService1TkV1RequestTestPostRequestMultipartFormDataJsonAsyncResponseBodyVo({
    required this.requestFormString,
    required this.requestFormStringNullable,
    required this.requestFormInt,
    required this.requestFormIntNullable,
    required this.requestFormDouble,
    required this.requestFormDoubleNullable,
    required this.requestFormBoolean,
    required this.requestFormBooleanNullable,
    required this.requestFormStringList,
    required this.requestFormStringListNullable,
  });

  String requestFormString; // 입력한 String 쿼리 파라미터
  String? requestFormStringNullable; // 입력한 String 쿼리 파라미터 Nullable
  int requestFormInt; // 입력한 int 쿼리 파라미터
  int? requestFormIntNullable; // 입력한 int 쿼리 파라미터 Nullable
  double requestFormDouble; // 입력한 double 쿼리 파라미터
  double? requestFormDoubleNullable; // 입력한 double 쿼리 파라미터 Nullable
  bool requestFormBoolean; // 입력한 bool 쿼리 파라미터
  bool? requestFormBooleanNullable; // 입력한 bool 쿼리 파라미터 Nullable
  List<String> requestFormStringList; // 입력한 StringList 쿼리 파라미터
  List<String>?
      requestFormStringListNullable; // 입력한 StringList 쿼리 파라미터 Nullable

  @override
  String toString() {
    return "requestFormString : $requestFormString, "
        "requestFormStringNullable : $requestFormStringNullable, "
        "requestFormInt : $requestFormInt, "
        "requestFormIntNullable : $requestFormIntNullable, "
        "requestFormDouble : $requestFormDouble, "
        "requestFormDoubleNullable : $requestFormDoubleNullable, "
        "requestFormBoolean : $requestFormBoolean, "
        "requestFormBooleanNullable : $requestFormBooleanNullable, "
        "requestFormStringList : $requestFormStringList, "
        "requestFormStringListNullable : $requestFormStringListNullable";
  }
}

////
// (인위적 에러 수신 테스트)
// 서버에서 송신하는 인위적 에러 수신 테스트
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1RequestTestGenerateErrorAsyncResponseHeaderVo,
            PostService1TkV1RequestTestGenerateErrorAsyncResponseBodyVo>>
    postService1TkV1RequestTestGenerateErrorAsync() async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/request-test/generate-error";
  String prodServerUrl = "/service1/tk/v1/request-test/generate-error";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(headers: requestHeaders), data: requestBody);

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1RequestTestGenerateErrorAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1RequestTestGenerateErrorAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1RequestTestGenerateErrorAsyncResponseHeaderVo();
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1RequestTestGenerateErrorAsyncResponseHeaderVo {
  PostService1TkV1RequestTestGenerateErrorAsyncResponseHeaderVo();
}

class PostService1TkV1RequestTestGenerateErrorAsyncResponseBodyVo {}

////
// (text/string 반환 샘플)
// Response Body 가 text/string 타입입니다.
Future<
    gc_template_classes.NetworkResponseObject<
        GetService1TkV1RequestTestReturnTextStringAsyncResponseHeaderVo,
        String>> getService1TkV1RequestTestReturnTextStringAsync() async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/request-test/return-text-string";
  String prodServerUrl = "/service1/tk/v1/request-test/return-text-string";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1RequestTestReturnTextStringAsyncResponseHeaderVo
        responseHeader;
    String? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        GetService1TkV1RequestTestReturnTextStringAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건

      responseBody = response.data;
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1RequestTestReturnTextStringAsyncResponseHeaderVo {
  GetService1TkV1RequestTestReturnTextStringAsyncResponseHeaderVo();
}

class GetRequestReturnTextStringAsyncResponseBodyVo {
  GetRequestReturnTextStringAsyncResponseBodyVo();
}

////
// (text/html 반환 샘플)
// Response Body 가 text/html 타입입니다.
Future<
    gc_template_classes.NetworkResponseObject<
        GetService1TkV1RequestTestReturnTextHtmlAsyncResponseHeaderVo,
        String>> getService1TkV1RequestTestReturnTextHtmlAsync() async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/request-test/return-text-html";
  String prodServerUrl = "/service1/tk/v1/request-test/return-text-html";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1RequestTestReturnTextHtmlAsyncResponseHeaderVo
        responseHeader;
    String? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        GetService1TkV1RequestTestReturnTextHtmlAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      responseBody = response.data;
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1RequestTestReturnTextHtmlAsyncResponseHeaderVo {
  GetService1TkV1RequestTestReturnTextHtmlAsyncResponseHeaderVo();
}

class GetRequestReturnTextHtmlAsyncResponseBodyVo {
  GetRequestReturnTextHtmlAsyncResponseBodyVo();
}

////
// (서버에 저장된 어플리케이션 버전 정보 가져오기)
Future<
        gc_template_classes.NetworkResponseObject<
            GetMobileAppVersionInfoAsyncResponseHeaderVo,
            GetMobileAppVersionInfoAsyncResponseBodyVo>>
    getClientApplicationVersionInfoAsync(
        {required GetMobileAppVersionInfoAsyncRequestQueryVo
            requestQueryVo}) async {
  // !!!서버 API 가 준비되면 더미 데이터 return 제거!!!
  return gc_template_classes.NetworkResponseObject(
      networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
          responseStatusCode: 200,
          responseHeaders: GetMobileAppVersionInfoAsyncResponseHeaderVo(),
          responseBody: GetMobileAppVersionInfoAsyncResponseBodyVo(
              minUpgradeVersion: "1.0.0", latestVersion: "1.0.0")),
      dioException: null);

  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/server-app-version-info";
  String prodServerUrl = "/server-app-version-info";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestQueryParams["platformCode"] = requestQueryVo.platformCode;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetMobileAppVersionInfoAsyncResponseHeaderVo responseHeader;
    GetMobileAppVersionInfoAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = GetMobileAppVersionInfoAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody = GetMobileAppVersionInfoAsyncResponseBodyVo(
          minUpgradeVersion: responseBodyMap["minUpgradeVersion"],
          latestVersion: responseBodyMap["latestVersion"]);
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetMobileAppVersionInfoAsyncRequestQueryVo {
  GetMobileAppVersionInfoAsyncRequestQueryVo({required this.platformCode});

  // 플랫폼 코드 (1 : web, 2 : android, 3 : ios, 4 : windows, 5 : macos, 6 : linux)
  int platformCode;
}

class GetMobileAppVersionInfoAsyncResponseHeaderVo {
  GetMobileAppVersionInfoAsyncResponseHeaderVo();
}

class GetMobileAppVersionInfoAsyncResponseBodyVo {
  GetMobileAppVersionInfoAsyncResponseBodyVo(
      {required this.minUpgradeVersion, required this.latestVersion});

  String minUpgradeVersion; // 최소 필요 버전, ex : "1.0.0"
  String latestVersion; // 최신 버전, ex : "1.0.0"
}

////
// (로그인 요청 with password)
// 서버 로그인 검증 요청 후 인증 정보 수신
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1AuthLoginWithPasswordAsyncResponseHeaderVo,
            PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVo>>
    postService1TkV1AuthLoginWithPasswordAsync(
        {required PostService1TkV1AuthLoginWithPasswordAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/login-with-password";
  String prodServerUrl = "/service1/tk/v1/auth/login-with-password";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestBody["loginTypeCode"] = requestBodyVo.loginTypeCode;
  requestBody["id"] = requestBodyVo.id;
  requestBody["password"] = requestBodyVo.password;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(headers: requestHeaders), data: requestBody);

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1AuthLoginWithPasswordAsyncResponseHeaderVo responseHeader;
    PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = PostService1TkV1AuthLoginWithPasswordAsyncResponseHeaderVo(
        apiResultCode: responseHeaderMap.containsKey("api-result-code")
            ? responseHeaderMap["api-result-code"][0]
            : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      Map<String, dynamic>? loggedInOutputResponse =
          responseBodyMap["loggedInOutput"];

      PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLoggedInOutput?
          loggedInOutput;

      if (loggedInOutputResponse != null) {
        loggedInOutput =
            PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLoggedInOutput(
          memberUid: loggedInOutputResponse["memberUid"],
          tokenType: loggedInOutputResponse["tokenType"],
          accessToken: loggedInOutputResponse["accessToken"],
          refreshToken: loggedInOutputResponse["refreshToken"],
          accessTokenExpireWhen:
              loggedInOutputResponse["accessTokenExpireWhen"],
          refreshTokenExpireWhen:
              loggedInOutputResponse["refreshTokenExpireWhen"],
        );
      }

      List<Map<String, dynamic>>? lockedOutputListResponse =
          (responseBodyMap["lockedOutputList"] == null)
              ? null
              : List<Map<String, dynamic>>.from(
                  responseBodyMap["lockedOutputList"]);

      List<PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLockedOutput>?
          lockedOutputList;

      if (lockedOutputListResponse != null) {
        lockedOutputList = [];
        for (var lockedOutput in lockedOutputListResponse) {
          lockedOutputList.add(
              PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLockedOutput(
            memberUid: lockedOutput["memberUid"],
            lockStart: lockedOutput["lockStart"],
            lockBefore: lockedOutput["lockBefore"],
            lockReasonCode: lockedOutput["lockReasonCode"],
            lockReason: lockedOutput["lockReason"],
          ));
        }
      }

      responseBody = PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVo(
        loggedInOutput: loggedInOutput,
        lockedOutputList: lockedOutputList,
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1AuthLoginWithPasswordAsyncRequestBodyVo {
  PostService1TkV1AuthLoginWithPasswordAsyncRequestBodyVo({
    required this.loginTypeCode,
    required this.id,
    required this.password,
  });

  int loginTypeCode; // 로그인 타입 (0 : 아이디, 1 : 이메일, 2 : 전화번호)
  String id; // 아이디 (0 : 홍길동, 1 : test@gmail.com, 2 : 82)000-0000-0000)
  String password; // 비밀번호
}

class PostService1TkV1AuthLoginWithPasswordAsyncResponseHeaderVo {
  PostService1TkV1AuthLoginWithPasswordAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (204 api-result-code)
  // 1 : 입력한 id 로 가입된 회원 정보가 없습니다.
  // 2 : 입력한 password 가 일치하지 않습니다.
  String? apiResultCode;
}

class PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVo {
  PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVo({
    required this.loggedInOutput,
    required this.lockedOutputList,
  });

  PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLoggedInOutput?
      loggedInOutput; // 로그인 성공 정보 (이 변수가 Null 이 아니라면 lockedOutputList 가 Null 입니다.)
  List<PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLockedOutput>?
      lockedOutputList; // 계정 잠김 정보 리스트 (이 변수가 Null 이 아니라면 loggedInOutput 이 Null 입니다.)
}

class PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLoggedInOutput {
  PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLoggedInOutput({
    required this.memberUid,
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpireWhen,
    required this.refreshTokenExpireWhen,
  });

  int memberUid; // 멤버 고유값
  String tokenType; // 인증 토큰 타입 (ex : Bearer)
  String accessToken; // 엑세스 토큰
  String refreshToken; // 리플레시 토큰
  String accessTokenExpireWhen; // 엑세스 토큰 만료 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
  String
      refreshTokenExpireWhen; // 리플레시 토큰 만료 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
}

class PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLockedOutput {
  PostService1TkV1AuthLoginWithPasswordAsyncResponseBodyVoLockedOutput({
    required this.memberUid,
    required this.lockStart,
    required this.lockBefore,
    required this.lockReasonCode,
    required this.lockReason,
  });

  int memberUid; // 멤버 고유값
  String lockStart; // 계정 정지 시작 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
  String?
      lockBefore; // 계정 정지 만료 시간 (이 시간이 지나기 전까지 계정 정지 상태, null 이라면 무기한 정지) (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
  int lockReasonCode; // 계정 정지 이유 코드(0 : 기타, 1 : 휴면계정, 2 : 패널티)
  String lockReason; // 계정 정지 이유 상세(시스템 악용 패널티, 1년 이상 미접속 휴면계정 등...)
}

////
// (로그아웃 요청 <>)
// 서버 로그인 검증 요청 후 인증 정보 수신
Future<
        gc_template_classes.NetworkResponseObject<
            DeleteService1TkV1AuthLogoutAsyncResponseHeaderVo,
            DeleteService1TkV1AuthLogoutAsyncResponseBodyVo>>
    deleteService1TkV1AuthLogoutAsync(
        {required DeleteService1TkV1AuthLogoutAsyncRequestHeaderVo
            requestHeaderVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/logout";
  String prodServerUrl = "/service1/tk/v1/auth/logout";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestHeaders["Authorization"] = requestHeaderVo.authorization;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.delete(requestUrlAndParam,
        options: Options(headers: requestHeaders), data: requestBody);

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    DeleteService1TkV1AuthLogoutAsyncResponseHeaderVo responseHeader;
    DeleteService1TkV1AuthLogoutAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = DeleteService1TkV1AuthLogoutAsyncResponseHeaderVo();
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class DeleteService1TkV1AuthLogoutAsyncRequestHeaderVo {
  DeleteService1TkV1AuthLogoutAsyncRequestHeaderVo(
      {required this.authorization});

  // 인증 토큰 (ex : "Bearer abcd1234!@#$")
  String authorization;
}

class DeleteService1TkV1AuthLogoutAsyncResponseHeaderVo {
  DeleteService1TkV1AuthLogoutAsyncResponseHeaderVo();
}

class DeleteService1TkV1AuthLogoutAsyncResponseBodyVo {}

////
// (토큰 재발급 요청 <>)
// 엑세스 토큰 및 리플레시 토큰 재발행
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1AuthReissueAsyncResponseHeaderVo,
            PostService1TkV1AuthReissueAsyncResponseBodyVo>>
    postService1TkV1AuthReissueAsync(
        {required PostService1TkV1AuthReissueAsyncRequestHeaderVo
            requestHeaderVo,
        required PostService1TkV1AuthReissueAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/reissue";
  String prodServerUrl = "/service1/tk/v1/auth/reissue";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestHeaders["Authorization"] = requestHeaderVo.authorization;
  requestBody["refreshToken"] = requestBodyVo.refreshToken;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(
          headers: requestHeaders,
        ),
        data: requestBody);

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1AuthReissueAsyncResponseHeaderVo responseHeader;
    PostService1TkV1AuthReissueAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = PostService1TkV1AuthReissueAsyncResponseHeaderVo(
        apiResultCode: (responseHeaderMap.containsKey("api-result-code"))
            ? responseHeaderMap["api-result-code"][0]
            : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      Map<String, dynamic>? loggedInOutputResponse =
          responseBodyMap["loggedInOutput"];

      PostService1TkV1AuthReissueAsyncResponseBodyVoLoggedInOutput?
          loggedInOutput;

      if (loggedInOutputResponse != null) {
        loggedInOutput =
            PostService1TkV1AuthReissueAsyncResponseBodyVoLoggedInOutput(
          memberUid: loggedInOutputResponse["memberUid"],
          tokenType: loggedInOutputResponse["tokenType"],
          accessToken: loggedInOutputResponse["accessToken"],
          refreshToken: loggedInOutputResponse["refreshToken"],
          accessTokenExpireWhen:
              loggedInOutputResponse["accessTokenExpireWhen"],
          refreshTokenExpireWhen:
              loggedInOutputResponse["refreshTokenExpireWhen"],
        );
      }

      List<Map<String, dynamic>>? lockedOutputListResponse =
          (responseBodyMap["lockedOutputList"] == null)
              ? null
              : List<Map<String, dynamic>>.from(
                  responseBodyMap["lockedOutputList"]);

      List<PostService1TkV1AuthReissueAsyncResponseBodyVoLockedOutput>?
          lockedOutputList;

      if (lockedOutputListResponse != null) {
        lockedOutputList = [];
        for (var lockedOutput in lockedOutputListResponse) {
          lockedOutputList
              .add(PostService1TkV1AuthReissueAsyncResponseBodyVoLockedOutput(
            memberUid: lockedOutput["memberUid"],
            lockStart: lockedOutput["lockStart"],
            lockBefore: lockedOutput["lockBefore"],
            lockReasonCode: lockedOutput["lockReasonCode"],
            lockReason: lockedOutput["lockReason"],
          ));
        }
      }

      responseBody = PostService1TkV1AuthReissueAsyncResponseBodyVo(
        loggedInOutput: loggedInOutput,
        lockedOutputList: lockedOutputList,
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1AuthReissueAsyncRequestHeaderVo {
  PostService1TkV1AuthReissueAsyncRequestHeaderVo(
      {required this.authorization});

  // 인증 토큰 (ex : "Bearer abcd1234!@#$")
  String authorization;
}

class PostService1TkV1AuthReissueAsyncRequestBodyVo {
  PostService1TkV1AuthReissueAsyncRequestBodyVo({required this.refreshToken});

  String refreshToken; // 리플래시 토큰 (토큰 타입을 앞에 붙이기)
}

class PostService1TkV1AuthReissueAsyncResponseHeaderVo {
  PostService1TkV1AuthReissueAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (204 api-result-code)
  // 1 : 유효하지 않은 Refresh Token 입니다.
  // 2 : Refresh Token 이 만료되었습니다.
  // 3 : 올바르지 않은 Access Token 입니다.
  // 4 : 탈퇴된 회원입니다.
  // 5 : 로그아웃 처리된 Access Token 입니다.(갱신 불가)
  String? apiResultCode;
}

class PostService1TkV1AuthReissueAsyncResponseBodyVo {
  PostService1TkV1AuthReissueAsyncResponseBodyVo({
    required this.loggedInOutput,
    required this.lockedOutputList,
  });

  PostService1TkV1AuthReissueAsyncResponseBodyVoLoggedInOutput?
      loggedInOutput; // 로그인 성공 정보 (이 변수가 Null 이 아니라면 lockedOutputList 가 Null 입니다.)
  List<PostService1TkV1AuthReissueAsyncResponseBodyVoLockedOutput>?
      lockedOutputList; // 계정 잠김 정보 리스트 (이 변수가 Null 이 아니라면 loggedInOutput 이 Null 입니다.)
}

class PostService1TkV1AuthReissueAsyncResponseBodyVoLoggedInOutput {
  PostService1TkV1AuthReissueAsyncResponseBodyVoLoggedInOutput({
    required this.memberUid,
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpireWhen,
    required this.refreshTokenExpireWhen,
  });

  int memberUid; // 멤버 고유값
  String tokenType; // 인증 토큰 타입 (ex : Bearer)
  String accessToken; // 엑세스 토큰
  String refreshToken; // 리플레시 토큰
  String accessTokenExpireWhen; // 엑세스 토큰 만료 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
  String
      refreshTokenExpireWhen; // 리플레시 토큰 만료 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
}

class PostService1TkV1AuthReissueAsyncResponseBodyVoLockedOutput {
  PostService1TkV1AuthReissueAsyncResponseBodyVoLockedOutput({
    required this.memberUid,
    required this.lockStart,
    required this.lockBefore,
    required this.lockReasonCode,
    required this.lockReason,
  });

  int memberUid; // 멤버 고유값
  String lockStart; // 계정 정지 시작 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
  String?
      lockBefore; // 계정 정지 만료 시간 (이 시간이 지나기 전까지 계정 정지 상태, null 이라면 무기한 정지) (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
  int lockReasonCode; // 계정 정지 이유 코드(0 : 기타, 1 : 휴면계정, 2 : 패널티)
  String lockReason; // 계정 정지 이유 상세(시스템 악용 패널티, 1년 이상 미접속 휴면계정 등...)
}

////
// (서버 접속 테스트)
Future<
        gc_template_classes.NetworkResponseObject<
            GetService1TkV1AuthForNoLoggedInAsyncResponseHeaderVo,
            GetService1TkV1AuthForNoLoggedInAsyncResponseBodyVo>>
    getService1TkV1AuthForNoLoggedInAsync() async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/for-no-logged-in";
  String prodServerUrl = "/service1/tk/v1/auth/for-no-logged-in";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1AuthForNoLoggedInAsyncResponseHeaderVo responseHeader;
    String? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = GetService1TkV1AuthForNoLoggedInAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건

      responseBody = response.data;
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1AuthForNoLoggedInAsyncResponseHeaderVo {
  GetService1TkV1AuthForNoLoggedInAsyncResponseHeaderVo();
}

class GetService1TkV1AuthForNoLoggedInAsyncResponseBodyVo {
  GetService1TkV1AuthForNoLoggedInAsyncResponseBodyVo();
}

////
// (무권한 로그인 진입 테스트 <>)
// Authorization null 이라면 401 에러 반환
Future<
        gc_template_classes.NetworkResponseObject<
            GetService1TkV1AuthForLoggedInAsyncResponseHeaderVo,
            GetService1TkV1AuthForLoggedInAsyncResponseBodyVo>>
    getService1TkV1AuthForLoggedInAsync(
        {required GetService1TkV1AuthForLoggedInAsyncRequestHeaderVo
            requestHeaderVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/for-logged-in";
  String prodServerUrl = "/service1/tk/v1/auth/for-logged-in";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  if (requestHeaderVo.authorization != null) {
    requestHeaders["Authorization"] = requestHeaderVo.authorization;
  }

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1AuthForLoggedInAsyncResponseHeaderVo responseHeader;
    String? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = GetService1TkV1AuthForLoggedInAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건

      responseBody = response.data;
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1AuthForLoggedInAsyncRequestHeaderVo {
  GetService1TkV1AuthForLoggedInAsyncRequestHeaderVo(
      {required this.authorization});

  // 인증 토큰 (ex : "Bearer abcd1234!@#$")
  String? authorization;
}

class GetService1TkV1AuthForLoggedInAsyncResponseHeaderVo {
  GetService1TkV1AuthForLoggedInAsyncResponseHeaderVo();
}

class GetService1TkV1AuthForLoggedInAsyncResponseBodyVo {
  GetService1TkV1AuthForLoggedInAsyncResponseBodyVo();
}

////
// (DEVELOPER 권한 진입 테스트 <'ADMIN' or 'DEVELOPER'>)
// Authorization null 이라면 401 에러 반환
Future<
        gc_template_classes.NetworkResponseObject<
            GetService1TkV1AuthForDeveloperAsyncResponseHeaderVo,
            GetService1TkV1AuthForDeveloperAsyncResponseBodyVo>>
    getService1TkV1AuthForDeveloperAsync(
        {required GetService1TkV1AuthForDeveloperAsyncRequestHeaderVo
            requestHeaderVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/for-developer";
  String prodServerUrl = "/service1/tk/v1/auth/for-developer";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  if (requestHeaderVo.authorization != null) {
    requestHeaders["Authorization"] = requestHeaderVo.authorization;
  }

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1AuthForDeveloperAsyncResponseHeaderVo responseHeader;
    String? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = GetService1TkV1AuthForDeveloperAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건

      responseBody = response.data;
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1AuthForDeveloperAsyncRequestHeaderVo {
  GetService1TkV1AuthForDeveloperAsyncRequestHeaderVo(
      {required this.authorization});

  // 인증 토큰 (ex : "Bearer abcd1234!@#$")
  String? authorization;
}

class GetService1TkV1AuthForDeveloperAsyncResponseHeaderVo {
  GetService1TkV1AuthForDeveloperAsyncResponseHeaderVo();
}

class GetService1TkV1AuthForDeveloperAsyncResponseBodyVo {
  GetService1TkV1AuthForDeveloperAsyncResponseBodyVo();
}

////
// (ADMIN 권한 진입 테스트 <'ADMIN'>)
// Authorization null 이라면 401 에러 반환
Future<
        gc_template_classes.NetworkResponseObject<
            GetService1TkV1AuthForAdminAsyncResponseHeaderVo,
            GetService1TkV1AuthForAdminAsyncResponseBodyVo>>
    getService1TkV1AuthForAdminAsync(
        {required GetService1TkV1AuthForAdminAsyncRequestHeaderVo
            requestHeaderVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/for-admin";
  String prodServerUrl = "/service1/tk/v1/auth/for-admin";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  if (requestHeaderVo.authorization != null) {
    requestHeaders["Authorization"] = requestHeaderVo.authorization;
  }

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1AuthForAdminAsyncResponseHeaderVo responseHeader;
    String? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = GetService1TkV1AuthForAdminAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건

      responseBody = response.data;
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1AuthForAdminAsyncRequestHeaderVo {
  GetService1TkV1AuthForAdminAsyncRequestHeaderVo(
      {required this.authorization});

  // 인증 토큰 (ex : "Bearer abcd1234!@#$")
  String? authorization;
}

class GetService1TkV1AuthForAdminAsyncResponseHeaderVo {
  GetService1TkV1AuthForAdminAsyncResponseHeaderVo();
}

class GetService1TkV1AuthForAdminAsyncResponseBodyVo {
  GetService1TkV1AuthForAdminAsyncResponseBodyVo();
}

////
// (아이디 중복 검사)
Future<
        gc_template_classes.NetworkResponseObject<
            GetService1TkV1AuthIdDuplicateCheckAsyncResponseHeaderVo,
            GetService1TkV1AuthIdDuplicateCheckAsyncResponseBodyVo>>
    getService1TkV1AuthIdDuplicateCheckAsync(
        {required GetService1TkV1AuthIdDuplicateCheckAsyncRequestQueryVo
            requestQueryVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/id-duplicate-check";
  String prodServerUrl = "/service1/tk/v1/auth/id-duplicate-check";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestQueryParams["id"] = requestQueryVo.id;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    // Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1AuthIdDuplicateCheckAsyncResponseHeaderVo responseHeader;
    GetService1TkV1AuthIdDuplicateCheckAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader = GetService1TkV1AuthIdDuplicateCheckAsyncResponseHeaderVo();
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody = GetService1TkV1AuthIdDuplicateCheckAsyncResponseBodyVo(
          duplicated: responseBodyMap["duplicated"]);
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1AuthIdDuplicateCheckAsyncRequestQueryVo {
  GetService1TkV1AuthIdDuplicateCheckAsyncRequestQueryVo({required this.id});

  String id;
}

class GetService1TkV1AuthIdDuplicateCheckAsyncResponseHeaderVo {
  GetService1TkV1AuthIdDuplicateCheckAsyncResponseHeaderVo();
}

class GetService1TkV1AuthIdDuplicateCheckAsyncResponseBodyVo {
  GetService1TkV1AuthIdDuplicateCheckAsyncResponseBodyVo(
      {required this.duplicated});

  bool duplicated;
}

////
// (이메일 회원가입 본인 검증 이메일 보내기)
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseHeaderVo,
            PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseBodyVo>>
    postService1TkV1AuthJoinTheMembershipEmailVerificationAsync(
        {required PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl =
      "/service1/tk/v1/auth/join-the-membership-email-verification";
  String prodServerUrl =
      "/service1/tk/v1/auth/join-the-membership-email-verification";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestBody["email"] = requestBodyVo.email;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(
            headers: requestHeaders,
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10)),
        data: requestBody);

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseHeaderVo(
            apiResultCode: (responseHeaderMap.containsKey("api-result-code"))
                ? responseHeaderMap["api-result-code"][0]!
                : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody =
          PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseBodyVo(
        verificationUid: responseBodyMap["verificationUid"],
        verificationExpireWhen: responseBodyMap["verificationExpireWhen"],
      );
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncRequestBodyVo {
  PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncRequestBodyVo(
      {required this.email});

  String email; // 수신 이메일
}

class PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseHeaderVo {
  PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (204 api-result-code)
  // 1 : 동일한 이메일을 사용하는 회원이 존재합니다.
  String? apiResultCode;
}

class PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseBodyVo {
  PostService1TkV1AuthJoinTheMembershipEmailVerificationAsyncResponseBodyVo({
    required this.verificationUid,
    required this.verificationExpireWhen,
  });

  int verificationUid; // 검증 고유값
  String verificationExpireWhen; // 검증 만료 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
}

////
// (이메일 회원가입 본인 확인 이메일에서 받은 코드 검증하기)
Future<
        gc_template_classes.NetworkResponseObject<
            GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseHeaderVo,
            GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseBodyVo>>
    getService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsync(
        {required GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncRequestQueryVo
            requestQueryVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl =
      "/service1/tk/v1/auth/join-the-membership-email-verification-check";
  String prodServerUrl =
      "/service1/tk/v1/auth/join-the-membership-email-verification-check";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestQueryParams["verificationUid"] = requestQueryVo.verificationUid;
  requestQueryParams["email"] = requestQueryVo.email;
  requestQueryParams["verificationCode"] = requestQueryVo.verificationCode;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.get(requestUrlAndParam,
        options: Options(headers: requestHeaders));

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseHeaderVo
        responseHeader;
    GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseHeaderVo(
            apiResultCode: (responseHeaderMap.containsKey("api-result-code"))
                ? responseHeaderMap["api-result-code"][0]!
                : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      // Map<String, dynamic> responseBodyMap = response.data;

      // responseBody 로 List 타입이 넘어오면 List<>.from 으로 받고,
      // Object 타입이 넘어오면 Map<String, dynamic> 으로 받고,
      // Object List 타입이 넘어오면 List<Map<String, dynamic>> 으로 받아서 처리

      responseBody =
          GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseBodyVo();
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncRequestQueryVo {
  GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncRequestQueryVo({
    required this.verificationUid,
    required this.email,
    required this.verificationCode,
  });

  int verificationUid; // 검증 고유값
  String email; // 확인 이메일
  String verificationCode; // 확인 이메일에 전송된 코드
}

class GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseHeaderVo {
  GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (204 api-result-code)
  // 1 : 이메일 검증 요청을 보낸 적이 없습니다.
  // 2 : 이메일 검증 요청이 만료되었습니다.
  // 3 : verificationCode 가 일치하지 않습니다.
  String? apiResultCode;
}

class GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseBodyVo {
  GetService1TkV1AuthJoinTheMembershipEmailVerificationCheckAsyncResponseBodyVo();
}

////
// (Email 회원가입)
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseHeaderVo,
            PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseBodyVo>>
    postService1TkV1AuthJoinTheMembershipWithEmailAsync(
        {required PostService1TkV1AuthJoinTheMembershipWithEmailAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/join-the-membership-with-email";
  String prodServerUrl = "/service1/tk/v1/auth/join-the-membership-with-email";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestFormDataMap = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestFormDataMap["verificationUid"] = requestBodyVo.verificationUid;
  requestFormDataMap["email"] = requestBodyVo.email;
  requestFormDataMap["password"] = requestBodyVo.password;
  requestFormDataMap["id"] = requestBodyVo.id;
  requestFormDataMap["verificationCode"] = requestBodyVo.verificationCode;
  if (requestBodyVo.profileImageFile != null) {
    requestFormDataMap["profileImageFile"] = requestBodyVo.profileImageFile;
  }

  FormData requestBody = FormData.fromMap(requestFormDataMap);

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(
          headers: requestHeaders,
        ),
        data: requestBody);

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseHeaderVo(
            apiResultCode: (responseHeaderMap.containsKey("api-result-code"))
                ? responseHeaderMap["api-result-code"][0]!
                : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      responseBody =
          PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseBodyVo();
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1AuthJoinTheMembershipWithEmailAsyncRequestBodyVo {
  PostService1TkV1AuthJoinTheMembershipWithEmailAsyncRequestBodyVo({
    required this.verificationUid,
    required this.email,
    required this.password,
    required this.id,
    required this.verificationCode,
    required this.profileImageFile,
  });

  int verificationUid; // 검증 고유값
  String email; // 아이디 - 이메일
  String password; // 사용할 비밀번호
  String id; // 계정 아이디
  String verificationCode; // oauth2Id 검증에 사용한 코드
  MultipartFile? profileImageFile; // 프로필 사진 파일
}

class PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseHeaderVo {
  PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (204 api-result-code)
  // 1 : 이메일 검증 요청을 보낸 적이 없습니다.
  // 2 : 이메일 검증 요청이 만료되었습니다.
  // 3 : verificationCode 가 일치하지 않습니다.
  // 4 : 이미 동일한 이메일로 가입된 회원이 존재합니다.
  // 5 : 이미 동일한 아이디로 가입된 회원이 존재합니다.
  String? apiResultCode;
}

class PostService1TkV1AuthJoinTheMembershipWithEmailAsyncResponseBodyVo {}

////
// (이메일 비밀번호 찾기 본인 검증 이메일 보내기)
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseHeaderVo,
            PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseBodyVo>>
    postService1TkV1AuthFindPasswordEmailVerificationAsync(
        {required PostService1TkV1AuthFindPasswordEmailVerificationAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/find-password-email-verification";
  String prodServerUrl =
      "/service1/tk/v1/auth/find-password-email-verification";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestBody["email"] = requestBodyVo.email;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(
            headers: requestHeaders,
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10)),
        data: requestBody);

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseBodyVo?
        responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseHeaderVo(
            apiResultCode: (responseHeaderMap.containsKey("api-result-code"))
                ? responseHeaderMap["api-result-code"][0]!
                : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      Map<String, dynamic> responseBodyMap = response.data;

      responseBody =
          PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseBodyVo(
              verificationUid: responseBodyMap["verificationUid"],
              verificationExpireWhen:
                  responseBodyMap["verificationExpireWhen"]);
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1AuthFindPasswordEmailVerificationAsyncRequestBodyVo {
  PostService1TkV1AuthFindPasswordEmailVerificationAsyncRequestBodyVo(
      {required this.email});

  String email; // 수신 이메일
}

class PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseHeaderVo {
  PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (api-result-code)
  // 1 : 해당 이메일로 가입된 회원 정보가 존재하지 않습니다.
  String? apiResultCode;
}

class PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseBodyVo {
  PostService1TkV1AuthFindPasswordEmailVerificationAsyncResponseBodyVo({
    required this.verificationUid,
    required this.verificationExpireWhen,
  });

  int verificationUid; // 검증 고유값
  String verificationExpireWhen; // 검증 만료 시간 (yyyy_MM_dd_'T'_HH_mm_ss_SSS_z)
}

////
// (이메일 비밀번호 찾기 완료)
Future<
        gc_template_classes.NetworkResponseObject<
            PostService1TkV1AuthFindPasswordWithEmailAsyncResponseHeaderVo,
            PostService1TkV1AuthFindPasswordWithEmailAsyncResponseBodyVo>>
    postService1TkV1AuthFindPasswordWithEmailAsync(
        {required PostService1TkV1AuthFindPasswordWithEmailAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/find-password-with-email";
  String prodServerUrl = "/service1/tk/v1/auth/find-password-with-email";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestBody["email"] = requestBodyVo.email;
  requestBody["verificationUid"] = requestBodyVo.verificationUid;
  requestBody["verificationCode"] = requestBodyVo.verificationCode;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.post(requestUrlAndParam,
        options: Options(
            headers: requestHeaders,
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10)),
        data: requestBody);

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    PostService1TkV1AuthFindPasswordWithEmailAsyncResponseHeaderVo
        responseHeader;
    PostService1TkV1AuthFindPasswordWithEmailAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PostService1TkV1AuthFindPasswordWithEmailAsyncResponseHeaderVo(
            apiResultCode: (responseHeaderMap.containsKey("api-result-code"))
                ? responseHeaderMap["api-result-code"][0]!
                : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      // Map<String, dynamic> responseBodyMap = response.data;

      responseBody =
          PostService1TkV1AuthFindPasswordWithEmailAsyncResponseBodyVo();
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PostService1TkV1AuthFindPasswordWithEmailAsyncRequestBodyVo {
  PostService1TkV1AuthFindPasswordWithEmailAsyncRequestBodyVo({
    required this.email,
    required this.verificationUid,
    required this.verificationCode,
  });

  String email; // 비밀번호를 찾을 계정 이메일
  int verificationUid; // 검증 고유값
  String verificationCode; // 이메일 검증에 사용한 코드
}

class PostService1TkV1AuthFindPasswordWithEmailAsyncResponseHeaderVo {
  PostService1TkV1AuthFindPasswordWithEmailAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (api-result-code)
  // 1 : 이메일 검증 요청을 보낸 적이 없습니다.
  // 2 : 이메일 검증 요청이 만료되었습니다.
  // 3 : verificationCode 가 일치하지 않습니다.
  // 4 : 해당 이메일로 가입한 회원 정보가 존재하지 않습니다.
  String? apiResultCode;
}

class PostService1TkV1AuthFindPasswordWithEmailAsyncResponseBodyVo {
  PostService1TkV1AuthFindPasswordWithEmailAsyncResponseBodyVo();
}

////
// (비밀번호 변경 요청 <>)
Future<
        gc_template_classes.NetworkResponseObject<
            PutService1TkV1AuthChangeAccountPasswordAsyncResponseHeaderVo,
            PutService1TkV1AuthChangeAccountPasswordAsyncResponseBodyVo>>
    putService1TkV1AuthChangeAccountPasswordAsync(
        {required PutService1TkV1AuthChangeAccountPasswordAsyncRequestHeaderVo
            requestHeaderVo,
        required PutService1TkV1AuthChangeAccountPasswordAsyncRequestBodyVo
            requestBodyVo}) async {
  // !!!개발 / 배포 모드별 요청 Path 지정!!!
  String devServerUrl = "/service1/tk/v1/auth/change-account-password";
  String prodServerUrl = "/service1/tk/v1/auth/change-account-password";

  Map<String, dynamic> requestHeaders = {};
  Map<String, dynamic> requestQueryParams = {};
  Map<String, dynamic> requestBody = {};

  // !!!Request Object 를 Map 으로 만들기!!!
  requestHeaders["Authorization"] = requestHeaderVo.authorization;
  requestBody["oldPassword"] = requestBodyVo.oldPassword;
  requestBody["newPassword"] = requestBodyVo.newPassword;

  // baseUrl + Request path + QueryParam
  String requestUrlAndParam = gf_template_functions.mergeNetworkQueryParam(
      queryParams: requestQueryParams,
      requestUrl: (gd_const_config.isDebugMode) ? devServerUrl : prodServerUrl);

  try {
    // !!!네트워크 요청 설정!!!
    // requestPathAndParam, headers 설정 외 세부 설정
    var response = await _serverDioObject.put(requestUrlAndParam,
        options: Options(
            headers: requestHeaders,
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10)),
        data: requestBody);

    int statusCode = response.statusCode!;
    Map<String, dynamic> responseHeaderMap = response.headers.map;

    PutService1TkV1AuthChangeAccountPasswordAsyncResponseHeaderVo
        responseHeader;
    PutService1TkV1AuthChangeAccountPasswordAsyncResponseBodyVo? responseBody;

    // !!!Response Map 을 Response Object 로 변경!!!
    responseHeader =
        PutService1TkV1AuthChangeAccountPasswordAsyncResponseHeaderVo(
            apiResultCode: (responseHeaderMap.containsKey("api-result-code"))
                ? responseHeaderMap["api-result-code"][0]
                : null);
    if (statusCode == 200) {
      // responseBody 가 반환되는 조건
      // Map<String, dynamic> responseBodyMap = response.data;

      responseBody =
          PutService1TkV1AuthChangeAccountPasswordAsyncResponseBodyVo();
    }

    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: gc_template_classes.NetworkResponseObjectOk(
            responseStatusCode: statusCode,
            responseHeaders: responseHeader,
            responseBody: responseBody),
        dioException: null);
  } on DioException catch (e) {
    // 서버에 리퀘스트가 도달하지 못한 에러 + Dio 가 에러로 규정한 Status Code
    //  = 클라이언트 입장에선 그냥 네트워크 에러로 처리
    return gc_template_classes.NetworkResponseObject(
        networkResponseObjectOk: null, dioException: e);
  }
}

class PutService1TkV1AuthChangeAccountPasswordAsyncRequestHeaderVo {
  PutService1TkV1AuthChangeAccountPasswordAsyncRequestHeaderVo(
      {required this.authorization});

  // 인증 토큰 (ex : "Bearer abcd1234!@#$")
  String authorization;
}

class PutService1TkV1AuthChangeAccountPasswordAsyncRequestBodyVo {
  PutService1TkV1AuthChangeAccountPasswordAsyncRequestBodyVo(
      {required this.oldPassword, required this.newPassword});

  // 인증 토큰 (ex : "Bearer abcd1234!@#$")
  String? oldPassword; // 기존 이메일 로그인용 비밀번호(기존 비밀번호가 없다면 null)
  String? newPassword; // 새 이메일 로그인용 비밀번호(비밀번호를 없애려면 null)
}

class PutService1TkV1AuthChangeAccountPasswordAsyncResponseHeaderVo {
  PutService1TkV1AuthChangeAccountPasswordAsyncResponseHeaderVo(
      {required this.apiResultCode});

  // (204 api-result-code)
  // 1 : 기존 비밀번호가 일치하지 않습니다.
  // 2 : 비밀번호를 null 로 만들려고 할 때, 이외에 로그인할 수단이 없으므로 비밀번호 제거가 불가능합니다.
  String? apiResultCode;
}

class PutService1TkV1AuthChangeAccountPasswordAsyncResponseBodyVo {
  PutService1TkV1AuthChangeAccountPasswordAsyncResponseBodyVo();
}
