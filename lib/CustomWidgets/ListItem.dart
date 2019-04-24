import 'package:flutter/material.dart';
import '../SubMethodsPage.dart';

class ListItem extends StatefulWidget {
  String categoryName;
  List favList;

  ListItem(String categoryName,List favList) {
    this.categoryName = categoryName;
    this.favList = favList;
  }

  @override
  State<StatefulWidget> createState() {
    return _ListItemState(categoryName,favList);
  }

}

class _ListItemState extends State<ListItem> {
  var _color;
  String categoryName;
  List favList;

  _ListItemState(String categoryName,List favList) {
    this.categoryName = categoryName;
    this.favList = favList;
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
            padding: const EdgeInsets.only(
                left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.local_hospital),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(categoryName,
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.4)),
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

  void _onClickItem(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SubMethodsPage(categoryName,favList)));
  }

}
