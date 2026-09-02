import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:jhamtani_app/View/Constant/app_assets.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/image_capture__screen_controller.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class ImageCaptureScreen extends StatefulWidget {
  final File image;
  final String title;

  const ImageCaptureScreen({super.key, required this.image, required this.title});

  @override
  State<ImageCaptureScreen> createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  ImageCaptureScreenController imageCaptureScreenController = Get.put(ImageCaptureScreenController());
  final _imageKey = GlobalKey<ImagePainterState>();
  bool isEdit = false;
  String imagePath = "";
  File? cropImage;
  ScreenshotController screenshotController = ScreenshotController();

  void saveScreenShort() async {
    imageCaptureScreenController.loader(true);
    Uint8List? image = await screenshotController.capture();

    if (image != null) {
      final Completer<ui.Image> completer = Completer();
      ui.decodeImageFromList(image, (img) {
        completer.complete(img);
      });
      ui.Image capturedImage = await completer.future;

      double cropTopHeight = isEdit ? 180 : 0;
      double cropBottomHeight = isEdit ? 40 : 60;
      double cropLeftWidth = 10;
      double cropRightWidth = 10;

      final newWidth = capturedImage.width - cropLeftWidth - cropRightWidth;
      final newHeight = capturedImage.height - cropTopHeight - cropBottomHeight;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromPoints(const Offset(0, 0), Offset(newWidth.toDouble(), newHeight.toDouble())),
      );

      canvas.drawImageRect(
        capturedImage,
        Rect.fromLTWH(
          cropLeftWidth,
          cropTopHeight,
          newWidth.toDouble(),
          newHeight.toDouble(),
        ),
        Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()), // Destination rectangle
        Paint(),
      );

      final ui.Image croppedImage = await recorder.endRecording().toImage(newWidth.toInt(), newHeight.toInt());
      final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      await Directory(directory).create(recursive: true);
      final fullPath = '$directory/${DateTime.now().millisecondsSinceEpoch}.png';
      final imgFile = File(fullPath);
      imgFile.writeAsBytesSync(pngBytes);
      imagePath = fullPath;
      imageCaptureScreenController.loader(false);
      log('imagePath::::::::::::::TRUE::${imagePath}');
      Navigator.pop(context, {"image": imagePath});
    } else {
      log('widget.image.path:::::::::::FALSE:::::${widget.image.path}');
      imageCaptureScreenController.loader(false);
      Navigator.pop(context, {"image": widget.image.path});
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Container(
        color: backGroundColor,
        child: Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBarWidget(
            backGroundColor: const Color(0xFF3498DB),
            leadingIcon: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Padding(
                padding: EdgeInsets.only(left: w * 0.03),
                child: const Icon(Icons.arrow_back_ios, size: 22, color: Colors.white),
              ),
            ),
            centerTitle: true,
            title: Padding(
              padding: EdgeInsets.only(top: h * 0.012),
              child: widget.title.boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isEdit ? 0 : h * 0.065,
                  ),
                  Container(
                    height: isEdit ? h * 0.65 : h * 0.585,
                    margin: EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.04),
                    decoration: BoxDecoration(
                      color: containerColor,
                    ),
                    child: isEdit
                        ? Screenshot(
                            controller: screenshotController,
                            child: Stack(
                              children: [
                                ImagePainter.file(
                                  widget.image,
                                  key: _imageKey,
                                  initialPaintMode: PaintMode.freeStyle,
                                  scalable: true,
                                  initialStrokeWidth: 2,
                                  textDelegate: TextDelegate(),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20, bottom: 30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                      decoration:
                                          const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Screenshot(
                            controller: screenshotController,
                            child: Stack(
                              children: [
                                Center(child: Image.file(widget.image, fit: BoxFit.cover)),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    // padding:
                                    //     EdgeInsets.only(top: h * 0.52, left: 20),
                                    padding: const EdgeInsets.only(left: 20, bottom: 50),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                      decoration:
                                          const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          saveScreenShort();
                        },
                        child: Column(
                          children: [
                            Container(
                              height: h * 0.075,
                              width: h * 0.075,
                              decoration: const BoxDecoration(color: appColor, shape: BoxShape.circle),
                              child: Center(
                                child: assetImage(AppAssets.cameraIcon, scale: 2),
                              ),
                            ),
                            8.0.addHSpace(),
                            AppString.sameImage.regularBarlowTextStyle(
                              fontSize: 13,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      (w * 0.2).addWSpace(),
                      GestureDetector(
                        onTap: () {
                          isEdit = !isEdit;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Container(
                              height: h * 0.075,
                              width: h * 0.075,
                              decoration: const BoxDecoration(color: appColor, shape: BoxShape.circle),
                              child: Center(
                                child: !isEdit
                                    ? assetImage(AppAssets.editIcon, scale: 2)
                                    : const Icon(Icons.cancel_outlined, color: Colors.white),
                              ),
                            ),
                            8.0.addHSpace(),
                            !isEdit
                                ? AppString.penRemark.regularBarlowTextStyle(
                                    fontSize: 13,
                                    textAlign: TextAlign.center,
                                  )
                                : AppString.cancel.regularBarlowTextStyle(
                                    fontSize: 13,
                                    textAlign: TextAlign.center,
                                  )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              GetBuilder<ImageCaptureScreenController>(builder: (controller) {
                return controller.imageSaver
                    ? Container(
                        color: scaffoldColor.withOpacity(0.4),
                        child: Center(
                          child: CircularProgressIndicator(color: blackColor),
                        ),
                      )
                    : const SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }
}
