import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/Notice/Notice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class PdfNoticePublish extends StatefulWidget {
  final String schoolId;
  PdfNoticePublish({@required this.schoolId});
  @override
  _PdfNoticePublishState createState() => _PdfNoticePublishState();
}

class _PdfNoticePublishState extends State<PdfNoticePublish> {
    TextEditingController subject=TextEditingController();
    File selectedFile;
    bool isReady=false;
    String url="";
    bool isProgress=false;
    double taskComplete=0;
    String fileName="";
 StorageReference ref;

  void pickFile() async {
    print("PickFile");
    File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['pdf']);

    if (mounted) {
      if (file != null) {
        setState(() {
          selectedFile=file;
          uploadFile();
         
        });
      }
    }
  }
void uploadFile()async{
  if(mounted){
    setState(() {
      fileName=subject.text+""+DateTime.now().millisecondsSinceEpoch.toString()+".pdf";
    });
  }
  Fluttertoast.showToast(msg: "Upload start");
ref =FirebaseStorage.instance.ref().
  child("notices").
  child("$fileName");
  StorageUploadTask task= ref.putFile(selectedFile);
  task.events.listen((event) { 
    if(mounted){
      setState(() {
        isProgress=true;
           taskComplete = _bytesTransferred(event.snapshot);
      });
    }

  });


 await task.onComplete.then((snap) {
   if(mounted){
     setState(() {
       isReady=true;
     });
    snap.ref.getDownloadURL().then((url) {
      if(mounted){
        setState(() {
          this.url=url;
        });
      }
    });
   }
 });
}
  double _bytesTransferred(StorageTaskSnapshot task) {
    return (task.bytesTransferred * 100) / task.totalByteCount;
  }
  
  void publish(){

    NoticeModel model=new NoticeModel(
      noticeMessage: "",
      published: DateTime.now().millisecondsSinceEpoch,
      subject: subject.text,
      type: "pdf",
      uid: FirebaseAuth.instance.currentUser.uid,
      url: url
    );

    FirebaseFirestore.instance.collection("Schools").doc(widget.schoolId).collection("notice").doc().set(model.toMap()).then((value){
      if(mounted){
        setState(() {
          isReady=false;
          isProgress=false;
          url="";
          subject.clear();
        });
      }


    });



  }
  
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if(url.isNotEmpty)

            IconButton(icon: Icon(Icons.delete), onPressed: (){
              FirebaseStorage.instance.ref().child("notices").child("$fileName").delete().then((value){
         if(mounted){
           setState(() {
              isReady=false;
          isProgress=false;
          url="";
          subject.clear();
           });
         }

              } );


            })
           

          ],
          title:Text("PDF Notice"),
           leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
           if(url.isNotEmpty)
            FirebaseStorage.instance.ref().child("notices").child("$fileName").delete();
           
            Navigator.of(context).pop(true);
          }),
        ),
      body: ListView(
      physics: ClampingScrollPhysics(),
       shrinkWrap: true,
       children: [
            SizedBox(height: 50),
            Text("Subject",textAlign: TextAlign.center,style: TextStyle(color: Colors.blue[800],fontSize: 21,fontWeight: FontWeight.bold),),
            //Notice Title
           Container(
             margin: EdgeInsets.all(5),
             height: 75,
              child: Card(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: subject,
                  decoration: InputDecoration(border: InputBorder.none,hintText: "Subject"),
                ),
              ),
            ),

            SizedBox(height: 50),
            if(isProgress)
         Center(child:    Text("${taskComplete.toInt().toString()} %",style: TextStyle(color:Colors.black,fontSize:16,fontWeight:FontWeight.bold),),),
          Container(
            child:
             IconButton(
               iconSize: 100,
               icon: Icon(Icons.file_upload,size: 100,),
             onPressed: (){  
               if(subject.text.isEmpty){
                 Fluttertoast.showToast(msg: "Notice title is empty");
                  return;
               }
               if(url.isNotEmpty){
                  Fluttertoast.showToast(msg: "Already uploaded a file");
                  return;
               }
                pickFile();
               
              }),
          ),
    SizedBox(height: 50),




    if(isReady)
     Container(
       margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child:
             RaisedButton(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
               color: Colors.blue[900],
               child: Text("Publish",style: TextStyle(color:Colors.white,fontSize:18),),
             onPressed: (){
               if(subject.text.isNotEmpty)
               publish();
             }),
          ),

       ],
      ),
      ),
      
    )
  
  , onWillPop: ()async{
    return false;
  });
  }
}