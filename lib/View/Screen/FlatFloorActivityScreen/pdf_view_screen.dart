// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:jhamtani_app/View/Widgets/app_bar.dart';
// import 'package:jhamtani_app/View/utils/extension.dart';

// class PdfViewScreen extends StatefulWidget {
//   const PdfViewScreen({super.key});

//   @override
//   State<PdfViewScreen> createState() => _PdfViewScreen();
// }

// class _PdfViewScreen extends State<PdfViewScreen> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

//   String title = Get.arguments;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarWidget(
//         title: title.boldRobotoTextStyle(fontSize: 18),
//       ),
//       body: SfPdfViewer.network(
//         'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
//         key: _pdfViewerKey,
//       ),
//     );
//   }
// }














import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:jhamtani_app/View/Screen/FlatFloorActivityScreen/pdf_view_controller.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/utils/extension.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({super.key});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreen();
}

class _PdfViewScreen extends State<PdfViewScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  late final String title;
  late final int visitId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    title = args['title'] ?? 'PDF Viewer';
    visitId = args['visitId'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: title.boldRobotoTextStyle(fontSize: 18),
        action: [
          IconButton(
            icon: const Icon(Icons.download, size: 22),
            onPressed: () {
             DownloadPdfController().downloadAndOpenPdf( visitId: visitId); 
            },
            tooltip: 'Download PDF',
          ),
        ],
      ),
      body: SfPdfViewer.network(
        'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}
