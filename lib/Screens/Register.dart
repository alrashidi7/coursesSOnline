import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_courses/units/Registeration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = '';
  File _image;
  bool vailedPhoneNumber = false;
  bool isLoading = false;
  bool isSuccess = false;
  var response;
  String message = "";
  int rondomKey = 0;

  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController;
  TextEditingController phoneController;
  TextEditingController emailController;
  TextEditingController passwordController;
  String verificationId;

  void snackbar(String message) {
    _globalKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = new TextEditingController();
    phoneController = new TextEditingController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
  }

  void sendData() async {
   Future.delayed(Duration(seconds: 3),() async{
     if (nameController.text.isEmpty ||
         passwordController.text.isEmpty ||
         phoneController.text.isEmpty ||
         phoneController.text.length< 11) {
       snackbar('all this field are required');
     } else {
       response = await http
           .post("http://192.168.1.9/coursesOnline/register.php",body: {
         "name": '${nameController.text}',
         "email": '${emailController.text}',
         "mobile": '${phoneController.text}',
         "password": '${passwordController.text}',
         "type": 'student',
       });
       if(Registeration.fromJson(convert.json.decode(response.body)) != null){
         setState(() {
           isLoading = false;
         });
         String success = Registeration.fromJson(convert.json.decode(response.body)).success;

         if(success == "registeration success"){
           setState(() {
             isSuccess = true;
             Timer(Duration(seconds: 1), (){
               Navigator.of(context).pushNamed('/login');
             });
           });
         }else
           snackbar("$success");
       }

     }
   });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body:Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 250,
                    height: 280,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('Images/register.gif'),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text('openingRegister'.tr().toString(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 550,
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: showImage(),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                focusColor: Theme.of(context).accentColor,
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Full Name'.tr().toString(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      helperText: "Email is Optional field".tr().toString(),
                      labelStyle:
                      TextStyle(color: Theme.of(context).accentColor),
                      focusColor: Theme.of(context).accentColor,
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email'.tr().toString(),
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: phoneController,
                    maxLength: 11,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelStyle:
                      TextStyle(color: Theme.of(context).accentColor),
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
                      labelStyle:
                      TextStyle(color: Theme.of(context).accentColor),
                      focusColor: Theme.of(context).accentColor,
                      prefixIcon: Icon(Icons.lock_open),
                      labelText: 'Password'.tr().toString(),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        sendData();
                      },
                      elevation: 1,
                      color: Theme.of(context).buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child:Text(
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
                      Text('You Already have Account?! '.tr().toString(),
                          style: TextStyle(color: Theme.of(context).accentColor)),
                      GestureDetector(
                        onTap: () => {Navigator.of(context).pushNamed('/login')},
                        child: Text(
                          'Login'.tr().toString(),
                          style: TextStyle(
                              color: Theme.of(context).accentColor, fontSize: 18),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          Image.asset('Images/checked.png',width: 100.0,height: 100.0,),
                        Text('Regestration success'.tr().toString()),
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

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Image.file(
            _image,
            fit: BoxFit.fill,
            height: 150.0,
            width: 100.0,
          );
        } else {
          return Image.asset(
            'Images/person.png',
            height: 150.0,
            width: 100.0,
          );
        }
      },
    );
  }
}
