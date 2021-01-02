
import 'package:e_school/Peoples/UserModel.dart';
import 'package:e_school/QuizChallenge/QuizStart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Rush extends StatefulWidget {

  final UserModel user;
  Rush({@required this.user,Key key}) : super(key: key);

  @override
  _RushState createState() => _RushState();
}

class _RushState extends State<Rush> {

var user=FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }


var style=TextStyle(color: Colors.blue[900],
fontSize: 24,
fontWeight: FontWeight.bold,
);
 
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Stack(
          
      
        children: [
           Hero(tag: widget.user.uid, child:  Container(
                margin: EdgeInsets.fromLTRB(50, 50, 15, 0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${widget.user.userProfile}")
                   ,fit: BoxFit.cover)
                ),
              ),),
                Container(  margin: EdgeInsets.fromLTRB(50, 120, 15, 0),
                  child: Text("${widget.user.userName}",
                  overflow: TextOverflow.ellipsis,
                  style:TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                   margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.4, MediaQuery.of(context).size.height*0.4, 15, 0),
                  child: Transform.rotate(angle: 45,
                  child: Text("VS",style: style,),),
                ),

            Container(
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.6, 15, 0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${user.photoURL}")
                   ,fit: BoxFit.cover)
                ),
              ),
                Container(  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.68, 15, 0),
                  child: Text("${user.displayName}", overflow: TextOverflow.ellipsis,style:TextStyle(fontWeight: FontWeight.bold)),
                ),


          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.8, 50, 0),
            child: RaisedButton(
              color:Colors.blue[900],
              onPressed: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => QuizStart(userBId: widget.user.uid,)));
              },
            child: Text("Start",style:TextStyle(color: Colors.white,fontSize:16)),),

          )

        ],
        
        ),

      ),
      
    );
  }
}