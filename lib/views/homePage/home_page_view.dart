import 'dart:io';

import 'package:cmd/controls/constants/text_style_constant.dart';
import 'package:cmd/controls/functions/file_saving_function.dart';
import 'package:cmd/views/homePage/providers/home_page_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as pathFun;
import 'package:video_player/video_player.dart';
import 'functions/file_picker_function.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  // late VideoPlayerController videoPlayerController;
  //
  // void setVideoPlayerController() {
  //   final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
  //   if (homePageProvider.fetchedFilePath.contains('.mp4')) {
  //     videoPlayerController = VideoPlayerController.file(File(homePageProvider.fetchedFilePath))
  //       ..initialize().then((value) {
  //         setState(() {});
  //       });
  //   }
  // }

  void setSavingConfig() async {
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    await saveFileToDirectory(subDirectory: 'CMD Android').then((value) {
      homePageProvider.setSavingPath(path: value);
    });
  }

  @override
  void initState() {
    setSavingConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('CMD'),
        titleTextStyle: keniaTextStyle(color: Colors.white54, fontSize: 30),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Consumer<HomePageProvider>(
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (value.fetchedFilePath.isEmpty)
                      ? DottedBorder(
                          color: Colors.white54,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.butt,
                          child: CupertinoButton(
                            padding: null,
                            onPressed: () {
                              filePickerButton(context: context);
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child:
                                      Text('Pick A File', style: keniaTextStyle(color: Colors.white54, fontSize: 20))),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                          child: (value.fetchedFilePath.contains('.jpg') ||
                                  value.fetchedFilePath.contains('.png') ||
                                  value.fetchedFilePath.contains('.gif') ||
                                  value.fetchedFilePath.contains('.jpeg'))
                              ? Image.file(File(value.fetchedFilePath))
                              : (value.fetchedFilePath.contains('.mp4'))
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.3,
                                          width: MediaQuery.of(context).size.width,
                                          child: VideoPlayer(
                                            VideoPlayerController.file(File(value.fetchedFilePath))
                                              ..initialize()
                                              ..play(),
                                          ),
                                        ),
                                        // Positioned(
                                        //   top: 80,
                                        //   left: 140,
                                        //   child: IconButton(
                                        //     onPressed: () {
                                        //       if (VideoPlayerController.file(File(value.fetchedFilePath)).value.isPlaying) {
                                        //         VideoPlayerController.file(File(value.fetchedFilePath)).play();
                                        //       } else {
                                        //         VideoPlayerController.file(File(value.fetchedFilePath)).pause();
                                        //       }
                                        //     },
                                        //     icon: (VideoPlayerController.file(File(value.fetchedFilePath)).value.isPlaying)
                                        //         ? Icon(Icons.play_circle_outline)
                                        //         : Icon(Icons.pause_circle_outline),
                                        //   ),
                                        // ),
                                        // Positioned(
                                        //   bottom: 0,
                                        //   child: SizedBox(
                                        //     height: 10,
                                        //     width: MediaQuery.of(context).size.width,
                                        //     child: VideoProgressIndicator(
                                        //       VideoPlayerController.file(File(value.fetchedFilePath)),
                                        //       allowScrubbing: true,
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    )
                                  : SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      width: MediaQuery.of(context).size.width,
                                      child: VideoPlayer(
                                        VideoPlayerController.file(File(value.fetchedFilePath))
                                          ..initialize()
                                          ..play(),
                                      ),
                                    ),
                        ),
                  SizedBox(height: 30),
                  Text(pathFun.basename(value.fetchedFilePath)),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CupertinoButton(
                          onPressed: () {
                            value.setShowBeforeData();
                          },
                          child: Text('Before Edit Data', style: keniaTextStyle(color: Colors.white))),
                      CupertinoButton(
                          onPressed: () {
                            value.setShowAfterData();
                          },
                          child: Text('After Edit Data', style: keniaTextStyle(color: Colors.white))),
                    ],
                  ),
                  Visibility(visible: value.showBeforeData, child: Text(value.beforeEditVideoData.toString())),
                  Visibility(visible: value.showAfterData, child: Text(value.afterEditVideoData.toString())),
                  buildClipPath(
                    context: context,
                    color: Colors.blue,
                    text: 'Convert MP4 to MP3',
                    onPressed: convertMP4ToMP3,
                  ),
                  buildClipPath(
                    context: context,
                    color: Colors.yellow,
                    text: 'Remove Meta Data',
                    onPressed: removeMetaData,
                  ),
                  buildClipPath(
                    context: context,
                    color: Colors.redAccent,
                    text: 'Convert MP4 to MP3',
                    onPressed: () {},
                  ),
                  buildClipPath(
                    context: context,
                    color: Colors.green,
                    text: 'Convert MP4 to MP3',
                    onPressed: () {},
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        filePickerButton(context: context);
                      },
                      child: Text('Pick Another', style: keniaTextStyle(color: Colors.black38)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> convertMP4ToMP3() async {
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);

    String ffmpegCommand =
        '-i ${homePageProvider.fetchedFilePath} -c:a libmp3lame ${homePageProvider.savingFolder}/${pathFun.basenameWithoutExtension(homePageProvider.fetchedFilePath)}.mp3';

    try {
      final returnCode = await FFmpegKit.executeAsync(ffmpegCommand);
      print('Return Code: ${await returnCode.getReturnCode()}');
    } catch (e) {
      print('Error - ${e.toString()}');
    }
  }

  Future<void> removeMetaData() async {
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    try {
      String ffmpegCommand =
          '-i ${homePageProvider.fetchedFilePath} -map_metadata -1 -c:v copy -c:a copy ${homePageProvider.savingFolder}/${pathFun.basename(homePageProvider.fetchedFilePath)}';

      await FFmpegKit.executeAsync(ffmpegCommand).then((value) async {
        print(await value.getReturnCode());
      });
    } catch (e) {
      print('Error - ${e.toString()}');
    }
  }

  Widget buildClipPath(
      {required BuildContext context, required Color color, required String text, required Function() onPressed}) {
    return CupertinoButton(
      padding: null,
      onPressed: onPressed,
      child: ClipPath(
        clipper: MyClipper(),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          color: color,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: buildLabel(text: text),
        ),
      ),
    );
  }

  Container buildLabel({required String text}) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: MediaQuery.of(context).size.width * .7,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(text, style: keniaTextStyle(color: Colors.black38)),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * .1, size.height * .5);
    path.lineTo(0, size.height);
    path.lineTo(size.width * .9, size.height);
    path.lineTo(size.width, size.height * .5);
    path.lineTo(size.width * .9, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
