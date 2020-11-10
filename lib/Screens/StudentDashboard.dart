import 'dart:async';
import 'dart:typed_data';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:online_courses/Screens/MyCourses.dart';
import 'package:online_courses/Screens/Settings.dart';
import 'package:online_courses/units/DetailsOfCourse.dart';
import 'package:online_courses/units/StudentEnroll.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';

class StudentDashboard extends StatefulWidget {
  final String studentName;
  final String studentPhone;
  final String imageUrl;

  StudentDashboard(this.studentName, this.studentPhone,this.imageUrl);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {


FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  List<String> countList = [
    "اولي اعدادي",
    "تانيه اعدادي",
    "ثالثه اعدادي",
    "اولي ثانوي",
    "تانيه ثانوي",
    "ثالثه ثانوي",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen",
    "Twenty"
  ];
  List<String> selectedCountList = [];
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  var response;
  bool isloading = true;
  bool isSuccess = false;
  bool isFilter = false;
  bool noCourses = false;
  String studentName;
  String studentPhone;
  String studentImage;
  Uint8List _image;
  String teacherName;
  String teacherPhone;
  String courseName;
  String courseLevel;
  String filterLevel = "";
  List<DetailsOfCourse> _courses;
  TextEditingController phoneController;
  TextEditingController keyController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  void showSnackBar(String message) {
    _globalKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    // TODO: implement
    showNotification();
    _image = convert.Base64Decoder().convert(studentImage);
    var androidInitialize = new AndroidInitializationSettings('chat');
    var iosInitialize = new IOSInitializationSettings();
    var initializationSetting = new InitializationSettings(androidInitialize, iosInitialize);
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSetting,onSelectNotification: notificationSelecting);
    phoneController = new TextEditingController();
    keyController = new TextEditingController();
    _courses = new List<DetailsOfCourse>();
    Timer(Duration(seconds: 2), () {
      getAllCourses();
    });
    super.initState();
  }

