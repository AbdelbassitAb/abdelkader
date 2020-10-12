import 'package:abdelkader/screens/constant.dart';
import 'package:abdelkader/screens/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:abdelkader/services/authenticate.dart';

class AddChefScreen extends StatefulWidget {
  @override
  _AddChefScreenState createState() => _AddChefScreenState();
}

class _AddChefScreenState extends State<AddChefScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String name = '';
  String password = '';
  String phoneNumber = '';
  double money = 0;
  String error = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Container(
                      width: size.width * 0.8,
                      height: size.height * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/61205.png'),
                            ),
                            Text(
                              'Add an image',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              decoration: textinputDecoration.copyWith(
                                hintText: 'Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a name' : null,
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              decoration: textinputDecoration.copyWith(
                                hintText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an Email' : null,
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              decoration: textinputDecoration.copyWith(
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (val) => val.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: textinputDecoration.copyWith(
                                hintText: 'Phone number',
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a Phone number' : null,
                              onChanged: (val) {
                                setState(() {
                                  phoneNumber = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              autocorrect: true,
                              keyboardType: TextInputType.number,
                              decoration: textinputDecoration.copyWith(
                                hintText: 'Money',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an Email' : null,
                              onChanged: (val) {
                                setState(() {
                                  money = double.parse(val);
                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  // setState(() => loading = true);
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email,
                                          password,
                                          name,
                                          phoneNumber,
                                          money);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Could not sign In';
                                      Navigator.pop(context);
                                    });
                                  } else
                                    Navigator.pop(context);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
  }
}
