import 'package:flutter/material.dart';

class TPageRoute{

  static pageRoute(BuildContext context, int durationInMS,dynamic className ){
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: durationInMS),
        pageBuilder: (_, __, ___) => className,
      ),
    );
  }
}