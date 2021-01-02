
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/Download.dart';
import 'package:e_school/Notice/PdfNoticeView.dart';
import 'package:e_school/Notice/TextNoticeView.dart';
import 'package:e_school/Notice/noticeStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Notice extends StatefulWidget {
  final String docId;
  Notice({this.docId});
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {

List<NoticeModel> notices=[

];
bool isLoading=true;
AdmobInterstitial interstitial;
AdmobReward reward;

@override
  void initState() {
    getNotices();
     interstitial=initInterstitial(interstitial);
  interstitial.load();
  reward=initReward(reward);
  reward.load();

    super.initState();
  }
getNotices()async{
 await  _fetchData();
}
Future<void> _fetchData(){
     FirebaseFirestore.instance.collection("Schools").
   doc(widget.docId).collection("notice").snapshots().listen((event) {
      if(mounted){
        setState(() {
          notices.clear();
          for (var item in event.docs) {
            Map<String,dynamic> data=item.data();
          var notice=  new NoticeModel(noticeMessage: data["noticeMessage"],
         subject: data["subject"],
         published: data["published"],
         uid: data["uid"],
        type: data["type"],
       url: data["url"],
       docId: item.id);
            notices.add(notice);
          }
          isLoading=false;
        });
      }
    });
    return null;
}


var user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()async{
          if(await interstitial.isLoaded){
            interstitial.show();
          }
           
           
            Navigator.of(context).pop(true);
          }),
        title:Hero(tag: "Notices", child: Text("Notice"))
      ),
      body:isLoading?Center(child:CircularProgressIndicator()):notices.length==0?Center(child:Text("Empty Notice",style:TextStyle(color: Colors.black,fontSize:18))): ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,

        physics: const ClampingScrollPhysics(),
        itemBuilder:  (context, index) {
          if(index!=null && index==1 || index!=null && index==13||index!=null && index==52){
            return Column(
              children: [
              AdmobBanner(adUnitId: getBannerId(), adSize: AdmobBannerSize.BANNER,  
              listener: (AdmobAdEvent event,Map<String,dynamic> args ) => hadleEvent(event, args, "Banner"),)
               , if(notices[index].type=="text")
              TextNotice(notice: notices[index],index: index,),
               if(notices[index].type=="pdf")
               PdfNotice(notice: notices[index],index: index,)
              ],
            );
          }
      if(notices[index].type=="text"){
            return TextNotice(notice: notices[index],index: index,);
      }else{
        return  PdfNotice(notice: notices[index],index: index,);
      }
        }, 
      itemCount: notices.length),
      
    ), onWillPop: ()async{
      if(await reward.isLoaded){
reward.show();
      }
      return true;
    });
  }
}

class TextNotice extends StatelessWidget {
 final NoticeModel notice;
 final int index;
  TextNotice({this.notice,this.index});


  
  @override
  Widget build(BuildContext context) {
  return  Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
                height: 150,
            child: Card(
              
               margin: EdgeInsets.zero,
               child: InkWell(
                 onTap: (){
                   Navigator.of(context).push(new MaterialPageRoute(builder: (context) => TextNoticeView(model: notice,index:index),));
                 },

                 child: Column(
                   crossAxisAlignment:CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                        
                     // Subject
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                      width:350,
                      height:50,
                    
                      child:Hero(tag: "subject $index", child: Text("${notice.subject}",style:subjectStyle))
                    )
                // Message
                    ,Container(
                      width:350,
                      height:50,
                       padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                      child: Text("${notice.noticeMessage}",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines:2,
                      style:TextStyle(fontWeight: FontWeight.bold),

                      ))
                    

                   
                  //PublishedDate

                  ,Container(
                    height: 20,
                    width:120,
                    margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.6),
                  
                    child: Text("${formattedDate(notice.published)}",style: TextStyle(fontWeight:FontWeight.bold),),
                  )

                   
                   ],

                 ),
               ),
               

            ),
     );
  }
}

class PdfNotice extends StatelessWidget {
   final NoticeModel notice;
 final int index;
  PdfNotice({this.notice,this.index});
  @override
  Widget build(BuildContext context) {
    return  Container(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
                height: 150,
            child: Card(
              
               margin: EdgeInsets.zero,
               child: InkWell(
                 onTap: (){
                   Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PDFNoticeView(model: notice,index:index),));
                 },

                 child: Column(
                   crossAxisAlignment:CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [

                     // Subject
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                      width:350,
                      height:50,
                    
                      child:Hero(tag: "subject $index", child: Text("${notice.subject}",style:subjectStyle))
                    )
                // Message
                   ,Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [ 
                       Container(
                         width: 250,
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                 
                    
                      child:Icon(Icons.picture_as_pdf,size:50)
                    ),
                             Container(
                               child:IconButton(
                               onPressed: ()async{
                                 await createFolder();
                                DownloadFile(notice.subject, notice.url).downloadStart();
                               },
                               icon: Icon(Icons.file_download),
                             ))
                    
                    
                    ],
           
                   )
                    

                   
                  //PublishedDate

                  ,Container(
                    height: 20,
                    width:120,
                    margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.6),
                  
                    child: Text("${formattedDate(notice.published)}",style: TextStyle(fontWeight:FontWeight.bold),),
                  )

                   
                   ],

                 ),
               ),
               

            ),
     );
  
  }
}



class NoticeModel{

     final  String subject;
     final String type;
     final String noticeMessage;
     final String url;
     final String uid;
     final int published;
     final String docId;
    NoticeModel({this.subject,this.type,this.noticeMessage,this.url,this.published,this.uid,this.docId});

    Map<String,dynamic> toMap()=>{"subject":subject,
    "type":type,
    "noticeMessage":noticeMessage,
    "url":url,
    "published":published
    ,"uid":uid};



}