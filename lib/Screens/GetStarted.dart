import 'dart:async';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:online_courses/Widgets/SlideDots.dart';
import 'package:online_courses/Widgets/SliderWelcome.dart';
import 'package:online_courses/units/Slide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStarted createState() => _GetStarted();
}

class _GetStarted extends State<GetStarted> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Future<SharedPreferences> pref = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer){
      if(_currentPage < 2){
        _currentPage++;
      }else{
        _currentPage = 0;
      }
      _pageController.animateToPage(_currentPage, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }
  void onPageChanged(int index){
    setState(() {
      _currentPage = index;
    });
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void showGetStartedPage() async {
    SharedPreferences _showGetStartedPagePref = await pref;
    _showGetStartedPagePref.setString('showGetStarted', 'false');
    Navigator.of(context).pushNamed('/login');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(156, 216, 226, 1),
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child:Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      onPageChanged: onPageChanged,
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      itemCount: slideList.length,
                      itemBuilder: (context, index) {
                        return SliderWelcome(index);
                      },
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for(int i=0;i <slideList.length;i++)
                                if(i == _currentPage)
                                  SlideDots(true)
                              else
                                SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  onPressed: showGetStartedPage,
                  elevation: 10,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
