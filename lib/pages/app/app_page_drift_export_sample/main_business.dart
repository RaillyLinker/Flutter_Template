// (external)
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// (inner_folder)
import 'main_widget.dart' as main_widget;

// (all)
import 'package:flutter_template/global_widgets/gw_slw_page_outer_frame.dart'
    as gw_slw_page_outer_frame;
import 'package:flutter_template/global_widgets/gw_sfw_wrapper.dart'
    as gw_sfw_wrapper;
import 'package:flutter_template/repositories/drift_db/data_provider.dart';
import 'package:flutter_template/repositories/drift_db/daos/dao_todos.dart';
import 'package:flutter_template/repositories/drift_db/app_database.dart';

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
    daoTodos = DatabaseProvider.todosDao;
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

  late DaoTodos daoTodos;
  final TextEditingController textFieldController = TextEditingController();

  // [private 변수]

  //----------------------------------------------------------------------------
  // !!!비즈니스 함수는 이 곳에서 저장 하여 사용 하세요.!!!
  // [public 함수]
  // (메인 위젯 화면 갱신)
  late VoidCallback refreshUi;

  void addTodo() async {
    final text = textFieldController.text.trim();
    if (text.isNotEmpty) {
      await daoTodos.insertTodo(TodosCompanion(title: drift.Value(text)));
      textFieldController.clear();
    }
  }

  void deleteTodo(int id) async {
    await daoTodos.deleteTodoById(id);
  }

  Future<void> exportDatabase() async {
    final dbFile = await getDatabaseFile();

    // 원본 파일 바이트 읽기
    final bytes = await dbFile.readAsBytes();

    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Export SQLite DB',
      fileName: 'backup.sqlite',
      type: FileType.custom,
      allowedExtensions: ['sqlite', 'db'],
      bytes: bytes, // 여기서 bytes 넣기 (Android/iOS 필수)
    );

    if (savePath != null) {
      showToast(
        "Export 완료: $savePath",
        context: mainContext,
        position: StyledToastPosition.center,
        animation: StyledToastAnimation.scale,
      );
    } else {
      showToast(
        "Export 취소됨",
        context: mainContext,
        position: StyledToastPosition.center,
        animation: StyledToastAnimation.scale,
      );
    }
  }

  Future<void> importDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Import SQLite DB',
      type: FileType.any, // 커스텀 확장자 지원 안되면 any로 둠
    );

    if (result != null && result.files.single.path != null) {
      final importPath = result.files.single.path!;

      // 확장자 직접 체크
      if (!(importPath.endsWith('.sqlite') || importPath.endsWith('.db'))) {
        showToast(
          "지원하지 않는 파일 형식입니다.",
          context: mainContext,
          position: StyledToastPosition.center,
          animation: StyledToastAnimation.scale,
        );
        return;
      }

      final dbFile = await getDatabaseFile();

      await DatabaseProvider.instance.close(); // 현재 DB 연결 닫기

      while (true) {
        try {
          if (await dbFile.exists()) {
            await dbFile.delete();
          }
          break;
        } catch (e) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }

      await File(importPath).copy(dbFile.path);

      DatabaseProvider.instance = AppDatabase();
      DatabaseProvider.todosDao = DatabaseProvider.instance.daoTodos;
      daoTodos = DatabaseProvider.todosDao;
      refreshUi();

      showToast(
        "Import 완료",
        context: mainContext,
        position: StyledToastPosition.center,
        animation: StyledToastAnimation.scale,
      );
    }
  }

  // [private 함수]
  void _doNothing() {}
}
