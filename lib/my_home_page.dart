import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:velocity_x/velocity_x.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //with 대신 implement를 사용할 수도 있지만 대신 필수로 구현해야 하는 함수를 그대로 구현시켜줘야 한다.
  int _counter = 0;
  late ShakeDetector detector;

  //나중에 초기화가 될 것이기에 late로 선언
  //didChangeAppLifecycleState에서 사용하기위해 initstate에서 선언부를 꺼냄

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
        onPhoneShake: () {
          setState(() {
            _counter++;
          });
        },
        shakeThresholdGravity: 1.5);
    //민감도 값 변경
    WidgetsBinding.instance.addObserver(this);
    //옵저버라는 리스너 추가
    //addObserver 내에 관찰할 객체(대상)을 넣어줘야 함 -> WidgetsBindingObserver
    //그러나 _MyHomePageState는 WidgestBindingObserver가 아니기에 with를 이용해 해당 객체로 변신을 시켜줍니다.
    //mixing 형태로 구현했다고 생각하면 편하다.
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        detector.startListening();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        detector.stopListening();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  //각 경우의 수에 따른 detector의 활동을 중지 혹은 재시작 설정

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //이것을 하지 않으면 메모리 reak이 생길 수 있다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            '흔들어서 카운트를 올려보세요'
                .text
                .bold
                .indigo300
                .isIntrinsic
                .size(20)
                .makeCentered()
                .box
                .color(Colors.black)
                .height(40)
                .withRounded()
                .make()
                .pSymmetric(h: 10, v: 10),
            //velocity_x를 이용해 Text랑 패딩 그리고 감싼 box를 축약한 코드
            //이걸 이제 메소드나 위젯 형태로 Extract해서 관리할 것!
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
