import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/Peoples/UserModel.dart';
import 'package:e_school/PublishQuiz/AddQuiz.dart';
import 'package:e_school/QuizChallenge/QuizModel.dart';
import 'package:e_school/QuizChallenge/RandomQuestion.dart';
import 'package:e_school/Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuizStart extends StatefulWidget {
 final String userBId;
 QuizStart({@required this.userBId});

  @override
  _QuizStartState createState() => _QuizStartState();
}

class _QuizStartState extends State<QuizStart> {

Timer countDown;
int count=0;
int totalQuestion=5;
String radioBtnCurrentSelected="";
List<bool> checked=[];
int currentQuestion=0;
List<QuizData> questions=[];
bool isLoading=true;
List<String> docId = [];
List<String> selectedAns=[];
List<String> correctAns=[];
UserModel challangedUser;
var user=FirebaseAuth.instance.currentUser;
List<String> userAans=[];

@override

void initState() {
   FirebaseFirestore.instance
        .collection("question")
     
        .get()
        .then((snap) {
      QuestionChoose choose = new QuestionChoose(snap: snap.docs);
      setState(() {
        for (var item in choose.getQuestions()) {
          Map<String, dynamic> d = item.data();
          docId.add(item.id);
          questions.add(
            new QuizData(
                userId: d['userId'],
                timestamp: d['timestamp'],
                question: d['question'],
                options: d['options'],
                type: d['type'],
                answer: d['answer'],
                upvote: d['upVote'],
                docId: item.id,
              ),
          );
        }
      });
    });


FirebaseFirestore.instance.collection("user").doc(widget.userBId).get().then((value){

  if(mounted){
    setState(() {
     try {
       challangedUser=new UserModel(
         userName: value.data()["userName"],
         token: value.data()["token"]
       );
       
     } catch (e) {
       print(e);
     }
    });
  }
});


   countDown=Timer.periodic(const Duration(seconds:1), (timer){
     if(mounted){
       setState(() {
         count++;
         if(count==25){
           Fluttertoast.showToast(msg: "Timeout", backgroundColor: Colors.red);
           userAans.add("Timeout");
           checked.clear();
           radioBtnCurrentSelected="";
           if(currentQuestion==4){
             challange();
           }
           if(currentQuestion!=4){
             currentQuestion++;
           }
           count=0;
         }
       });
     }
   });

    super.initState();
  }

@override
  void dispose() {
    checked.clear();
    countDown?.cancel();
    super.dispose();
  }
static const timerStyle=TextStyle(fontSize: 16,fontWeight: FontWeight.bold);


Widget radioButtonOptions(){
  return Container(

    child: ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: questions[currentQuestion].options.length,
      itemBuilder: (context, index) {
      return ListTile(
        onTap: () {
           if(mounted){
             setState(() {
               radioBtnCurrentSelected=questions[currentQuestion].options[index];
             });
           }
        },
        title:Text( questions[currentQuestion].options[index]),
         selected: true,
         leading: Radio(value: radioBtnCurrentSelected,
         activeColor: Colors.red[900],
         focusColor: Colors.blue[900],
          groupValue:questions[currentQuestion].options[index], 
         onChanged: (value) {
           if(mounted){
             setState(() {
               radioBtnCurrentSelected=questions[currentQuestion].options[index];
             });
           }
         },),
         
          
      
      );
    },),
  );
}

