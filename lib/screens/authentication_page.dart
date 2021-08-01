import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire01/screens/second_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationPage extends StatefulWidget {
  static const routes = "/authentication_page";
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String mail = "", password = " ", phoneNumber = "";
  AuthByMailMode authByMailMode = AuthByMailMode.SignUp;
  AuthenticationMode authenticationMode = AuthenticationMode.ByMail;
  String _verificationCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication Page"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInAnonymously();
                print(userCredential.user!.uid);
                getSnackBar(msg: "Sign In Anonymous");
              },
              child: Text("Sign In Anonymous"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  authenticationMode = AuthenticationMode.ByMail;
                  authByMailMode = AuthByMailMode.SignUp;
                });
                getForm();
              },
              child: Text("Sign Up By Email&Password"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  authenticationMode = AuthenticationMode.ByMail;
                  authByMailMode = AuthByMailMode.SignIn;
                });
                getForm();
              },
              child: Text("Sign In By Email&Password"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  authenticationMode = AuthenticationMode.ByPhoneNumber;
                });
                getForm();
              },
              child: Text("Sign UP Mobile Phone"),
            ),
            ElevatedButton(
              onPressed: () async {
                UserCredential res = await signInWithGoogle();

                Navigator.of(context).pushNamedAndRemoveUntil(
                    SecondPage.routes, (route) => false);
              },
              child: Text("Sign In By Google"),
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                onPrimary: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getSnackBar({required String msg}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 02),
      ),
    );
  }

  getForm() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            (authenticationMode == AuthenticationMode.ByPhoneNumber)
                ? "Sign Up"
                : (authByMailMode == AuthByMailMode.SignIn)
                    ? "Sign In"
                    : "Sign Up",
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (authenticationMode == AuthenticationMode.ByMail)
                  Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty ||
                              val == "" ||
                              val == " " ||
                              val.length == 0) {
                            return "Please enter email address first .... ";
                          }
                          if (!EmailValidator.validate(val)) {
                            return "Please enter valid email address..";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            mail = val!;
                          });
                        },
                        controller: mailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your e-mail address",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty ||
                              val == "" ||
                              val == " " ||
                              val.length == 0) {
                            return "Please enter password address first .... ";
                          }
                          if (val.length < 6) {
                            return "Please enter at least 6 characters";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            password = val!;
                          });
                        },
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                if (authenticationMode == AuthenticationMode.ByPhoneNumber)
                  Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty ||
                              val == "" ||
                              val == " " ||
                              val.length == 0) {
                            return "Please enter PhoneNumber first .... ";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            phoneNumber = val!;
                          });
                        },
                        controller: phoneNumberController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          hintText: "Enter your phone number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  mailController.clear();
                  passwordController.clear();
                  phoneNumberController.clear();
                  mail = "";
                  password = "";
                  phoneNumber = "";
                  Navigator.of(context).pop();
                });
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  if (authenticationMode == AuthenticationMode.ByPhoneNumber) {
                    getSignInByPhoneNumber();
                  } else {
                    if (authByMailMode == AuthByMailMode.SignIn) {
                      getSignInByMail();
                    } else {
                      getRegisterByMail();
                    }
                  }
                }
              },
              child: Text(
                (authByMailMode == AuthByMailMode.SignIn)
                    ? "Sign In"
                    : "Sign Up",
              ),
            ),
          ],
        );
      },
    );
  }

  getRegisterByMail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: password);
      print(userCredential.user!.uid);
      Navigator.of(context).pop();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(SecondPage.routes, (routes) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.of(context).pop();
        getSnackBar(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.of(context).pop();
        getSnackBar(msg: 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      getSnackBar(msg: e.toString());
    }
    setState(() {
      mailController.clear();
      passwordController.clear();
      mail = "";
      password = "";
    });
  }

  getSignInByMail() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
      print(userCredential.user!.uid);
      Navigator.of(context).pop();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(SecondPage.routes, (routes) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Navigator.of(context).pop();
        getSnackBar(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Navigator.of(context).pop();
        getSnackBar(msg: 'Wrong password provided for that user.');
      }
    }
    setState(() {
      mailController.clear();
      passwordController.clear();
      mail = "";
      password = "";
    });
  }

  getSignInByPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      timeout: Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        print("Time Out......1211");
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          _verificationCode = verificationID;
        });
        getOtp();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
        print("Time Out......");
      },
    );
  }

  getOtp() {
    var otp = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: formKey2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onSaved: (val) {
                      setState(() {
                        otp = val!;
                      });
                    },
                    controller: otpController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "OTP",
                      hintText: "Enter your otp",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            title: Text("OTP"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  formKey2.currentState!.save();
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(
                      PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: otp),
                    )
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            SecondPage.routes, (route) => false);
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('invalid OTP')));
                  }
                },
                child: Text("Submit"),
              ),
            ],
          );
        });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

enum AuthByMailMode {
  SignUp,
  SignIn,
}
enum AuthenticationMode {
  ByMail,
  ByPhoneNumber,
}
