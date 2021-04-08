import 'package:abdelkader/models/chef.dart';
import 'package:abdelkader/screens/pofile.dart';
import 'package:abdelkader/screens/profile_transactions.dart';
import 'package:abdelkader/screens/workerTransactions.dart';
import 'package:abdelkader/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';


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
            backgroundImage: data.pic != null
                ? FirebaseImage(
                    'gs://abdelkakder-app.appspot.com/uploads/${data.pic}',
                    shouldCache: true,
                    maxSizeBytes: 5000 * 1000,
                    cacheRefreshStrategy: CacheRefreshStrategy.NEVER)
                : AssetImage('assets/61205.png'),
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
                          pic: data.pic,
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
  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;
  }

  @override
  Widget build(BuildContext context) {
    final usersList = Provider.of<List<ChefData>>(context) ?? [];

    return usersList.length == 0 ? Center(child: Text('Pas de chef ajouté'))  :  ListView.builder(
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
  final TR data;

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


              data.workerId != null ?

              Text(
                '${data.name} a payé ${data.workerName}',
                style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
              ) : SizedBox(),

              SizedBox(
                height: 5,
              ),

              Text(
                data.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),


              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(double.parse(data.somme.toString()).toString() + ' Da',style: TextStyle(color: Colors.grey,fontSize: 16),),
                    Text(
                      data.time,
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
    final transactionsList = Provider.of<List<TR>>(context) ?? [];
    return ListView.builder(
      itemCount: transactionsList.length,
      itemBuilder: (context, index) {

        return Transaction_Card(data: transactionsList[index]);
      },
    );
  }
}

class Worker_card extends StatelessWidget {
  final Workerr data;

  Worker_card({this.data});

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
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkerTransactions(uid: data.uid,)));
          },
        ),
      ),
    );
  }
}

class TransactionsController extends GetxController {
  var description = ''.obs;
  var somme = '0'.obs;
  var currentMoney = 0.obs;
  var loading = false.obs;

  var checkBoxValue = false.obs;
   var selectedWorker = Workerr(name: 'unselected');
  TextEditingController descriptionTextfield = TextEditingController();
  TextEditingController sommeTextfield = TextEditingController();
}

