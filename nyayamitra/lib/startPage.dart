import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyayamitra/forgotPassPage.dart';
import 'package:nyayamitra/homePage.dart';
import 'package:nyayamitra/signupPage.dart';
import 'uiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authService.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class PageTearClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.12, size.height * 0.12, size.width, size.height * 0.12);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _StartPageState extends State<StartPage> {
  double screenHeightRatio = 1.0;
  double screenWidthRatio = 0.1;
  double logoSize = 40;
  bool isDisable = false;
  final _auth = AuthService();
  var errorMessage = '';
  bool _obscure = true;
  var emailText = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      screenWidthRatio = 0.3;
      screenHeightRatio = 1.1;
      logoSize = 60;
    } else {
      screenWidthRatio = 0.8;
      screenHeightRatio = 1.2;
      logoSize = 80;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("NyayaMitra"),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1,
                color: Colors.black,
              ),
              ClipPath(
                clipper: PageTearClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 1,
                  color: Colors.white,
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Uihelper.showLogo(logoSize),
                    Uihelper.showText("NyayaMitra", 30.0, Colors.white),
                    SizedBox(height: 15),
                    Uihelper.showText(
                        "justice at your fingertips...", 14.0, Colors.white),
                    SizedBox(height: 15),
                    Uihelper.showText("SignIn to continue", 16.0, Colors.white),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            screenWidthRatio,
                        child: Uihelper.showTextField("Enter your Email",
                            Icons.email, emailText, context),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            screenWidthRatio,
                        child: TextField(
                          controller: password,
                          obscureText: _obscure,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "Enter your Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscure = !_obscure;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye),
                            ),
                            suffixIconColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassPage()));
                        },
                        child: Uihelper.showText(
                            "Forgot Password?", 14.0, Colors.blueAccent),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width *
                          screenWidthRatio /
                          2,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                        ),
                        onPressed: isDisable
                            ? null
                            : () async {
                          setState(() {
                            isDisable = true;
                          });
                          _showLoader(context);

                          bool success = await _SignIn();

                          if (mounted) Navigator.pop(context); // close loader

                          if (success && mounted) {
                            goToHome(context);
                          }

                          setState(() {
                            isDisable = false;
                          });
                        },
                        child: Text("Login"),
                      ),
                    ),
                    if (errorMessage.isNotEmpty) ...[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isDisable = false;
                            errorMessage = '';
                          });
                        },
                        child: Text("Retry"),
                      ),
                    ],
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Uihelper.showText(
                          "new to NyayaMitra", 14.0, Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width *
                          screenWidthRatio /
                          2,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signuppage()));
                          },
                          child: Text("SignUp")),
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

  void goToHome(BuildContext context) {
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homepage()));
  }

  Future<bool> _SignIn() async {
    try {
      final cred = await _auth.loginUserWithEmailAndPass(
          emailText.text.trim(), password.text.trim());
      if (cred != null) {
        log("Login Successful");
        return true;
      } else {
        Uihelper.CustomAlertBox(
            context,
            Uihelper.showText("Something Went wrong", 14, Colors.red));
        return false;
      }
    } on FirebaseAuthException catch (e) {
      Uihelper.CustomAlertBox(context, e.code.toString());
      return false;
    }
  }

  Future<void> _resetPassword() async {
    if (emailText.text.isEmpty) {
      Uihelper.CustomAlertBox(context,
          Uihelper.showText("Please enter your email", 14, Colors.red));
      return;
    }

    _showLoader(context);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailText.text.trim());
      if (mounted) Navigator.pop(context);
      Uihelper.CustomAlertBox(context,
          Uihelper.showText("Redirecting to reset password...", 14, Colors.green));
    } catch (e) {
      if (mounted) Navigator.pop(context);
      Uihelper.CustomAlertBox(
          context, Uihelper.showText("Error: ${e.toString()}", 14, Colors.red));
    }
  }

  void _showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
