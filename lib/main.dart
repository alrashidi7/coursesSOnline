import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:online_courses/Screens/AddCourse.dart';
import 'package:online_courses/Screens/AdminDashboard.dart';
import 'package:online_courses/Screens/AdminEnrollment.dart';
import 'package:online_courses/Screens/CourseDetails.dart';
import 'package:online_courses/Screens/GetStarted.dart';
import 'package:online_courses/Screens/Login.dart';
import 'package:online_courses/Screens/MyCourses.dart';
import 'package:online_courses/Screens/Profile.dart';
import 'package:online_courses/Screens/Register.dart';
import 'package:flutter/material.dart';
import 'package:online_courses/Screens/Settings.dart';
import 'package:online_courses/Screens/StudentDashboard.dart';
import 'package:online_courses/Screens/TeacherDashboard.dart';
import 'package:online_courses/Screens/TeacherMoney.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(EasyLocalization(
    child: MyApp(),
    path: "langs/",
    saveLocale: true,
    supportedLocales: [
      Locale('ar', 'EG'),
      Locale('en', 'EG'),
    ],
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String showGetLoginName="name";
  String showGetLoginImageUrl="image";
  String showGetLoginPhone="phone";
  String showGetMain="type";
  String showGetStarted="true";
  bool isDarkMode = true;
  SharedPreferences _showGetStartedPagePref;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
   ThemeData dartTheme = ThemeData(
    primarySwatch: Colors.grey,
    buttonColor: Colors.grey,
     primaryColor: Color.fromRGBO(156, 216, 226, 1),
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );
   ThemeData lightTheme  =  ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Color.fromRGBO(156, 216, 226, 1),
    buttonColor: Color.fromRGBO(156, 216, 226, 1),
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    textSelectionColor: Colors.white,
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  void pref() async {
    _showGetStartedPagePref = await preferences;
    isDarkMode= _showGetStartedPagePref.getBool("switchState");
    if(isDarkMode == null){
      isDarkMode = false;
    }
    setState(() {
      showGetStarted = _showGetStartedPagePref.getString('showGetStarted')??"false";
      showGetLoginName = _showGetStartedPagePref.getString('username');
      showGetLoginPhone = _showGetStartedPagePref.getString('phone');
      showGetLoginImageUrl= _showGetStartedPagePref.getString('imageUrl');
      showGetMain = _showGetStartedPagePref.getString('type');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    pref();
    print('mode is : $isDarkMode');
    super.initState();
  }
  Widget showGetStartedPage() {
    print('showGetStartedPage: $showGetMain $showGetLoginName $showGetLoginPhone');
    if(showGetStarted == 'true') {
      return GetStarted();
    } else{
      switch(showGetMain){
        case "student":
          print('$showGetLoginName $showGetLoginPhone');
          return StudentDashboard(showGetLoginName,showGetLoginPhone,showGetLoginImageUrl);
        break;
        case "teacher":
          print('$showGetLoginName $showGetLoginPhone');

         return TeacherDashboard(showGetLoginName,showGetLoginPhone,showGetLoginImageUrl);
        break;
        case "type":
          return Login();
          break;
        case "admin":
          return AdminDashboard(showGetLoginName,showGetLoginPhone,showGetLoginImageUrl);
          break;
      }
      return Login();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo'.tr().toString(),
      theme: isDarkMode ? dartTheme : lightTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Container(
        child: showGetStartedPage(),
      ),
      routes: {
        '/login': (context) => new Login(),
        '/getStarted': (context) => new GetStarted(),
        '/register': (context) => new Register(),
        '/teacherDashBoard': (context) => new TeacherDashboard("", "",""),
        '/studentDashBoard': (context) => new StudentDashboard("", "",""),
        '/adminDashBoard': (context) => new AdminDashboard("","",""),
        '/adminEnrollment': (context) => new AdminEnrollment("","","",""),
        '/courseDetails': (context) => new CourseDetails("", "", "", ""),
        '/studentCourses': (context)=> new MyCourses("",""),
        '/settings': (context)=>new Settings(),
        '/myApp': (context)=>new MyApp(),
        '/addCourse': (context)=>new AddCourse("",""),
        '/teacherMoney':(context)=> new TeacherMoney("", ""),
        '/profile':(context)=> new Profile("",""),
      },
    );
  }
}
