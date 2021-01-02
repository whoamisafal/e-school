import 'package:admob_flutter/admob_flutter.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/Assignment/AssignmentView.dart';
import 'package:flutter/material.dart';

class Assignment extends StatefulWidget {
final  int grade;
final String schoolId;
Assignment({this.grade, this.schoolId});
  @override
  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {

  Widget listItem(int index){
    
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.zero,
        child:InkWell(
          onTap:(){
            Navigator.of(context).push(new MaterialPageRoute(builder:(context) => AssignmentView(grade: items[index],schoolId:widget.schoolId), ));

          },
          child:Container(
            padding:EdgeInsets.fromLTRB(20,25,5,0),
            child: Text(items[index],style: TextStyle(fontSize:16,fontWeight:FontWeight.bold),textAlign: TextAlign.start,)
          ),
        ),
      )
    );
  }
  static const items=["Nursery","LKG","UKG","Class One","Class Two"
  ,"Class Three","Class Four","Class Five",
  "Class Six","Class Seven","Class Eight",
  "Class Nine","Class Ten",
  "Class Eleven","Class Twelve"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Hero(tag: "Assignment", child: Text("Assignment")),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.of(context).pop(true);
          }),

      ),
      body:ListView.builder(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        itemCount:widget.grade==null?0:widget.grade+3,
        itemBuilder: (context, index) {
          if(index!=null && index==2 ||index!=null && index==10){
               return Column(
              children: [
              AdmobBanner(adUnitId: getBannerId(), adSize: AdmobBannerSize.BANNER,  
              listener: (AdmobAdEvent event,Map<String,dynamic> args ) => hadleEvent(event, args, "Banner"),)
             ,listItem(index),

              ],
            );
          }
          return listItem(index);
        },
      ),
    );
  }
}
