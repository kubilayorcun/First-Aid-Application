import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'CustomWidgets/SubMethodListItem.dart';

class SubMethodsPage extends StatefulWidget {
  String categoryName;
  List<SubMethodListItem> favList;

  SubMethodsPage(String categoryName,List<SubMethodListItem> favList) {
    this.categoryName = categoryName;
    this.favList = favList;
  }

  @override
  State<StatefulWidget> createState() {
    return _SubMethodsPageState(categoryName,favList);
  }
}

class _SubMethodsPageState extends State<SubMethodsPage> {
  String categoryName;
  List<SubMethodListItem> favList;
  List<String> subCategories = ["1. Madde", "2.Madde", "3.Madde"];

  _SubMethodsPageState(String categoryName,List<SubMethodListItem> favList) {
    this.favList = favList;
    this.categoryName = categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("İlk Yardım"),
        ),
        body: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection(categoryName).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return ListView.separated(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SubMethodListItem(snapshot.data.documents[index].data['Name'],favList,false);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Colors.black);
                  },
                );
              },
            )
        )
    );

  }
}
