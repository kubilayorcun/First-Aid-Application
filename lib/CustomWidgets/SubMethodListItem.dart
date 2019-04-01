import 'package:flutter/material.dart';
import '../MethodPage.dart';
import 'package:firstaidproject/DatabaseHelper.dart';

class SubMethodListItem extends StatefulWidget {
  String categoryName;

  SubMethodListItem(String categoryName) {
    this.categoryName = categoryName;
  }

  @override
  State<StatefulWidget> createState() {
    return _SubMethodListItemState(categoryName);
  }
}



class _SubMethodListItemState extends State<SubMethodListItem> {

  var _favIcon;
  String categoryName;
  final dbHelper = DatabaseHelper.instance;

  _SubMethodListItemState(String categoryName) {
    this.categoryName = categoryName;
    this._favIcon = Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          splashColor: Color.fromRGBO(255, 81, 81, 0),
          highlightColor: Colors.red,
          onTap: () => _onClickItem(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 0.0, bottom: 5.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  Icon(Icons.access_alarm),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(categoryName,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.4)),
                  )
                ]),
                IconButton(
                  color: Colors.red,
                  onPressed: _onClickFavIcon,
                  icon: Icon(_favIcon),
                  padding: EdgeInsets.all(0),
                )
              ],
            ),
          ),
        ),
        /*Divider(
              color: Colors.black,

          )*/
      ],
    );
  }

  void _insert(String name) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name
    };

    await dbHelper.insert(row);
  }


  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) => print(row));
  }

  void _onClickItem(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MethodPage(categoryName)));
  }

  void _onClickFavIcon() {
    setState(() {
      _favIcon = (_favIcon==Icons.star_border)?Icons.star:Icons.star_border;
    });
    if(_favIcon == Icons.star_border){
      print("remove : " + categoryName);
      // TODO: Means that user wants to remove the item from favourites (which is again the persistent data on user's phone.)
    }
    else if(_favIcon == Icons.star){
      print("add : " + categoryName);
      _insert(categoryName);
      // TODO: Add to favourites tab list. (which is a persistent data on user's phones)
    }
  }
}
