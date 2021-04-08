import 'package:flutter/cupertino.dart';

class Chef {
  final String uid;
  Chef({this.uid});
}




class ChefData {
  final String uid;
  final String name;
  final String email;
  final String numTlf;
  final double argent;
  final bool deleted;
  final String pic;

  ChefData({this.uid, this.name, this.email, this.numTlf, this.argent,this.deleted,this.pic});
}

class TR {
  final String uid;
  final String name;
  final String description;
  final String time;
  final double argent;
  final double somme;
  final String workerName;
  final String workerId;
  final bool deleted;


  // final String workerName;

  TR({this.uid,this.name,this.description,this.time,this.argent,this.somme,this.workerName,this.workerId,this.deleted});
}

class Workerr {

   String name;
   String uid;

  Workerr({this.name,this.uid});

}




