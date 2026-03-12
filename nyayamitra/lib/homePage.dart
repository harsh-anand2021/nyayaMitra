import 'package:flutter/material.dart';
import 'package:nyayamitra/startPage.dart';
import 'package:nyayamitra/uiHelper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'saved_responses_screen.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomePage();
}

class _HomePage extends State<Homepage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _responseController = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  bool _isDarkTheme = true;

  double screenWidthRatio = 0.1;
  double logoSize = 10;
  double screenHeightRatio = 1.0;
  double profileBoxHeight = 100.0;

  List<String> savedResponses = [];
  String userName = "User";
  String userEmail = "user@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "user@example.com";
        userName = user.displayName?.isNotEmpty == true
            ? user.displayName!
            : userEmail.split('@')[0];
      });
    }
  }

  Future<void> _submitQuery() async {
    setState(() {
      _isLoading = true;
      _response = "Fetching legal advice...";
    });

    final userQuestion = _controller.text.trim();
    if (userQuestion.isEmpty) {
      setState(() {
        _response = "Please enter a legal query.";
        _isLoading = false;
      });
      return;
    }

    try {
      final result = await askNyayMitra(userQuestion);
      setState(() {
        _response = result;
        savedResponses.insert(0, result);
        if (savedResponses.length > 5) {
          savedResponses = savedResponses.sublist(0, 5);
        }
        _isLoading = false;
        _controller.clear();
      });

      await _typeResponse(result);
    } catch (e) {
      print("❌ Error in _submitQuery: $e");
      setState(() {
        _response = "Something went wrong. Please try again.";
        _isLoading = false;
      });
    }
  }

  Future<void> _saveResponseToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _response.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('responses')
          .add({'response': _response, 'timestamp': Timestamp.now()});
    }
  }

  Future<void> _typeResponse(String fullResponse) async {
    _responseController.text = '';
    for (int i = 0; i < fullResponse.length; i++) {
      await Future.delayed(Duration(milliseconds: 25));
      _responseController.text += fullResponse[i];
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );

              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.toDouble();
    final backgroundColor = _isDarkTheme ? Colors.black : Colors.white;
    final textColor = _isDarkTheme ? Colors.white : Colors.black;
    final drawerColor = _isDarkTheme ? Colors.grey[900] : Colors.grey[100];
    final boxColor = _isDarkTheme ? Colors.white : Colors.black;
    final profileTextColor = _isDarkTheme ? Colors.black : Colors.white;

    if (kIsWeb) {
      screenWidthRatio = 0.3;
      screenHeightRatio = 1.15;
      logoSize = 60.0;
      profileBoxHeight = 100.0;
    } else {
      screenWidthRatio = 0.8;
      screenHeightRatio = 1.1;
      logoSize = 80.0;
      profileBoxHeight = 65.0;
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("NyayaMitra"),
          backgroundColor: _isDarkTheme ? Colors.grey : Colors.grey,
          actions: [
            IconButton(
              icon: Icon(_isDarkTheme ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: () => setState(() => _isDarkTheme = !_isDarkTheme),
            )
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: drawerColor,
            child: Column(
              children: [
                SizedBox(height: 45),
                Uihelper.showLogo(40.0),
                TextButton(
                  onPressed: () {},
                  child: Uihelper.showText("NyayaMitra", 18.0, textColor),
                ),
                Uihelper.showText("Justice at your fingertips...", 14.0, textColor),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: profileBoxHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[400],
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Name: $userName",
                                  style: TextStyle(color: profileTextColor, fontSize: 14),
                                  overflow: TextOverflow.ellipsis),
                              Text("Email: $userEmail",
                                  style: TextStyle(color: profileTextColor, fontSize: 13),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final selectedResponse = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SavedResponsesScreen()),
                        );
                        if (selectedResponse != null && selectedResponse is String) {
                          setState(() {
                            _responseController.text = selectedResponse;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text("Show Saved Responses",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
                if (savedResponses.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🧾 Recent Responses",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            ...savedResponses.map((response) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _responseController.text = response;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight: 180,
                                      minHeight: 60,
                                    ),
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: _isDarkTheme ? Colors.grey[850] : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: _isDarkTheme
                                              ? Colors.grey[700]!
                                              : Colors.grey),
                                    ),
                                    child: Text(
                                      response.length > 100
                                          ? "${response.substring(0, 100)}..."
                                          : response,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: textColor, fontSize: 13),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    onPressed: _showLogoutDialog,
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text("Logout", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          color: backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 100) : EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 2 / 3,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      style: TextStyle(color: textColor),
                      controller: _responseController,
                      cursorColor: textColor,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: textColor),
                        ),
                        hintText:
                        'Follow the instructions and contact legal authorities to seek Justice... ',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 36.0,
                          fontStyle: FontStyle.italic,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _controller.clear();
                              _response = '';
                              _responseController.clear();
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isDarkTheme ? Colors.white : Colors.black,
                            ),
                            child: Icon(Icons.refresh,
                                size: 18,
                                color: _isDarkTheme ? Colors.black : Colors.white),
                          ),
                        ),
                        InkWell(
                          onTap: _saveResponseToFirestore,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Uihelper.showText("Save Response", 16.0, Colors.white),
                                SizedBox(width: 4),
                                Icon(Icons.save, size: 20, color: Colors.white),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeight / 6,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      style: TextStyle(color: textColor),
                      controller: _controller,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: textColor),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                        hintText:
                        "Describe the incident on which you need legal advisory...",
                        border: OutlineInputBorder(),
                        suffixIcon: GestureDetector(
                          onTap: _isLoading ? null : _submitQuery,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _isLoading ? Colors.grey : Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.send, size: 28, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
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

Future<String> askNyayMitra(String question) async {
  final url = getBaseUrl() + '/ask';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"question": question}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'];
    } else {
      return "Error: ${response.statusCode}";
    }
  } catch (e) {
    print("❌ Exception in askNyayMitra: $e");
    return "Failed to connect to the server.";
  }
}

String getBaseUrl() {
  if (kIsWeb) {
    return 'http://192.168.170.93:5000'; // Web uses the system's local IP
  } else if (Platform.isAndroid) {
    bool isEmulator = !Platform.environment.containsKey('ANDROID_BOOTLOGO');
    return isEmulator ? 'http://10.0.2.2:5000' : 'http://192.168.170.93:5000'; // Android emulator uses 10.0.2.2
  } else if (Platform.isIOS) {
    return 'http://192.168.170.93:5000'; // iOS uses the device IP
  } else {
    return 'http://192.168.170.93:5000'; // Default to real device IP
  }
}

