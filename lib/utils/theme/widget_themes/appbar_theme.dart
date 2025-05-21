import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TAppBarTheme{
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.dark, size: 18.0),
    actionsIconTheme: IconThemeData(color: TColors.dark, size: 18.0),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.white, size: 18.0),
    actionsIconTheme: IconThemeData(color: TColors.white, size: 18.0),
  );
}