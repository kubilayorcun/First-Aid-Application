import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class FavouritesTab extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return FavouritesTabState();

  }





}

class FavouritesTabState extends State<FavouritesTab>{


  final dbHelper = DatabaseHelper.instance;

  List tempList = new List();
  List favList = new List();

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) {
      tempList = row.values.toList();
      print(tempList[1]);
      favList.add(tempList[1]);
    });

  }

  @override
  void initState() {
    super.initState();
    favList.clear();
    _query();
    print(favList);
  }

  @override
  Widget build(BuildContext context) {
    print(favList);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
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
                      title: Text(favList[index]),
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

