// (external)
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
    _classifyImage();
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

  late Interpreter interpreter;
  late List<String> labels;
  String result = "분류 중...";
  final int inputSize = 256;

  // [private 변수]

  //----------------------------------------------------------------------------
  // !!!비즈니스 함수는 이 곳에서 저장 하여 사용 하세요.!!!
  // [public 함수]
  // (메인 위젯 화면 갱신)
  late VoidCallback refreshUi;

  // [private 함수]
  List<LabelScore> getTopK(List<double> scores, List<String> labels, int topK) {
    final indexed = List.generate(
      scores.length,
      (i) => LabelScore(labels[i], scores[i]),
    );
    indexed.sort((a, b) => b.score.compareTo(a.score));
    return indexed.take(topK).toList();
  }

  Future<void> _classifyImage() async {
    // 1. 모델 로드
    interpreter = await Interpreter.fromAsset(
      'lib/assets/tflite/mobilevit_small.tflite',
    );

    print(interpreter.getInputTensor(0).shape);
    print(interpreter.getInputTensor(0).type);

    // 2. 라벨 로드
    final labelData = await rootBundle.loadString(
      'lib/assets/tflite/mobilevit_small.json',
    );
    final parsed = json.decode(labelData);
    if (parsed is Map<String, dynamic>) {
      labels = parsed.values.map((e) => e.toString()).toList();
    } else if (parsed is List) {
      labels = List<String>.from(parsed);
    } else {
      throw Exception('Unexpected label file format');
    }

    // 3. 이미지 로드 및 리사이즈
    final imageData = await rootBundle.load('lib/assets/tflite/test.jpg');
    final image = img.decodeImage(imageData.buffer.asUint8List())!;
    final resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );

    // 4. 입력 전처리 (Pixel.r / g / b 사용)
    final input = List.generate(
      3,
      (c) => // Channel: 0 - R, 1 - G, 2 - B
      List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          final pixel = resizedImage.getPixel(x, y);
          if (c == 0) return pixel.r / 255.0;
          if (c == 1) return pixel.g / 255.0;
          return pixel.b / 255.0;
        }),
      ),
    );

    final inputTensor = [input]; // shape: [1, 3, 256, 256]

    // 5. 추론 실행
    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
    interpreter.run(inputTensor, output);

    // 6. Top-3 결과 추출
    final outputList = output[0] as List<double>;
    final topK = getTopK(outputList, labels, 3);

    result = topK
        .map((e) => '${e.label}: ${e.score.toStringAsFixed(2)}')
        .join('\n');

    refreshUi();
  }
}

class LabelScore {
  final String label;
  final double score;

  LabelScore(this.label, this.score);
}
