// (external)
import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

// (inner_folder)
import 'main_business.dart' as main_business;

// (all)
import 'package:flutter_project_template/global_widgets/gw_sfw_wrapper.dart'
    as gw_sfw_wrapper;

// [위젯 뷰]

//------------------------------------------------------------------------------
// (입력 데이터)
class InputVo {
  // !!!위젯 입력값 선언!!!
  const InputVo({required this.onDialogCreated});

  // (다이얼로그가 생성된 시점에 한번 실행 되는 콜백)
  final VoidCallback onDialogCreated;
}

// (결과 데이터)
class OutputVo {
  // !!!위젯 출력값 선언!!!
  const OutputVo();
}

//------------------------------------------------------------------------------
class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.inputVo});

  final InputVo inputVo;

  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> with WidgetsBindingObserver {
  // [콜백 함수]
  @override
  Widget build(BuildContext context) {
    mainBusiness.mainContext = context;
    mainBusiness.refreshUi = refreshUi;
    if (mainBusiness.pageInitFirst) {
      mainBusiness.pageInitFirst = false;
      mainBusiness.onCreate();
    }
    return PopScope(
      canPop: mainBusiness.canPop,
      child: FocusDetector(
        onFocusGained: () async {
          if (mainBusiness.needCallOnDialogCreated) {
            mainBusiness.needCallOnDialogCreated = false;
            widget.inputVo.onDialogCreated();
          }
          await mainBusiness.onFocusGainedAsync();
        },
        onFocusLost: () async {
          await mainBusiness.onFocusLostAsync();
        },
        onVisibilityGained: () async {
          await mainBusiness.onVisibilityGainedAsync();
        },
        onVisibilityLost: () async {
          await mainBusiness.onVisibilityLostAsync();
        },
        onForegroundGained: () async {
          await mainBusiness.onForegroundGainedAsync();
        },
        onForegroundLost: () async {
          await mainBusiness.onForegroundLostAsync();
        },
        child: getScreenWidget(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    mainBusiness.mainContext = context;
    mainBusiness.refreshUi = refreshUi;
    mainBusiness.inputVo = widget.inputVo;
    mainBusiness.initState();
  }

  @override
  void dispose() {
    mainBusiness.mainContext = context;
    mainBusiness.refreshUi = refreshUi;
    mainBusiness.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // [public 변수]
  // (mainBusiness) - 데이터 변수 및 함수 저장 역할
  final main_business.MainBusiness mainBusiness = main_business.MainBusiness();

  //----------------------------------------------------------------------------
  // !!!위젯 관련 함수는 이 곳에서 저장 하여 사용 하세요.!!!
  // [public 함수]
  // (MainWidget Refresh 함수)
  void refreshUi() {
    setState(() {});
  }

  // [private 함수]

  //----------------------------------------------------------------------------
  // [화면 작성]
  Widget getScreenWidget() {
    // !!!화면 위젯 작성 하기!!!

    return SingleChildScrollView(
      child: Container(
        height: 300,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    mainBusiness.closeDialog();
                  },
                ),
              ],
            ),
            const Expanded(
              child: Text(
                "테스트 다이얼로그",
                style: TextStyle(fontFamily: "MaruBuri"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
