import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets/ListItem.dart';
class FirebaseHelper extends StatelessWidget {
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('CategoryNames').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        print(snapshot.data.documents[2].data.values.toList());
        return ListView.separated(
          padding: EdgeInsets.all(8.0),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            return ListItem(snapshot.data.documents[index].data['Name']);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: Colors.black);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