  Future showNotification() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm");
    SharedPreferences preferences = await prefs;
    String reminderDate = preferences.getString('reminderDate');
    if(reminderDate != null) {
      DateTime schaduleReminder = dateFormat.parse(
          '$reminderDate');
      final date1 = schaduleReminder.day;
      final date2 = DateTime
          .now()
          .day;
      final difference = date2 - date1;
      if(difference == 0){
        preferences.remove('reminderDate');
       print('reminderDate ${preferences.getString('reminderDate')}');
      }
      DateTime schaduleReminderInDay = DateTime.now().add(
          Duration(minutes: difference));
      print('difference: $difference $date1 $date2');
      print('schaduleReminder: $reminderDate');

      var androidDetails = AndroidNotificationDetails(
          'channelId', 'channelName', 'channelDescription',
          importance: Importance.Max);
      var iosDetails = IOSNotificationDetails();
      var notificationDetails = NotificationDetails(androidDetails, iosDetails);
      print('schaduleReminder: $schaduleReminder');

      await _flutterLocalNotificationsPlugin.schedule(
          0, 'Course Reminder', 'you have session today..\n please go check your dashBoard', schaduleReminderInDay, notificationDetails);

    }else{
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    final StudentDashboard argsStudent =
        ModalRoute.of(context).settings.arguments;
    setState(() {
      if (argsStudent != null) {
        studentName = argsStudent.studentName;
        studentPhone = argsStudent.studentPhone;
      } else {
        studentName = widget.studentName;
        studentPhone = widget.studentPhone;
      }
      print("hello $studentName $studentPhone");
    });
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(
        "$studentName",
        style: TextStyle(fontSize: 20.0),
      ),
      accountEmail: Text("0$studentPhone"),
      currentAccountPicture: CircleAvatar(
        child:studentImage == "/null"? Image.asset(
          "Images/person.png",
          width: 50,
          height: 50,
        ):
            Image.memory(_image,width: 50,height: 50,),
      ),
    );
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Student Dashboard'.tr().toString()),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            drawerHeader,
            Container(
              margin: EdgeInsets.all(10),
              child: Text("Main",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/studentDashBoard',arguments: StudentDashboard(studentName,studentPhone,studentImage));
              },
              leading: Icon(Icons.class_),
              title: Text("ClassRooms".tr().toString()),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('/studentCourses',arguments: MyCourses(studentName,studentPhone));
              },
              leading: Icon(Icons.import_contacts),
              title: Text("My Courses".tr().toString()),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text("Other",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/settings',arguments: Settings());
              },
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              leading: Icon(Icons.face),
              title: Text("Profile"),
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text("Logout"),
              onTap: logout,
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.library_books),
              title: Text("About US"),
            ),
            ListTile(
              leading: Icon(Icons.perm_contact_calendar),
              title: Text("Contact US"),
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text("Rate App"),
            ),
          ],
        ),
      ),
      body: isFilter
          ? SafeArea(
              child: FilterListWidget(
                allTextList: countList,
                height: MediaQuery.of(context).size.height,
                hideheaderText: true,
                selectedTextList: selectedCountList,
                onApplyButtonClick: (list) {
                  if (list.length == 1) {
                    setState(() {
                      filterLevel = list[0].toString();
                    });
                    getAllCoursesFilter(filterLevel);
                    setState(() {
                      selectedCountList = List.from(list);
                      print(selectedCountList[0]);
                      isFilter = false;
                    });
                  } else {
                    showSnackBar("please select one only");
                  }
                },
              ),
            )
          : ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    child: isloading
                        ? Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Card(
                                elevation: 8,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : RaisedButton(
                            onPressed: () {
                              setState(() {
                                isFilter = true;
                              });
                            },
                            elevation: 10,
                            color: Theme.of(context).buttonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text(
                              "Filter by level".tr().toString(),
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor),
                            ),
                          )),
                noCourses
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 150,
                          ),
                          SizedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  'Images/emptybox.png',
                                  width: 100,
                                  height: 100,
                                ),
                                Text(
                                  "sorry we don`t have courses to your level yet..",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context).accentColor),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _courses.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if(_courses[index].active =="active"){

                              }else{
                                showSnackBar("this course not active please contact with courseTeacher");
                              }
                              print(
                                  "${_courses[index].courseName}, ${_courses[index].courseLevel}, ${_courses[index].teacherName},${_courses[index].teacherPhone}");
                            },
                            child: Container(
                              color: Theme.of(context).backgroundColor,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  side: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).accentColor),
                                ),
                                color: Theme.of(context).backgroundColor,
                                elevation: 5.0,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 0.0, 15.0, 15.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: SmoothStarRating(
                                          starCount: 5,
                                          spacing: 2.0,
                                          allowHalfRating: true,
                                          rating: double.parse(_courses[index]
                                              .courseRate
                                              .toString()),
                                          onRated: (value) {
                                            showSnackBar("thanks for rating");
                                            print("rating value -> $value");
                                            // print("rating value dd -> ${value.truncate()}");
                                          },
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                                " Course name: ".tr().toString(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w300)),
                                            Text(
                                                "${_courses[index].courseName}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                                " Course level: ".tr().toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w300)),
                                            Text(
                                                "${_courses[index].courseLevel}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          " Course description: ".tr().toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 18,
                                              fontWeight: FontWeight.w300)),
                                      Text(
                                          "${_courses[index].courseDescription}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: <Widget>[
                                            Text('MR: '.tr().toString(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w300)),
                                            Text('${_courses[index].teacherName}',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                                'teacher phone: '.tr().toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300)),
                                            Text(
                                                '0${_courses[index].teacherPhone}',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              " Course Date: ".tr().toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w300)),
                                          Text(
                                              "${_courses[index].sessionDay} at ${_courses[index].courseSessionDate}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              " Course users: ".tr().toString(),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                  fontWeight: FontWeight.w300)),
                                          Text(
                                              "${_courses[index].courseUsers}",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                if(_courses[index].active =="active"){
                                                  showSnackBar("this A new feature will be exist in next Version ");

                                                }else{
                                                  showSnackBar("this course not active please contact with courseTeacher");
                                                }

                                              },
                                              child: Image.asset(
                                                'Images/chat.png',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )),
                                          GestureDetector(
                                              onTap: () async{
                                                if(_courses[index].active =="active"){
                                                  print('calender:');
                                                  //TODO
                                                  SharedPreferences preferences = await prefs;
                                                  preferences.setString('reminderDate',
                                                      '${_courses[index].sessionDayDate} ${_courses[index].courseSessionDate}');
                                                  print('${preferences.getString('reminderDate')}');
                                                  showSnackBar("add reminder Successfully");

                                                }else{
                                                  showSnackBar("this course not active please contact with courseTeacher");
                                                }
                                              },
                                              child: Image.asset(
                                                'Images/calendar.png',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )),
                                          GestureDetector(
                                              onTap: () {
                                                if(_courses[index].active =="active"){
                                                  setState(() {
                                                    teacherName = _courses[index]
                                                        .teacherName;
                                                    teacherPhone = _courses[index]
                                                        .teacherPhone;
                                                    courseName = _courses[index]
                                                        .courseName;
                                                    courseLevel = _courses[index]
                                                        .courseLevel;
                                                  });
                                                  var today = new DateTime.now();
                                                  String formattedDate =
                                                  DateFormat('d')
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
                                                          .sessionDay) {
                                                    print(courseLevel);
                                                    sessionCheck();
                                                  } else {
                                                    showSnackBar(
                                                        'you can`t be here now please try again in session Day');
                                                  }
                                                }else{
                                                  showSnackBar("this course not active please contact with courseTeacher");
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
              ],
            ),
    );
  }
