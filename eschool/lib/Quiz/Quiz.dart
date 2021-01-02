import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/ChallengeAccept/CanAccept.dart';
import 'package:e_school/Peoples/UserModel.dart';
import 'package:e_school/Peoples/Users.dart';
import 'package:e_school/Quiz/Resut.dart';
import 'package:e_school/QuizChallenge/QuizModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';


class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
var user=FirebaseAuth.instance.currentUser;
List<QuizChallangeModel> challengers=[];
List<QuizChallangeModel> challenged=[];
bool isLoadingA=true;
bool isLoadingB=true;


@override
  void initState() {

   try {
      fetch();
   } catch (e) {
     print(e);
   }finally{
     if(mounted){
      setState(() {
         isLoadingA=false;
        isLoadingB=false;
      });
     }
   }


   
    super.initState();
  }
  void fetch(){

       FirebaseFirestore.instance.collection("challenge").
    where("userBId",
    isEqualTo: user.uid).
    where("declined", isEqualTo: false).
    where("userBdel",isEqualTo: false).
    snapshots().listen((event) { 
     if(mounted){
       setState(() {
         challengers.clear();
         for (var item in event.docs) {
           Map<String,dynamic> data=item.data();
           QuizChallangeModel model=new QuizChallangeModel(
  accept: data["accept"],
  declined: data["declined"],
  documentId: data["documentId"],
  userAAns: data["userAAns"],
  userAId: data["userAId"],
  userATimestamp:data["userATimestamp"],
  userAdel: data["userAdel"],
  userBAns: data["userBAns"],
  userBId: data["userBId"],
  userBTimestamp: data["userBTimestamp"],
  userBdel: data["userBdel"],
  docId: item.id
);
           challengers.add(model);
           isLoadingA=false;
         }
       });
     }
    });
FirebaseFirestore.instance.collection("challenge").
    where("userAId",
    isEqualTo: user.uid).
    where("userAdel",isEqualTo: false).
    snapshots().listen((event) { 
    if(mounted){
       setState(() {
         challenged.clear();
          for (var item in event.docs) {
               Map<String,dynamic> data=item.data();
           QuizChallangeModel model=new QuizChallangeModel(
  accept: data["accept"],
  declined: data["declined"],
  documentId: data["documentId"],
  userAAns: data["userAAns"],
  userAId: data["userAId"],
  userATimestamp:data["userATimestamp"],
  userAdel: data["userAdel"],
  userBAns: data["userBAns"],
  userBId: data["userBId"],
  userBTimestamp: data["userBTimestamp"],
  userBdel: data["userBdel"]  ,docId: item.id
);
           challenged.add(model);
           isLoadingB=false;
         }
       });
     }

    });

  }

var style=TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => Users(),
          ));

        }
      ,child: Icon(Icons.add,size: 35,),
      tooltip: "Challenge",
      ),
      appBar: AppBar(
      
        title:Hero(tag: "Quiz", child: Text("Quiz")),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.of(context).pop(true);
          }),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
shrinkWrap: true,
  children: [
 AdmobBanner(adUnitId: getBannerId(), adSize: AdmobBannerSize.BANNER,  
    listener: (AdmobAdEvent event,Map<String,dynamic> args ) => hadleEvent(event, args, "Banner"),)
 ,if(challengers.length>0)
     Container(
        margin: EdgeInsets.all(25),
        child:Text("Challenged form other",style: style,)),
      
    if(isLoadingB && isLoadingA)
     Center(child: CircularProgressIndicator(),)
    else
      Container(
        child: ListView.builder(
           physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: challengers.length,
          itemBuilder: (context, index) {
          return Challenger(model: challengers[index]);
        }
        ,),
      ),
      if(challenged.length>0)
      Container(
        margin: EdgeInsets.all(25),
        child:Text("You challenged",style: style,)), 
     
      if(isLoadingB && isLoadingA)
      Center(child: CircularProgressIndicator(),)
      else
       Container(
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
            shrinkWrap: true,
          itemCount: challenged.length,
          itemBuilder: (context, index) {
          return Challenged(model: challenged[index]);
        }
        ,),
      )

  ],
      ),
      
    );
  }
}



