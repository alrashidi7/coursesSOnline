import 'dart:async';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_courses/units/DetailsOfCourse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CourseDetails extends StatefulWidget {
  final String courseName;
  final String courseLevel;
  final String teacherName;
  final String teacherPhone;

  CourseDetails(
      this.courseName, this.courseLevel, this.teacherName, this.teacherPhone);

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  var response;
  bool isloading = true;
  bool isSuccess = false;
  String courseName;
  String courseLevel;
  String teacherName;
  String teacherPhone;
  List<DetailsOfCourse> _courses;

  @override
  void initState() {
    // TODO: implement initState
    _courses = new List<DetailsOfCourse>();
    Timer(Duration(seconds: 2), () {
      retriveCourses(teacherName, teacherPhone, courseName, courseLevel);
    });

    super.initState();
  }

  void showSnackBar(String message) {
    _globalKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<List<DetailsOfCourse>> retriveCourses(String teacherName,
      String teacherPhone, String courseName, String courseLevel) async {
    response = await http
        .post("http://192.168.1.9/coursesOnline/courseDetails.php", body: {
      'teacherName': '$teacherName',
      'teacherPhone': '$teacherPhone',
      'courseName': '$courseName',
      'courseLevel': '$courseLevel',
    });

    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = convert.json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _courses.add(DetailsOfCourse.fromJson(map));
            print('Id-------${map['id']}');
          }
        }
        setState(() {
          isloading = false;
          _courses = _courses;
        });
      }

      return _courses;
    } else {
      print('error');
      throw Exception('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final CourseDetails args = ModalRoute.of(context).settings.arguments;
    setState(() {
      courseName = args.courseName;
      courseLevel = args.courseLevel;
      teacherName = args.teacherName;
      teacherPhone = args.teacherPhone;
    });
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _globalKey,
      body: Stack(children: <Widget>[
        SizedBox.expand(
          child: Image.asset(
            'Images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: isloading
              ? SizedBox(
                  width: 100,
                  height: 100,
                  child: Card(
                    elevation: 8,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(15.0),
                  child: ListView(children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12.0),
                      alignment: Alignment.bottomLeft,
                      height: 200,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Mr:$teacherName",
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Theme.of(context).textSelectionColor),
                            ),
                            Text(
                              "0$teacherPhone",
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Theme.of(context).accentColor),
                            )
                          ]),
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _courses.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              print(
                                  "${_courses[index].courseName}, ${_courses[index].courseLevel}, ${_courses[index].teacherName},${_courses[index].teacherPhone}");
                            },
                            child: Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  side: BorderSide(
                                      width: 0.9,
                                      color: Theme.of(context).accentColor),
                                ),
                                color: Theme.of(context).backgroundColor,
                                elevation: 5.0,
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(" Course name: ".tr().toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600)),
                                          Text("${_courses[index].courseName}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(children: <Widget>[
                                        Text(" Course level: ".tr().toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600)),
                                        Text("${_courses[index].courseLevel}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ]),
                                      Text(
                                          " Course description: "
                                              .tr()
                                              .toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          "${_courses[index].courseDescription}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(children: <Widget>[
                                        Text(" Course Date: ".tr().toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "${_courses[index].courseSessionDate}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(children: <Widget>[
                                        Text(
                                            " Course WeekDay: ".tr().toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600)),
                                        Text("${_courses[index].sessionDay}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(children: <Widget>[
                                        Text(" Course users: ".tr().toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600)),
                                        Text("${_courses[index].courseUsers}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                showDialog(context: context,builder: (_) => AlertDialog(
                                                  title: Text('InactiveCourse'.tr().toString()),
                                                  content: Text('disActiveCourse'.tr().toString()),
                                                  actions: <Widget>[
                                                    RaisedButton(onPressed:(){
                                                      Navigator.pop(context);
                                                    } , child: Text("NO")),
                                                    RaisedButton(onPressed: (){
                                                      disActiveClassRoom(_courses[index].id);
                                                      Navigator.pop(context);
                                                    }, child: Text("YES")),
                                                  ],
                                                ),
                                                );

                                              },
                                              child: Image.asset(
                                                'Images/close.png',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )),
                                          GestureDetector(
                                              onTap: () {
                                                showSnackBar("this A new feature will be exist in next Version ");
                                              },
                                              child: Image.asset(
                                                'Images/chat.png',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )),
                                          GestureDetector(
                                              onTap: () {
                                                calenderIconPress();
                                              },
                                              child: Image.asset(
                                                'Images/calendar.png',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )),
                                          GestureDetector(
                                              onTap: () {
                                                var today = new DateTime.now();
                                                String formattedDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(today);
                                                print(formattedDate);
                                                DateTime date = DateTime.now();
                                                String dayOfSeesion =
                                                    DateFormat('EEEE')
                                                        .format(date)
                                                        .toLowerCase();
                                                print(
                                                    "$dayOfSeesion: ${_courses[index].sessionDay}");
                                                if (dayOfSeesion ==
                                                    _courses[index]
                                                        .sessionDay && formattedDate == _courses[index].sessionDayDate) {
                                                  print(courseLevel);
                                                  //TODO create
                                                  changeDateOfCourse(_courses[index].id,_courses[index].sessionDayDate);
                                                } else {
                                                  showSnackBar(
                                                      'you can`t be here now please try again in session Day');
                                                }
                                              },
                                              child: Image.asset(
                                                'Images/enter.png',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ]),
                ),
        ),
      ]),
    );
  }

  calenderIconPress() {}

  Future<void> changeDateOfCourse(String id,String date) async {
    var response = await http.post("http://192.168.1.9/coursesOnline/modifyDateOfCourse.php",body: {
      "id":id,
      "date":date,
    });
    if(response.statusCode == 200){
      showSnackBar("Welcome to class");
    }else{
      throw Exception('error');
    }
  }

  void disActiveClassRoom(String id) async{
    var response = await http.post("http://192.168.1.9/coursesOnline/disactiveClass.php",body: {
      "id":id,
      "active":'Inactive',
    });
    if(response.statusCode == 200){
      showSnackBar("this class isn`t active now to active it again go to menu in your dashboard");
    }else{
      throw Exception('error');
    }
  }
}
