import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './CustomWidgets/ListItem.dart';
class MethodListTab extends StatelessWidget {

  List favList;

  MethodListTab(List favList) {
    this.favList = favList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("İlk Yardım"),
        ),
        body: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('CategoryNames').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return ListView.separated(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListItem(snapshot.data.documents[index].data['Name'],favList);
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
/*ListView.separated(
padding: EdgeInsets.all(8.0),
itemCount: categories.length,
itemBuilder: (BuildContext context, int index) {
return categories[index];
},
separatorBuilder: (BuildContext context, int index) {
return Divider(color: Colors.black);
},
)*/
