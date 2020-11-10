
import 'dart:async';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:online_courses/Screens/TeacherDashboard.dart';
import 'package:online_courses/units/AddingCourse.dart';


class AddCourse extends StatefulWidget {
  final String teacherName;
  final String teacherPhone;

  AddCourse(this.teacherName, this.teacherPhone);

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  var response;
  bool isLoading = false;
  bool isSuccess = false;
  String teacherName; //
  String teacherPhone; //
   String courseName; //
   String courseLevel= 'select Course Level'; //
  String courseUsers; //
  String courseDescription; //
  String courseSessionDate = " "; //time
  String courseRate; //
  String sessionDay;  //
  String sessionDayDate; //
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  DateTime currentDate =DateTime.now();
  
  showSnackBar(String message){
    _globalKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  TextEditingController courseNameController = new TextEditingController();
  TextEditingController courseDescriptionController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    AddCourse arguments = ModalRoute.of(context).settings.arguments;
    teacherName = arguments.teacherName;
    teacherPhone = arguments.teacherPhone;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(title: Text('Add new Course'.tr().toString()),centerTitle: true,),
      body:               Center(
        child:  isSuccess ? SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: Card(
              elevation: 8,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('Images/checked.png',width: 100.0,height: 100.0,),
                    Text('Add Course successfully'.tr().toString()),
                  ],
                ),
              ),
            ),
          ),
        ) :
      SingleChildScrollView(
        child: Center(
    child:  isLoading ? SizedBox(
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
    ) : Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: courseNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Theme.of(context).accentColor),
                  focusColor: Theme.of(context).accentColor,
                  prefixIcon: Icon(Icons.person),
                  labelText: ' Course name: '.tr().toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              DropdownButton<String>(
                isExpanded: true,
                items: <String>['select Course Level','English', 'Arabic']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    courseLevel = newValue;
                    print(courseLevel);
                  });
                },
                value: courseLevel,
                icon: Icon(Icons.arrow_downward),
                iconSize: 22,
                elevation: 16,
                style: TextStyle(color: Theme.of(context).accentColor),
                underline: Container(
                    height: 0.5,
                    color: Theme.of(context).accentColor),
              ),SizedBox(
                height: 15.0,
              ),
              TextFormField(
                maxLines: 5,
                controller: courseDescriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Theme.of(context).accentColor),
                  focusColor: Theme.of(context).accentColor,
                  prefixIcon: Icon(Icons.person),
                  labelText: ' Course description: '.tr().toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text("SELECT DAY".tr().toString(),style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5
              ),),
              SizedBox(
                height: 15.0,
              ),
              CalendarTimeline(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 7)),
                onDateSelected: (date){
                  print(date);
                  setSeesionDay(date.weekday);
                  setState(() {
                    sessionDayDate = date.toString();
                    print(date.weekday);
                  });
                },
                monthColor: Theme.of(context).accentColor,
                dayColor: Theme.of(context).primaryColor,
                dayNameColor: Color(0xFF333A47),
                  activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.redAccent[100],
                dotsColor: Color(0xFF333A47),
                selectableDayPredicate: (date) => date.day != 23,
              ),
              SizedBox(
                height: 25.0,
              ),
              RaisedButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true, onChanged: (date) {
                      print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      setState(() {
                        courseSessionDate = formatDate(
                            DateTime(date.year,date.month,date.day,date.hour,date.minute), [HH, ':', nn]);
                      });
                      },
                       currentTime: DateTime.now());
                  },
                  child: Text(
                    'SHOW TIME PICKER'.tr().toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5),
                  )),
            SizedBox(
              height: 20,
            ),
            Text(
              '$courseSessionDate',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
            ),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                onPressed: (){
                  showDialog(context: context,builder: (_) => AlertDialog(
                    title: Text('Save changes'.tr().toString()),
                    content: Text('alertDialogContent'.tr().toString()),
                    actions: <Widget>[
                      RaisedButton(onPressed:(){
                        Navigator.pop(context);
                      } , child: Text("NO")),
                      RaisedButton(onPressed: (){
                        addCourse();
                        Navigator.pop(context);
                      }, child: Text("YES")),
                    ],
                  ),
                  );
                },
                elevation: 10,
                color: Theme.of(context).buttonColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  'ADD COURSE'.tr().toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,

                  ),
                ),
              ),


            ],
          ),
        ),
      ),
      ),
      ),
    );
  }

  addCourse() async{
    setState(() {
      isLoading = true;
    });
    if(teacherName !=null &&teacherPhone !=null &&courseNameController.text !=null &&courseDescriptionController.text !=null
    ||courseLevel != "select Course Level" &&sessionDay !=null &&courseSessionDate !=null &&sessionDayDate!=null){
      response = await http.post("http://192.168.1.9/coursesOnline/addCourse.php",body: {
        "teacherName":'$teacherName',
        "teacherPhone":'$teacherPhone',
        "courseName":'${courseNameController.text}',
        "courseDescription":'${courseDescriptionController.text}',
        "courseLevel":'$courseLevel',
        "sessionDay":'$sessionDay',
        "courseSessionDate":'$courseSessionDate',
        "sessionDayDate":'$sessionDayDate',
        "courseUsers":"0",
        "courseRate":"3",
      });
      if(response.statusCode == 200){

          setState(() {
            isLoading = false;
          });
          String success = AddingCourse.fromJson(convert.json.decode(response.body)).success;

          if(success == "success"){
            setState(() {
              isSuccess = true;
              Timer(Duration(seconds: 2), (){
                Navigator.of(context).pushNamed('/teacherDashBoard',arguments: TeacherDashboard(teacherName, teacherPhone,""));
              });
            });
          }else
            showSnackBar("$success");
      }else{
        showSnackBar("123");
      }

    }else{
      showSnackBar("please complete information");
    }
  }
  void setSeesionDay(int day){
    switch (day){
      case 1:
        print("monday");
        setState(() {
          sessionDay = "monday";
        });
        break;
      case 2:
        print("tuesday");
        setState(() {
          sessionDay = "tuesday";
        });
        break;
      case 3:
        print("wednesday");
        setState(() {
          sessionDay = "wednesday";
        });
        break;
      case 4:
        print("thursday");
        setState(() {
          sessionDay = "thursday";
        });
        break;
      case 5:
        print("friday");
        setState(() {
          sessionDay = "friday";
        });
        break;
      case 6:
        print("saturday");
        setState(() {
          sessionDay = "saturday";
        });
        break;
      case 7:
        print("sunday");
        setState(() {
          sessionDay = "sunday";
        });
        break;
    }
  }
}
