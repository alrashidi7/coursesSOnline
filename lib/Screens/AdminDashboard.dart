import 'dart:async';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:online_courses/Screens/AdminEnrollment.dart';
import 'package:online_courses/units/DetailsOfCourse.dart';
import 'package:online_courses/units/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class AdminDashboard extends StatefulWidget {
  final String adminName;
  final String adminPhone;
  final String imageUrl;

  AdminDashboard(this.adminName, this.adminPhone,this.imageUrl);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
  String adminName="";
  String adminPhone="";
  String adminImage="";
  Uint8List _imageBytes ;
  String teacherPhone="";
  String teacherName="";
  String courseName="";
  String courseLevel="";
  String filterLevel = "";
  List<DetailsOfCourse> _courses;
  TextEditingController phoneController;
  TextEditingController passwordController;

  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  void showSnackBar(String message){
    _globalKey.currentState.showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 1),));
  }

  @override
  void initState() {
    // TODO: implement initState
    phoneController = new TextEditingController();
    passwordController = new TextEditingController();
    _imageBytes = convert.Base64Decoder().convert(adminImage);
    _courses = new List<DetailsOfCourse>();
    Timer(Duration(seconds: 2), () {
      getAllCourses();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdminDashboard argsAdmin =
        ModalRoute.of(context).settings.arguments;
    setState(() {
      if (argsAdmin != null) {
        adminName = argsAdmin.adminName;
        adminPhone = argsAdmin.adminPhone;
        adminImage = argsAdmin.imageUrl;
      } else {
        adminName = widget.adminName;
        adminPhone = widget.adminPhone;
      }
      print("hello $adminName $adminPhone");
    });
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(
        "$adminName",
        style: TextStyle(fontSize: 20.0),
      ),
      accountEmail: Text("0$adminPhone"),
      currentAccountPicture: CircleAvatar(
        child:adminImage == "/null" ? Image.asset(
          "Images/person.png",
          width: 50,
          height: 50,
        ):
            Image.memory(_imageBytes,width: 50,height: 50,),
      ),
    );
    return Scaffold(
     backgroundColor:  Theme.of(context).backgroundColor,
      key: _globalKey,
      appBar: AppBar(
        title: Text('Admin Dashboard'.tr().toString()),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            drawerHeader,
            Container(
              margin: EdgeInsets.all(10),
              child: Text("Main".tr().toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                getAllCourses();
              },
              leading: Icon(Icons.class_),
              title: Text("All courses".tr().toString()),
            ),
            ListTile(
              leading: Icon(Icons.import_contacts),
              title: Text("Students".tr().toString()),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text("Other".tr().toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.settings),
              title: Text("Settings".tr().toString()),
            ),
            ListTile(
              leading: Icon(Icons.face),
              title: Text("Profile".tr().toString()),
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text("Logout".tr().toString()),
              onTap: logout,
            ),
            ListTile(
              onTap: () {},
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
      body:isFilter?
      SafeArea(
        child: FilterListWidget(
          allTextList: countList,
          height: MediaQuery.of(context).size.height,
          hideheaderText: true,
          selectedTextList: selectedCountList, onApplyButtonClick: (list) {
          if (list.length == 1){
            setState(() {
              filterLevel = list[0].toString();
            });
            getAllCoursesFilter(filterLevel);
            setState(() {
              selectedCountList = List.from(list);
              print(selectedCountList[0]);
              isFilter = false;
            });
          }else{ showSnackBar("please select one only"); }
        },
        ),
      ):
      ListView(
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
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ):
              RaisedButton(
                onPressed: (){
                  setState(() {
                    isFilter = true;
                  });
                },
                elevation: 10,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child:Text("Filter by level".tr().toString(),
                  style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold,color: Colors.white),) , )

          ),
          noCourses?
          Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset('Images/emptybox.png',width: 100,height: 100,),
                    Text("sorry we don`t have courses to your level yet..",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.normal,color: Colors.black),)
                  ],
                ),
              ),
            ],
          )
              :ListView.builder(
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
                            width: 1.0,
                            color: Theme.of(context).accentColor),
                      ),
                      color: Theme.of(context).backgroundColor,
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15.0,0.0,15.0,15.5),
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
                                rating: double.parse(_courses[index].courseRate.toString()),
                                onRated:  (value) {
                                  showSnackBar("thanks for rating");
                                  print("rating value -> $value");
                                  // print("rating value dd -> ${value.truncate()}");
                                },
                              ),
                            ),
                            Text(
                                " Course name: ${_courses[index].courseName}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                " Course level: ${_courses[index].courseLevel}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300)),

                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                " Course description: ${_courses[index].courseDescription}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                              height: 25,
                            ),
                            Text('MR: ${_courses[index].teacherName}', textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('teacher phone: 0${_courses[index].teacherPhone}', textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                                " Course Date:${_courses[index].sessionDay} at ${_courses[index].courseSessionDate}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                                " Course users: ${_courses[index].courseUsers}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      teacherName = _courses[index].teacherName;
                                      teacherPhone = _courses[index].teacherPhone;
                                      courseName = _courses[index].courseName;
                                      courseLevel = _courses[index].courseLevel;
                                      DateTime date = DateTime.now();
                                      String dayOfWeek = DateFormat('EEEE').format(date).toLowerCase();
                                      if(dayOfWeek == _courses[index].sessionDay){
                                        showSnackBar("sorry you can`t enroll in same day of session");
                                      }else{
                                      //TODO admin dashboard controller
                                      showDialog(context: context,builder: (BuildContext context){
                                        return AlertDialog(
                                          elevation: 10,
                                          title: Text('Admin Login',textAlign: TextAlign.center,),
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextFormField(
                                                  controller: phoneController,
                                                  maxLength: 11,
                                                  keyboardType: TextInputType.phone,
                                                  decoration: InputDecoration(
                                                    labelStyle: TextStyle(color:Color.fromRGBO(156, 216, 226, 1) ),
                                                    focusColor: Color.fromRGBO(156, 216, 226, 1),
                                                    prefixIcon: Icon(Icons.phone),
                                                    labelText: 'Phone Number',
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.deepOrange),
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: passwordController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(color:Color.fromRGBO(156, 216, 226, 1) ),
                                            focusColor: Color.fromRGBO(156, 216, 226, 1),
                                            prefixIcon: Icon(Icons.lock_open),
                                            labelText: 'password',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color:Color.fromRGBO(156, 216, 226, 1) ),
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),SizedBox(
                                        height: 20,
                                        ),

                                                Container(
                                                  margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                                  child: RaisedButton(
                                                    onPressed: (){
                                                     sendData();
                                                      Navigator.pop(context);
                                                    },
                                                    elevation: 10,
                                                    color: Theme.of(context).buttonColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0)),
                                                    child: Text(
                                                      'Login',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.normal,
                                                        color: Theme.of(context).accentColor,
                                                        letterSpacing: 1.2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          ),
                                        );
                                      });
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

  void logout() async {
    SharedPreferences removeUser = await preferences;
    removeUser.clear();
    Navigator.of(context).pushNamed('/login');
  }
  Future<List<DetailsOfCourse> > getAllCourses() async{
    _courses.clear();
    response = await http.post("http://192.168.1.9/coursesOnline/allCourses.php");
    if(response.statusCode == 200){
      List<dynamic> values=new List<dynamic>();
      values = convert.json.decode(response.body);
      if(values.length > 1){
        for(int i=0;i<values.length;i++){
          if(values[i]!=null){
            Map<String,dynamic> map=values[i];
            _courses.add(DetailsOfCourse.fromJson(map));
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
  Future<List<DetailsOfCourse> > getAllCoursesFilter(String level) async{

    setState(() {
      _courses.clear();
      isloading= true;
    });
    print(level);
    response = await http.post("http://192.168.1.9/coursesOnline/cousesFilter.php",body:
    {
      'level':'$level',
    });
    if(response.statusCode == 200){
      List<dynamic> values=new List<dynamic>();
      values = convert.json.decode(response.body);
      if(values.length > 1){
        setState(() {
          noCourses = false;
        });
        for(int i=0;i<values.length;i++){
          if(values[i]!=null){
            Map<String,dynamic> map=values[i];
            _courses.add(DetailsOfCourse.fromJson(map));
            }
        }
      }else{
        setState(() {
          noCourses = true;
        });

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
  void sendData() async {
    if (
    passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        phoneController.text.length< 11) {
      setState(() {
        isloading = false;
      });
      showSnackBar('all this field are required');
    }
      response = await http
          .post("http://192.168.1.9/coursesOnline/login.php",body: {
        "phone": '${phoneController.text}',
        "password": '${passwordController.text}',
        "type": 'admin',
      });
      if(SignIn.fromJson(convert.json.decode(response.body)) != null){
        setState(() {
          isloading = false;
          adminName = SignIn.fromJson(convert.json.decode(response.body)).userName;
          adminPhone = SignIn.fromJson(convert.json.decode(response.body)).userPhone;
        });
        String success = SignIn.fromJson(convert.json.decode(response.body)).success;

        if(success == "success"){
          setState(() {
            isSuccess = true;
            if(SignIn.fromJson(convert.json.decode(response.body)).type == 'admin'){
              //TODO
              showSnackBar('welcome $adminName \n');
              Navigator.of(context).pushNamed('/adminEnrollment',arguments: AdminEnrollment(teacherName,teacherPhone,courseName,courseLevel));
            }
          });
        }else {
          isSuccess = false;
          showSnackBar("$success");
        }
      }
    }
  }


