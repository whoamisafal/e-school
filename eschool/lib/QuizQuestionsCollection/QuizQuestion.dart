import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/PublishQuiz/AddQuiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';


class QuizQuestionCollection extends StatefulWidget {
  @override
  _QuizQuestionCollectionState createState() => _QuizQuestionCollectionState();
}

class _QuizQuestionCollectionState extends State<QuizQuestionCollection> {
 List<QuizData> questions=[];
 bool isLoading=true;
 
 @override
  void initState() {
    FirebaseFirestore.instance.collection("question").get().then((value) {
      questions.clear();
      for (var item in value.docs) {
        Map<String,dynamic> data=item.data();
        var d=new QuizData(userId: data["userId"], timestamp: data["timestamp"], question: data["question"],
         options: data["options"], type: data["type"], answer: data["answer"], upvote: data["upvote"]);
         if(mounted){
           setState(() {
             questions.add(d);
             isLoading=false;
           });
         }
        
      }


    });
   
   
   
    super.initState();
  }
 
 
 
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.of(context).pop(true);
          }),
          title: Text("Quiz questions"),),
          body: isLoading?Center(child: CircularProgressIndicator(),)
          :questions.length==0?Center(child: Text("Empty"),):
          ListView.builder(
            shrinkWrap: true,
            itemCount: questions.length,
            itemBuilder: (context, index) {
           if(index!=null && index%10==0){
              return Column(
                children: [
                 Container(
              height: 90,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
           
                adUnitID: getNativeId(),
                numberAds: 3,
                
                type: NativeAdmobType.banner,
              ),
            ),
                    Questionview(data: questions[index],index: index,)
                ],
              );
           }else if(index!=null && index%13==0){
        return Column(
                children: [
                 Container(
              height: 90,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
           
                adUnitID: getBannerId(),
                numberAds: 3,
                
                type: NativeAdmobType.banner,
              ),
            ),
                    Questionview(data: questions[index],index: index,)
                ],
              );
            
           }else{
               return Questionview(data: questions[index],index: index,);
           }
          },),
      ),


      
    );
  }
}

class Questionview extends StatelessWidget {
final  QuizData data;
final int index;
  Questionview({Key key,@required this.data,this.index}):super(key:key);
  @override
  Widget build(BuildContext context) {
    var questionstyle=TextStyle(fontSize: 18,fontWeight: FontWeight.w500);
    var optionStyle=TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black);
    
     var answerStyle=TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.green[900]);
    
    return Container(
   
   
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(15),
      child:Column(
  
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        SelectableText("$index. ${data.question}",style:questionstyle),
        ListView.builder(
            physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.options.length,
          itemBuilder: (context, index) {
          return SelectableText("${index+1}. ${data.options[index]}",style: optionStyle,);
        },),
      Container(child: Text("Ans",style: TextStyle(color:Colors.orange[900],fontWeight:FontWeight.bold),),),
        SizedBox(
       width: 250,
          child:  ListView.builder(
            physics: ClampingScrollPhysics(),
          shrinkWrap: true,
       
          itemCount: data.answer.length,
          itemBuilder: (context, index) {
          return SelectableText(" ${data.answer[index]}",style: answerStyle,);
        },),
     
     )
     
     
      ],),
    );
  }
}