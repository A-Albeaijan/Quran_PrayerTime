import 'dart:convert';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:slate/style.dart';

import 'package:http/http.dart' as http;

class PrayerTime extends StatefulWidget {
  const PrayerTime({super.key});

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  bool _isLoading = true;
  var country = Get.arguments[0];

  var city = Get.arguments[1];
  @override
  Widget build(BuildContext context) {
    Future<PrayTime> fetchtime() async {
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/timingsByCity?country=${country.substring(8)}&city=${city}'));
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        return PrayTime.fromJson(data['data']['timings']);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load');
      }
    }

    var size = MediaQuery.of(context).size;
    var formatter = new DateFormat('dd-MM-yyyy');
    int houre = int.parse(DateFormat('kk').format(DateTime.now()));

    String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());
    String formattedDate = formatter.format(DateTime.now());
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Prayer Time',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Positioned(
            //   child: Container(
            //     width: double.infinity,
            //     height: size.height * 0.8,
            //     color: Colors.amber,
            //   ),
            // ),
            Positioned(
              //image
              top: 0,
              right: 0,
              left: 0,
              child: SizedBox(
                height: size.height * 0.35,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    houre > 6 && houre < 17
                        ? Image.asset(
                            'assets/1.jpg',
                            fit: BoxFit.cover,
                          )
                        : houre > 17 && houre < 20
                            ? Image.asset(
                                'assets/4.jpg',
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/5.jpg',
                                fit: BoxFit.cover,
                              ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${city}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                height: size.height * 0.6,
                // child: ListView.separated(
                //   separatorBuilder: (BuildContext context, int index) =>
                //       const Divider(height: 1, thickness: 2),
                //   itemCount: 5,
                //   itemBuilder: (context, int index) {
                //     return ListTile(
                //       subtitle: Text('da'),
                //       title: Text('data'),
                //       trailing: Icon(Icons.sunny),
                //     );
                //   },
                // ),
                child: FutureBuilder(
                  future: fetchtime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Skeleton(
                        themeMode: ThemeMode.system,
                        isLoading: _isLoading,
                        skeleton: SkeletonListView(),
                        child: Container(child: Center(child: Text("Content"))),
                      );
                    } else {
                      PrayTime temp = snapshot.data as PrayTime;

                      return Column(
                        children: [
                          ListTile(
                            subtitle: Text('${temp.Fajr}'),
                            title: const Text('Fajr'),
                            trailing: const Icon(
                              Icons.wb_twilight,
                            ),
                          ),
                          ListTile(
                            subtitle: Text(temp.Dhuhr),
                            title: const Text('Dhuhr'),
                            trailing: const Icon(Icons.sunny),
                          ),
                          ListTile(
                            subtitle: Text(temp.Asr),
                            title: const Text('Asr'),
                            trailing: const Icon(Icons.sunny),
                          ),
                          ListTile(
                            subtitle: Text(temp.Maghrib),
                            title: const Text('Maghrib'),
                            trailing: const Icon(
                              Icons.nights_stay,
                            ),
                          ),
                          ListTile(
                            subtitle: Text(temp.Isha),
                            title: const Text('Isha'),
                            trailing: const Icon(
                              Icons.nightlight_round,
                            ),
                          ),
                        ],
                      );
                    } //return widget because builder's return type is widget
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrayTime {
  final String Fajr;
  final String Dhuhr;
  final String Asr;
  final String Maghrib;
  final String Isha;
  const PrayTime({
    required this.Isha,
    required this.Maghrib,
    required this.Fajr,
    required this.Dhuhr,
    required this.Asr,
  });

  factory PrayTime.fromJson(Map<String, dynamic> json) {
    return PrayTime(
      Isha: json['Isha'],
      Maghrib: json['Maghrib'],
      Fajr: json['Fajr'],
      Dhuhr: json['Dhuhr'],
      Asr: json['Asr'],
    );
  }
}
