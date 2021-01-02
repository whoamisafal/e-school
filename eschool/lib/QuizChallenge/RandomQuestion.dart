import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'dart:math';

class QuestionChoose {
  List<DocumentSnapshot> snap;

  QuestionChoose({@required this.snap});

  List<DocumentSnapshot> getQuestions() {
    int len = snap.length;
    Random random = new Random();
    List<DocumentSnapshot> data = [];
    int randValue = random.nextInt(len - 5);

    for (int i = randValue; i < randValue + 5; i++) {
      data.add(snap[i]);
    }
    return data;
  }
}
