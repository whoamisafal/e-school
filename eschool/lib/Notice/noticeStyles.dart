import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 const subjectStyle=TextStyle(
   color: Colors.black,
   fontSize: 16,
   fontWeight: FontWeight.bold
   
 );
 String formattedDate(int timestamp) {
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    String dateFormate = DateFormat('d MMM yyyy').format(date);
    return dateFormate;
  }