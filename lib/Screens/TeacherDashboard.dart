import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:easy_localization/easy_localization.dart';
import 'package:online_courses/Screens/AddCourse.dart';

import 'package:online_courses/Screens/CourseDetails.dart';
import 'package:online_courses/Screens/Profile.dart';
import 'package:online_courses/Screens/TeacherMoney.dart';

import 'package:online_courses/units/TeacherCourses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDashboard extends StatefulWidget {
  final String showGetLoginName;
  final String showGetLoginPhone;
  final String imageUrl;
  TeacherDashboard(this.showGetLoginName, this.showGetLoginPhone,this.imageUrl);
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {

  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  var response;
  bool isloading = true;
  bool isSuccess = false;
  String teacherName;
  String teacherPhone;
  String imageUrl;
  Uint8List _bytesImage;
  List<TeacherCourses> _courses;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
//  void retriveDataPrefrences() async{
//    SharedPreferences _showGetStartedPagePref = await preferences;
//    setState(() {
//      teacherName = _showGetStartedPagePref.getString('username');
//      teacherPhone = _showGetStartedPagePref.getString('phone');
//      imageUrl=_showGetStartedPagePref.getString('imageUrl');
//      print('imageUrl::: ${imageUrl.length}');
//
//    });}

  @override
  void initState() {
    _courses = new List<TeacherCourses>();
    Timer(Duration(seconds: 1),(){
      retriveCourses(teacherName,teacherPhone);
    });
    print('teacherName:$teacherName $teacherPhone');
    super.initState();
  }
  void showSnackBar(String message){
    _globalKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
  Future<List<TeacherCourses> > retriveCourses(String teacherName,
      String teacherPhone) async{

    response = await http.post("http://192.168.1.9/coursesOnline/teacherCourses.php",body:
    {
      'teacherName':'$teacherName',
      'teacherPhone':'$teacherPhone',
    });
    if(response.statusCode == 200){
      List<dynamic> values=new List<dynamic>();
      values = convert.json.decode(response.body);
      if(values.length > 1){
        for(int i=0;i<values.length;i++){
          if(values[i]!=null){
            Map<String,dynamic> map=values[i];
            _courses.add(TeacherCourses.fromJson(map));
          }
        }
      }
      setState(() {
        isloading = false;
        _courses = _courses;

      });
      return _courses;
    }else{
    throw Exception('error');
    }
    }
  @override
  Widget build(BuildContext context) {
    setState(() {
    final TeacherDashboard argsTeacher = ModalRoute.of(context).settings.arguments;
      if(argsTeacher != null) {
        teacherName = argsTeacher.showGetLoginName;
        teacherPhone = argsTeacher.showGetLoginPhone;
        imageUrl = argsTeacher.imageUrl;
        print(imageUrl);
      }else{
        teacherName = widget.showGetLoginName;
        teacherPhone = widget.showGetLoginPhone;
        imageUrl = widget.imageUrl;
        print(imageUrl);
     }

    });
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text("Mr: $teacherName",style: TextStyle(fontSize: 20.0),),
      accountEmail: Text("0$teacherPhone"),
      currentAccountPicture: CircleAvatar(
        child: _bytesImage == null?
        Image.asset("Images/person.png",width: 50,height: 50,) :
        Image.memory(_bytesImage,width: 50,height: 50,)
      ),
    );
    return Scaffold(
      key: _globalKey,
      backgroundColor:  Theme.of(context).backgroundColor,
      appBar: AppBar(
      title: Text('Teacher Dashboard'.tr().toString()),
      centerTitle: true,
      ),
      drawer:  Drawer(
        child: ListView(
          children: <Widget>[
            drawerHeader,
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Main",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('/teacherDashBoard',arguments: TeacherDashboard(teacherName, teacherPhone,imageUrl));
              },
              leading: Icon(Icons.class_),
              title: Text("ClassRooms".tr().toString()),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('/teacherMoney',arguments: TeacherMoney(teacherName, teacherPhone));
              },
              leading: Image.asset('Images/wallet.png',width: 27,height: 27,),
              title: Text("my Wallet".tr().toString()),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('/addCourse',arguments: AddCourse(teacherName, teacherPhone));
              },
              leading: Icon(Icons.add_to_photos),
              title: Text("Add Course".tr().toString()),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                  "Other".tr().toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: (){},
              leading: Icon(Icons.settings),
              title: Text("Settings".tr().toString()),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('/profile',arguments: Profile(teacherName,teacherPhone));
              },
              leading: Icon(Icons.face),
                title: Text("Profile".tr().toString()),
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text("Logout".tr().toString()),
              onTap: logout,
            ),
            ListTile(
              onTap: (){},
              leading: Icon(Icons.library_books),
              title: Text("About US".tr().toString()),
            ),
            ListTile(
              leading: Icon(Icons.perm_contact_calendar),
              title: Text("Contact US".tr().toString()),
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text("Rate App".tr().toString()),
            ),
          ],
        ),
      ),
      body:
          Center(
            child: isloading ? SizedBox(
              width: 100,
              height: 100,
              child: Card(
                elevation: 8,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ) :ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap:(){
                    String courseName = _courses[index].courseName;
                    String courseLevel =  _courses[index].courseLevel;
                    String teacherName =  _courses[index].teacherName;
                    String teacherPhone =  _courses[index].teacherPhone;
                    print("$courseName, $courseLevel, $teacherName,$teacherPhone");
                      Navigator.of(context).pushNamed('/courseDetails',
                          arguments:
                            CourseDetails(courseName,courseLevel,teacherName,teacherPhone),
                          );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15.0,5.0,15.0,5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          side: BorderSide(width: 0.9, color: Theme.of(context).accentColor),
                        ),
                        color:  Theme.of(context).backgroundColor,
                        elevation: 5.0,
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    Text(" Course name: ".tr().toString(),
                                        textAlign:TextAlign.start,
                                    style: TextStyle(fontSize:18.0,fontWeight: FontWeight.w300)),
                                    Text("${_courses[index].courseName}",

                                        textAlign:TextAlign.start,
                                    style: TextStyle(fontSize:20.0,fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                                  Text(" Course description: ".tr().toString(),
                                      textAlign:TextAlign.start,
                                      style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18.0)),
                                  Text("${_courses[index].CourseDescription}",
                                      textAlign:TextAlign.start,
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                              SizedBox(
                                height: 25,
                              ),


                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: <Widget>[
                                        Text(" Course level: ".tr().toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize:18.0,fontWeight: FontWeight.w300)),
                                        Text("${_courses[index].courseLevel}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize:20.0,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(" Course users: ".tr().toString(),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(fontSize:18.0,fontWeight: FontWeight.w300)),
                                      Text("${_courses[index].CourseUsers}",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(fontSize:20.0,fontWeight: FontWeight.bold)),
                                    ],
                                  ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),

    );
  }
  void logout() async{
      SharedPreferences removeUser = await preferences;
      removeUser.clear();
      Navigator.of(context).pushNamed('/login');
  }

  Widget image(String thumbnail) {
    String placeholder = "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
    if (thumbnail?.isEmpty ?? true)
      thumbnail = placeholder;
    else {
      switch (thumbnail.length % 4) {
        case 1:  break; // this case can't be handled well, because 3 padding chars is illeagal.
        case 2:  thumbnail = thumbnail + "=="; break;
        case 3:  thumbnail = thumbnail + "="; break;
        case 3:  thumbnail = thumbnail + "=="; break;
      }
    }
    final _byteImage = convert.Base64Decoder().convert(thumbnail);
    Widget image = Image.memory(_byteImage,width: 50,height: 50);
    return image;
  }
}
