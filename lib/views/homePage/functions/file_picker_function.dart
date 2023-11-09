// ignore_for_file: use_build_context_synchronously

import 'package:cmd/views/homePage/providers/home_page_provider.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controls/constants/text_style_constant.dart';

Future<void> filePickerButton({required BuildContext context}) async {
  final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
  FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
  if (filePickerResult != null) {
    homePageProvider.setFetchedFile(path: filePickerResult.files.single.path!);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Center(child: Text('Please Pick A File', style: keniaTextStyle()))));
  }
  FFprobeKit.getMediaInformation(homePageProvider.fetchedFilePath).then((session) async {
    final information = await session.getMediaInformation();

    if (information == null) {
      homePageProvider.setBeforeEditVideoData(data: 'Error\n+${information!.getAllProperties()}');
    } else {
      homePageProvider.setBeforeEditVideoData(data: information.getAllProperties().toString().replaceAll(',', '\n'));
    }
  });
}
