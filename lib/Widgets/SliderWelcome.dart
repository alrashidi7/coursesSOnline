import 'dart:ui';

import 'package:online_courses/units/Slide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderWelcome extends StatefulWidget {
  final int index;
  SliderWelcome(this.index);
  _SliderWelcome createState() => _SliderWelcome();
}
class _SliderWelcome extends State<SliderWelcome> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(slideList[widget.index].imageUrl.toString()),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(slideList[widget.index].title.toUpperCase(),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          Text(slideList[widget.index].description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor)),
          SizedBox(
            height: 20,
          ),
        ],
    );
  }
}
