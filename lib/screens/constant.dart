import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/models/transaction.dart';
import 'package:abdelkader/screens/pofile.dart';
import 'package:abdelkader/screens/profile_transactions.dart';
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
      color: Colors.blue,
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
                    builder: (context) => Profile_Transactions(
                          uid: data.uid,
                          name: data.name,
                          email: data.email,
                          phoneNumber: data.numTlf,
                          money: data.argent,
                          deleted: data.deleted,
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
        if (usersList[index].deleted == false) {
          return UserCard(data: usersList[index]);
        } else
          return SizedBox(
            height: 0,
          );
      },
    );
  }
}

class Transaction_Card extends StatelessWidget {
  final Transaction1 data;
  Transaction_Card({this.data});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text(
                'Description',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 5,),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.somme.toString()),
                    Text(
                      data.time.toIso8601String(),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  Widget build(BuildContext context) {
    final transactionsList = Provider.of<List<Transaction1>>(context) ?? [];
    return ListView.builder(
      itemCount: transactionsList.length,
      itemBuilder: (context, index) {
        print('hhhhh');
        return Transaction_Card(data: transactionsList[index]);

      },
    );
  }
}


