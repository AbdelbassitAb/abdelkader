import 'package:abdelkader/models/chef.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  CollectionReference get collection {
    return usersCollection;
  }

  Future<void> updateUserData(String uid, String name, String email,
      String numTlf, double argent) async {
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'numTlf': numTlf,
      'argent': argent,
    });
  }

  List<ChefData> _chefListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChefData(
          uid: doc.data()['uid'],
          name: doc.data()['name'],
          email: doc.data()['email'],
          numTlf: doc.data()['numTlf'],
          argent: doc.data()['argent']);
    }).toList();
  }

  ChefData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return ChefData(
        uid: uid,
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        numTlf: snapshot.data()['numTlf'],
        argent: snapshot.data()['argent']);
  }

  //get brews stream
  Stream<List<ChefData>> get chefs {
    return usersCollection.snapshots().map(_chefListFromSnapshot);
  }

  Stream<ChefData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<void> deleteChef(String id) {
    return usersCollection.doc(id).delete();
  }
}
