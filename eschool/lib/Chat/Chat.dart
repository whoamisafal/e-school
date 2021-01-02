import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/Chat/GroupChat.dart';

import 'package:e_school/Chat/Message.dart';

import 'package:e_school/Peoples/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

class ChatPage extends StatefulWidget {
  final String schooldId;
  ChatPage({@required this.schooldId});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
String schoolName="";
String logoUrl="";
@override
void initState() {
try {
    FirebaseFirestore.instance.collection("Schools").doc(widget.schooldId)
  .snapshots().listen((event) { 
    if(event.exists){
      if(mounted){
        setState(() {
          schoolName=event.data()["name"];
          logoUrl=event.data()["logo"];
        });
      }
    }
  });
} catch (e) {
}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(

       appBar: AppBar(title: Text("Chat"),
       leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.of(context).pop(true);})
       ,bottom: TabBar(
     
      
        indicatorColor: Colors.red,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: tabs.map((e){
        return Tab(icon: Icon(e.icon),
        text: e.tabName,
        );
      }).toList(),),
      )

      ,body: TabBarView(children: tabs.map((e){
        if(e.tabName=="People"){
          return Peoples();
        }
        return GroupChat(logo: logoUrl,schoolName: schoolName,sid: widget.schooldId,);
      }).toList())
      ,),
      
    );
  }
}
class GroupChat extends StatelessWidget {
final String logo;
final String schoolName;
final String sid;
GroupChat({this.logo,this.schoolName,this.sid});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(5),
      
           
            child: Card(
              elevation: 3,
              child:InkWell(
                onTap: (){
                  Navigator.of(context).push(new 
                  MaterialPageRoute(
                    builder: (context) =>GroupChatScreen(sid:sid,),
                  ));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("$logo", )
                   ,fit: BoxFit.cover)
                ),
              ),
                 Flexible(
                
                child: Text("$schoolName Group chat",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)))



],
                ),),
              )
            ),

            Container(
              height:150,
              child:NativeAdmob(adUnitID: getNativeId(),
            numberAds: 2,
            type: NativeAdmobType.full,
            ),)
       
       
        ],
      ),
    );
  }
}

class Peoples extends StatefulWidget {
  @override
  _PeoplesState createState() => _PeoplesState();
}

class _PeoplesState extends State<Peoples> {
List<UserModel> users=[];
bool isLoading=true;
var currentUser=FirebaseAuth.instance.currentUser;
AdmobInterstitial interstitial;

@override
  void initState() {
    
   try {
      FirebaseFirestore.instance.collection("user")
    .where("uid", isNotEqualTo: currentUser.uid)
 
    .snapshots().listen((event) {
      users.clear();
      for (var item in event.docs) {
        if(mounted){
          setState(() {
            Map<String,dynamic> d=item.data();
          var model=  new UserModel(
        job: d["job"],schoolDocId: d["schoolDocId"]
        ,uid: d["uid"],
         userName: d["userName"],
         token: d["token"],
         userProfile:d["userProfile"] );
         users.add(model);
        isLoading=false;
          });
        }
        
      }

    });
   } catch (e) {
   }finally{
     interstitial=initInterstitial(interstitial);
     interstitial.load();
     if(mounted){
       setState(() {
         isLoading=false;
       });
     }
   }
  
    super.initState();
  }

@override
  void dispose() {

    super.dispose();
  }


Widget user(UserModel user){
  return Container(
    margin: EdgeInsets.all(1),
    height: 80,
 
    child: InkWell(
      onTap:()async{
          if(await interstitial.isLoaded){
            interstitial.show();

          }
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ChatScreen(model: user,),));


      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:[
            Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(tag: user.uid, child:   Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${user.userProfile}", )
                   ,fit: BoxFit.cover)
                ),
              ),),
                Container(
                  child: Center(child:Text("${user.userName}",style:TextStyle(fontWeight: FontWeight.bold))),
                ),
            ],
          ),

          Padding(padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.75)
          ,child:Text("${user.job}"
          ,style: TextStyle(color:Colors.blue[900],
          fontWeight: FontWeight.bold,fontSize:16),),
          
          )
        
        ]
      ),

    ),

  );
}


  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child:CircularProgressIndicator() )
    :ListView.builder(
      itemCount: users.length,
      shrinkWrap: true,
       itemBuilder:(context, index) {
         return user(users[index]);
       } ,
      
    );
  }
}




class TabData{
  String tabName;
  IconData icon;
  TabData({this.icon,this.tabName});
}


List<TabData> tabs=[
TabData(icon: Icons.chat,tabName: "Group chat"),
TabData(icon: Icons.people,tabName: "People"),


];