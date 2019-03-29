import 'package:flutter/material.dart';
import './CustomWidgets/ListItem.dart';

class MethodListTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Widget> categories = [

     ListItem("Boğulma"),
     ListItem("Kanama"),
     ListItem("Kalp krizi"),
     ListItem("Kas ve kemik"),
     ListItem("Suni teneffüs"),


    ];
    return Scaffold(
        body: Center(
            child: ListView.separated(
              padding: EdgeInsets.all(8.0),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return categories[index];
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.black);
              },
            )
        )
    );
  }
}
