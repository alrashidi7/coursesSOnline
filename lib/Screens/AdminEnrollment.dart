import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:easy_localization/easy_localization.dart';

import 'package:online_courses/units/Enrollment.dart';

class AdminEnrollment extends StatefulWidget {
  final String teacherName;
  final String teacherPhone;
  final String courseName;
  final String courseLevel;

  AdminEnrollment(
      this.teacherName, this.teacherPhone, this.courseName, this.courseLevel);

  @override
  _AdminEnrollmentState createState() => _AdminEnrollmentState();
}

class _AdminEnrollmentState extends State<AdminEnrollment> {
  String courseName;
  String courseLevel;
  String teacherName;
  String teacherPhone;
  String money;
  String key;
  bool isSuccess = false;
  var response;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController phoneController;
  TextEditingController moneyController;

  void snackbar(String message) {
    _globalKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message),duration: Duration(seconds: 1),));
  }
  @override
  void initState() {
    // TODO: implement initState
    phoneController = new TextEditingController();
    moneyController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdminEnrollment argsEnrollments =
        ModalRoute.of(context).settings.arguments;
    setState(() {
      teacherName = argsEnrollments.teacherName;
      teacherPhone = argsEnrollments.teacherPhone;
      courseName = argsEnrollments.courseName;
      courseLevel = argsEnrollments.courseLevel;
    });
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _globalKey,
      body: Stack(
        children: <Widget>[
          Image.asset('Images/paymentBackground.jpg',fit: BoxFit.fitHeight,),
          Center(
            child: Container(
              margin: EdgeInsets.all(40.0),
              child: Card(
                color:  Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)

                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            maxLength: 11,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Theme.of(context).accentColor),
                              focusColor: Theme.of(context).accentColor,
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Student phone'.tr().toString(),
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Theme.of(context).accentColor),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: moneyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Theme.of(context).accentColor),
                              focusColor: Theme.of(context).accentColor,
                              prefixIcon: Icon(Icons.attach_money),
                              labelText: 'the money'.tr().toString(),
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Theme.of(context).accentColor),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).buttonColor,
                      onPressed: () {
                        enrollment();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Enroll'.tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).accentColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child:  isSuccess ? SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Card(
                  elevation: 8,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('Images/acceptedPayment.png',width: 100.0,height: 100.0,),
                        Text('Enrollment'.tr().toString()),
                        Text('$key',style: TextStyle(
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
      )
    );
  }
  void enrollment() async{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    print('hlh $formattedDate');
    response = await http.post('http://192.168.1.9/coursesOnline/enroll.php',body: {
      "teacherName":'$teacherName',
      "teacherPhone":'$teacherPhone',
      "studentPhone":'${phoneController.text}',
      "courseName":'$courseName',
      "courseLevel":'$courseLevel',
      "DateOfDay":'$formattedDate',
      "money":'${moneyController.text}',
    });
    if(Enrollment.fromJson(convert.json.decode(response.body)) != null){
      String success = Enrollment.fromJson(convert.json.decode(response.body)).success;
      switch (success){
        case 'enroll successful':
          snackbar(success);
          key = Enrollment.fromJson(convert.json.decode(response.body)).key;
          setState(() {
            isSuccess = true;
          });

          break;
        case 'error please try again':
          snackbar(success);
          break;
        case 'this phone is not found in our database please register':
          snackbar(success);
          break;
        case 'this phone number already enroll':
          snackbar(success);
          break;
      }
    }else{
      print('faild');
    }
  }
}
