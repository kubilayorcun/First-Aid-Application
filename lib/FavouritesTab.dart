import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'CustomWidgets/SubMethodListItem.dart';

class FavouritesTab extends StatefulWidget {

  List<SubMethodListItem> favList;

  FavouritesTab(List<SubMethodListItem> favList) {
    this.favList = favList;
  }

  @override
  State<StatefulWidget> createState() {
    return FavouritesTabState(favList);
  }
}

class FavouritesTabState extends State<FavouritesTab>{


  final dbHelper = DatabaseHelper.instance;

  List tempList = new List();
  List<SubMethodListItem> favList;

  FavouritesTabState(List<SubMethodListItem> favList) {
    this.favList = favList;
  }


  @override
  Widget build(BuildContext context) {
    print(favList);
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoriler"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: favList.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context , int index){
                    return ListTile(
                      title: SubMethodListItem(favList[index].getCategoryName(),favList,favList[index].isFav,favList[index].getBaseCategoryName()),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

}

