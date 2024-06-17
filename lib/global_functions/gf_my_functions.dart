// (external)
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

// (all)
import 'package:flutter_template/repositories/spws/spw_auth_info.dart'
    as spw_sign_in_member_info;

// [전역 함수 작성 파일]
// 프로그램 전역에서 사용할 함수들은 여기에 모아둡니다.

// -----------------------------------------------------------------------------
// (현 시점 검증된 로그인 정보 가져오기)
// 검증된 현재 회원 정보 가져오기 (비회원이라면 null)
spw_sign_in_member_info.SharedPreferenceWrapperVo? getNowAuthInfo() {
  spw_sign_in_member_info.SharedPreferenceWrapperVo? nowAuthInfo;

  // Shared Preferences 에 저장된 로그인 유저 정보 가져오기
  spw_sign_in_member_info.SharedPreferenceWrapperVo? authInfo =
      spw_sign_in_member_info.SharedPreferenceWrapper.get();

  // 로그인 검증 실행
  if (authInfo != null) {
    // 액세스 토큰 만료 시간이 지났는지 확인
    bool isAccessTokenExpired = DateFormat("yyyy_MM_dd_'T'_HH_mm_ss_SSS_z")
        .parse(authInfo.accessTokenExpireWhen)
        .isBefore(DateTime.now());

    if (isAccessTokenExpired) {
      // 액세스 토큰 만료
      // 리플레시 토큰 만료 시간이 지났는지 확인
      bool isRefreshTokenExpired = DateFormat("yyyy_MM_dd_'T'_HH_mm_ss_SSS_z")
          .parse(authInfo.refreshTokenExpireWhen)
          .isBefore(DateTime.now());

      if (isRefreshTokenExpired) {
        // 리플레시 토큰 만료
        // login_user_info SPW 비우기
        spw_sign_in_member_info.SharedPreferenceWrapper.set(value: null);
        // 재 로그인이 필요한 상황이므로 비회원으로 다루기
      } else {
        // 리플레시 토큰 만료 되지 않음 = 재발급은 하지 않고 회원 정보 승인
        nowAuthInfo = authInfo;
      }
    } else {
      // 액세스 토큰 만료 되지 않음 (= 검증된 정상 로그인 정보)
      nowAuthInfo = authInfo;
    }
  }

  return nowAuthInfo;
}

////
// (Gif 정보 가져오기)
GetGifDetailsOutputVo getGifDetails({required ByteData byteData}) {
  // GIF 이미지 데이터 로드
  var gif = img.decodeGif(byteData.buffer.asUint8List());

  if (gif == null) throw 'Failed to decode gif';

  int duration = 0;

  for (var frame in gif.frames) {
    duration += frame.frameDuration;
  }

  return GetGifDetailsOutputVo(frameCount: gif.numFrames, duration: duration);
}

class GetGifDetailsOutputVo {
  GetGifDetailsOutputVo({required this.frameCount, required this.duration});

  int frameCount;
  int duration;
}

////
// (영문, 숫자 랜덤 String 을 length 만큼의 길이로 반환)
String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(
        random.nextInt(chars.length),
      ),
    ),
  );
}
