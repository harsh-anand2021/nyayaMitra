import 'package:flutter/material.dart';
import 'package:nyayamitra/homePage.dart';
import 'package:nyayamitra/startPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Checkuser extends StatefulWidget{
  const  Checkuser({super.key});
  @override
  State<StatefulWidget> createState()=>_CheckUserState();
}
class _CheckUserState extends State<Checkuser>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder<Widget>(future:checkUser(),
      builder: (context,AsyncSnapshot<Widget>snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else if(snapshot.hasError){
          return Center(child: Text('Error :${snapshot.error}'),);
        }
        else{
          return snapshot.data??StartPage();
        }
      }
      ),
    );
  }

Future<Widget> checkUser()async{
  final user=FirebaseAuth.instance.currentUser;
  if (user==null){
    return StartPage();
  }
  else{
    return Homepage();
  }
}

}