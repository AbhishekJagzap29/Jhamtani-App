// import 'dart:developer';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:jhamtani_app/Api/Repo/project_repo.dart';
// import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/download_pdf_res_model.dart';
// import 'package:jhamtani_app/View/Utils/app_layout.dart';
// import 'dart:convert';

// class DownloadPdfController extends GetxController {
//   Future<void> downloadAndOpenPdf({required int visitId}) async {
//     try {
//       final response = await ProjectRepo().downloadPdfForHQIRepo(
//         body: {"visit_id": visitId},
//       );

//       if (response is DownloadPdfResponseModel && response.pdfBase64 != null) {
//         final bytes = base64Decode(response.pdfBase64!);

//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = '${directory.path}/HQI_Visit_$visitId.pdf';
//         final file = File(filePath);

//         await file.writeAsBytes(bytes);
//         await OpenFile.open(file.path);
//       } else {
//         errorSnackBar("Download Failed", "PDF data missing");
//       }
//     } catch (e) {
//       log("Error in downloadAndOpenPdf: $e");
//       errorSnackBar("Error", e.toString());
//     }
//   }
// }










import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/download_pdf_res_model.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart'; // Assuming this contains `errorSnackBar`

class DownloadPdfController extends GetxController {
  Future<void> downloadAndOpenPdf({required int visitId}) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Download PDF response
      final response = await ProjectRepo().downloadPdfForHQIRepo(
        body: {"visit_id": visitId},
      );

      if (response is DownloadPdfResponseModel && response.pdfBase64 != null) {
        final bytes = base64Decode(response.pdfBase64!);

        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/HQI_Visit_$visitId.pdf';
        final file = File(filePath);

        await file.writeAsBytes(bytes);

        // Open the PDF file
        await OpenFile.open(file.path);
      } else {
        errorSnackBar("Download Failed", "PDF data missing");
      }
    } catch (e) {
      log("Error in downloadAndOpenPdf: $e");
      errorSnackBar("Error", e.toString());
    } finally {
      // Close the loading dialog if it's open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }






  Future<void> downloadAndOpenPdfForFlat({required String flatId}) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ProjectRepo().downloadPdfForHqiFlatRepo(
        body: {"flat_id": flatId},
      );

      if (response is DownloadPdfResponseModel && response.pdfBase64 != null) {
        final bytes = base64Decode(response.pdfBase64!);
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/HQI_Flat_$flatId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);
      } else {
        errorSnackBar("Download Failed", "PDF data missing");
      }
    } catch (e) {
      log("Error in downloadAndOpenPdfForFlat: $e");
      errorSnackBar("Error", e.toString());
    } finally {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }
}




















