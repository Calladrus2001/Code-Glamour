import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_glamour/Views/Homepage.dart';
import 'package:code_glamour/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool hasAccount = true;
  bool isDesigner = false;
  final emailController = new TextEditingController();
  final passController = new TextEditingController();
  String _email = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
  }

  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return clr1;
      }
      return clr1;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Homepage();
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.27,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 65),
                              Image.asset(
                                'assets/images/intro.png',
                                height: 250,
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text("Code:Glamour",
                        style: TextStyle(
                            color: clr1, letterSpacing: 3, fontSize: 24)),
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Enter your email',
                                  hintText: 'ex: test@gmail.com',
                                ),
                                onChanged: (value) {
                                  _email = value;
                                },
                                validator: (value) {}),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: passController,
                              decoration: InputDecoration(
                                labelText: 'Enter your password',
                              ),
                              obscureText: true,
                              onChanged: (value) {
                                _password = value;
                              },
                              validator: (value) {},
                            ),
                            SizedBox(height: 36),

                            /// designer checkbox
                            hasAccount
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Are you a Designer?",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Checkbox(
                                              value: isDesigner,
                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty
                                                  .resolveWith(getColor),
                                              onChanged: (value) {
                                                setState(() {
                                                  isDesigner = !isDesigner;
                                                });
                                                print(isDesigner);
                                              })
                                        ],
                                      ),
                                      SizedBox(height: 24),
                                    ],
                                  )
                                : SizedBox(),

                            /// login/register button

                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: GestureDetector(
                                  child: Container(
                                    height: 55,
                                    width: double.infinity,
                                    child: Center(
                                        child: hasAccount
                                            ? Text(
                                                "Register",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : Text(
                                                "Login",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                    decoration: BoxDecoration(
                                        color: clr1,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                  ),
                                  onTap: () {
                                    if (hasAccount) {
                                      SignUp(_email, _password);
                                      users
                                          .doc(_email)
                                          .set({"Designer": isDesigner});
                                    } else {
                                      SignIn(_email, _password);
                                    }
                                    emailController.text = "";
                                    passController.text = "";
                                  },
                                )),

                            /// login/register button ends
                            SizedBox(height: 64),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                hasAccount
                                    ? Text("Already have an account?  ",
                                        style: TextStyle(color: Colors.grey))
                                    : Text("Don't have an account?  ",
                                        style: TextStyle(color: Colors.grey)),
                                GestureDetector(
                                    child: hasAccount
                                        ? Text("Login",
                                            style: TextStyle(color: clr1))
                                        : Text("Register",
                                            style: TextStyle(color: clr1)),
                                    onTap: () {
                                      setState(() {
                                        hasAccount = !hasAccount;
                                      });
                                    })
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  Future SignIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future SignUp(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
