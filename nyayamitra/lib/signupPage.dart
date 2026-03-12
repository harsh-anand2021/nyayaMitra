import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyayamitra/authService.dart';
import 'package:nyayamitra/homePage.dart';
import 'package:nyayamitra/uiHelper.dart';

class Signuppage extends StatefulWidget {
  @override
  State<Signuppage> createState() => _SignupPage();
}

class PageTearClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.12, size.height * 0.12, size.width, size.height * 0.12);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _SignupPage extends State<Signuppage> {
  final _auth = AuthService();
  final _firestore = FirebaseFirestore.instance;

  double screenWidthRatio = 0.1;
  double screenHeightRatio = 1.0;
  double logoSize = 50.0;

  bool _obscure = true;
  bool _isChecked = false;
  bool _isLoading = false;

  double textSize=20.0;

  TextEditingController nameText = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController setPassword = TextEditingController();
  TextEditingController confPassword = TextEditingController();

  String? _selectedState;

  @override
  void dispose() {
    nameText.dispose();
    age.dispose();
    email.dispose();
    setPassword.dispose();
    confPassword.dispose();
    super.dispose();
  }

  void goToHome(BuildContext context) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Homepage()));

  Future<void> _SignUp() async {
    if (!_isChecked) {
      Uihelper.showAlertDialog(context, "Please accept Terms & Conditions");
      return;
    }

    if (setPassword.text.length < 6) {
      Uihelper.showAlertDialog(context, "Password must be at least 6 characters long");
      return;
    }

    if (setPassword.text != confPassword.text) {
      Uihelper.showAlertDialog(context, "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _auth.createUserWithEmailAndPass(email.text.trim(), setPassword.text.trim());
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          'name': nameText.text.trim(),
          'state': _selectedState ?? '',
          'dob': age.text.trim(),
          'email': email.text.trim(),
          'createdAt': Timestamp.now(),
        });

        log("User created and data stored successfully");
        goToHome(context);
      } else {
        Uihelper.showAlertDialog(context, "Signup failed. Try again.");
      }
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.message}");
      if (e.code == 'weak-password') {
        Uihelper.showAlertDialog(context, "Password is too weak. Please choose a stronger password.");
      } else {
        Uihelper.showAlertDialog(context, e.message ?? "An error occurred");
      }
    } catch (e) {
      log("Signup error: $e");
      Uihelper.showAlertDialog(context, "An unexpected error occurred");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (kIsWeb) {
      screenWidthRatio = 0.3;
      screenHeightRatio = 1.15;
      logoSize = 60.0;
      textSize=18;
    } else {
      screenWidthRatio = 0.8;
      screenHeightRatio = 1.1;
      logoSize = 80.0;
      textSize=24;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("NyayaMitra"),
        backgroundColor: Colors.grey,
      ),
      drawer:Drawer(
        child: Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Center(child: Uihelper.showLogo(60.0)),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "NyayaMitra",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: Colors.white38, thickness: 0.5, height: 30),
              Center(child: Uihelper.showText("Our Mission", 20.0, Colors.white),),
              // Expanded mission text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "To create an equitable society where justice is accessible to all — empowering individuals through AI-driven legal guidance and compassionate support.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: textSize,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              // About Us Button in white rounded container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.black),
                    title: Text(
                      "About Us",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("About NyayaMitra"),
                          content: Text(
                            "NyayaMitra is committed to making legal help more accessible using AI technology. We aim to empower every individual with reliable, compassionate, and intelligent legal support.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close"),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Footer
              Container(
                color: Colors.grey,
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Text(
                  "Justice at your fingertips...",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),


      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * screenHeightRatio * 1.1,
                color: Colors.black,
              ),
              ClipPath(
                clipper: PageTearClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * screenHeightRatio,
                  color: Colors.white,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Uihelper.showLogo(logoSize),
                    Uihelper.showText("NyayaMitra", 20.0, Colors.white),
                    Uihelper.showText("justice at your fingertips...", 14.0, Colors.white),
                    SizedBox(height: 20),
                    Uihelper.showText("Create new account", 18.0, Colors.white),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * screenWidthRatio,
                      child: Column(
                        children: [
                          Uihelper.showTextField("Enter your name", Icons.abc, nameText, context),
                          SizedBox(height: 10),
                          buildStateDropdown(),
                          SizedBox(height: 10),
                          buildDobPicker(),
                          SizedBox(height: 10),
                          Uihelper.showTextField("Enter your email", Icons.email, email, context),
                          SizedBox(height: 10),
                          buildPasswordField(setPassword, "Create Password"),
                          SizedBox(height: 10),
                          buildPasswordField(confPassword, "Confirm Password"),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                                side: BorderSide(width: 2, color: Colors.white),
                                checkColor: Colors.white,
                              ),
                              Uihelper.showText("I hereby confirm that I have read all the", 12.0, Colors.white),
                            ],
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Uihelper.showText("Terms & Conditions", 12.0, Colors.blue)),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _SignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isLoading ? Colors.grey : Colors.white,
                            ),
                            child: _isLoading
                                ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                                : Uihelper.showText("SignUp", 14.0, Colors.black),
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: _obscure,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.white),
        hintText: label,
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
        suffixIconColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }

  Widget buildStateDropdown() {
    final List<String> states = [
      'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa',
      'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala',
      'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland',
      'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
      'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
    ];

    return DropdownButtonFormField<String>(
      initialValue: _selectedState,
      onChanged: (String? newValue) {
        setState(() {
          _selectedState = newValue;
        });
      },
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.black,
      decoration: InputDecoration(
        labelText: "State",
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      hint: Text("Select your state", style: TextStyle(color: Colors.white)),
      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      items: states.map((String state) {
        return DropdownMenuItem<String>(
          value: state,
          child: Text(state, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  Widget buildDobPicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (picked != null) {
          if (picked.day <= 31 && picked.month <= 12 && picked.year >= 1900) {
            age.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          } else {
            Uihelper.showAlertDialog(context, "Invalid date selected");
          }
        }
      },
      child: AbsorbPointer(
        child: Uihelper.showTextField("Date of Birth (dd/mm/yyyy format)", Icons.calendar_today, age, context),
      ),
    );
  }
}
