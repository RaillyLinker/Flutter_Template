// (external)
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:tflite_flutter/tflite_flutter.dart';

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
    interpreter.close();
  }

  // (최초 실행시 단 한번 실행) - 위젯 build 바로 직전, 모든 것이 준비 되었을 때
  void onCreate() async {
    // !!!onCreate 로직 작성!!!

    final data = await rootBundle.load('lib/assets/tflite/bus.jpg');
    final bytes = data.buffer.asUint8List();
    originalImage = img.decodeImage(bytes)!;

    interpreter = await Interpreter.fromAsset(
      'lib/assets/tflite/yolo11n_float32.tflite',
    );

    // Prepare UI image from the original for correct display
    uiImage = await _convertImage(originalImage!);

    // Distort resize for inference only
    final resizedImage = img.copyResize(
      originalImage!,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.linear,
    );

    detections = await _runInference(
      resizedImage,
      originalImage!.width,
      originalImage!.height,
    );

    refreshUi();
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

  img.Image? originalImage;
  ui.Image? uiImage;
  late Interpreter interpreter;
  List<Detection> detections = [];
  final int inputSize = 320;

  // [private 변수]

  //----------------------------------------------------------------------------
  // !!!비즈니스 함수는 이 곳에서 저장 하여 사용 하세요.!!!
  // [public 함수]
  // (메인 위젯 화면 갱신)
  late VoidCallback refreshUi;

  // [private 함수]
  void _doNothing() {}

  Future<List<Detection>> _runInference(
    img.Image inputImage,
    int origW,
    int origH,
  ) async {
    // Prepare NHWC input buffer
    final inputBuffer = Float32List(inputSize * inputSize * 3);
    int idx = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = inputImage.getPixel(x, y);
        inputBuffer[idx++] = pixel.r / 255.0;
        inputBuffer[idx++] = pixel.g / 255.0;
        inputBuffer[idx++] = pixel.b / 255.0;
      }
    }
    final input = inputBuffer.reshape([1, inputSize, inputSize, 3]);

    final batch = 1;
    final numBoxes = 300;
    final numAttrs = 6;
    var outputBuffer = List.generate(
      batch,
      (_) => List.generate(numBoxes, (_) => List.filled(numAttrs, 0.0)),
    );

    interpreter.run(input, outputBuffer);

    List<Detection> detections = [];
    for (var i = 0; i < numBoxes; i++) {
      final conf = outputBuffer[0][i][4];
      if (conf < 0.3) continue;

      final x1n = outputBuffer[0][i][0];
      final y1n = outputBuffer[0][i][1];
      final x2n = outputBuffer[0][i][2];
      final y2n = outputBuffer[0][i][3];
      final classId = outputBuffer[0][i][5].toInt();

      // Scale back to original image coordinates
      final x1 = x1n * origW;
      final y1 = y1n * origH;
      final x2 = x2n * origW;
      final y2 = y2n * origH;

      detections.add(
        Detection(
          rect: Rect.fromLTRB(x1, y1, x2, y2),
          score: conf,
          classId: classId,
        ),
      );
    }

    return detections;
  }

  Future<ui.Image> _convertImage(img.Image src) async {
    final completer = Completer<ui.Image>();
    final pngBytes = Uint8List.fromList(img.encodePng(src));
    ui.decodeImageFromList(pngBytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }
}

class Detection {
  final Rect rect;
  final double score;
  final int classId;

  Detection({required this.rect, required this.score, required this.classId});
}
