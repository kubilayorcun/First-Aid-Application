import 'package:flutter/material.dart';
import '../SubMethodsPage.dart';

class ListItem extends StatefulWidget {
  String categoryName;

  ListItem(String categoryName) {
    this.categoryName = categoryName;
  }

  @override
  State<StatefulWidget> createState() {
    return _ListItemState(categoryName);
  }

}

class _ListItemState extends State<ListItem> {
  var _color;
  String categoryName;

  _ListItemState(String categoryName) {
    this.categoryName = categoryName;
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
                Icon(Icons.access_alarm),
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
        MaterialPageRoute(builder: (context) => SubMethodsPage(categoryName)));
  }

}
