import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/screens/addChefScreen.dart';
import 'package:abdelkader/screens/constant.dart';
import 'package:abdelkader/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChefsScreen extends StatefulWidget {
  @override
  _ChefsScreenState createState() => _ChefsScreenState();
}

class _ChefsScreenState extends State<ChefsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ChefData>>.value(
      value: DatabaseService().chefs,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Users',
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              UsersList(),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddChefScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
