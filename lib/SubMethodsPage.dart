import 'package:flutter/material.dart';
import 'CustomWidgets/SubMethodListItem.dart';

class SubMethodsPage extends StatefulWidget {
  String categoryName;

  SubMethodsPage(String categoryName) {
    this.categoryName = categoryName;
  }

  @override
  State<StatefulWidget> createState() {
    return _SubMethodsPageState(categoryName);
  }
}

class _SubMethodsPageState extends State<SubMethodsPage> {
  String categoryName;
  List<String> subCategories = ["1. Madde", "2.Madde", "3.Madde"];

  _SubMethodsPageState(String categoryName) {
    this.categoryName = categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: ListView.separated(
          padding: EdgeInsets.all(8.0),
          itemCount: subCategories.length,
          itemBuilder: (BuildContext context, int index) {
            return SubMethodListItem(subCategories[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: Colors.black);
          },
        ),
      ),
    );
  }
}
