import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/screens/pofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const textinputDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(4.0),
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      color: Colors.black,
    ),
    prefixIcon: Icon(
      Icons.attach_money,
      color: Colors.black,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ));

class UserCard extends StatelessWidget {
  final ChefData data;
  UserCard({this.data});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          trailing: Icon(Icons.chevron_right),
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage('assets/61205.png'),
            backgroundColor: Colors.white,
          ),
          title: Text(
            data.name,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                          uid: data.uid,
                          name: data.name,
                          email: data.email,
                          phoneNumber: data.numTlf,
                          money: data.argent,
                        )));
          },
        ),
      ),
    );
  }
}

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    final usersList = Provider.of<List<ChefData>>(context) ?? [];

    return ListView.builder(
      itemCount: usersList.length,
      itemBuilder: (context, index) {
        return UserCard(data: usersList[index]);
      },
    );
  }
}
