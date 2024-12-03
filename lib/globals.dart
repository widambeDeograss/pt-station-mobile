library my_prj.globals;

import 'package:flutter/material.dart';

String ip = "http://192.168.1.130:5556";

String remoteDomain = ip;
String remoteDomainApi = "$ip";

const MaterialColor primaryWhite = MaterialColor(
  _whitePrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
const int _whitePrimaryValue = 0xFFFFFFFF;

const MaterialColor primaryRed = MaterialColor(
  _redPrimaryValue,
  <int, Color>{
    50: Color(0xFFFF5733),
    100: Color(0xFFFF5733),
    200: Color(0xFFFF5733),
    300: Color(0xFFFF5733),
    400: Color(0xFFFF5733),
    500: Color(_redPrimaryValue),
    600: Color(0xFFFF5733),
    700: Color(0xFFFF5733),
    800: Color(0xFFFF5733),
    900: Color(0xFFFF5733),
  },
);
const int _redPrimaryValue = 0xFFFF5733;