Widget checkBoxOptions(){
  
for (var item in questions[currentQuestion].options) {
    checked.add(false);print(item);
}

  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: questions[currentQuestion].options.length,
      itemBuilder: (context, index) {
      return CheckboxListTile(
        value: checked[index],
        onChanged: (value) {
          if(value){
            setState(() {
            checked[index]=value;
            selectedAns.add(questions[currentQuestion].options[index]);
          });
          }else{
             setState(() {
            checked[index]=value;
            selectedAns.remove(questions[currentQuestion].options[index]);
          });
          }
        },
        selected: true,
        title: Text(questions[currentQuestion].options[index]),
      
         
          
      
      );
    },),
  );
}
void validate(){
      if(questions[currentQuestion].type=="options"){
      if(radioBtnCurrentSelected==questions[currentQuestion].answer[0]){
      Fluttertoast.showToast(msg: "Correct", backgroundColor: Colors.green[900]);
      userAans.add("Correct");
       }else{
        Fluttertoast.showToast(msg: "Wrong", backgroundColor: Colors.red[900]);
         userAans.add("Wrong");
         }
          }else if(questions[currentQuestion].type=="checkbox"){
                      selectedAns.sort();

                        for (var item in questions[currentQuestion].answer) {
                          if(mounted){
                            setState(() {
                              correctAns.add(item.toString());
                            });
                          }
                          
                        }
                        correctAns.sort();
                        if(listEquals(correctAns, selectedAns)){
                           Fluttertoast.showToast(msg: "Correct", backgroundColor: Colors.green[900]);
                         userAans.add("Correct");
                        }else{
                           Fluttertoast.showToast(msg: "Wrong", backgroundColor: Colors.red[900]);
                       userAans.add("Wrong");
                        }
                        
                        
                    }
}
Widget alert(){
  return AlertDialog(
    backgroundColor: Colors.black38,
    title: Text("Do you want to close?",style: TextStyle(color:Colors.white),),
    actions: [
       RaisedButton(
         color: Colors.red,
        onPressed: (){Navigator.of(context).pop(true);},
        child: Text("No"),
      ),
      RaisedButton(
         color: Colors.blue,
        child: Text("Yes"),
        onPressed: (){
         int len=userAans.length;
              for(int i=len;i<5;i++){
                if(mounted){
                  setState(() {
                    userAans.add("Wrong");
                  });
                }
              }
              challange();
              Navigator.of(context).pop(true);
      }),
     
      
    ],
  );
}
void challange()async{

 sendNotificationMessage(challangedUser.token, "Challange form ${user.displayName}", "Quiz Challenge");
 
QuizChallangeModel model=new QuizChallangeModel(
  accept: false,
  declined: false,
  documentId: docId,
  userAAns: userAans,
  userAId: FirebaseAuth.instance.currentUser.uid,
  userATimestamp: DateTime.now().millisecondsSinceEpoch,
  userAdel: false,
  userBAns: null,
  userBId: widget.userBId,
  userBTimestamp: null,
  userBdel: false
);

FirebaseFirestore.instance.collection("challenge").doc().set(model.toMap()).then((value)async {
 sendNotification();

  Navigator.of(context).pop(true);Navigator.of(context).pop(true);
});

  
}
 
  sendNotification()async{
  try{
         FirebaseFirestore.instance.collection("Notifications").doc(widget.userBId).collection("notification").doc().set({
            "title":"Challange form ${user.displayName}",
            "body":"Quiz Challenge",
            "timestamp":DateTime.now().millisecondsSinceEpoch,
            "seen":false,
            "token":challangedUser.token
          });

  }catch(e){

  }finally{

  }
  return null;
}


  @override
  Widget build(BuildContext context) {
  
    return WillPopScope(
      child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
           leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
             showDialog(context: context
             , builder: (context) => alert(),
             
             
             );
          }),
          title: Text("Challenge"),

          
        ),
        body:questions.length>0? Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(3),
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(3),
            child:ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
          children: [

              //Loading
              Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 25,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(side: BorderSide(width: 2,color: Colors.blue[900])
                      ,borderRadius: BorderRadius.circular(15)
                      ),
                    ),
               ),

                  ),                   Positioned(
                    child: Container(
                      height: 25,
                    width:(MediaQuery.of(context).size.width*count.toDouble())/25,
                    child: Card(
                      color: Colors.red,
                       shape: RoundedRectangleBorder(side: BorderSide(width: 1,color: Colors.green[900])
                      ,borderRadius: BorderRadius.circular(15)
                      ),
                    ),

                  ),),


                ],
              ),
  //Timer
              SizedBox(height: 25,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.only(left:25),child:Text("${currentQuestion+1}/$totalQuestion",style: timerStyle,),)
                   ,Padding(padding: EdgeInsets.only(right:35)
                   ,child:  Text("$count sec",style:timerStyle),)
              ],
            ),

            //
           Center(
             child: Container(
              height: 25,
              width: 250,
              margin: EdgeInsets.zero,
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                return Icon(Icons.skip_next,color: index==currentQuestion?Colors.red[900]:Colors.black,size: 25,);
              },),
            ),),



              //Questions

               
              Container(
               
                margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Text("${questions[currentQuestion].question}",style: TextStyle(fontSize:18,fontWeight:FontWeight.w700),),
              ),


              //Radio Button
         if(questions[currentQuestion].type=="options")
         radioButtonOptions(),

              //Check Box
        if(questions[currentQuestion].type=="checkbox")
        checkBoxOptions(),

              //Submit
            Container(
                width: 250,
                
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, 5,10, 5),
                
              child: RaisedButton(
                elevation: 5,
                color: Colors.blue[800],
                onPressed: (){
                
                    validate();

                  count=0;
                  if(currentQuestion==4){
                    challange();
                  }

                  if(currentQuestion!=4){
                      if(mounted){
                    setState(() {
                      selectedAns.clear();
                      correctAns.clear();
                     checked.clear();
                     radioBtnCurrentSelected="";
                    currentQuestion++;
                  });
                 }
                  }
                
                },
              child: Text("Submit",style:TextStyle(color: Colors.white,fontSize: 16)),),
            ),





          ],
        ),
          ),

        ):Center(child:CircularProgressIndicator())
      ),


      
      
    )
  , onWillPop: ()async {
    return false;
    
  },);
  
  }
}

