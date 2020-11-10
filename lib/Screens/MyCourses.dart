import 'dart:async';


import 'package:flutter/material.dart';
import 'package:online_courses/units/StudentMyCourses.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyCourses extends StatefulWidget {
  final String studentName;
  final String studentPhone;

  MyCourses(this.studentName, this.studentPhone);

  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  String studentName;
  String studentPhone;
  bool isloading = true;
  List<StudentMyCourses> _myCourses;
  @override
  void initState() {
    // TODO: implement initState
    _myCourses = new List<StudentMyCourses>();
    Timer(Duration(seconds: 1),()
        {
        retriveCourses(studentName,studentPhone);
        });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    MyCourses arguments = ModalRoute
        .of(context)
        .settings
        .arguments;
    setState(() {
      studentName = arguments.studentName;
      studentPhone = arguments.studentPhone;

    });
    return Scaffold(
      backgroundColor:  Theme.of(context).backgroundColor,
      key: _globalKey,
      appBar: AppBar(title: Text("My Courses".tr().toString()), centerTitle: true,),
      body:Center(
        child: isloading ? SizedBox(
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
        ) :ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: _myCourses.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
//                  print(
//                      "${_courses[index].courseName}, ${_courses[index].courseLevel}, ${_courses[index].teacherName},${_courses[index].teacherPhone}");
                },
                child: Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20.0)),
                      side: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).accentColor),
                    ),
                    color:  Theme.of(context).backgroundColor,
                    elevation: 5.0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          15.0, 0.0, 15.0, 15.5),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  " Course name: ".tr().toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  "${_myCourses[index].courseName}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  " Course level: ".tr().toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  "${_myCourses[index].courseLevel}",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: <Widget>[
                              Text('MR: '.tr().toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500)),
                              Text('${_myCourses[index].teacherName}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  'teacher phone: '.tr().toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                  '0${_myCourses[index].teacherPhone}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  "Your Money: ".tr().toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300)),
                              Text(
                                  "${_myCourses[index].money}",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300)),
                              Text(
                                  ".EPG".tr().toString(),
                                  textAlign: TextAlign.end,
                                      style: TextStyle(
                                      fontWeight: FontWeight.w300)
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
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

  Future<List<StudentMyCourses>> retriveCourses(String studentName,String studentPhone ) async{
    print('retrive:$studentName $studentPhone');
    var response = await http.post(
        'http://192.168.1.9/coursesOnline/studentCourses.php',
        body: { 'studentPhone': studentPhone,
                'studentName': studentName,
        });
    if(response.statusCode == 200){
      List<dynamic> values = new List<dynamic>();
      values = convert.json.decode(response.body);
      if(values.length > 1){
        setState(() {
          isloading = false;
        });
        for(int i=0;i<values.length;i++){
          if(values[i]!=null){
            Map<String,dynamic> map=values[i];
            _myCourses.add(StudentMyCourses.fromJson(map));
          }
        }
      }
    }
    print('_myCourses $_myCourses');
    return _myCourses;
  }
}
