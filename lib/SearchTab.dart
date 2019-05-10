import 'dart:async';

import 'package:flutter/material.dart';
import 'CustomWidgets/SubMethodListItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MethodPage.dart';

class SearchTab extends StatefulWidget {
  List<SubMethodListItem> favList;

  SearchTab(List<SubMethodListItem> favList) {
    this.favList = favList;
  }

  Text text;

  @override
  SearchTabState createState() => new SearchTabState(favList);
}

class SearchTabState extends State<SearchTab> {
  TextEditingController editingController = new TextEditingController();
  List<SubMethodListItem> favList;

  SearchTabState(List<SubMethodListItem> favList) {
    this.favList = favList;
  }

  List<String> defaultList = [];
  List<String> defaultBaseList = [];
  List<String> items = List<String>();
  List<String> baseItems = List<String>();

  Future<void> getAllSubCategories() async {
    List<String> categoryNames = [];

    await for (var snapshot
        in Firestore.instance.collection("CategoryNames").snapshots()) {
      for (var a in snapshot.documents) {
        categoryNames.add(a.data["Name"]);
        print(a.data["Name"]);
      }
      break;
    }

    print("mert");
    for (var a in categoryNames) {
      await for (var snapshot in Firestore.instance.collection(a).snapshots()) {
        for (var b in snapshot.documents) {
          setState(() {
            defaultList.add(b.data["Name"]);
            defaultBaseList.add(a);
            print(b.data["Name"]);
          });
        }
        break;
      }
    }
    setState(() {
      items.addAll(defaultList);
      baseItems.addAll(defaultBaseList);
    });
  }

  @override
  void initState() {
    getAllSubCategories();
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      items.clear();
      baseItems.clear();
    });
    query = query.toLowerCase();
    if (query.isNotEmpty) {
      for (int i = 0; i < defaultList.length; i++) {
        if (defaultList[i].toLowerCase().contains(query)) {
          setState(() {
            items.add(defaultList[i]);
            baseItems.add(defaultBaseList[i]);
          });
        }
      }
    } else {
      setState(() {
        items.addAll(defaultList);
        baseItems.addAll(defaultBaseList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arama"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.topCenter,
              child: TextField(
                cursorColor: Colors.red,
                cursorWidth: 2.0,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 17.0, color: Colors.black),
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    hintText: "Ara",
                    labelText: "Arama",
                    hintStyle: TextStyle(),
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(8.0),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(child: Text(items[index]), padding: EdgeInsets.all(10),),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MethodPage(
                                      items[index], baseItems[index])))
                        },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Colors.black);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
