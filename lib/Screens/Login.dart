
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:online_courses/Screens/AdminDashboard.dart';
import 'package:online_courses/Screens/StudentDashboard.dart';

import 'package:online_courses/Screens/TeacherDashboard.dart';


import 'package:online_courses/units/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController phoneController;
  TextEditingController passwordController;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  var response;
  bool isloading = false;
  bool isSuccess = false;
  bool checkBoxValueStudent = false;
  bool checkBoxValueTeacher = false;
  bool rememberMe = false;
  String showGetLoginName="teacherName";
  String showGetLoginPhone="teacherPhone";
  String type = "type";
  String imageUrl;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  void snackbar(String message) {
    _globalKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
  void rememberME(String name,String phone,String type,String imageUrl) async{
    SharedPreferences _showGetStartedPagePref = await preferences;
    _showGetStartedPagePref.setString('username', name);
    _showGetStartedPagePref.setString('phone', phone);
    _showGetStartedPagePref.setString('type', type);
    _showGetStartedPagePref.setString('imageUrl', imageUrl);

    print('rememberMe ${_showGetStartedPagePref.getString('username')}'
        '${_showGetStartedPagePref.getString('phone')}'
        ' ${_showGetStartedPagePref.getString('type')}'
        ' ${_showGetStartedPagePref.getString('imageUrl')}');
  }

  void sendData() async {
      if (
          passwordController.text.isEmpty ||
          phoneController.text.isEmpty ||
          phoneController.text.length< 11) {
        setState(() {
          isloading = false;
        });
        snackbar('all this field are required');
      } else {

        if(checkBoxValueStudent == true){
          setState(() {
            type = "student";
          });
        }else if(checkBoxValueTeacher){
          setState(() {
            type = "teacher";
          });
        }else{
          setState(() {
            type = "admin";
          });
        }

        response = await http
            .post("http://192.168.1.9/coursesOnline/login.php",body: {
          "phone": '${phoneController.text}',
          "password": '${passwordController.text}',
          "type": '$type',
        });
        if(SignIn.fromJson(convert.json.decode(response.body)) != null){
          setState(() {
            isloading = false;
            showGetLoginName = SignIn.fromJson(convert.json.decode(response.body)).userName;
            showGetLoginPhone = SignIn.fromJson(convert.json.decode(response.body)).userPhone;
            String type = SignIn.fromJson(convert.json.decode(response.body)).type;
            imageUrl = SignIn.fromJson(convert.json.decode(response.body)).imageUrl;

            rememberME(showGetLoginName,showGetLoginPhone,type,imageUrl);
          });
          print('$showGetLoginName $showGetLoginPhone');
          String success = SignIn.fromJson(convert.json.decode(response.body)).success;

          if(success == "success"){
            setState(() {
              isSuccess = true;
              Timer(Duration(seconds: 2),(){
                switch(SignIn.fromJson(convert.json.decode(response.body)).type){
                  case 'teacher':
                    Navigator.of(context).pushReplacementNamed('/teacherDashBoard',arguments:TeacherDashboard(showGetLoginName,showGetLoginPhone,imageUrl));
                    break;
                  case 'student':
                    String studentName;
                    String studentPhone;
                    setState(() {
                      print(showGetLoginName);
                      studentName =showGetLoginName;
                      studentPhone =showGetLoginPhone;
                      print('go to studentPage');
                    });
                    Navigator.of(context).pushReplacementNamed('/studentDashBoard',arguments:StudentDashboard(studentName,studentPhone,imageUrl));
                    break;
                  case 'admin':
                    Navigator.of(context).pushReplacementNamed('/adminDashBoard',arguments: AdminDashboard(showGetLoginName,showGetLoginPhone,imageUrl));
                }
              });

                if(SignIn.fromJson(convert.json.decode(response.body)).type == 'teacher'){
                }else{

                }
            });
          }else
            isSuccess = false;
            snackbar("$success");
        }
      }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController = new TextEditingController();
    passwordController = new TextEditingController();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: 350,
                    height: 250,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('Images/login.gif'),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text('Welcome back..'.tr().toString(),textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, color: Theme.of(context).accentColor,fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phoneController,
                    maxLength: 11,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color:Theme.of(context).accentColor),
                      focusColor: Theme.of(context).accentColor,
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone Number'.tr().toString(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor),
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
                      labelStyle: TextStyle(color:Theme.of(context).accentColor ),
                      focusColor: Theme.of(context).accentColor,
                      prefixIcon: Icon(Icons.lock_open),
                      labelText: 'password'.tr().toString(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color:Theme.of(context).primaryColor ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            value: checkBoxValueStudent,
                            activeColor: Theme.of(context).primaryColor, onChanged: ((bool value) {
                              setState(() {
                                checkBoxValueStudent = value;
                                checkBoxValueTeacher = false;
                              });
                          }),
                          ),
                          Text(
                            'As a Student'.tr().toString(),
                            style: TextStyle(color:Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            value: checkBoxValueTeacher,
                            activeColor: Theme.of(context).primaryColor, onChanged: ((bool value) {
                             setState(() {
                               checkBoxValueTeacher = value;
                               checkBoxValueStudent = false;
                             });
                          }),
                          ),
                          Text(
                            'As a Teacher'.tr().toString(),
                            style: TextStyle(color:Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Theme.of(context).primaryColor, onChanged: ((bool value) {
                        setState(() {
                          rememberMe = value;
                        });
                      }),
                      ),
                      Text(
                        'Remember ME'.tr().toString(),
                        style: TextStyle(color:Theme.of(context).accentColor),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: RaisedButton(
                      onPressed: (){
                        setState(() {
                          isloading = true;
                        });
                        sendData();
                      },
                      elevation: 10,
                      color: Theme.of(context).buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        'Get Started'.tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).accentColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                          'You don`t have Account yet?! '.tr().toString(),
                          style: TextStyle(color:Theme.of(context).accentColor)),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: Text(
                          'Register'.tr().toString(),
                          style: TextStyle(color:Theme.of(context).accentColor,fontSize: 18),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),

                ],

              ),
            ),
          ),
          Center(
            child:  isloading ? SizedBox(
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
            ) : SizedBox(),
          ),
          Center(
            child:  isSuccess ? SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Card(
                  elevation: 8,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('Images/suit.png',width: 100.0,height: 100.0,),
                        Text('\nwelcome back',style: TextStyle(
                          color: Theme.of(context).accentColor
                        ),),
                        Text('$showGetLoginName',style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                ),
              ),
            ) : SizedBox(),
          ),


        ],

      ),
    );
  }

}


