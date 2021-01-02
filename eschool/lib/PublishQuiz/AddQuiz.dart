
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          title: Text("Add Quiz"),
        ),
        body: PublishQuiz(),
      ),
    );
  }
}

class PublishQuiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<PublishQuiz> {
  List<Options> options = [];
  
  TextEditingController question = new TextEditingController();
  bool ans = true;
  String result = "Answer not matched";
  List<String> quiz=["Single ans ","Multiple ans"];
  String selectedType;
  @override
  void dispose() {
    
    question.dispose();
    options.clear();
    super.dispose();
  }

  @override
  void initState() {
    selectedType=quiz[0];
    super.initState();
  }

  Widget optionWidget(int opt) {
    return Container(
      child: Card(
          child: Stack(
        children: [
          TextField(
            controller: options[opt - 1].controller,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: "Options $opt"),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.8,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  options.removeAt(opt - 1);
                });
              },
            ),
          )
        ],
      )),
    );
  }

  void submitQustion(QuizData data) {
    FirebaseFirestore.instance.collection("questions").doc().set(data.toMap());

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          options.clear();
          question.clear();
         
        });
      }
    });
  }
var style=TextStyle(color: Colors.blue[900],fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Container(

              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,

                children: [
                 Ink(
                   color: selectedType==quiz[0]?Colors.red:Colors.transparent,
                   child:  ListTile(
                    onTap: (){
                      if(mounted){
                        setState(() {
                          selectedType=quiz[0];
                        });
                      }
                    },
                    title: Text(quiz[0],style: style,),
                  ),
                 ),
                 Ink(
                    color: selectedType==quiz[1]?Colors.red:Colors.transparent,
                   child: ListTile(
                     onTap: (){ if(mounted){
                        setState(() {
                           selectedType=quiz[1];

                        });
                      }},
                       title: Text(quiz[1],style: style,),
                  ),
                  )

                ],
              )
            ),

      SizedBox(
              height: 45,
            ),


            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Card(
                elevation: 5,
                child: TextField(
                  controller: question,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Write your question here",
                      border: InputBorder.none),
                ),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return optionWidget(index + 1);
              },
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      int len = options.length;

                      options.insert(
                          len,
                          new Options(
                              index: options.length,
                              opt: null,
                              controller: TextEditingController()));
                    });
                  },
                ),
                Text("Add options"),
              ],
            ),
            // Answer field
           
            SizedBox(
              height: 15,
            ),

            Padding(
                padding: EdgeInsets.fromLTRB(75, 0, 75, 0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  color: Colors.blue[500],
                  onPressed: () async {
                    if (question.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Question field cannot be null");
                      return;
                    }
                   if(options.length==0){
                      Fluttertoast.showToast(
                          msg: "Options is cannot be null");
                      return;
                   }
                   
                   if(quiz[0]==selectedType){

                  showDialog(context: context
                  ,builder: (context) => TestBox(
                    onPublishQuiz: (val) {
                        if(val){
                         if(mounted){
                           setState(() {
                              question.clear();
                          options.clear();
                           });
                         }
                        }
                      
                    },
                    onpublish: () {
                      
                    },
                    options: options, question: 
                    question.text,
                    
                  ),
                  );
                   }else if(quiz[1]==selectedType){
                     
                  showDialog(context: context
                  ,builder: (context) => MuntipleOptionApp(options: options, question: question.text,
                  onpublish:() {
                    
                  } ,
                  onPublishQuiz: (val) {
                      if(val){
                         if(mounted){
                           setState(() {
                              question.clear();
                          options.clear();
                           });
                         }
                        }
                  }
                  
                  ,),
                  );
                   }
               
                   

                   
                  
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(color: Colors.white,fontSize: 16),
                  ),
                )),

            SizedBox(
              height: 45,
            ),
          
          ],
        ),
      ),
    );
  }
}

class Options {
  final int index;
  final String opt;
  final TextEditingController controller;
  Options({this.index, this.opt, this.controller});
}

class TestBox extends StatefulWidget {
  final List<Options> options;
   final VoidCallback onpublish;

  final Function(bool) onPublishQuiz;
  final String question;
  TestBox(
      { @required this.options, @required this.question,this.onpublish,@required this.onPublishQuiz});
  @override
  _TestBoxState createState() => _TestBoxState();
}

