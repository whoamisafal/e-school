import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/Assignment/AssignmentView.dart';

import 'package:e_school/Notice/noticeStyles.dart';
import 'package:e_school/Notice/viewer.dart';
import 'package:e_school/Peoples/UserModel.dart';
import 'package:flutter/material.dart';


class PDFAssignmentView extends StatefulWidget {
   final AssignmentModel  model;
   final int index;
   PDFAssignmentView({this.model,this.index});
  @override
  _PDFAssignmentViewState createState() => _PDFAssignmentViewState();
}

class _PDFAssignmentViewState extends State<PDFAssignmentView> {
UserModel userModel;

@override
  void initState() {
   FirebaseFirestore.instance.collection("user").doc(widget.model.uid).get().then((event) {
     if(mounted){
       setState(() {
         if(event.exists){
 userModel=new UserModel(userName: event.data()["userName"]
        ,userProfile: event.data()["userProfile"]);
         }
       
       });
     }

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
          children:[
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.of(context).pop(true);
          }),
         Hero(tag: "subject ${widget.index}", child:  Container(
          
           width: MediaQuery.of(context).size.width*0.8,
           child:Text("${widget.model.text}",
           maxLines: 2,
           overflow: TextOverflow.ellipsis,style:subjectStyle)))
            ],
          ),   SizedBox(height: 10,),
            //Profile and UserName
            if(userModel!=null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

                Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${userModel.userProfile}")
                   ,fit: BoxFit.cover)
                ),
              ),
              if(userModel!=null)
                Container(
                  child: Center(child:Text("${userModel.userName}",style:TextStyle(fontWeight: FontWeight.bold))),
                ),
            ],
          ),
        
        
        
          //Published Date
          Container(
            padding: EdgeInsets.all(15),
            child:Text(formattedDate(widget.model.published),style:TextStyle(fontWeight: FontWeight.w700)
            ,)
            ,)

         
          
          
          ],
        ),
            //Notice
      Container(
        height: MediaQuery.of(context).size.height*0.7,
        child:  PDFViwer(url: widget.model.url),)
         
         
          ]
        )  


      ),
    
      
    );
  }
}

