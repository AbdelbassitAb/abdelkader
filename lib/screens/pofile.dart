import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final double money;
  Profile({this.uid, this.name, this.email, this.phoneNumber, this.money});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamProvider<CollectionReference>.value(
      child: MaterialApp(
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              centerTitle: true,
              leading: Icon(Icons.arrow_back),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      DatabaseService().deleteChef(this.widget.uid);

                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  child: Center(
                    child: Container(
                      width: size.width,
                      color: Colors.black.withOpacity(0.2),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/61205.png'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: size.width * 0.9,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.person,
                                size: 40,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                this.widget.name,
                                style: TextStyle(fontSize: 25),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: size.width * 0.9,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.email,
                                size: 40,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                this.widget.email,
                                style: TextStyle(fontSize: 20),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: size.width * 0.9,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.phone,
                                size: 40,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                this.widget.phoneNumber,
                                style: TextStyle(fontSize: 25),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: size.width * 0.9,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.attach_money,
                                size: 40,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                this.widget.money.toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: size.width * 0.5,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: RaisedButton(
                                  color: Colors.red,
                                  child: Text(
                                    'Modifier',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
