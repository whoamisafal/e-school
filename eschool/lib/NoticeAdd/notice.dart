import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/Notice/Notice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewNotice extends StatefulWidget {
  @override
  _NewNoticeState createState() => _NewNoticeState();
}

class _NewNoticeState extends State<NewNotice> {
  TextEditingController subject=TextEditingController();
  TextEditingController notice=TextEditingController();
  String docId="";
  @override
  void initState() { 
    FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser.uid).get().then((value){
if(mounted){
  
setState(() {
  docId=value.data()["sId"];
});
}

    });


    super.initState();
    
  }

  publishNotice(){
    NoticeModel model=new NoticeModel(noticeMessage: notice.text,
                published: DateTime.now().millisecondsSinceEpoch,
                subject: subject.text,
                type: "text",
                uid: FirebaseAuth.instance.currentUser.uid,
                url: null);
                
                FirebaseFirestore.instance.collection("Schools").doc(docId).collection("notice").doc().set(model.toMap()).then((value){
                  subject.clear();
                  notice.clear();
                });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(title: Text("New Notice"),
         leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.of(context).pop(true);
          }),),


        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
              Text("Subject",textAlign: TextAlign.center,style: TextStyle(color: Colors.blue[800],fontSize: 21,fontWeight: FontWeight.bold),),
            //Notice Title
           Container(
             margin: EdgeInsets.all(5),
             height: 50,
              child: Card(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: subject,
                  decoration: InputDecoration(border: InputBorder.none,hintText: "Subject"),
                ),
              ),
            ),

            Text("Notice description",textAlign: TextAlign.center,style: TextStyle(color: Colors.blue[800],fontSize: 21,fontWeight: FontWeight.bold),),
            //Text Notice Message
            Container(
              margin: EdgeInsets.all(5),
              child: Card(
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: notice,
                  decoration: InputDecoration(border: InputBorder.none,hintText: "Notice description"),
                  minLines: 15,
                  maxLines: 35,
                ),
              ),
            )

            //pUBLISH nOTICE  

            ,Container(
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, 10, 20, 0),
              child: RaisedButton(onPressed: (){

                if(subject.text.isEmpty){
                  Fluttertoast.showToast(msg: "Subject filed empty",backgroundColor: Colors.red);
                  return;
                }
                 if(notice.text.isEmpty){
                    Fluttertoast.showToast(msg: "Notice filed empty",backgroundColor: Colors.red);
                  return;
                }
                if(docId.isEmpty){
                   Fluttertoast.showToast(msg: "Something went wrong",backgroundColor: Colors.red);
                  return;
                }
                publishNotice();




              },
              color: Colors.blue[900],
              child: Text("Published",style: TextStyle(color:Colors.white),),
              
              ),
            )



          ],
        ),
      ),
      
      
    );
  }
}