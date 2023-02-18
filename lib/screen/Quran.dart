import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:slate/screen/reading_page.dart';
import '../models/surah.dart';

import '../models/surah.dart';
import '../style.dart';

class Quran extends StatefulWidget {
  @override
  _QuranState createState() => _QuranState();
}

class _QuranState extends State<Quran> with TickerProviderStateMixin {
  List<Surah> surahList = [];
  List<Surah> copyhList = [];
  int selectedIndex = 0;
  bool isReverse = false;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    readJson();
    super.initState();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/suarh.json');
    final data = await json.decode(response);
    for (var item in data["chapters"]) {
      surahList.add(Surah.fromMap(item));
      copyhList.add(Surah.fromMap(item));
    }

    debugPrint(surahList.length.toString());
    debugPrint(copyhList.length.toString());
    setState(() {});
  }

  void search(String query) {
    final sugg = surahList.where((surah) {
      final ename = surah.name.toLowerCase();
      final aname = surah.arabicName;
      final input = query.toLowerCase();

      return ename.contains(input);
    }).toList();
    setState(() {
      if (sugg.isEmpty) {
        surahList = copyhList;
      } else {
        surahList = sugg;
      }
    });
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () {
            Get.back();
          },
        ),

        title: TextField(
          onChanged: search,
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
        ),
        //change order
        actions: [
          Transform.rotate(
            angle: isReverse ? pi : 2 * pi,
            child: IconButton(
                icon: const Icon(
                  Icons.sort,
                  color: Colors.teal,
                ),
                onPressed: () {
                  setState(() {
                    isReverse = !isReverse;
                  });
                }),
          ),
        ],
      ),
      body: surahList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            )
          : chaptersList(isReverse ? surahList.reversed.toList() : surahList),
    );
  }

  Widget chaptersList(List<Surah> chapters) {
    return ListView.separated(
      controller: _controller,
      itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.teal,
            child: Text(chapters[index].id.toString()),
          ),
          title: Text(chapters[index].name),
          subtitle: Text(chapters[index].versesCount.toString()),
          trailing: Text(
            chapters[index].arabicName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          onTap: () {
            Get.to(() => ReadingPage(surah: chapters[index]));
          }),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: chapters.length,
    );
  }
}
