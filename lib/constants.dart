import 'package:flutter/material.dart';

const kHomeScreenLogoPath = 'assets/images/lucis.png';
const kCameraIcon = IconData(0xe800, fontFamily: 'CustomIcons');
const kExploreIcon = IconData(0xe801, fontFamily: 'CustomIcons');
const kMapIcon = IconData(0xe802, fontFamily: 'CustomIcons');
const kYouIcon = IconData(0xe803, fontFamily: 'CustomIcons');

const kLoginButtonBackgroundColor = Colors.black54;
const kRegisterButtonBackgroundColor = Colors.deepOrangeAccent;

const kDefaultAvatarPath = 'assets/images/astronaut.png';
const kDefaultMarkerSize = 50;

const kMaxImageImportHeight = 600.0;

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kDefaultFailureMessage = 'Something went wrong!';
