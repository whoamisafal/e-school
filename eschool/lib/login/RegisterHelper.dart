import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/Home/MainHome.dart';
import 'package:e_school/login/auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterHelper extends StatefulWidget {
  @override
  _RegisterHelperState createState() => _RegisterHelperState();
}

class _RegisterHelperState extends State<RegisterHelper> {
 
  List<String> jobs=["Student","Teacher","Guardian"];
   String selected="Student";
    bool isLoading=true;
   TextEditingController editingController=new TextEditingController();
  List<QueryDocumentSnapshot> snaps=[];
  String docID="";
  @override
  void initState() {
   FirebaseFirestore.instance.collection("Schools").get().then((value){
      for (var item in value.docs) {
       if(mounted){
         setState(() {
            snaps.add(item);
            docID=item.id;
            isLoading=false;
         // dropSelected=item;
         });
       }

      }
   });

    super.initState();
  }

@override
  void dispose() {
    editingController.clear();
  editingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
              SizedBox(height: 50,),
           Center(child: Text("Who are you?"
           ,style: TextStyle(
             color: Colors.blue[900],
             fontSize:24,
           fontWeight: FontWeight.bold
          
            ),
            ),
            ),
         
          Container(
            margin: EdgeInsets.all(25),
            child:  ListView.builder(
            shrinkWrap: true,
              itemCount: jobs.length,
              itemBuilder: (context, index) {

              return RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: (){
                if(mounted){
                  setState(() {
                    selected=jobs[index];
                    print(selected);
                  });
                }
              },
              child: Text("${jobs[index]}",style:TextStyle(color: Colors.white,fontSize: 16)),
              color: jobs[index]==selected?Colors.red:Colors.blue,
              );
            },),)
      
      ,Center(child: Text("Choose your school"
           ,style: TextStyle(
             color: Colors.blue[900],
             fontSize:24,
           fontWeight: FontWeight.bold
          
            ),
            ),
            ),
          SizedBox(height: 50,),
           
           Container(
             
             child: ListView.builder(
             
               physics: ClampingScrollPhysics(),
               shrinkWrap: true,
               itemCount: snaps.length,
               itemBuilder: (context, index) {
               return Ink(

                 padding: EdgeInsets.all(3),
                 color: docID==snaps[index].id? Colors.red:Colors.blue,
                 child:ListTile(

                 onTap: (){
                   if(mounted){
                     setState(() {
                       docID=snaps[index].id;
                     });
                   }
                 },
                 title: Column(
                   children:[
                     Text("${snaps[index].data()["name"]}",style:TextStyle(color: Colors.white,fontSize: 16)),
                      Text("${snaps[index].data()["district"]}\t\t${snaps[index].data()["street"]}",style:TextStyle(color: Colors.white,fontSize: 16)),
                   ]
                 ),
               )
               );
             },),
           ),

    if(!isLoading)
          Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.6, 80, 20, 20),
            child: RaisedButton(onPressed: ()async{
              await signInWithGoogle(docID,selected).then((result) {
                      if (result != null) {
                        Fluttertoast.showToast(
                            msg: "Login Success",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context)
                            .pushReplacement(new MaterialPageRoute(
                          builder: (context) => Home(),
                        ));
                      }
                    });
              
            },
            color: Colors.blue[800]
            ,child: Text("Login",style:TextStyle(color:Colors.white,fontSize:16)),),
          ),


          ],



        ),
      ),
    );
  }
}