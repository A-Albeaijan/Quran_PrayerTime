import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loaction extends StatefulWidget {
  const Loaction({super.key});

  @override
  State<Loaction> createState() => _LoactionState();
}

class _LoactionState extends State<Loaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    );
  }
}
