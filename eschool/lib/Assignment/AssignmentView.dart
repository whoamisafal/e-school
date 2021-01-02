import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/Assignment/PdfNoticeView.dart';

import 'package:e_school/Download.dart';
import 'package:e_school/Notice/noticeStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AssignmentView extends StatefulWidget {
  final String grade;
  final String schoolId;
  AssignmentView({this.grade,this.schoolId});
  @override
  _AssignmentViewState createState() => _AssignmentViewState();
}

class _AssignmentViewState extends State<AssignmentView> {
String selectedMenu;
List<AssignmentModel> assignments=[
];
Widget assignmentText(AssignmentModel model,int index){
  return Container(
    child: Card(
       margin: EdgeInsets.zero,
      child:InkWell(
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
       Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [

             Container(
           margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
           child:   Text(formattedDate(model.published),textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red[800],fontSize:18),))
         
         ,
                //if(FirebaseAuth.instance.currentUser.uid==model.uid)
       //  menu(model)
         
         
         ],
       )
         ,SizedBox(
           height: 15,
         )
         ,Container(
           margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
           child: SelectableText(model.text,
           style:TextStyle(fontSize: 16,
           fontWeight: FontWeight.w600)),
         ),
         SizedBox(
           height: 25,
         ),
         
         
          ],
        ),
      ),
    )
  );
}


Widget menu(AssignmentModel model){
  return Container(

    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
    child: DropdownButton(
      value: null,
      isDense: true,
      onChanged: (String newValue) {
    if(mounted){
      setState(() {
     // menuAction(newValue,model);
      
      });
    }
      },
      items: ['update', 'delete'].map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
  );
}
Widget pdfMenu(AssignmentModel model){
  return Container(

    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
    child: DropdownButton(
      value: null,
      isDense: true,
      onChanged: (String newValue) {
    if(mounted){
      setState(() {
     // menuAction(newValue,model);
      
      });
    }
      },
      items: [ 'delete'].map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
  );
}


 /*menuAction(String val ,AssignmentModel model){
  if(val=="delete"){
    FirebaseFirestore.instance.collection("Schools").doc(widget.schoolId).collection("assignment").doc(model.docId).delete();    

  }
  else if(val=="update"){
   
    showDialog(context: context
    ,builder: (context) => PublishAssignment(type: true,docId: model.docId, schoolId: widget.schoolId, grade: widget.grade,assignment: model.text,),
    
    );
  }

}*/



@override
  void initState() {
    FirebaseFirestore.instance.collection("Schools").doc(widget.schoolId).collection("assignment").where("grade",
    isEqualTo: widget.grade).limit(25).snapshots().listen((event) {
  assignments.clear();
      if(mounted){
        setState(() {
         
          for (var item in event.docs) {
            Map<String,dynamic> data=item.data();
         var model=   new AssignmentModel(
        text: data["text"],
        type: data["type"],
       published: data["published"],
       url: data["url"],
       grade: data["grade"],
       uid: data["uid"],
       docId: item.id,
    );
          
          assignments.add(model);
          }
        });
      }
     });
    super.initState();
  }
  assignmentPDF(AssignmentModel model,int index){
    return Container(   margin: EdgeInsets.zero,
     
      child:  Card(
       margin: EdgeInsets.zero,
      child:InkWell(
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => PDFAssignmentView(index: index,model: model,),
          ));
        },
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
       Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [

             Container(
           margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
           child:   Text(formattedDate(model.published),textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red[800],fontSize:18),))
         
       ,
       //
       if(FirebaseAuth.instance.currentUser.uid==model.uid)
       pdfMenu(model)
         
         
         ],
       )  ,Row(crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children:[
           Icon(Icons.picture_as_pdf,size: 50,),
           IconButton(icon: Icon(Icons.file_download), onPressed: ()async{
            await  createFolder();
             DownloadFile("${model.text+model.grade}", model.url).downloadStart();

           })
         ]
       )
  
       
         ,Container(
           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
           child: SelectableText(model.text,
           style:TextStyle(fontSize: 16,
           fontWeight: FontWeight.w600)),
         ),
         SizedBox(
           height: 25,
         ),
         
         
          ],
        ),
      ),
    )


     
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

   


      appBar: AppBar(
         leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.of(context).pop(true);
          }),
        title: Text("${widget.grade} Assignment"),
      ),
      body: assignments.length==0?Container(child:Center(child: Text("Assignment not found",style:TextStyle(color: Colors.black,fontSize:18)),)): ListView.builder(
        itemCount: assignments.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          if(index!=null && index==1 ||index!=null && index==15 ){
           return  Column(
              children: [
              AdmobBanner(adUnitId: getBannerId(), adSize: AdmobBannerSize.BANNER,  
              listener: (AdmobAdEvent event,Map<String,dynamic> args ) => hadleEvent(event, args, "Banner"),)
               , if(assignments[index].type=="text")
              assignmentText(assignments[index],index),
               if(assignments[index].type=="pdf")
                assignmentPDF(assignments[index],index)
              ],
            );
          }
          if(assignments[index].type=="text")
          return assignmentText(assignments[index],index);
          else
          return assignmentPDF(assignments[index],index);
        },
      ),
      
    );
  }
}

class AssignmentModel{
  final String type;
  final String text;
  final String uid;
  final String url;
  final int published;
  final String docId;
  final String grade;


  AssignmentModel({this.type,this.text,this.url,this.published,this.grade,this.uid,this.docId});

  Map<String,dynamic> toMap()=>{
    "type":type,
    "text":text,
    "uid":uid,
    "url":url,
    "published":published,
    "grade":grade




  };

}