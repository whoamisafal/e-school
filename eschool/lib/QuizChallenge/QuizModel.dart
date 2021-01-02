class QuizChallangeModel{
  String userAId;
  String userBId;
  int userATimestamp;
  int userBTimestamp;
  List<dynamic> userAAns;
  List<dynamic> userBAns;
  List<dynamic> documentId;
  bool userAdel;
  bool userBdel;
  bool accept;
  bool declined;
  String docId;

QuizChallangeModel({this.userAId,
this.userBId,
this.userATimestamp,
this.userBTimestamp,
this.userAAns,
this.userBAns,
this.documentId,
this.userAdel
,this.userBdel,
this.accept,
this.declined,
this.docId
});

Map<String,dynamic> toMap()=>{




    "userAId":userAId,
   "userBId":userBId,
    "userATimestamp":userATimestamp,
   "userBTimestamp":userBTimestamp,
   "userAAns":userAAns,
   "userBAns":userBAns,
 "documentId":documentId,
  "userAdel":userAdel,
   'userBdel':userBdel,
   'accept':accept,
    'declined':declined,
};



}