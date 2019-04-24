import 'package:flutter/material.dart';
import 'CustomWidgets/SubMethodListItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets/ListItem.dart';
class SearchTab extends StatefulWidget {
  List<SubMethodListItem> favList;
  SearchTab(List<SubMethodListItem> favList) {
   this.favList = favList;
  }
  String searchText = "";
  Text text;
  //final items = List<String>.generate(10000, (i) => "Item $i");
  List<String> items = new List<String>();

  @override
  SearchTabState createState() => new SearchTabState(favList);

}

class SearchTabState extends State<SearchTab> {
  TextEditingController editingController = new TextEditingController();
  List<SubMethodListItem> favList;
  SearchTabState(List<SubMethodListItem> favList) {
    this.favList=favList;
  }

  final defaultList = List<String>();
  var items = List<String>();

  @override
  void initState() {
    items.addAll(defaultList);
    super.initState();
  }


  void filterSearchResults(String query){
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(defaultList);
    if(query.isNotEmpty){
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item){
        if(item.contains(query)){
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(defaultList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
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
                keyboardType: TextInputType.multiline ,
                maxLines: null,
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black
                ),
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 8.0,bottom: 8.0, left: 8.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22.0))
                    ),
                    hintText: "Search",
                    labelText: "Search",
                    hintStyle: TextStyle(),
                    prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('CategoryNames').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    print(snapshot.data.documents[2].data.values.toList());
                    return ListView.separated(
                      padding: EdgeInsets.all(8.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        defaultList.add(snapshot.data.documents[index].data['Name']);
                        items.add(snapshot.data.documents[index].data['Name']);
                        return ListItem(items[index],favList);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(color: Colors.black);
                      },
                    );
                  },
                )
            )
          ],
        ),
      ),
    );
  }



}





