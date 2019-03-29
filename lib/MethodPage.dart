import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MethodPage extends StatefulWidget {
  String appBarTitle;

  MethodPage(String appBarTitle) {
    this.appBarTitle = appBarTitle;
  }

  @override
  State<StatefulWidget> createState() {
    return new _MethodPageState(appBarTitle);
  }

}
enum TtsState { playing, stopped }

class _MethodPageState extends State<MethodPage> {
  String appBarTitle;
  FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  final controller = ScrollController();
  double cWidth = 0.0;
  double itemHeight = 28.0;
  double itemsCount = 20;
  double screenWidth;


  _MethodPageState(String appBarTitle) {
    this.appBarTitle = appBarTitle;
  }

  @override
  initState() {
    super.initState();
    initTts();
    controller.addListener(onScroll);
  }

  onScroll() {
    setState(() {
      cWidth = controller.offset * screenWidth / (itemHeight * itemsCount);
    });
  }

  @override
  void dispose() {
    controller.removeListener(onScroll);
  }

  initTts() {
    flutterTts = new FlutterTts();
    flutterTts.setLanguage("tr-TR");
    flutterTts.setVolume(10.0);
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak(String step) async {
    var result = await flutterTts.speak(step);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }


  @override
  Widget build(BuildContext context) {

    List<String> methodSteps = new List();
    methodSteps.add("Şimdi hastayı yatar pozisyona getiriniz.");
    methodSteps.add(
        "Bundan sonra yatar pozisyonda hastayı tedavi etmeye başlayabiliriz.");
    methodSteps.add(
        "Şimdi ise boğulmakta olan hastaya yetkililer gelene kadar sûni teneffüs yapmaya devam etmelisiniz.");


    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 12.0,
              width: cWidth,
              color: Colors.green
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(
                      "• here is a content going on to the next line hopefully",
                      style: TextStyle(fontSize: 60.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(
                      "• here is a content going on to the next line hopefully",
                      style: TextStyle(fontSize: 60.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(40.0),
                    child: Image.asset(
                      'assets/pic.png',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 15.0),
                    child: Text(
                      "• here is a content going on to the next line hopefully",
                      style: TextStyle(fontSize: 60.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 15.0),
                    child: Text(
                      "• here is a content going on to the next line hopefully",
                      style: TextStyle(fontSize: 60.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 15.0),
                    child: Text(
                      "• here is a content going on to the next line hopefully",
                      style: TextStyle(fontSize: 60.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: () =>
              _speak(
                  "Şimdi, kazâzedenin başını hafifçe kaldırmalısınız ki hasta nefes almakta güçlük çekmesin."),
          child: Icon(Icons.headset),
          elevation: 20.0,
        ),
        padding: EdgeInsets.only(
          bottom: 30.0,
          right: 15.0,
        ),
        height: 100.0,
        width: 100.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

}

/**
 *

 * **/
