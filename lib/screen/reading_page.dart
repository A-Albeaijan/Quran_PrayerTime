import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quran/quran.dart' as quran;
import 'package:quran/quran.dart';
import 'package:quran/surah_data.dart';

import '../models/surah.dart';
import '../style.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key, required this.surah});
  final Surah surah;

  @override
  State<ReadingPage> createState() => _ReadingPageState(surah.id);
}

class _ReadingPageState extends State<ReadingPage> {
  final id;
  bool showbtn = false;
  ScrollController scrollController = ScrollController();
  // late AudioPlayer player;
  _ReadingPageState(this.id);
  var duration;
  @override
  void initState() {
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int count = widget.surah.versesCount;
    int index = widget.surah.id;
    bool _isplaying = false;

    var duration;
    Future audio() async {
      duration = getAudioURLByVerseNumber(index);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: size.height * 0.0,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 238, 238, 236),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.teal[300],
              onPressed: () {},
              child: const Icon(
                Icons.keyboard_arrow_up_sharp,
              ),
            ),
            // Controll(audioPlayer: player),
          ],
        ),
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.surah.arabicName,
            style: const TextStyle(
              fontFamily: 'Aldhabi',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: const Text(''),
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: header(),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: count <= 20 ? TextAlign.center : TextAlign.justify,
                  text: TextSpan(
                    children: [
                      for (var i = 1; i <= count; i++) ...{
                        TextSpan(
                          text:
                              ' ${quran.getVerse(index, i, verseEndSymbol: false)} ',
                          style: const TextStyle(
                            fontFamily: 'Kitab',
                            fontSize: 25,
                            color: Colors.black87,
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.teal,
                              radius: 14,
                              child: Text(
                                '$i',
                                textAlign: TextAlign.center,
                                textScaleFactor:
                                    i.toString().length <= 2 ? 1 : .8,
                              ),
                            ),
                          ),
                        ),
                      }
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ' ' + quran.basmala + ' ',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'NotoNastaliqUrdu',
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

// class Controll extends StatelessWidget {
//   const Controll({super.key, required this.audioPlayer});
//   final AudioPlayer audioPlayer;
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<PlayerState>(
//       stream: audioPlayer.playerStateStream,
//       builder: (context, snapshot) {
//         final playerState = snapshot.data;
//         final processingState = playerState?.processingState;
//         final playing = playerState?.playing;

//         if (playing == true) {
//           return IconButton(
//             onPressed: audioPlayer.play,
//             icon: const Icon(Icons.play_arrow_rounded),
//           );
//         } else if (processingState != ProcessingState.completed) {
//           return IconButton(
//             onPressed: audioPlayer.pause,
//             icon: const Icon(Icons.pause_rounded),
//           );
//         }
//         return const Icon(Icons.play_arrow_rounded);
//       },
//     );
//   }
// }
