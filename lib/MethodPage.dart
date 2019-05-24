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
  bool isTtsSingleEnabled;
  int currentIndex = 0;
  bool isTtsEnabled;

  List<String> content = [];

  _MethodPageState(String appBarTitle, String baseCategory) {
    this.appBarTitle = appBarTitle;
    this.baseCategory = baseCategory;
  }

  Future<void> getContent() async {
    await for (var snapshot in Firestore.instance
        .collection(baseCategory)
        .document(appBarTitle)
        .snapshots()) {
      for (String a in snapshot.data["Content"]) {
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
    isTtsSingleEnabled = false;
    currentIndex = 0;
    getContent();
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

  void readSingleLine(String line) {
    if (isTtsSingleEnabled) {
      _stop();
    } else {
      if (line.startsWith("http")) {
        setState(() {
          currentIndex++;
        });
        readSingleLine(content[currentIndex]);
      } else {
        _stop();
        _speak(line);
      }
    }

    setState(() {
      isTtsSingleEnabled = !isTtsSingleEnabled;
    });
  }

  void readNext(String line) {
    if (line.startsWith("http")) {
      setState(() {
        currentIndex++;
      });
      readNext(content[currentIndex]);
    } else {
      _stop();
      _speak(line);
    }
  }

  void readContent(List content) {
    String strContent = "";
    for (int i = 0; i < content.length; i++) {
      strContent = strContent + content[i];
    }

    isTtsEnabled ? _stop() : _speak(strContent);

    setState(() {
      isTtsEnabled = !isTtsEnabled;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(

              itemCount: content.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      print(index.toString() + "number tapped.");
                      setState(() {
                        currentIndex = index;
                        if (isTtsSingleEnabled) {
                          isTtsSingleEnabled = !isTtsSingleEnabled;
                        }
                      });
                      _stop();
                    },
                    title: Container(
                      
                      // , backgroundColor: (currentIndex==index)?Color.fromRGBO(255, 128, 128, 1):Colors.white),
                      decoration: (currentIndex==index)?BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                        color: Colors.redAccent,
                        style: BorderStyle.solid,
                        width: 2.0,
                      )):null,
                      child: Container(
                        child: content[index].startsWith("http")
                            ? Image.network(content[index])
                            : Text(content[index],
                                style: TextStyle(fontSize: 20, )),
                        padding: EdgeInsets.all(10.0),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        child: Row(
          children: <Widget>[
            Container(
              child: FloatingActionButton(
                heroTag: "1",
                onPressed: () => readSingleLine(content[currentIndex]),
                child: isTtsSingleEnabled
                    ? Icon(Icons.stop)
                    : Icon(Icons.skip_next),
                elevation: 20.0,
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
            ),
            Container(
              child: FloatingActionButton(
                heroTag: "2",
                onPressed: () {
                  setState(() {
                    currentIndex++;
                  });
                  readNext(content[currentIndex]);
                },
                child: Icon(Icons.navigate_next),
                elevation: 20.0,
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
            ),
            Container(
              child: FloatingActionButton(
                heroTag: "3",
                onPressed: () => readContent(content),
                child: isTtsEnabled ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                elevation: 20.0,
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          bottom: 30.0,
          right: 15.0,
          left: 20.0,
        ),
        height: 100.0,
        width: 280.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
