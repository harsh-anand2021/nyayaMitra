import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyayamitra/uiHelper.dart';

class ForgotPassPage extends StatefulWidget {
  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> _resetPassword() async {
    if (emailController.text.isEmpty) {
      _showAlert("Please enter your email", Colors.black);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      setState(() {
        isLoading = false;
      });
      _showAlert("Password reset link sent! Check your email.", Colors.green);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showAlert("Error: ${e.toString()}", Colors.red);
    }
  }

  void _showAlert(String message, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notification"),
          content: Text(message, style: TextStyle(color: textColor)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Uihelper.showText("forgot password", 26.0,Colors.black),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Reset Your Password",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 35),
                  Container(
                    height: 70,
                    width: 300,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: emailController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        hintText: "Enter Email Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        suffixIcon: Icon(Icons.email, color: Colors.grey[700]),
                      ),
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (isLoading)
                    CircularProgressIndicator()
                  else
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Send Reset Link",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
