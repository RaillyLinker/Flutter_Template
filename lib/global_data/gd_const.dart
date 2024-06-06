// (external)
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

// [전역 상수 저장 파일]
// 프로그램 전역에서 사용할 전역 상수를 선언하는 파일입니다.

// 상수를 모아둡니다.

// -----------------------------------------------------------------------------
// (SharedPreferences 객체)
late final SharedPreferences sharedPreferences;

// (디바이스 정보)
/*
    아래 코드를 참고하여, 각 디바이스 환경별 다른 객체로 변환하여 사용하세요.

    import 'package:device_info_plus/device_info_plus.dart';

    val baseDeviceInfo =
      if (kIsWeb) {
        // as WebBrowserInfo
        return webBrowserInfo;
      } else {
        if (Platform.isAndroid) {
          // as AndroidDeviceInfo
          return androidInfo;
        } else if (Platform.isIOS) {
          // as IosDeviceInfo
          return iosInfo;
        } else if (Platform.isLinux) {
          // as LinuxDeviceInfo
          return linuxInfo;
        } else if (Platform.isMacOS) {
          // as MacOsDeviceInfo
          return macOsInfo;
        } else if (Platform.isWindows) {
          // as WindowsDeviceInfo
          return windowsInfo;
        }
      }
 */
late final BaseDeviceInfo baseDeviceInfo;
