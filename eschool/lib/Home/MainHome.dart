import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:e_school/Assignment/Assignment.dart';
import 'package:e_school/Chat/Chat.dart';
import 'package:e_school/Home/notificationView.dart';


import 'package:e_school/Home/styles.dart';
import 'package:e_school/ModelQuestions/ModelQuestions.dart';
import 'package:e_school/Notice/Notice.dart';
import 'package:e_school/Notice/PdfNoticeView.dart';
import 'package:e_school/Notice/TextNoticeView.dart';

import 'package:e_school/Quiz/Quiz.dart';
import 'package:e_school/QuizQuestionsCollection/QuizQuestion.dart';
import 'package:e_school/Results/Results.dart';

import 'package:e_school/login/RegisterHelper.dart';
import 'package:e_school/login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    
      child: MainHome(),
      
    );
  }
}



class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  
String url="";
String schoolName="School";
int grade=0;
String sid="";
bool isLoading=true;
bool hasNotice=false;
int notifications=0;
var user=FirebaseAuth.instance.currentUser;
@override
  void initState() {
   try {

FirebaseFirestore.instance.collection("user")
.doc(FirebaseAuth.instance.currentUser.uid).snapshots().
listen((d){
  if(mounted){
    setState(() {
      sid=d.data()["sId"];
    });
  }
  
     FirebaseFirestore.instance.collection("Schools").
   doc(d.data()["sId"]).snapshots().listen((value){
if(mounted){
  setState(() {
    url=value.data()["logo"];
    schoolName=value.data()['name'];
    grade=value.data()["grade"];
  });
}
   });
   if(sid.isNotEmpty)
FirebaseFirestore.instance.collection("Schools").doc(sid).collection("notice").snapshots().listen((event) { 
  if(event.docs.length>0){
    if(mounted){
      setState(() {
        hasNotice=true;
      });
    }
  }

});


});


} catch (e) {
  print(e);




}finally{
   fcm.configure(
     
     onLaunch: (message) async{
       print("OnLaunch");
     },
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      
      });
}
FirebaseFirestore.instance.collection("Notifications").doc(user.uid).collection("notification")
.where("seen" , isEqualTo: false).snapshots().listen((value){
  
 if(mounted){

setState(() {
  notifications=value.docs.length;
});

 }
});



    super.initState();
  }
   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1),(){
      if(mounted){
        setState(() {
          isLoading=false;
        });
      }
    });
    return SafeArea(
      child: Scaffold(
      key:scaffoldKey,
       backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            if(notifications!=0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                   IconButton(icon:Icon(Icons.notifications),
                   onPressed: (){
                  scaffoldKey.currentState.showBottomSheet((context) => NotificationView());
                   },
                iconSize: 35,
                    color: Colors.white,),
                   Container(
                     width: 25,
                     height: 25,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle
                       ,color:Colors.blue[900]
                     ),
                     child: Center(child: Text(notifications>9?"+9":notifications.toString(), style: TextStyle(color:Colors.white
                   ,fontWeight: FontWeight.bold
                   ),),),
                   )
                ],)
              ],
            ),SizedBox(width:15)

          ],
          elevation: 5,
           
          title: Text("$schoolName",style:TextStyle(color: Colors.white)),
        ),
        drawer: Drawer(
          
          child: MyDrawer(url: url,sid: sid,),
        ),
        body:isLoading?Center(child:CircularProgressIndicator()): ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
        SchoolBanner(schoolName: schoolName,url: url,),
        if(hasNotice)
         ImportantNotice(docId: sid,),
        Menu(grade: grade,sid: sid,),
 
          ],

        ),


      ),
      
    );
  }
}
//Menu
class Menu extends StatelessWidget {
final int grade;
final String sid;
Menu({this.grade,this.sid});
static const menus=["Notices","Quiz","Assignment","Model Questions","Results","Learn quiz questions","Chat"];

void _menuAction(int index,BuildContext context){
 List<Widget> navItem=[new Notice(docId:sid),new Quiz(),new Assignment(grade: grade,schoolId:sid),new ModelQuestions(docId: sid,),new Result(docId: sid,),new QuizQuestionCollection(),new ChatPage(schooldId: sid,)];
Navigator.of(context).push(new MaterialPageRoute(builder: (context) => navItem[index],));

}
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
    
      height: MediaQuery.of(context).size.height*0.8,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: menus.length,
      physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        mainAxisSpacing: 2,childAspectRatio: 1,crossAxisSpacing: 1),
       itemBuilder: (context, index) {
         return Container(
           width: 150,
          
            child:Card(
              borderOnForeground: true,
              clipBehavior: Clip.antiAlias,
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1,color: Colors.red,style: BorderStyle.solid),

              borderRadius: BorderRadius.circular(15),) ,
               
                elevation:3,
              child:InkWell(
              onTap: () => _menuAction(index,context),
              child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Hero(tag: "${menus[index]}", child: Container(
                 
                   
                   child:Text("${menus[index]}",style:menuTextStyle,textAlign: TextAlign.center,)
                   )),
                ]
             
            
              )))
              
         );
       },),
      
    );
  }
}

class MyDrawer extends StatefulWidget {
final String url;
final String sid;
MyDrawer({@required this.url,@required this.sid});
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          padding: EdgeInsets.zero,
          
