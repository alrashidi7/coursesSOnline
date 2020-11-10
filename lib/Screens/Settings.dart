
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  bool isSwitchedFT = false;
  String dropDownValue = "English";

  @override
  void initState() {
//    isSwitchedFT = false;
    // TODO: implement initState

    super.initState();
    getSwitchValues();
  }

  getSwitchValues() async {
    isSwitchedFT = await getSwitchState();
    if(isSwitchedFT ==null){
      isSwitchedFT = false;
    }
    setState(() {});
  }
  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    print('Switch Value saved $value');
    return prefs.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSwitchedFT = prefs.getBool("switchState");
    print('isSwitchedFT $isSwitchedFT');
    return isSwitchedFT;
  }
  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text('Settings'.tr().toString()), centerTitle: true,),
      body: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text('Dark Theme'.tr().toString()),
                      Switch(
                        value: isSwitchedFT,
                        onChanged: (bool value) {
                          setState(() {
                            isSwitchedFT = value;
                            saveSwitchState(value);
                            print('Saved state is $isSwitchedFT');
                            Navigator.of(context).pushNamed('/myApp');
                            //switch works
                          });
                          print(isSwitchedFT);
                        },
                        activeTrackColor: Theme.of(context).accentColor,
                        activeColor:  Color.fromRGBO(156, 216, 226, 1),
                      ),
                    ],
                  ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FlatButton.icon(onPressed: (){}, icon: Icon(Icons.language), label: Text("Language".tr().toString())),
                  DropdownButton<String>(
                     value: dropDownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).accentColor),
                    onChanged: (String newValue) {
                        setState(() {
                          dropDownValue = newValue;
                          if(newValue == 'English'){
                            EasyLocalization.of(context).locale = Locale("en","EG");
                          }else{
                            EasyLocalization.of(context).locale = Locale("ar","EG");
                          }
                        });
                    },
                      items: <String>['English', 'Arabic']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                 ] )
                ],
              )

          ),

    );
  }
}
