import 'package:abdelkader/models/chef.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:abdelkader/models/transaction.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference transactionsCollection = FirebaseFirestore.instance.collection('Transactions');

  CollectionReference get collection {
    return usersCollection;
  }

  Future<void> updateUserData(String uid, String name, String email,
      String numTlf, double argent,bool deleted) async {
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'numTlf': numTlf,
      'argent': argent,
      'deleted': deleted,
    });
  }

  Future<void> updateUserTransaction(String uid, String name,String description,DateTime time,
       double argent,double somme,bool deleted) async {
    return await usersCollection.doc(uid).collection('Transactions').doc(DateTime.now().toString()).set({
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
          deleted: doc.data()['deleted']);
    }).toList();
  }

  List<Transaction1> TransactionsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Transaction1(
          uid: doc.data()['uid'],
          name: doc.data()['name'],
          description: doc.data()['description'],
          time: doc.data()['time'],
          somme: doc.data()['somme'],
          argent: doc.data()['argent'],
          deleted: doc.data()['deleted']);
    }).toList();
  }

  ChefData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return ChefData(
        uid: uid,
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        numTlf: snapshot.data()['numTlf'],
        argent: snapshot.data()['argent'],
        deleted: snapshot.data()['deleted']);
  }

  //get brews stream
  Stream<List<ChefData>> get chefs {
    return usersCollection.snapshots().map(_chefListFromSnapshot);
  }

  Stream<List<Transaction1>> get transactions{
    return  usersCollection.doc(uid).collection('Transactions').snapshots().map(TransactionsListFromSnapshot);
  }



  Stream<ChefData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<void> deleteChef(String id) {
    return usersCollection.doc(id).delete();
  }
}