class Challenger extends StatefulWidget {
   final QuizChallangeModel model;
  Challenger({@required this.model});
  @override
  _ChallengerState createState() => _ChallengerState();
}

class _ChallengerState extends State<Challenger> {
  UserModel user;
bool isLoading=true;
AdmobInterstitial interstitial;
var currentUser=FirebaseAuth.instance.currentUser;
  @override
  void initState() {
   FirebaseFirestore.instance.collection("user")
   .doc(widget.model.userAId).get().then((value){
     if(mounted){
       setState(() {
         Map<String,dynamic> data=value.data();
         user=new UserModel(job: data["job"], userName: data["userName"], 
         userProfile: data["userProfile"]);
         isLoading=false;
       });
     }

   });
    
    interstitial=initInterstitial(interstitial);
    interstitial.load();
    super.initState();
  }
  var userTextStyle=TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold);
   
  @override
  Widget build(BuildContext context) {
     return Container(
      margin: EdgeInsets.zero,
       child: Card(
         margin: EdgeInsets.zero,
         child: InkWell(
           onTap: (){
             if(widget.model.accept){
               Navigator.of(context).push(new MaterialPageRoute(
                 builder: (context) => ResultView(model: widget.model, type: true, user: user,),
               ));
             }

           },
           child: Stack(
           children: [

             if(widget.model.accept)
             Container(
               margin:EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.82, 0, 0, 0),
               child: IconButton(icon: Text("clear",style: TextStyle(color:Colors.red[900],fontWeight:FontWeight.bold),),onPressed: ()async{
                 if(await interstitial.isLoaded){
                   interstitial.show();
                 }
                 FirebaseFirestore.instance.collection("challenge").doc(widget.model.docId).update({"userBdel":true});
               },),
             ),
                // UserProfile
               
               Container(
                margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                  !isLoading? NetworkImage("${user.userProfile}", ): AssetImage("assets/user.png")
                   ,fit: BoxFit.cover)
                ),
              ),

             //UserName
             if(!isLoading)
                Container(
                   width:MediaQuery.of(context).size.width*0.6,
                  margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
                  child:Text("${user.userName}", overflow: TextOverflow.ellipsis, maxLines: 1
                  ,style: userTextStyle,))
                else  Container(  margin: EdgeInsets.fromLTRB(80, 20, 0, 0),child:Text("Unknown",style: userTextStyle,))
           ,

          // Accept and decline button
           if(!(widget.model.accept))
         Container(
           margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
           child:   Row(
             crossAxisAlignment: CrossAxisAlignment.end,
             mainAxisAlignment: MainAxisAlignment.end,
             children: [

               RaisedButton(onPressed: (){

                  FirebaseFirestore.instance.collection("challenge").doc(widget.model.docId)
                  .update({"declined":true,"userBdel":true});

               },
               shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
               color: Colors.red[900]
               , child: Text("Decline", style: TextStyle(color:Colors.white,fontSize:15),),
               ),
               SizedBox(width: 10,),
           
              RaisedButton(onPressed: (){
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => CanAccept(model: widget.model,user:user),
                ));
              },
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
               color: Colors.blue[900]
               , child: Text("Accept", style: TextStyle(color:Colors.white,fontSize:15),),
               ),
                SizedBox(width: 10,),
             ],
           ))
           
           //Result
           ,if(widget.model.accept)
         Container(
           margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.5, 40, 0, 0),
           child: CurrentUserAcceptedChallenge(model: widget.model))

           
           
           ],
         ),
         )
       ),
    );
  }
}

class Challenged extends StatefulWidget {
  final QuizChallangeModel model;
  const Challenged({@required this.model, key}) : super(key: key);

  @override
  _ChallengedState createState() => _ChallengedState();
}

