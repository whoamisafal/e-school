

import 'package:admob_flutter/admob_flutter.dart';
import 'package:e_school/AdmobId.dart';
import 'package:e_school/Home/MainHome.dart';
import 'package:e_school/login/RegisterHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    Admob.initialize(getAppId());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
    
        backgroundColor: Colors.white12
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin{
  FirebaseAuth auth=FirebaseAuth.instance;
  AnimationController controller;
  double pos=0;
  double nextPos=0;
@override
  void initState() {
   Future.delayed(Duration(seconds: 1),(){
        controller=new AnimationController(
        vsync: this,
        duration: const Duration(seconds:3 )
      )..addListener(() {
        
        
            setState(() {
            if(pos<MediaQuery.of(context).size.width*0.5)
                pos+=controller.value.toDouble()*100;
                else
          if(nextPos<MediaQuery.of(context).size.width*0.5)
                nextPos+=controller.value.toDouble()*30;
          
            });
         
      });
       controller.forward();
   });
     Future.delayed(const Duration(seconds: 3),(){
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) =>auth.currentUser!=null? Home():RegisterHelper(),));


   });
    super.initState();
  }

@override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
        child: Scaffold(
          body: Container(
            child: Stack(
              children: [
                if(pos>0)
                  Positioned(
                    top: pos,
                    child: Image.asset("assets/e.png"),),
                    if(nextPos>0)
                  Positioned(
                    top: pos,
                    left: 20,
                    child: Image.asset("assets/school.png"),)

            ],),
          ),
        ),
        

 
      
    );
  }
}