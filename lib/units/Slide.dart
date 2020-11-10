import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description});
}

final slideList=[
  Slide(imageUrl: 'Images/videocall.jpg', title: 'Video Conference MeetingTitle'.tr().toString(), description: 'Video Conference MeetingDescription'.tr().toString()),
  Slide(imageUrl: 'Images/documents.jpg', title: 'Files and materialsTitle'.tr().toString(), description: 'Files and materialsDescription'.tr().toString()),
  Slide(imageUrl: 'Images/vodafonecash.png', title: 'payment methodTitle'.tr().toString(), description: 'payment methodDescription'.tr().toString()),
];