Future notificationSelecting(String payload) async{

}

  void logout() async {
    SharedPreferences removeUser = await preferences;
    removeUser.clear();
    Navigator.of(context).pushNamed('/login');
  }

  Future<List<DetailsOfCourse>> getAllCourses() async {
    response =
        await http.post("http://192.168.1.9/coursesOnline/allCourses.php");
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = convert.json.decode(response.body);
      if (values.length > 1) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _courses.add(DetailsOfCourse.fromJson(map));
            print('Id-------${map['id']}');
          }
        }
      }
      setState(() {
        isloading = false;
        _courses = _courses;
      });
      return _courses;
    } else {
      throw Exception('error');
    }
  }

  Future<List<DetailsOfCourse>> getAllCoursesFilter(String level) async {
    setState(() {
      _courses.clear();
      isloading = true;
    });
    print(level);
    response = await http
        .post("http://192.168.1.9/coursesOnline/cousesFilter.php", body: {
      'level': '$level',
    });
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = convert.json.decode(response.body);
      if (values.length > 1) {
        setState(() {
          noCourses = false;
        });
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _courses.add(DetailsOfCourse.fromJson(map));
            print('Id-------${map['id']}');
          }
        }
      } else {
        setState(() {
          noCourses = true;
        });
      }
      setState(() {
        isloading = false;
        _courses = _courses;
      });
      return _courses;
    } else {
      throw Exception('error');
    }
  }

  void enrollSession() async {
    response = await http
        .post("http://192.168.1.9/coursesOnline/studentEnroll.php", body: {
      "studentPhone": '$studentPhone',
      "teacherName": '$teacherName',
      "teacherPhone": '$teacherPhone',
      "courseName": '$courseName',
      "courseLevel": '$courseLevel',
    });
    if (StudentEnroll.fromJson(convert.json.decode(response.body)) != null) {
      setState(() {
        isloading = false;
        String success =
            StudentEnroll.fromJson(convert.json.decode(response.body)).success;
        print(success);
        if (success == "success") {
          //TODO create shareprefrences and save the rondomKey and phoneNumber and date of login and tomorrow date on it
          print(StudentEnroll.fromJson(convert.json.decode(response.body)).key);
          String key =
              StudentEnroll.fromJson(convert.json.decode(response.body)).key;
          createSession(key);
          setState(() {
            isSuccess = true;
            studentName =
                StudentEnroll.fromJson(convert.json.decode(response.body))
                    .studentName;
            //TODO create class room
            showSnackBar(studentName);
          });
        } else {
          isSuccess = false;
          showSnackBar("$success");
        }
      });
    }
  }
  void createSession(String key) async{
              var today = new DateTime.now();
          var tomorrow = today.add(new Duration(days: 1));
          String formattDayOpenSession = DateFormat('d').format(today);
          String formattDayEndSession = DateFormat('d').format(tomorrow);
          print('date: $formattDayOpenSession to: $formattDayEndSession');
    SharedPreferences preferences = await prefs;
    preferences.setString('sessionKey', key);
    preferences.setString('dayOpenSession', formattDayOpenSession.toString());
    preferences.setString('dayEndSession', formattDayEndSession.toString());
    preferences.setString('courseName', courseName);
    preferences.setString('courseLevel', courseLevel);
    preferences.setString('teacherName', teacherName);
    preferences.setString('studentName', studentName);

    print('sessionCreated: ${preferences.getString('dayOpenSession')} + ${preferences.getString('dayEndSession')}');
  }
  void sessionCheck() async{
    SharedPreferences preferences = await prefs;
    preferences.getString('sessionKey');
    preferences.getString('dayOpenSession');
    preferences.getString('dayEndSession');

    if(
    preferences.getString('courseName') ==courseName &&
    preferences.getString('courseLevel') ==courseLevel &&
    preferences.getString('teacherName') == teacherName &&
    preferences.getString('studentName') == studentName) {
      if (preferences.getString('sessionKey') != null) {
        print('sessionKey ${preferences.getString('sessionKey')}');
        var today = new DateTime.now();
        int formattDayToday = int.parse(
            DateFormat('d').format(today).toString());
        int formattDayEndSession = int.parse(
            preferences.getString('dayEndSession'));
        print(
            'formattDayToday: $formattDayToday formattDayEndSession: $formattDayEndSession');
        switch (formattDayEndSession) {
          case 31:
            if (formattDayToday >= 1) {
              preferences.remove('sessionKey');
              preferences.remove('dayOpenSession');
              preferences.remove('dayEndSession');
              showSnackBar(
                  'sorry you can`t be here now please wait the session next week');
            }
            break;
          case 30:
            if (formattDayToday == 1) {
              preferences.remove('sessionKey');
              preferences.remove('dayOpenSession');
              preferences.remove('dayEndSession');
              showSnackBar(
                  'sorry you can`t be here now please wait the session next week');
            }
            break;
        }
        if (formattDayToday > formattDayEndSession) {
          preferences.remove('sessionKey');
          preferences.remove('dayOpenSession');
          preferences.remove('dayEndSession');
          showSnackBar(
              'sorry you can`t be here now please wait the session next week');
        } else {
          //TODO go to class
          showSnackBar('welcome in class room');
        }
      } else {
        enrollSession();
      }
    }else{
      enrollSession();
    }

  }
}
