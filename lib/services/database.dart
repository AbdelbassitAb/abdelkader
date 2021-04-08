
import 'package:abdelkader/models/chef.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference transactionsCollection =
  FirebaseFirestore.instance.collection('Transactions');
  final CollectionReference workersCollection =
  FirebaseFirestore.instance.collection('Workers');

  CollectionReference get collection {
    return usersCollection;
  }

  Future<void> updateUserData(String uid, String name, String email,
      String numTlf, double argent,bool deleted,{String pic}) async {
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'numTlf': numTlf,
      'argent': argent,
      'deleted': deleted,
      'pic' : pic,
    });
  }

  Future<void> updateWorkerData(String uid, String name,) async {
    return await workersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
    });
  }


  Future<void> updateUserTransaction(String uid, String name,String description,String time,
       double argent,double somme,Workerr worker,bool deleted) async {

    await transactionsCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'description' : description,
      'time' : time,
      'argent': argent,
      'somme' : somme,
      'workerName' : worker.name,
      'workerId' : worker.uid,
      'deleted': deleted,
    });



  if(worker.uid!=null)
    {

    await workersCollection.doc(worker.uid).collection('Transactions').doc(uid).set({
      'uid': uid,
      'name': name,
      'description' : description,
      'time' : time,
      'argent': argent,
      'somme' : somme,
      'workerName' : worker.name,
      'workerId' : worker.uid,
      'deleted': deleted,
    });
    }

    return await usersCollection.doc(this.uid).collection('Transactions').doc(uid).set({
      'uid': uid,
      'name': name,
      'description' : description,
      'time' : time,
      'argent': argent,
      'somme' : somme,
      'workerName' : worker.name,
      'workerId' : worker.uid,
      'deleted': deleted,
    });
  }



  Future<void> addTransaction(String uid, String name,String description,String time,
      double argent,double somme,bool deleted) async {
    return await usersCollection.doc(uid).collection('Transactions').add({
      'uid': uid,
      'name': name,
      'description' : description,
      'time' : time,
      'argent': argent,
      'somme' : somme,
      'deleted': deleted,
    });
  }





  List<ChefData> _chefListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChefData(
          uid: doc.data()['uid'],
          name: doc.data()['name'],
          email: doc.data()['email'],
          numTlf: doc.data()['numTlf'],
          argent: doc.data()['argent'],
          deleted: doc.data()['deleted'],
          pic: doc.data()['pic']);
    }).toList();
  }

  List<Workerr> _workerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Workerr(
          uid: doc.data()['uid'],
          name: doc.data()['name'],
          );
    }).toList();
  }



  List<TR> _transactionsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TR(
          uid: doc.data()['uid'],
          name: doc.data()['name'],
          description: doc.data()['description'],
         time: doc.data()['time'],
          argent: doc.data()['argent'],
          somme: doc.data()['somme'],
          workerName: doc.data()['workerName'],
          workerId: doc.data()['workerId'],
          deleted: doc.data()['deleted']);
    }).toList();
  }



  //get brews stream
  Stream<List<ChefData>> get chefs {
    return usersCollection.snapshots().map(_chefListFromSnapshot);
  }

  Stream<List<Workerr>> get workers {
    return workersCollection.snapshots().map(_workerListFromSnapshot);
  }

  Stream<List<TR>> get allTransactions {
    return  transactionsCollection.snapshots().map(_transactionsListFromSnapshot);
  }



  Stream<List<TR>> get transactions {
    return  usersCollection.doc(uid).collection('Transactions').snapshots().map(_transactionsListFromSnapshot);
  }







  Stream<List<TR>> get workerTransactions {
    return  workersCollection.doc(uid).collection('Transactions').snapshots().map(_transactionsListFromSnapshot);
  }




  Future<void> deleteChef(String id) {
    return usersCollection.doc(id).delete();
  }



  Future<void> deleteTransaction(String id) {
    transactionsCollection.doc(id).delete();
    return usersCollection.doc(this.uid).collection('Transactions').doc(id).delete();

  }
  Future<void> deleteWorkersTransaction(String id) {
    return workersCollection.doc(this.uid).collection('Transactions').doc(id).delete();

  }






}
class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadFromStorage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }





}