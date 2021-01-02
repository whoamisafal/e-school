
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/Download.dart';
import 'package:e_school/Notice/Notice.dart';
import 'package:e_school/Notice/PdfNoticeView.dart';

import 'package:e_school/Notice/noticeStyles.dart';
import 'package:flutter/material.dart';



class ModelQuestions extends StatefulWidget {
  final String docId;
  ModelQuestions({this.docId});
  @override
  _ModelQuestionsState createState() => _ModelQuestionsState();
}

class _ModelQuestionsState extends State<ModelQuestions> {

List<NoticeModel> notices=[
];
bool isLoading=true;

@override
  void initState() {
    getNotices();
    super.initState();
  }
getNotices()async{
 await  _fetchData();
}
Future<void> _fetchData(){
     FirebaseFirestore.instance.collection("Schools").
   doc(widget.docId).collection("modelQuestions").snapshots().listen((event) {
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
       url: data["url"]);
            notices.add(notice);
          }
          isLoading=false;
        });
      }
    });
    return null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.of(context).pop(true);
          }),
        title:Hero(tag: "Model Questions", child: Text("Model Questions"))
      ),
      body:isLoading?Center(child:CircularProgressIndicator()):notices.length==0?Center(child:Text("Empty",style:TextStyle(color: Colors.black,fontSize:18))): ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,

        physics: const ClampingScrollPhysics(),
        itemBuilder:  (context, index) {
        if(index!=null && index==0 || index!=null && index==13||index!=null && index==52){
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
        return PdfNotice(index: index,notice: notices[index],);
        }, 
      itemCount: notices.length),
      
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


