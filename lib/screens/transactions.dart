import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/screens/constant.dart';
import 'package:abdelkader/services/database.dart';
import 'package:get/get.dart';

import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final double money;
  final bool deleted;

  Transactions({
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.money,
    this.deleted,
  });

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final TransactionsController transactionsController =
      Get.put(TransactionsController());
  ChefData chefData = ChefData();

  @override
  void initState() {
    chefData = ChefData(
        uid: this.widget.uid,
        argent: this.widget.money,
        name: this.widget.name,
        email: this.widget.email,
        numTlf: this.widget.phoneNumber,
        deleted: this.widget.deleted);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Transactions'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            StreamBuilder<List<TR>>(
                stream: DatabaseService(uid: this.widget.uid).transactions,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Center(
                        child: Text('Pas de transaction trouvé'),
                      );
                    } else {
                      snapshot.data.sort((a,b) {
                        return b.time.compareTo(a.time);
                      });
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                showMyDialog(
                                    snapshot.data[index], context, chefData);
                              },
                              child:
                                  Transaction_Card(data: snapshot.data[index]));
                        },
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showMyDialog(TR(somme: 0, argent: this.widget.money),
                        context, chefData);
                  },
                ))
          ],
        ));
  }
}
