import 'package:flutter/material.dart';
import 'package:online_courses/Screens/CourseDetails.dart';

class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final CourseDetails args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
      ),
    );
  }
}