class _TestBoxState extends State<TestBox> {
  List<String> selectedValue = [""];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.question}\n\nSelect answer and submit'),
      content: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      
                     if(mounted){
                        setState(() {
                          selectedValue.clear();
                        selectedValue.add(widget.options[index].controller.text);
                      });
                     }
                    },
                    title: Text(widget.options[index].controller.text),
                    leading: Radio(
                      value: selectedValue[0],
                      groupValue:
                          widget.options[index].controller.text.toString(),
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                RaisedButton(
                  color: Colors.blue[400],
                  elevation: 5,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                RaisedButton(
                  color: Colors.blue[400],
                  elevation: 5,
                  onPressed: () {
                   if(selectedValue.length>0){
                      if(selectedValue[0].isEmpty){
                      Fluttertoast.showToast(msg: "Please select an answer",backgroundColor: Colors.red);
                      return;
                    }
                   }
                    List<String> options=[];
                    options.clear();
                    for (var item in widget.options) {
                      if(mounted){
                        setState(() {
                          options.add(item.controller.text);
                        });
                      }
                    }
                  QuizData data=new QuizData(
                    answer: selectedValue,
                    options: options,
                    type: "options",
                    question: widget.question,
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                    upvote: 0,
                    userId: FirebaseAuth.instance.currentUser.uid
                  );
                  FirebaseFirestore.instance.collection("question").doc().set(data.toMap()).then((value){
                    widget.onPublishQuiz(true);
                    Navigator.of(context).pop(true);
                  });
                  
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      elevation: 25,
    );
 
 
  }
}



class MuntipleOptionApp extends StatefulWidget {
    final List<Options> options;
 final VoidCallback onpublish;

  final Function(bool) onPublishQuiz;
  final String question;
  MuntipleOptionApp(
      { @required this.options, @required this.question, this.onpublish,@required this.onPublishQuiz});
  @override
  _MuntipleOptionAppState createState() => _MuntipleOptionAppState();
}

class _MuntipleOptionAppState extends State<MuntipleOptionApp> {
   List<String> correctAns=[];
   List<bool> ans=[];
  @override
  void initState() {
    ans.clear();
    for (var item in widget.options) {
      ans.add(false);
      print(item);      
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.question}\nChoose ans and submit'),
      content: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  return  CheckboxListTile(
                    value: ans[index],
                      title: Text("${widget.options[index].controller.text}"),
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                        ans[index]=value;
                        });
                      },
                   
                  );
                },
              ),
            ),
            Row(
              children: [
                RaisedButton(
                  color: Colors.blue[400],
                  elevation: 5,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                RaisedButton(
                  color: Colors.blue[400],
                  elevation: 5,
                  onPressed: () {
                    if(ans.length==0){
                      Fluttertoast.showToast(msg: "Please select an answer",backgroundColor: Colors.red);
                      return;
                    }

                     for(int i=0;i<ans.length;i++){
                        if(ans[i]==true){
                             setState(() {
                                correctAns.add(widget.options[i].controller.text);
                             });

                        }
                      }
                       List<String> options=[];
                    options.clear();
                    for (var item in widget.options) {
                      if(mounted){
                        setState(() {
                          options.add(item.controller.text);
                        });
                      }
                    }
                          QuizData data=new QuizData(
                    answer: correctAns,
                    options: options,
                    type: "checkbox",
                    question: widget.question,
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                    upvote: 0,
                    userId: FirebaseAuth.instance.currentUser.uid
                  );
                  FirebaseFirestore.instance.collection("question").doc().set(data.toMap()).then((value){
                    widget.onPublishQuiz(true);
                    Navigator.of(context).pop(true);
                  });
                    
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      elevation: 25,
    );
 
 
  }
}


class QuizData {
  final String userId;
  final int timestamp;
  final String question;
  final List<dynamic> options;
  final String type;
  final List<dynamic> answer;
  final int upvote;
  final String docId;
  final List<dynamic> votes;



  QuizData(
      {@required this.userId,
      @required this.timestamp,
      @required this.question,
      @required this.options,
      @required this.type,
      @required this.answer,
      @required this.upvote,
      this.votes,
      this.docId
     });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "timestamp": timestamp,
      "question": question,
      "options": options,
      "type": type,
      "answer": answer,
      "upVote": 0,
      
    };
  }
}