class _ChallengedState extends State<Challenged> {
UserModel user;
bool isLoading=true;
int userAscore=0;
AdmobReward reward;
  @override
  void initState() {
   FirebaseFirestore.instance.collection("user")
   .doc(widget.model.userBId).get().then((value){
     if(mounted){
       setState(() {
         Map<String,dynamic> data=value.data();
         user=new UserModel(job: data["job"], userName: data["userName"], 
         userProfile: data["userProfile"]);
         isLoading=false;
       });
     }

   });
    
     for (var item in widget.model.userAAns) {
    if(item=="Correct"){
      if(mounted){
        setState(() {
          userAscore+=1;
        });
      }
    }     
   }
    reward=initReward(reward);
   reward.load();
    super.initState();
  }
  var userTextStyle=TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
       child: Card(
         margin: EdgeInsets.zero,
         child: InkWell(
           onTap: (){
             if(widget.model.accept){
               Navigator.of(context).push(new MaterialPageRoute(
                 builder: (context) => ResultView(model: widget.model, type: false, user: user,),
               ));
             }
           },
           child: Stack(
           children: [
             // Clear button

             if(widget.model.accept || widget.model.declined)
             Container(
               margin:EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.82, 0, 0, 0),
               child: IconButton(icon: Text("clear",style: TextStyle(color:Colors.red[900],fontWeight:FontWeight.bold),),onPressed: ()async{
                 if(await reward.isLoaded){
                   reward.show();
                 }

                 FirebaseFirestore.instance.collection("challenge").doc(widget.model.docId).update({"userAdel":true});
               },),
             ),
             if(!widget.model.accept&&! widget.model.declined)
               Container(
                 margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.65, 40, 0, 0),
                 child:  Text("Your Score:$userAscore",style: TextStyle(color: Colors.blue[900],fontSize:13,fontWeight:FontWeight.bold),),),         
            //Pending

            if(!(widget.model.accept||widget.model.declined))
            Container(
              margin:EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.8, 5, 0, 0),
              child: Text("Pending...",style: TextStyle(fontWeight: FontWeight.bold),),),

                // UserProfile
               
                Container(
                margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                  !isLoading? NetworkImage("${user.userProfile}", ): AssetImage("assets/user.png")
                   ,fit: BoxFit.cover)
                ),
              ),


             //UserName
             if(!isLoading)
                Container(
                  width:MediaQuery.of(context).size.width*0.6,
                  
                  margin: EdgeInsets.fromLTRB(80, 20, 0, 0),
                  
                  child:Text("${user.userName}",
                  maxLines: 1
                  ,overflow: TextOverflow.ellipsis,style: userTextStyle,))
                else  Container(  margin: EdgeInsets.fromLTRB(80, 20, 0, 0),child:Text("Unknown",style: userTextStyle,))
           ,
           
           //Result
           if(widget.model.accept)
         Container(
           margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.5, 40, 0, 0),
           child: AcceptedChallenged(model: widget.model))


          //Declined Challenge
           ,if(widget.model.declined)
         Container(
           margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, 65, 0, 10),
           child:  Text("Declined" ,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[900]),))
           
           
           ],
         ),
         )
       ),
    );
  }
}
class AcceptedChallenged extends StatefulWidget {
    final QuizChallangeModel model;
  const AcceptedChallenged({@required this.model, key}) : super(key: key);
  @override
  _AcceptedChallengedState createState() => _AcceptedChallengedState();
}

class _AcceptedChallengedState extends State<AcceptedChallenged> {
  
int userAscore=0;
int userBScore=0;
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
var style=TextStyle(color: Colors.amber[900], fontSize: 16,fontWeight: FontWeight.w800);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(userAscore==userBScore?"Uniform":userAscore>userBScore?"You win":"You lose",style: style,),
    );
  }
}

class CurrentUserAcceptedChallenge extends StatefulWidget {
    final QuizChallangeModel model;
  const CurrentUserAcceptedChallenge({@required this.model, key}) : super(key: key);
  @override
  _CurrentUserAcceptedChallengeState createState() => _CurrentUserAcceptedChallengeState();
}

class _CurrentUserAcceptedChallengeState extends State<CurrentUserAcceptedChallenge> {
  
int userAscore=0;
int userBScore=0;
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
var style=TextStyle(color: Colors.deepOrange[900], fontSize: 16,fontWeight: FontWeight.w800);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(userAscore==userBScore?"Uniform":userAscore<userBScore?"You win":"You lose",style: style,),
    );
  }
}