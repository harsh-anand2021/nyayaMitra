import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyayamitra/homePage.dart';
import 'package:nyayamitra/startPage.dart';
import 'package:nyayamitra/uiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';// <-- added

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: FirebaseOptions(apiKey:"AIzaSyB2aFS17b0Pvi5X9sW0b4Rm9vD9ErlQ1Io" , appId:"1:39574454255:web:cff4a5a3b41fc414e9001a", messagingSenderId: "39574454255", projectId: "nyayamitra-5b724"));
    // no Firebase init for web here as per your original
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NyayaMitra',
      theme: ThemeData(),
      home: const MyHomePage(title: 'NyayaMitra'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class PageTearClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.12, size.height * 0.12, size.width, size.height * 0.12);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _MyHomePageState extends State<MyHomePage> {
  double screenHeightRatio = 1.0;
  double screenWidthRatio = 1.0;
  double logoSize = 80;
  double gapHeight = 30;
  double textSize = 45;
  String _text = '';
  final String _fullText =
      'Welcome\n to \nIndia\'s first\n AI powered\n Legal Advisor! \n \n NYAYAMITRA ';
  int _index = 0;
  bool _isTypingFinished = false;

  @override
  void initState() {
    super.initState();
    _typeText();
  }

  Future<void> _typeText() async {
    while (_index < _fullText.length) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _text = _fullText.substring(0, _index + 1);
        _index++;
      });
    }
    setState(() {
      _isTypingFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = 1.0;
    if (kIsWeb) {
      screenWidthRatio = 0.2;
      screenHeight = 10.8;
      gapHeight = 5;
      logoSize = 80;
      textSize = 28;
    } else {
      screenWidthRatio = 0.8;
      screenHeight = 5.5;
      gapHeight = 60;
      logoSize = 100;
      textSize = 31;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: Column(
            children:[
              SizedBox(height: 30),
              SizedBox(height: gapHeight),
              Uihelper.showLogo(40.0),
              TextButton(
                  onPressed: () {},
                  child: Uihelper.showText("NyayaMitra", 18.0, Colors.white)),
              SizedBox(height: gapHeight),
              Uihelper.showText("OUR TEAM", 14.0, Colors.amber),
              SizedBox(height: gapHeight / 2),
              _buildTeamCard(
                context,
                imagePath: "assets/images/harsh_anand.jpg",
                name: "Harsh Anand",
                role: "Application Developer",
                linkedinUrl:
                "https://www.linkedin.com/in/harsh-anand-019970264/", // replace with actual link
              ),
              _buildTeamCard(
                context,
                imagePath: "assets/images/aman_gupta.jpg",
                name: "Aman Gupta",
                role: "A.I Developer",
                linkedinUrl:
                "https://www.linkedin.com/in/amangupta97656/", // replace with actual link
              ),
              _buildTeamCard(
                context,
                imagePath: "assets/images/aru.jpg",
                name: "Arun Kumar",
                role: "DB Administrator",
                linkedinUrl:
                "https://www.linkedin.com/in/arun-kumar-29a0a5253/", // replace with actual link
              ),
              _buildTeamCard(
                context,
                imagePath: "assets/images/chintu_kumar.jpg",
                name: "Chintu Kumar",
                role: "UI&UX Designer",
                linkedinUrl:
                "https://www.linkedin.com/in/chintu-kumar-64623318b/", // replace with actual link
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * screenHeightRatio*1.05,
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
                  const SizedBox(height: 20),
                  Container(
                    child: Uihelper.showLogo(logoSize),
                  ),
                  SizedBox(height: gapHeight),
                  Container(
                    // Make text container wider on web for large screens
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width * 0.6
                        : null,
                    child: Text(
                      _text,
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: kIsWeb ? 6.0 : 0.5, // More spacing on web
                      ),
                      textAlign: TextAlign.center,
                    ),

                  ),
                  const SizedBox(height: 30),
                  _isTypingFinished
                      ? Center(
                    child: Container(
                      width: kIsWeb
                          ? MediaQuery.of(context).size.width * 0.2
                          : MediaQuery.of(context).size.width * 0.5,
                      height: 45,
                      child: ElevatedButton(

                      onPressed: () {
                        final user=FirebaseAuth.instance.currentUser;
                           if(user==null){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => StartPage()));
                           }
                           else{
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => Homepage()));
                           }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: Uihelper.showText(
                              "Continue>>", 18.0, Colors.black)),
                    ),
                  )
                      : Container(),
                  const SizedBox(height: 15),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => Homepage()));
                  //     },
                  //     child: Uihelper.showText(
                  //         "Mainpage testing", 18.0, Colors.white)),
                  // const SizedBox(height: 20),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  // Helper method for drawer cards with effects
  Widget _buildTeamCard(BuildContext context,
      {required String imagePath,
        required String name,
        required String role,
        required String linkedinUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.4),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final Uri uri = Uri.parse(linkedinUrl);
            if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not launch LinkedIn profile')),
              );
            }
          },
          splashColor: Colors.amber.withOpacity(0.3),
          highlightColor: Colors.amber.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        role,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.open_in_new, color: Colors.amber),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
