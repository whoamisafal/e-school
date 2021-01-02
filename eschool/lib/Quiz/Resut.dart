import 'package:e_school/Peoples/UserModel.dart';
import 'package:e_school/QuizChallenge/QuizModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResultView extends StatefulWidget {
final  QuizChallangeModel model;
final UserModel user;
  final bool type;
  
  ResultView({@required this.model,@required this.user,@required this.type,Key key}) : super(key: key);

  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
int userAscore=0;
int userBScore=0;
var user=FirebaseAuth.instance.currentUser;

var style=TextStyle(color: Colors.blue[900],
fontSize: 24,
fontWeight: FontWeight.bold,
);
 var scoreStyle=TextStyle(color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.bold,
);
 
@override
  void initState() {
   for (var item in widget.model.userAAns) {
    if(item=="Correct"){
      if(mounted){
        setState(() {
          userAscore+=1;
        });
      }
    }     
   }
     for (var item in widget.model.userBAns) {
    if(item=="Correct"){
      if(mounted){
        setState(() {
          userBScore+=1;
        });
      }
    }     
   }
    super.initState();
  }
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
  child: Center(child:widget.type?Text("$userAscore : $userBScore",style:scoreStyle):Text("$userBScore : $userAscore",style:scoreStyle)),
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
 
 
          ],
        ),
      ),
      
      
    );
  }
}