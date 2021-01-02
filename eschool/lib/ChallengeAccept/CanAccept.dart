import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/ChallengeAccept/AcceptChallenge.dart';
import 'package:e_school/Peoples/UserModel.dart';
import 'package:e_school/QuizChallenge/QuizModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CanAccept extends StatefulWidget {
  final QuizChallangeModel model;
  final UserModel user;
  CanAccept({@required this.model,@required this.user,Key key}) : super(key: key);

  @override
  _CanAcceptState createState() => _CanAcceptState();
}


class _CanAcceptState extends State<CanAccept> {
  var user=FirebaseAuth.instance.currentUser;

var style=TextStyle(color: Colors.blue[900],
fontSize: 24,
fontWeight: FontWeight.bold,
);
int userAscore=0;

@override
  void initState() {
 
 for (var item in widget.model.userAAns) {
   if(item=="Correct"){
     userAscore++;
   }
   
 }
    super.initState();
  }
 var scoreStyle=TextStyle(color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.bold,
);
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
      
        children: [

Container(
margin: EdgeInsets.fromLTRB(50, MediaQuery.of(context).size.height*0.3, 15, 0),
  width: 250,
  height: 50,
  color: Colors.red,
  child: Center(child:Text("$userAscore : ?",style:scoreStyle)),
),


           Container(
                margin: EdgeInsets.fromLTRB(50, MediaQuery.of(context).size.height*0.4, 15, 0),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${widget.user.userProfile}")
                   ,fit: BoxFit.cover)
                ),
              ),
                Container(  margin: EdgeInsets.fromLTRB(50, MediaQuery.of(context).size.height*0.5, 15, 0),
                  child: Text("${widget.user.userName}",
                  overflow: TextOverflow.ellipsis,
                  style:TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                   margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.4, MediaQuery.of(context).size.height*0.43, 15, 0),
                  child: Transform.rotate(angle: 0,
                  child: Text("VS",style: style,),),
                ),

            Container(
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6,MediaQuery.of(context).size.height*0.4, 15, 0),
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
                Container(  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.5, 15, 0),
                  child: Text("${user.displayName}", overflow: TextOverflow.ellipsis,style:TextStyle(fontWeight: FontWeight.bold)),
                ),
 
 
 
 Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.15, MediaQuery.of(context).size.height*0.8, 50, 0),
            child: RaisedButton(
              color:Colors.red[900],
              onPressed: (){
        
                  FirebaseFirestore.instance.collection("challenge").doc(widget.model.docId)
                  .update({"declined":true,"userBdel":true});
                  Navigator.of(context).pop(true);
              },
            child: Text("Decline",style:TextStyle(color: Colors.white,fontSize:16)),),

          ),

          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.8, 50, 0),
            child: RaisedButton(
              color:Colors.blue[900],
              onPressed: (){
             Navigator.of(context).push(new MaterialPageRoute(builder: (context) => AcceptChallenge(model: widget.model,user: widget.user,)));
              },
            child: Text("Next",style:TextStyle(color: Colors.white,fontSize:16)),),

          )

        ],
        
        ),

      ),
      
    );
      
       
  
  }
}