Future<void> showMyDialog(
    TR transaction, BuildContext context, ChefData chefData) async {
  final _formKey1 = GlobalKey<FormState>();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  final TransactionsController transactionsController =
      Get.put(TransactionsController());

  var uuid = Uuid();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      transactionsController.currentMoney(transaction.argent.toInt());
      transactionsController.descriptionTextfield.text =
          transaction.description ?? '';
      transactionsController.sommeTextfield.text =
          transaction.somme.toInt().toString() ?? 0.toString();
      return AlertDialog(
        title: transaction.name == '' ? Text('Supprimer la transaction')  :  Text('Ajouter une transaction'),
        content:
            GetX<TransactionsController>(builder: (transactionsController) {
         return SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                transactionsController.loading.value ? Center(child: CircularProgressIndicator())  : transaction.name == '' ? SizedBox() : Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: transactionsController.descriptionTextfield,
                        decoration: textinputDecoration.copyWith(
                          hintText: 'descripton',
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
                            val.isEmpty ? 'entrer une description svp' : null,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: transactionsController.sommeTextfield,
                        keyboardType: TextInputType.number,
                        decoration: textinputDecoration.copyWith(
                          hintText: '0',
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
                            val.isEmpty ? 'entrer une somme svp' : null,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('Payer un travailleur'),
                          Checkbox(
                              value: transactionsController.checkBoxValue.value,
                              activeColor: Colors.green,
                              onChanged: (bool newValue) {
                                transactionsController.checkBoxValue(newValue);
                                print(transactionsController.checkBoxValue.value);
                              }),
                        ],
                      ),
                      transactionsController.checkBoxValue.value ? Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selectionner un travailleur'),
                          SizedBox(height: 5,),
                          StreamBuilder<List<Workerr>>(
                              stream: DatabaseService().workers,
                              builder: (context, snapshot) {
                                if(snapshot.hasData)
                                  {



                                    List<Workerr> list = snapshot.data;
                                    transactionsController.selectedWorker.name = '';

                                    transactionsController.selectedWorker.uid = null;




                                    list.add(transactionsController.selectedWorker);
                                    return  DropdownButtonFormField(
                                      value: transaction.workerId != null ? transaction.workerName : transactionsController.selectedWorker.name ,
                                      decoration: InputDecoration(
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
                                      items: snapshot.data.map((worker) {
                                        return DropdownMenuItem(
                                          value: worker.name,
                                          child: Text(
                                            worker.name,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        print(val);

                                        for(int i=0;i<list.length;i++)
                                          {
                                            if(list[i].name==val)
                                              {

                                                print('true');
                                                transactionsController.selectedWorker.name = val;
                                                transactionsController.selectedWorker.uid = list[i].uid;
                                              }
                                          }


                                      },
                                    );


                                  }else
                                    {
                                      return SizedBox();
                                    }

                              }),
                        ],
                      ) : SizedBox()
                    ],
                  ),
                )
              ],
            ),
          );
        }),
        actions: <Widget>[
          transactionsController.loading.value ? SizedBox() : transaction.name == '' ? SizedBox() : RaisedButton(
              color: Colors.green,
              child:
                  transaction.uid == null ? Text('Ajouter') : Text('Modifier'),
              onPressed: () async {
                if (_formKey1.currentState.validate()) {
                  transactionsController.loading(true);
                  transactionsController.currentMoney((double.parse(
                              transactionsController.sommeTextfield.text) +
                          transactionsController.currentMoney.value -
                          transaction.somme)
                      .toInt());

                  await DatabaseService(uid: chefData.uid).updateUserData(
                      chefData.uid,
                      chefData.name,
                      chefData.email,
                      chefData.numTlf,
                      transactionsController.currentMoney.value.toDouble() ??
                          chefData.argent,
                      chefData.deleted);


                  if(transaction.workerName != transactionsController.selectedWorker.name)
                    {
                      await DatabaseService(uid: transaction.workerId)
                          .deleteWorkersTransaction(transaction.uid);
                    }


                  await DatabaseService(uid: chefData.uid)
                      .updateUserTransaction(
                    transaction.uid == null ? uuid.v4() : transaction.uid,
                    chefData.name,
                    transactionsController.descriptionTextfield.text,
                    dateFormat.format(DateTime.now()),
                    transactionsController.currentMoney.value.toDouble() ??
                        chefData.argent,
                    double.parse(transactionsController.sommeTextfield.text),
                    transactionsController.selectedWorker,
                    chefData.deleted,
                  );





                  transactionsController.sommeTextfield.text = '0';
                  transactionsController.descriptionTextfield.text = '';
                  transactionsController.selectedWorker.name = '';
                  transactionsController.selectedWorker.uid = null;
                  transactionsController.loading(false);
                  Get.back();
                }
              }),
          transaction.uid != null
              ?  transactionsController.loading.value ? SizedBox() :  RaisedButton(
                  color: Colors.red,
                  child: Text('Suprimer'),
                  onPressed: () async {
                    transactionsController.loading(true);
                    await DatabaseService(uid: chefData.uid).updateUserData(chefData.uid, chefData.name, chefData.email, chefData.numTlf, chefData.argent-transaction.somme, chefData.deleted);
                    await DatabaseService(uid: chefData.uid)
                        .deleteTransaction(transaction.uid);
                    await DatabaseService(uid: transaction.workerId)
                        .deleteWorkersTransaction(transaction.uid);
                    transactionsController.loading(false);
                    Navigator.of(context).pop();
                  })
              : SizedBox(),
        ],
      );
    },
  );
}
