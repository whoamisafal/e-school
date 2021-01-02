
import 'package:intl/intl.dart';
class ChatModel{
 final String message;
 final int timestamp;
 final String url;
 final String senderId;
 final String reciverId;
 final String type;
 final bool seen;
 final int userBseentimestamp;
 final String docId;



ChatModel({this.message,this.timestamp,this.reciverId,this.senderId,this.type,this.userBseentimestamp,this.seen,this.docId,this.url});

Map<String,dynamic> toMap()=>{
  "message":message,
  "timestamp":timestamp,
  "senderId":senderId,
  "reciverId":reciverId,
  "type":type,
  "seen":false,
  "url":url,
  "userBseentimestamp":null,
  
};



}
String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a ');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp );
    
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    
     
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
