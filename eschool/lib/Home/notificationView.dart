

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/Notice/noticeStyles.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
var user=FirebaseAuth.instance.currentUser;
List<NotificationModel> notifications=[];
@override
  void initState() {
   FirebaseFirestore.instance.collection("Notifications").
   doc(user.uid).collection("notification").limit(80)
.snapshots().listen((value){
  
 if(mounted){
notifications.clear();
setState(() {
for (var item in value.docs) {
 Map<String,dynamic> data=item.data();
 var notification=new NotificationModel(body: data["body"],
 seen: data["seen"],
 timestamp: data["timestamp"],
 title: data["title"],
 docId: item.id
 );
  notifications.add(notification);
}
});
 }
});


    super.initState();
  }
Widget _notice(NotificationModel model){
  return Container(
    
    height: 100,
    color:model.seen? Colors.blue[900]:Colors.blue[150],
    child: InkWell(
      onTap: (){
         FirebaseFirestore.instance.collection("Notifications").doc(user.uid).
         collection("notification").doc(model.docId).update({"seen":true});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
         Center(child:  Text(formattedDate(model.timestamp),
         style: TextStyle(color:Colors.deepOrange, fontSize:12),),),

       Container(
         margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
         child:   Text("${model.title}",
          textAlign: TextAlign.center
          , overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.red[500], fontSize: 16,fontWeight: FontWeight.bold),
          ),),
         Container(
           margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
          
            
            child: Text("${model.body}", overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize:14 ,fontWeight:FontWeight.bold),
          maxLines: 2,
          
          ),)
,
        
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Container(
  
      height: MediaQuery.of(context).size.height*0.9,
      width: MediaQuery.of(context).size.width,
        child: Container(
         
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Center(child:  Text("Notifications", 
            style: TextStyle(color:Colors.blue[900],
            fontSize: 18,
            fontWeight: FontWeight.bold
            
            ),)),
            SizedBox(height: 10,),
          
         Flexible(child:  ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: notifications.length,
            shrinkWrap: true,

            itemBuilder: (context, index){
              return _notice(notifications[index]);
            },),)
          
          
          
            ],
          ),
        ),
    );
  }
}

class NotificationModel {
  final String body;
  final String title;
  final bool seen;
  final int timestamp;
  final String docId;
  NotificationModel({this.body,this.title,this.seen,this.timestamp,this.docId});

  
}