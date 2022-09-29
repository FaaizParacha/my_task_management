import 'package:flutter/material.dart';
import 'package:my_task_management/constants/constant.dart';
import 'package:my_task_management/view/auth/log_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task Management',
      theme: ThemeData(
        primaryColor: appClr,
        //primarySwatch: appClr,
        backgroundColor: whiteTxtClr
      ),
      home: logIn()
    );
  }
}
