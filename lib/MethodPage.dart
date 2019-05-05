import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MethodPage extends StatefulWidget {
  String appBarTitle;
  String baseCategory;

  MethodPage(String appBarTitle, String baseCategory) {
    this.appBarTitle = appBarTitle;
    this.baseCategory = baseCategory;
  }

  @override
  State<StatefulWidget> createState() {
    return new _MethodPageState(appBarTitle, baseCategory);
  }
}

enum TtsState { playing, stopped }

class _MethodPageState extends State<MethodPage> {
  String appBarTitle;
  String baseCategory;
  FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  final controller = ScrollController();
  double cWidth = 0.0;
  double itemHeight = 25.0;
  double itemsCount = 8;
  double screenWidth;
  bool isTtsEnabled;

  List<String> content = [];

  _MethodPageState(String appBarTitle, String baseCategory) {
    this.appBarTitle = appBarTitle;
    this.baseCategory = baseCategory;
  }

  Future<void> getContent() async {
    await for (var snapshot in Firestore.instance.collection(baseCategory).document(appBarTitle).snapshots()) {
      for (var a in snapshot.data["Content"]) {
        setState(() {
          content.add(a);
        });
        print(a);
      }
      break;
    }
  }

  @override
  initState() {
    super.initState();
    initTts();
    isTtsEnabled = false;
    controller.addListener(onScroll);
    getContent();
  }

  onScroll() {
    setState(() {
      cWidth = controller.offset * screenWidth / (itemHeight * itemsCount);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onScroll);
  }

  initTts() {
    flutterTts = new FlutterTts();
    flutterTts.setLanguage("tr-TR");
    flutterTts.setVolume(1.0);
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
        isTtsEnabled = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  void readContent(List content) {
    String strContent = "";
    for (int i = 0; i < content.length; i++) {
      strContent = strContent + content[i];
    }

    isTtsEnabled?_stop():_speak(strContent);

    setState(() {
      isTtsEnabled =! isTtsEnabled;
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
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 12.0, width: cWidth, color: Colors.redAccent),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection(baseCategory)
                  .document(appBarTitle)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return ListView.builder(
                  controller: controller,
                  itemCount: snapshot.data["Content"].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        (index+1).toString()+". " + snapshot.data["Content"][index],
                        style: TextStyle(fontSize: 25.0),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: () => readContent(content),
          child: isTtsEnabled?Icon(Icons.headset_off):Icon(Icons.headset),
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
