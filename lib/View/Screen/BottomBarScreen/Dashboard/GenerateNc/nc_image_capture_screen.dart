// // nc_image_capture_screen.dart

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_painter/image_painter.dart';
// import 'package:path_provider/path_provider.dart';

// class NcImageCaptureWidget extends StatefulWidget {
//   final List<File> initialImages; // Existing images (if any)
//   final Function(List<File>) onImagesUpdated; // Callback to parent screen
//   final String title;

//   const NcImageCaptureWidget({
//     super.key,
//     required this.initialImages,
//     required this.onImagesUpdated,
//     required this.title,
//   });

//   @override
//   _NcImageCaptureWidgetState createState() => _NcImageCaptureWidgetState();
// }

// class _NcImageCaptureWidgetState extends State<NcImageCaptureWidget> {
//   final ImagePicker _picker = ImagePicker();
//   List<File> _images = [];

//   @override
//   void initState() {
//     super.initState();
//     _images = List<File>.from(widget.initialImages);
//   }

//   //   Pick Image with Pen Editor
//   Future<void> _pickImage(ImageSource source) async {
//     if (_images.length >= 5) {
//       _showSnackbar(
//           "You've reacched the limit - you can add up to 5 photos only.");
//       return;
//     }

//     final XFile? picked = await _picker.pickImage(source: source);
//     if (picked == null) return;

//     File original = File(picked.path);
//     File? edited = await _openPenRemarkEditor(original);

//     if (edited != null) {
//       setState(() {
//         _images.add(edited);
//       });
//       widget.onImagesUpdated(_images);
//     }
//   }

//   // Pen Remark Drawing Screen
//   Future<File?> _openPenRemarkEditor(File imageFile) async {
//     final GlobalKey<ImagePainterState> painterKey =
//         GlobalKey<ImagePainterState>();
//     //31/12
//      bool isSaving = false;

//     return await showDialog<File?>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) {
//         return Dialog(
//           insetPadding: const EdgeInsets.all(10),
//           backgroundColor: Colors.white,
//           child: Column(
//             children: [
//               // HEADER
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () =>
//                           // Navigator.pop(dialogContext),
//                           //12/12
//                           Navigator.of(dialogContext, rootNavigator: true)
//                               .pop(),
//                       child: const Text("Cancel",
//                           style: TextStyle(color: Colors.red)),
//                     ),
//                     const Text(
//                       "Pen Remark",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         try {
//                           final imgBytes =
//                               await painterKey.currentState?.exportImage();
//                           if (imgBytes != null) {
//                             final dir =
//                                 await getApplicationDocumentsDirectory();
//                             final path =
//                                 '${dir.path}/pen_edit_${DateTime.now().millisecondsSinceEpoch}.png';

//                             final File edited = File(path);
//                             await edited.writeAsBytes(imgBytes);

//                             // Navigator.pop(dialogContext, edited);
//                             //12/12
//                             Navigator.of(dialogContext, rootNavigator: true)
//                                 .pop(edited);
//                           } else {
//                             Navigator.pop(dialogContext, imageFile);
//                           }
//                         } catch (e) {
//                           Navigator.pop(dialogContext, imageFile);
//                         }
//                       },
//                       child: const Text("Save",
//                           style: TextStyle(color: Colors.blue)),
//                     ),
//                   ],
//                 ),
//               ),

//               // IMAGE PAINTER
//               Expanded(
//                 child: ImagePainter.file(
//                   imageFile,
//                   key: painterKey,
//                   scalable: true,
//                   initialStrokeWidth: 2,
//                   initialPaintMode: PaintMode.freeStyle,
//                 ),
//               ),
//             ],
//           ),
//         );

//       },
//     );
//   }

//   // Full Screen Image Viewer
//   void _viewImage(File file) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.black,
//         insetPadding: EdgeInsets.zero,
//         child: Stack(
//           children: [
//             InteractiveViewer(
//               child: Center(child: Image.file(file, fit: BoxFit.contain)),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white, size: 30),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //  Image Picker UI
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // const Text(
//         //   "Rectified Images",
//         //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         // ),
//         Text(
//           widget.title,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),

//         const SizedBox(height: 10),

//         // SHOW SELECTED IMAGES
//         if (_images.isNotEmpty)
//           SizedBox(
//             height: 160,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _images.length,
//               itemBuilder: (context, index) {
//                 final img = _images[index];
//                 return Stack(
//                   children: [
//                     GestureDetector(
//                       onTap: () => _viewImage(img),
//                       child: Container(
//                         width: 140,
//                         margin: const EdgeInsets.only(right: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           image: DecorationImage(
//                             image: FileImage(img),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),

