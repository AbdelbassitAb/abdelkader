import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/screens/chefsScreen.dart';
import 'package:abdelkader/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:abdelkader/screens/constant.dart';
import 'package:uuid/uuid.dart';

import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final double money;
  final bool deleted;
  final String pic;


  Profile(
      {this.uid,
      this.name,
      this.email,
      this.phoneNumber,
      this.money,
      this.deleted,
      this.pic});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Uint8List imageBytes;
  String errorMsg;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  var uuid = Uuid();


  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String img;
  String _currentName;
  String _currentEmail;
  String _currentPhoneNumber;
  String somme;
  double _currentMoney;
  String url;

  Future<void> GetImage() async {
    final ref =
        FirebaseStorage.instance.ref().child('uploads/${this.widget.pic}');
// no need of the file extension, the name will do fine.
    var url1 = await ref.getDownloadURL();
    setState(() {
      url = url1.toString();
    });
  }

  @override
  void initState() {
    if (this.widget.pic != null) {
      GetImage();
    }
    _currentPhoneNumber = this.widget.phoneNumber;
    _currentName = this.widget.name;
    _currentEmail = this.widget.email;
    _currentMoney = this.widget.money;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var img = imageBytes != null
        ? Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          )
        : Text(errorMsg != null ? errorMsg : "Loading...");

    /*Future<void>  GetImage() async {
      final ref = FirebaseStorage.instance.ref().child('uploads/${this.widget.pic}');
      var url = await ref.getDownloadURL();
      setState(() {
        img = url;

      });
    }*/

    Size size = MediaQuery.of(context).size;

    Future<void> _DeleteMsg() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Voulez vous vraiment supprimer cet utilisateur ?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Oui'),
                onPressed: () {
                  DatabaseService().updateUserData(
                      this.widget.uid,
                      this.widget.name,
                      this.widget.email,
                      this.widget.phoneNumber,
                      this.widget.money,
                      true);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChefsScreen()));
                },
              ),
              TextButton(
                child: Text('Non'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Entrer une somme'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formKey1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: textinputDecoration.copyWith(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'entrer un numero' : null,
                      onChanged: (val) => setState(() => somme = val),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                  color: Colors.green,
                  child: Text('Ajouter'),
                  onPressed: () {
                    if (_formKey1.currentState.validate()) {
                      setState(() {
                        _currentMoney = double.parse(somme) + _currentMoney;
                      });
                      Navigator.of(context).pop();
                    }
                  }),
              RaisedButton(
                  color: Colors.red,
                  child: Text('Substituer'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _currentMoney = _currentMoney - double.parse(somme);
                      });

                      Navigator.of(context).pop();
                    }
                  })
            ],
          );
        },
      );
    }

    return StreamProvider<CollectionReference>.value(
      child: MaterialApp(
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      //DatabaseService().deleteChef(this.widget.uid);
                      _DeleteMsg();
                    },
                  ),
                )
              ],
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: size.width * 0.8,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {},
                                child: url != null
                                    ? Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(url),
                                              fit: BoxFit.cover),
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            AssetImage('assets/61205.png'),
                                      ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                initialValue: this.widget.name,
                                decoration: textinputDecoration.copyWith(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'entrer un nom' : null,
                                onChanged: (val) =>
                                    setState(() => _currentName = val),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                initialValue: this.widget.email,
                                decoration: textinputDecoration.copyWith(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.blue,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (val) => val.isEmpty
                                    ? 'entrer un email'
                                    : null,
                                onChanged: (val) =>
                                    setState(() => _currentEmail = val),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: this.widget.phoneNumber,
                                decoration: textinputDecoration.copyWith(
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    color: Colors.blue,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (val) => val.isEmpty
                                    ? 'entrer un numero de telephone'
                                    : null,
                                onChanged: (val) =>
                                    setState(() => _currentPhoneNumber = val),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 47,
                                width: size.width * 0.9,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    )),
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.attach_money,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Text(
                                    _currentMoney.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '   DA',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      onPressed: _showMyDialog),
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
                                      color: (_currentPhoneNumber !=
                                                  this.widget.phoneNumber ||
                                              _currentEmail !=
                                                  this.widget.email ||
                                              _currentName !=
                                                  this.widget.name ||
                                              _currentMoney !=
                                                  this.widget.money)
                                          ? Colors.red
                                          : Colors.grey,
                                      child: Text(
                                        'Modifier',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: (_currentPhoneNumber !=
                                                  this.widget.phoneNumber ||
                                              _currentEmail !=
                                                  this.widget.email ||
                                              _currentName !=
                                                  this.widget.name ||
                                              _currentMoney !=
                                                  this.widget.money)
                                          ? () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                await DatabaseService(
                                                        uid: this.widget.uid)
                                                    .updateUserData(
                                                        this.widget.uid,
                                                        _currentName ??
                                                            this.widget.name,
                                                        _currentEmail ??
                                                            this.widget.email,
                                                        _currentPhoneNumber ??
                                                            this
                                                                .widget
                                                                .phoneNumber,
                                                        _currentMoney ??
                                                            this.widget.money,
                                                        this.widget.deleted);


                                                if(_currentMoney <
                                                    this.widget.money){
                                                  await DatabaseService(uid: this.widget.uid).updateUserTransaction( uuid.v4(), '' , 'Abdelkader a payé ${this.widget.name}',  dateFormat.format(DateTime.now()),  _currentMoney ??
                                                      this.widget.money,- double.parse(somme), Workerr(), false);

                                                }
                                                if(_currentMoney >
                                                    this.widget.money){
                                                  await DatabaseService(uid: this.widget.uid).updateUserTransaction( uuid.v4(), '' , 'Abdelkader a payé ${this.widget.name}',  dateFormat.format(DateTime.now()),  _currentMoney ??
                                                      this.widget.money,double.parse(somme), Workerr(), false);

                                                }

                                                
                                                
                                                Navigator.pop(context);
                                              }
                                            }
                                          : null),
                                ),
                              ),
                            ],
                          ),
                        ),
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
