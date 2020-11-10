import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final String name;
  final String phone;
  Profile(this.name, this.phone);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  File _image;
  final picker = ImagePicker();
  String imageDataString;
  Uint8List _bytesImage;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageDataString = convert.base64Encode(_image.readAsBytesSync());
        print(imageDataString.length);
        _bytesImage = convert.Base64Decoder().convert(imageDataString);
        print(imageDataString);
      } else {
        print('No image selected.');
      }
    });
  }
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String name;
  String phone;
  String email;
  String password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  }

  @override
  Widget build(BuildContext context) {
    Profile arguments = ModalRoute.of(context).settings.arguments;
    if(arguments !=null){
      setState(() {
        name = arguments.name;
        phone = arguments.phone;
      });
    }
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _globalKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 60, 30, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 24,
                        color: Theme.of(context).accentColor,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    Text(
                      'Profiles details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 24, width: 24)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70,
                      child: ClipOval(
                        child: _image ==null ?
                        Image.asset(
                          'Images/person.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ):Image.memory(_bytesImage,fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,),
                      ),
                    ),
                    Positioned(
                        bottom: 1,
                        right: 1,
                        child: GestureDetector(
                          onTap: (){
                            print('object');
                           getImage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.black54, Color.fromRGBO(0, 41, 102, 1)])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20,0),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            helperText: "optional",
                            labelStyle: TextStyle(color:Colors.white,),
                            focusColor: Colors.white,
                            prefixIcon: Icon(Icons.person,color: Colors.white,),
                            labelText: 'Full Name'.tr().toString(),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20,0.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          helperText: "optional",
                          labelStyle: TextStyle(color:Colors.white,),
                          focusColor: Colors.white,
                          prefixIcon: Icon(Icons.email,color: Colors.white,),
                          labelText: 'Email'.tr().toString(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20,10.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            helperText: "optional",
                            labelStyle: TextStyle(color:Colors.white,),
                            focusColor: Colors.white,
                            prefixIcon: Icon(Icons.lock_open
                              ,color: Colors.white,),
                            labelText: 'New Password'.tr().toString(),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        )
                    ),

                    GestureDetector(
                      onTap: saveChanges,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        height: 70,
                        width: 200,
                        child: Align(
                          child: Text(
                            'Save',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 20),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(156, 216, 226, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                            )),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }

  void saveChanges() async{
    if(nameController.text != null){
      setState(() {
       name =  nameController.text ;
      });
    }
    var response =await http.post("http://192.168.1.9/coursesOnline/profile.php",body: {
      'imageUrl':imageDataString,
      'name':name,
      'phone':phone,
      'email':emailController.text,
      'password':passwordController.text,
    });
    if(response.statusCode == 200){
      String success = convert.json.decode(response.body);
      print(success);
    }else{
     throw Exception("error");
    }
  }

}