          child: Container(
            height: 120,
          width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.blue,),
      child:Stack(
        fit: StackFit.loose,
        overflow: Overflow.clip,
        clipBehavior: Clip.antiAlias,
        children: [
          if(widget.url.isNotEmpty)
      Positioned.fill(child:   Image.network(widget.url,fit: BoxFit.cover,))
     
      ],) ,

        )),
          ListTile(
        title: Text("Notice"),
        onTap: (){
        
          Navigator.of(context).pop(true);
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Notice(docId: widget.sid,),));
        },
      ),
        ListTile(
        title: Text("Quiz"),
        onTap: (){
        
          Navigator.of(context).pop(true);
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Quiz(),));
        },
      ),

       ListTile(
        title: Text("Chat"),
        onTap: (){
        
          Navigator.of(context).pop(true);
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ChatPage(schooldId: widget.sid,),));
        },
      ),
  ListTile(
        title: Text("Log out"),
        onTap: (){
          signOutGoogle();
          FirebaseAuth.instance.signOut();
          
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => RegisterHelper(),));
        },
      )
     
      ],
      
    );
  }
}


//Important Notice 




class ImportantNotice extends StatefulWidget {
  final String docId;
  ImportantNotice({@required this.docId});
  @override
  _ImportantNoticeState createState() => _ImportantNoticeState();
}

class _ImportantNoticeState extends State<ImportantNotice> {
    int currentScrollIndex=0;

  Timer timer;
  bool isLoading=true;
  List<NoticeModel> impNotices=[];
  
@override
  void initState() {
_fetchData();

   
 timer=  Timer.periodic(const Duration(seconds: 5), (timer) { 
     if(mounted){
       setState(() {
         currentScrollIndex++;
      
         if(currentScrollIndex>=impNotices.length){
           currentScrollIndex=0;
         }
       });
     }
   });
   
    super.initState();
  }
  _fetchData(){
   
     FirebaseFirestore.instance.collection("Schools").
   doc(widget.docId).collection("notice").orderBy("published",descending: true).limit(2).snapshots().listen((event) {
      if(mounted){
        setState(() { impNotices.clear();
          for (var item in event.docs) {
            Map<String,dynamic> data=item.data();
          var notice=  new NoticeModel(noticeMessage: data["noticeMessage"],
         subject: data["subject"],
         published: data["published"],
         uid: data["uid"],
        type: data["type"],
       url: data["url"]);
            impNotices.add(notice);
          }
          isLoading=false;
        });
      }
    });
    return null;
}

@override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
 
 

 
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 260,
      margin: EdgeInsets.all(10),
   
      child:Card(
        color: Colors.teal[700],
          elevation: 5,
           shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
        child: impNotices==null?Center(child:CircularProgressIndicator()): ListView(
      
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        physics: const ClampingScrollPhysics(),

        children: [
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0)
          
          ,child: Text("Notices",style:schoolTextStyle,),)
          ,SizedBox(height: 10,)
          ,Center(
              heightFactor: 1,
              widthFactor: 4,
              child:Container(
                  width: 60,
                  height: 20,
         
            child: Center(
              child:ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: impNotices.length,
              itemBuilder: (context, index) {
             if(currentScrollIndex==index){
        return Center(child:Container(
                margin: EdgeInsets.all(4),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                     color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),);
             }else{
                return Center(child:Container(
                margin: EdgeInsets.all(4),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                     color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),);
             }
            },),)
          ),),

       Container(
      margin: EdgeInsets.all(10),
      height: 150,
      width: MediaQuery.of(context).size.width,
            child: Center(
              child: Center(
                child:Container( height: 150,
                margin: EdgeInsets.all(4),
                
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                 
                  shape: BoxShape.rectangle,
                
                ),
                child: InkWell(           
                  onTap:(){
                    if(impNotices[currentScrollIndex].type=="text"){
                      Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => TextNoticeView(index: currentScrollIndex,model: impNotices[currentScrollIndex],),
                    ));
                    }else if(impNotices[currentScrollIndex].type=="pdf"){
                        Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => PDFNoticeView(index: currentScrollIndex,model: impNotices[currentScrollIndex],),
                    ));
                    }
                  }
                
                ,child: Column(
                  children: [
                    if(impNotices.length>0)
                    Text(impNotices[currentScrollIndex].subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize:16,fontWeight:FontWeight.bold,color:Colors.white)
                    ),
                    SizedBox(height: 15,),
                    if(impNotices.length>0 && impNotices[currentScrollIndex].type=="text")
                    Text(impNotices[currentScrollIndex].noticeMessage
                    , maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize:16,fontWeight:FontWeight.bold,
                    color: Colors.white),
                    ),
                    if(impNotices.length>0 && impNotices[currentScrollIndex].type=="pdf")
                    Icon(Icons.picture_as_pdf,size:80,color:Colors.white)


                  ],
                ),
                
                ),
              ),)
        )
          ),
          
      
          
      
        ],
      ),
      )
      
    );
  }
}
//School Banner


class SchoolBanner extends StatelessWidget {

  final String schoolName;
  final String url;
  SchoolBanner({@required this.schoolName,@required this.url});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 120,
      child: Card(
      color:Colors.teal[700],
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
        elevation: 5,
        margin: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(url.isNotEmpty)
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("$url")
                   ,fit: BoxFit.cover)
                ),
              ),
           
           if(schoolName!=null)
              Container(
                width: MediaQuery.of(context).size.width*0.60,
                height:110,
                child: Center(child:Text(
                  "$schoolName",
                  maxLines: 3
                ,style:schoolTextStyle)),
              ),

          ],
        )
      ),
      
    );
  }
}