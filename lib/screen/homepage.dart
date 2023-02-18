import 'package:flutter/material.dart';
import 'package:slate/screen/Prayertimer.dart';
import 'package:slate/style.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'Quran.dart';
import 'location.dart';
import 'package:location/location.dart';
import 'package:country_picker/country_picker.dart';
import 'package:csc_picker/csc_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  String? selectedCountrey;
  String? selectedState;
  String? selectedCity;
  String? countryCode;
  Future<dynamic> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.location_on_rounded,
              color: greenColor,
            ),
            onPressed: () {
              getLocation().then((value) => print(value));
            },
          ),
          title: Text(
            'Slate',
            style: titleGreenStyle(),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: CircleAvatar(
          //       backgroundColor: blueColor,
          //       backgroundImage: const AssetImage('assets/moon.png'),
          //     ),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                CSCPicker(
                  onCountryChanged: (value) {
                    setState(() {
                      selectedCountrey = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      selectedState = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
                // Image.asset(
                //   'assets/logo.png',
                //   height: size.height * 0.1,
                // ),
                const SizedBox(
                  height: 20,
                ),
                InspirationWidget(size),
                Row(
                  children: [
                    Column(
                      children: [
                        customContainer(
                          page: 'Quran',
                          width: size.width,
                          height: size.height,
                          color: greenColor,
                          image: 'assets/quran.png',
                          title: 'Quran',
                        ),
                        customContainer(
                          page: 'a',
                          width: size.width,
                          height: size.height * 0.7,
                          color: purpleColor,
                          image: 'assets/bookmark.png',
                          title: 'Bookmark',
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        customContainer(
                          selectedCity: selectedCity,
                          selectedCountrey: selectedCountrey,
                          page: 'PrayerTime',
                          width: size.width,
                          height: size.height * 0.7,
                          color: redColor,
                          image: 'assets/prayer.png',
                          title: 'Prayer',
                        ),
                        customContainer(
                          page: 'Loaction',
                          width: size.width,
                          height: size.height,
                          color: blueColor,
                          image: 'assets/location.png',
                          title: 'Location',
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container InspirationWidget(Size size) {
    return Container(
      height: size.height * 0.15,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(1.5, 3),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(
            'assets/dashboard.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            primaryColor.withOpacity(0.7),
            secondaryColor.withOpacity(0.7),
          ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.4,
              child: ListTile(
                title: Text(
                  '',
                  style: titleStyle(),
                ),
                subtitle: Text(
                  '',
                  style: subtitleStyle(),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: size.width * 0.3,
              height: size.height * 0.2,
              child: Image.asset(
                'assets/lamp.png',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class customContainer extends StatelessWidget {
  customContainer({
    Key? key,
    required this.width,
    required this.title,
    required this.image,
    required this.color,
    required this.height,
    required this.page,
    this.selectedCountrey,
    this.selectedCity,
  }) : super(key: key);

  final double width;
  final double height;
  final String title;
  final String image;
  final Color color;
  final String page;
  final String? selectedCountrey;
  final String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (page == 'PrayerTime' && selectedCity == null) {
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.info,
            body: const Center(
              child: Text(
                'Please select a city',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            btnOkOnPress: () {},
          ).show();
        } else {
          Get.toNamed(
            '/${page}',
            arguments: [
              selectedCountrey,
              selectedCity,
            ],
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        height: height * 0.25,
        width: width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(1.5, 3),
            ),
          ],
          image: const DecorationImage(
            image: AssetImage(
              'assets/dashboard.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Image.asset(
                image,
                fit: BoxFit.fill,
                width: width * 0.2,
              ),
              const Spacer(),
              Text(
                title,
                style: titleStyle(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
