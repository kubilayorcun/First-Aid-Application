import 'package:flutter/material.dart';
import 'MethodListTab.dart';
import 'SearchTab.dart';
import 'FavouritesTab.dart';
import 'DatabaseHelper.dart';
import 'CustomWidgets/SubMethodListItem.dart';
void main() => runApp(MyApp());
/**
 * 1-highlight the content that is being read by the tts.
 * 2-Center the string that is being read by the tts.
 * 3-Add pictures/pngs to content page.
 * 4-Update favorites list on delete. (instant rerender)
 * **/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İlk Yardım',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final dbHelper = DatabaseHelper.instance;
  List tempList = new List();
  static List<SubMethodListItem> favList = new List();

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) {
      tempList = row.values.toList();
      //print(tempList[1]);
      favList.add(SubMethodListItem(tempList[1],favList,true,tempList[2]));
    });

  }

  @override
  void initState() {
    super.initState();
    favList.clear();
    _query();
  }

  final _widgetOptions = [
    new MethodListTab(favList),
    new SearchTab(favList),
    new FavouritesTab(favList),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('')),
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('')),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), title: Text('')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
