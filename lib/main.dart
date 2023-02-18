import 'package:flutter/material.dart';
import 'package:slate/screen/Prayertimer.dart';
import 'package:slate/screen/Quran.dart';
import 'package:slate/screen/homepage.dart';
import 'package:get/get.dart';
import 'package:slate/screen/location.dart';
import 'package:slate/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: primaryColor),
      home: const HomePage(),
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/Quran', page: () => Quran()),
        GetPage(name: '/PrayerTime', page: () => PrayerTime()),
        GetPage(name: '/Loaction', page: () => Loaction()),
        GetPage(name: '/a', page: () => Quran()),
      ],
    );
  }
}
