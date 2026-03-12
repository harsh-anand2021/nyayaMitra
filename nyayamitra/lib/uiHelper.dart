import 'package:flutter/material.dart';
class Uihelper {

//function for background gradient Container
static Container gradientContainer(_child){
  return Container(
    child: _child,
     decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black,Colors.teal],
          begin: Alignment.topRight,
          end: Alignment.bottomCenter
          )
        ),
         height: double.infinity,
         width:double.infinity,
  );
}
//function for logo
 static CircleAvatar showLogo(size){
    return CircleAvatar(
      minRadius: size,
      maxRadius: size,
      backgroundColor: Colors.black,
      child: Image(image: AssetImage("assets/images/logo.png")),
    );
  }
  //function for textField
  static TextField showTextField(hinttext, iconname,_textController,context){
    return TextField(
        controller: _textController,
        textInputAction: TextInputAction.next,
        //onSubmitted: (value){FocusScope.of(context).nextFocus();},
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
        labelText: hinttext,
        labelStyle: TextStyle(color: Colors.white),
        hintText: hinttext,
        suffixIcon: Icon(iconname),
        suffixIconColor: Colors.white,
        hintStyle:TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
        enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white)
        )
        
      ),
    );
  }

   //function for customized button
  static ElevatedButton showElevatedButton(buttonName){
    return ElevatedButton(onPressed: (){
      
    }, child:showText(buttonName,20,Colors.black),style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
    ),);
  }

  //function for white text with size 16
 static Text showText(text,size,_color){
     return Text(
      text,style: TextStyle(fontSize:size,color:_color,),
      textAlign: TextAlign.center,
     );
  }
 
 //showTextField with suffixButton function

 static TextField buttonTextField(_controller,_hinttext,_labelText,Icon _iconButton,_action){
  return TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintStyle:TextStyle(color: Colors.white),
                        hintText: _hinttext,
                        labelText: _labelText,
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(onPressed:_action, icon:_iconButton),
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
  );
 }

  static CustomAlertBox(BuildContext context, text){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: text,
        actions: [
          TextButton(onPressed: (){
            
            Navigator.pop(context);
          }, child: Text('ok'))
        ],
      );
    });
  }
  static void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

}
