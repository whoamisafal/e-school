
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_school/Chat/ChatModel.dart';
import 'package:e_school/Peoples/UserModel.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class GroupChatScreen extends StatefulWidget {
  final String sid;

  GroupChatScreen({this.sid});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {

TextEditingController message=new TextEditingController();
var user=FirebaseAuth.instance.currentUser;
List<ChatModel> chats=[];
bool isLoading=true;
 var chat;
  _buildMessage(ChatModel message, bool isMe) {


    final  msg = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(!isMe)
        MessageProfile(model:message),
        Container(
      
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              right: 80
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width ,
      decoration: BoxDecoration(
        color: isMe ? Color(0xFF0a5543) : Color(0xFFFD5E02),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

         

          Text(
            "${message.message}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            readTimestamp(message.timestamp),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
   
       
       
        ],
      ),
    )
      ],
    );
 return msg;
  }

  _buildMessageComposer() {
 
   
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
      
          Expanded(
            child: TextField(
              controller: message,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if(message.text.isEmpty){
                return;
              }
              var model=new ChatModel(
               message:message.text,
              senderId: FirebaseAuth.instance.currentUser.uid,
              seen: false,
              reciverId: widget.sid,
              userBseentimestamp: null,
              timestamp: DateTime.now().millisecondsSinceEpoch,
              type: "text",
              url: null
             );
        chat.doc().set(model.toMap()).then((value) {
        
          message.clear();
        });
            

            },
          ),
        ],
      ),
    );
  }
@override
  void initState() {
    
  chat=FirebaseFirestore.instance.collection("Schools").doc(widget.sid).collection("chat");
    
    try {
     chat
      .orderBy("timestamp", descending: true).snapshots().listen((event) {

if(mounted){

setState(() {
  chats.clear();
  for (var item in event.docs) {
    Map<String,dynamic> data=item.data();
  ChatModel model=new ChatModel(
      docId: item.id,
      message: data["message"],
      seen: data["seen"],
      timestamp: data["timestamp"],
      type: data["type"],
       url: data["url"],
       senderId: data["senderId"],
       
     
    );
    chats.add(model);
    
  }
});

}


});
    } catch (e) {
    }finally{
      if(mounted){
        setState(() {
          isLoading=false;
        });
      }
    }



    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          "Group Chat",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
     
    
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child:isLoading?Center(child: CircularProgressIndicator()):chats.length==0?Center(child:Text("Let's start chatting")): ListView.builder(
                    itemCount: chats.length,
                    reverse: true,
                    itemBuilder: (context, index) => chats[index].senderId==user.uid?_buildMessage(chats[index],true):_buildMessage(chats[index],false),),
                  
                 
                ),
              ),
            ),
             
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}


class MessageProfile extends StatefulWidget {
  final ChatModel model;
  MessageProfile({this.model});
  @override
  _MessageProfileState createState() => _MessageProfileState();
}

class _MessageProfileState extends State<MessageProfile> {
UserModel model;
@override
  void initState() {
try {
   FirebaseFirestore.instance.collection("user")
 .doc(widget.model.senderId).snapshots().listen((event) { 
if(mounted){
  setState(() {
     Map<String,dynamic> d=event.data();
           model=  new UserModel(
          schoolDocId: d["schoolDocId"]
        ,uid: d["uid"],
         userName: d["userName"],
         userProfile:d["userProfile"] );
       
  });
}
 });
} catch (e) {
}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        
        children: [
        if(model!=null)
           Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                   color: Colors.teal[600],
                   shape: BoxShape.circle,
                   image: DecorationImage(image: 
                   NetworkImage("${model.userProfile}", )
                   ,fit: BoxFit.cover)
                ),
              )
          ,if(model!=null)
          Text("${model.userName}",style: TextStyle(fontWeight: FontWeight.bold ),)

      ],),
      
    );
  }
}