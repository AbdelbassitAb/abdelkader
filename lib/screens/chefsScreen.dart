import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/screens/addChefScreen.dart';
import 'package:abdelkader/screens/constant.dart';
import 'package:abdelkader/screens/home.dart';
import 'package:abdelkader/screens/users.dart';
import 'package:abdelkader/screens/workers.dart';
import 'package:abdelkader/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChefsScreen extends StatefulWidget {
  @override
  _ChefsScreenState createState() => _ChefsScreenState();
}

class _ChefsScreenState extends State<ChefsScreen> {
  int _selectedindex;
  @override
  void initState() {
    _selectedindex = 0;
    super.initState();
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Users(),
    Workers(),
  ];
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ChefData>>.value(
      value: DatabaseService().chefs,
      child: MaterialApp(
        home: Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedindex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),title: Text('Page principale'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),title: Text('Chefs chantier'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),title: Text('Travailleurs'),
                )
              ],
              currentIndex: _selectedindex,
              onTap: (value){setState(() {
                _selectedindex=value;
              });},type: BottomNavigationBarType.shifting,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black,
              showUnselectedLabels: true,
            )),
      ),
    );
  }
}