//                     // DELETE BUTTON
//                     Positioned(
//                       right: 5,
//                       top: 5,
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _images.removeAt(index);
//                           });
//                           widget.onImagesUpdated(_images);
//                         },
//                         child: const CircleAvatar(
//                           radius: 14,
//                           backgroundColor: Colors.redAccent,
//                           child:
//                               Icon(Icons.close, color: Colors.white, size: 16),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),

//         const SizedBox(height: 10),

//         // BUTTONS
//         Row(
//           children: [
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.camera),
//               icon: const Icon(Icons.camera_alt),
//               label: const Text("Capture"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
//             ),
//             const SizedBox(width: 12),
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               icon: const Icon(Icons.photo),
//               label: const Text("Gallery"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   void _showSnackbar(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }

///31/12
// nc_image_capture_screen.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

class NcImageCaptureWidget extends StatefulWidget {
  final List<File> initialImages;
  final Function(List<File>) onImagesUpdated;
  final String title;

  const NcImageCaptureWidget({
    super.key,
    required this.initialImages,
    required this.onImagesUpdated,
    required this.title,
  });

  @override
  _NcImageCaptureWidgetState createState() => _NcImageCaptureWidgetState();
}

class _NcImageCaptureWidgetState extends State<NcImageCaptureWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _images = List<File>.from(widget.initialImages);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) {
      _showSnackbar(
          "You've reacched the limit - you can add up to 5 photos only.");
      return;
    }
    
    // final XFile? picked = await _picker.pickImage(source: source);
    //02/01/26
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 60, //  compress image at capture time
    );
//===================================
    if (picked == null) return;

    File original = File(picked.path);
    File? edited = await _openPenRemarkEditor(original);

    if (edited != null) {
      setState(() {
        _images.add(edited);
      });
      widget.onImagesUpdated(_images);
    }
  }

  //  UPDATED: Pen Remark Editor with Loading + Faster Save
  Future<File?> _openPenRemarkEditor(File imageFile) async {
    final GlobalKey<ImagePainterState> painterKey =
        GlobalKey<ImagePainterState>();

    bool isSaving = false;

    return await showDialog<File?>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(10),
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  // HEADER
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: isSaving
                              ? null
                              : () => Navigator.of(dialogContext,
                                      rootNavigator: true)
                                  .pop(),
                          child: const Text("Cancel",
                              style: TextStyle(color: Colors.red)),
                        ),
                        const Text(
                          "Pen Remark",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  setDialogState(() => isSaving = true);

                                  try {
                                    final Uint8List? imgBytes = await painterKey
                                        .currentState
                                        ?.exportImage();

                                    if (imgBytes != null) {
                                      final dir = await getTemporaryDirectory();
                                      final path =
                                          '${dir.path}/pen_${DateTime.now().millisecondsSinceEpoch}.jpg';

                                      final File edited = File(path);
                                      await edited.writeAsBytes(
                                        imgBytes,
                                        flush: false, // ⚡ faster
                                      );

                                      Navigator.of(dialogContext,
                                              rootNavigator: true)
                                          .pop(edited);
                                    } else {
                                      Navigator.pop(dialogContext, imageFile);
                                    }
                                  } catch (e) {
                                    Navigator.pop(dialogContext, imageFile);
                                  }
                                },
                          child:
                              //  isSaving
                              //     ? const SizedBox(
                              //         height: 18,
                              //         width: 18,
                              //         child:
                              //             CircularProgressIndicator(strokeWidth: 2),
                              //       )
                              //     :
                              const Text("Save",
                                  style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ),

                  // IMAGE PAINTER WITH LOADING OVERLAY
                  Expanded(
                    child: Stack(
                      children: [
                        ImagePainter.file(
                          imageFile,
                          key: painterKey,
                          scalable: true,
                          initialStrokeWidth: 2,
                          initialPaintMode: PaintMode.freeStyle,
                        ),
                        if (isSaving)
                          Container(
                            color: Colors.black45,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _viewImage(File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              child: Center(child: Image.file(file, fit: BoxFit.contain)),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (_images.isNotEmpty)
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final img = _images[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _viewImage(img),
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                          widget.onImagesUpdated(_images);
                        },
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.redAccent,
                          child:
                              Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo),
              label: const Text("Gallery"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
