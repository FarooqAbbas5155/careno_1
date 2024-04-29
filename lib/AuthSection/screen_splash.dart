import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../constant/helpers.dart';
// import 'package:flutter_gif/flutter_gif.dart';

class SplashScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 8), () async {
      Widget screen = await getHomeScreen();
      Get.offAll(screen);

    });
    return Scaffold(
      backgroundColor: Colors.white, // Customize the background color if needed
      body: Center(
        child: Image.asset("assets/gif/GIF.gif")
        )

    );
  }
}
