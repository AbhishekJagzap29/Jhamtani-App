//Updated Code 22/12
// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/generate_nc_floor_res_model.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/app_string.dart';
import 'package:jhamtani_app/View/Constant/responsive.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_controller.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generate_nc_details_screen.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
//21/02/26
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


class GenerateNcScreen extends StatefulWidget {
  final int project_id;
  final int tower_id;
  final int patn_id;
  final int id;
  final int activity_id;
  final int floor_id;
  final int flat_id;
  final int projectresId;
  final String description;
  final String flag_category;
  final String status;

  GenerateNcScreen({
    required this.project_id,
    required this.tower_id,
    required this.patn_id,
    required this.id,
    required this.projectresId,
    required this.activity_id,
    required this.flat_id,
    required this.floor_id,
    required this.description,
    required this.flag_category,
    required this.status,
  });

  @override
  _GenerateNcScreenState createState() => _GenerateNcScreenState();
}

bool isLoading = false;

class _GenerateNcScreenState extends State<GenerateNcScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedProject;
  String? selectedTower;
  String? selectedFloor;
  String? selectedFlat;
  String? selectedFlagCategory;
  String? selectedActivity;
  String? selectedActivityType;
  String? selectedChecklistLine;
  String? selectedProjectResponsible;

  final TextEditingController descriptionController = TextEditingController();
  String selectedStep = 'Draft';
  DateTime? selectedDate;
  //File? _selectedImage;
  List<File> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  bool isOtherSelected = false;
  TextEditingController otherController = TextEditingController();

  final GenerateNcController controller = Get.put(GenerateNcController());

  Future<void> _pickImage(ImageSource source) async {
    //  Limit check
    if (_selectedImages.length >= 5) {
      //errorSnackBar("Error", "You can only capture up to 5 photos.");
      errorSnackBar(
          "", "You've reached the limit — you can attach up to 5 photos only.");
      return;
    }

    // final XFile? pickedImage = await _picker.pickImage(source: source);
    //02/01/26
    final XFile? pickedImage = await _picker.pickImage(
      source: source,
      imageQuality: 60, //  compress image at capture time
    );
//=========================
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      //  Open Pen Remark editor
      final editedImage = await _openPenRemarkEditor(imageFile);

      if (editedImage != null) {
        setState(() {
          _selectedImages.add(editedImage);
        });
      }
    }
  }

  //03/01/26
  Future<Uint8List> _compressImage(File file) async {
    return await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          quality: 60,
          minWidth: 1280,
          minHeight: 1280,
        ) ??
        await file.readAsBytes();
  }

  ///=========================
  ///21/02/26
  Future<void> _downloadImage(File imageFile) async {
  await Permission.photos.request();
  await Permission.storage.request();

  try {
    Uint8List bytes = await imageFile.readAsBytes();

    await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: "NC_${DateTime.now().millisecondsSinceEpoch}",
    );

    successSnackBar("Success", "Image saved to gallery");
  } catch (e) {
    errorSnackBar("Error", "Failed to download image");
  }
}
///=============================================

// view captured image in a dialog
  void _viewCapturedImage(File imageFile) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: Stack(
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(imageFile, fit: BoxFit.contain),
              ),
            ), 
            //21/02/26
             // ⬇ DOWNLOAD BUTTON (TOP LEFT)
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              icon: Icon(Icons.download, color: Colors.white, size: 28),
              onPressed: () {
                _downloadImage(imageFile);
              },
            ),
          ),
          //=========================
             Positioned(
              left: 10,
              top: 10,
              child: IconButton(
                icon: Icon(Icons.download, color: Colors.white, size: 28),
                onPressed: () => _downloadImage(imageFile),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
//

  Future<List<String>> _uploadImage() async {
    List<String> base64Images = [];

    try {
      for (var img in _selectedImages) {
        // Uint8List imageBytes = await img.readAsBytes();
        // base64Images.add('data:image/jpeg;base64,${base64Encode(imageBytes)}');
        //03/01/26
        Uint8List imageBytes = await _compressImage(img);
        base64Images.add('data:image/jpeg;base64,${base64Encode(imageBytes)}');
/////
      }
    } catch (e) {
      print("Error encoding images: $e");
    }

    return base64Images;
  }

  // Future<File?> _openPenRemarkEditor(File imageFile) async {
  //   final GlobalKey<ImagePainterState> painterKey =
  //       GlobalKey<ImagePainterState>();

  //   // IMPORTANT: capture parent context BEFORE opening dialog
  //   final parentContext = context;

  //   return await showDialog<File?>(
  //     context: parentContext,
  //     barrierDismissible: false,
  //     builder: (_) {
  //       return StatefulBuilder(builder: (dialogContext, setState) {
  //         return Dialog(
  //           insetPadding: const EdgeInsets.all(10),
  //           backgroundColor: Colors.white,
  //           child: Column(
  //             children: [
  //               // Header
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(dialogContext).pop();
  //                     },
  //                     child: const Text("Cancel",
  //                         style: TextStyle(color: Colors.red)),
  //                   ),
  //                   const Text(
  //                     "Pen Remark",
  //                     style:
  //                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),
  //                   TextButton(
  //                     onPressed: () async {
  //                       try {
  //                         final bytes =
  //                             await painterKey.currentState?.exportImage();

  //                         // DO NOT use "context" here
  //                         // USE dialogContext instead
  //                         if (bytes != null) {
  //                           final directory =
  //                               await getApplicationDocumentsDirectory();
  //                           final String filePath =
  //                               '${directory.path}/edited_${DateTime.now().millisecondsSinceEpoch}.png';

  //                           File editedFile = File(filePath);
  //                           await editedFile.writeAsBytes(bytes);

  //                           Navigator.of(dialogContext).pop(editedFile);
  //                         } else {
  //                           Navigator.of(dialogContext).pop(imageFile);
  //                         }
  //                       } catch (e) {
  //                         Navigator.of(dialogContext).pop(imageFile);
  //                       }
  //                     },
  //                     child: const Text("Save",
  //                         style: TextStyle(color: Colors.blue)),
  //                   ),
  //                 ],
  //               ),

  //               Expanded(
  //                 child: ImagePainter.file(
  //                   imageFile,
  //                   key: painterKey,
  //                   scalable: true,
  //                   initialStrokeWidth: 2,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }
  //31/12
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
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: isSaving
                              ? null
                              : () => Navigator.of(dialogContext).pop(),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
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
                                    final Uint8List? bytes = await painterKey
                                        .currentState
                                        ?.exportImage();

                                    if (bytes != null) {
                                      //  FAST SAVE
                                      final dir = await getTemporaryDirectory();
                                      final path =
                                          '${dir.path}/pen_${DateTime.now().millisecondsSinceEpoch}.jpg';

                                      final File editedFile = File(path);
                                      await editedFile.writeAsBytes(
                                        bytes,
                                        flush: false, //  faster
                                      );

                                      Navigator.of(dialogContext)
                                          .pop(editedFile);
                                    } else {
                                      Navigator.of(dialogContext)
                                          .pop(imageFile);
                                    }
                                  } catch (e) {
                                    Navigator.of(dialogContext).pop(imageFile);
                                  }
                                },
                          child:
                              // isSaving
                              //     ? const SizedBox(
                              //         height: 18,
                              //         width: 18,
                              //         child:
                              //             CircularProgressIndicator(strokeWidth: 2),
                              //       )
                              //     :
                              const Text(
                            "Save",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // IMAGE + LOADING OVERLAY
                  Expanded(
                    child: Stack(
                      children: [
                        ImagePainter.file(
                          imageFile,
                          key: painterKey,
                          scalable: true,
                          initialStrokeWidth: 2,
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
//=============================

  void _showSnackbar(String message, {bool isSuccess = true}) {
    if (isSuccess) {
      successSnackBar("Success", message);
    } else {
      errorSnackBar("Error", message);
    }
  }

  Future<void> _submitForm() async {
    // if (_formKey.currentState?.validate() ?? false)
    //  {
    if (descriptionController.text.trim().isEmpty) {
      errorSnackBar(
        "Error",
        "Checker/Approver Remark is required",
      );
      return;
    }

    //  Checker/Approver Image validation
    if (_selectedImages.isEmpty) {
      errorSnackBar(
        "Error",
        "Checker/Approver image is required",
      );
      return;
    }
    {
      try {
        //String? base64Image = await _uploadImage();
        List<String> base64Images = await _uploadImage();

        Map<String, dynamic> body = {
          'status': 'open',
          'project_id': widget.project_id,
          'tower_id': widget.tower_id,
          'floor_id': widget.floor_id,
          'flat_id': widget.flat_id,
          'activity_id': widget.activity_id,
          'activity_type_id': widget.patn_id,
          'project_responsible_id': widget.projectresId,
          'flag_category': selectedFlagCategory ?? '',
          'description': descriptionController.text,
          //'rectified_image': base64Image ?? '',
          'rectified_image': base64Images.isNotEmpty ? base64Images : [],
          'project_create_date': DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(selectedDate ?? DateTime.now()),
        };
        if (selectedChecklistLine == "Other") {
          body['id'] = null;
          body['name'] = null;
          body['custom_checklist_item'] =
              otherController.text.isNotEmpty ? otherController.text : '';
        } else {
          body['id'] = controller.ncgenerateactivitytypechecklist
              .firstWhere((e) => e.name == selectedChecklistLine)
              .id;
          body['name'] = controller.ncgenerateactivitytypechecklist
              .firstWhere((e) => e.name == selectedChecklistLine)
              .name;
          body['custom_checklist_item'] = null;
        }

        var response = await ProjectRepo().ncsubmitbuttonRepo(body: body);

        print("NC Submit Response: $response"); // Debug log

        if (response != null) {
          final status = response['status']?.toString().toLowerCase() ?? '';
          final message = response['message'] ?? '';

          if (status == 'success') {
            _showSnackbar(
                message.isNotEmpty ? message : 'NC submitted successfully');
            // ✅ fetch updated NC data before navigation
            await controller.fetchAllNcData();
            //12/12
            // if (!mounted) return;
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => GenerateNcDetailsScreen()),
            // );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GenerateNcDetailsScreen(),
              ),
            );
          } else {
            _showSnackbar(
              message.isNotEmpty ? message : 'Submission failed: Unknown error',
              isSuccess: false,
            );
          }
        } else {
          _showSnackbar('Submission failed: Empty response', isSuccess: false);
        }
      } catch (e) {
        _showSnackbar('Form submission failed: $e', isSuccess: false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller.getprojectresponsiblelist();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
        // appBar: AppBarWidget(
        //   title: AppString.generatenc.boldRobotoTextStyle(fontSize: 20),
        // ),
        appBar: AppBarWidget(
  backGroundColor: const Color(0xFF3498DB), // Sky Blue
  title: AppString.generatenc.boldRobotoTextStyle(
    fontSize: 20,
    fontColor: Colors.white,
  ),
),
        body: SafeArea(
            child: GetBuilder<GenerateNcController>(builder: (controller) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateField(),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Flag Category",
                    hintText: "Select flag category",
                    value: selectedFlagCategory,
                    items: [
                      'Nc',
                      'Yellow Flag',
                      'Red Flag',
                      'Orange Flag',
                      'Green Flag'
                    ],
                    onChanged: (value) =>
                        setState(() => selectedFlagCategory = value),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Project Responsible",
                    hintText: "Select user",
                    value: selectedProjectResponsible,
                    items: controller.ncGenerateProjectResponsible.isNotEmpty
                        ? controller.ncGenerateProjectResponsible
                            .map((e) => e.name)
                            .toList()
                        : ["Loading...."],
                    onChanged: (value) {
                      setState(() {
                        selectedProjectResponsible = value;
                        controller.getprojectresponsiblelist();

                        if (controller
                            .ncGenerateProjectResponsible.isNotEmpty) {
                          final selectedResponsible = controller
                              .ncGenerateProjectResponsible
                              .firstWhere(
                            (e) => e.name == value,
                            // orElse: () => null,
                          );
                          if (selectedResponsible != null) {
                            controller.projectresId =
                                selectedResponsible.projectresId;
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Project Name",
                    hintText: "Select project",
                    value: selectedProject,
                    items: controller.ncgenerate.isNotEmpty
                        ? controller.ncgenerate
                            .map((e) => e.project_name)
                            .toList()
                        : ["Loading..."],
                    onChanged: (value) {
                      setState(() {
                        selectedProject = value;
                        controller.project_id = controller.ncgenerate
                            .firstWhere((e) => e.project_name == value)
                            .project_id;
                        controller.gettowerlist();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Tower Name",
                    hintText: "Select tower",
                    value: selectedTower,
                    items: controller.ncgeneratetower.isNotEmpty
                        ? controller.ncgeneratetower
                            .map((e) => e.tower_name)
                            .toList()
                        : ["Loading...."],
                    onChanged: (value) {
                      setState(() {
                        selectedTower = value;
                        controller.tower_id = controller.ncgeneratetower
                            .firstWhere((e) => e.tower_name == value)
                            .tower_id;
                        controller.getfloorlist();
                        controller.getflatlist();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Floor Name",
                    hintText: "Select floor",
                    value: selectedFloor,
                    items: controller.ncgeneratefloor.isNotEmpty
                        ? controller.ncgeneratefloor
                            .map((e) => e.floor_name)
                            .toList()
                        : ["No Floors available"],
                    onChanged: (value) {
                      setState(() {
                        selectedFloor = value;
                        // controller.floor_id = controller.ncgeneratefloor
                        //     .firstWhere((e) => e.floor_name == value)
                        //     .floor_id;
                        //07/01/26
                        NcGenerateFloor? floor;
try {
  floor = controller.ncgeneratefloor
      .firstWhere((e) => e.floor_name == value);
} catch (e) {
  floor = null;
}
controller.floor_id = floor?.floor_id;
///=====================================
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Flat Name",
                    hintText: "Select flat",
                    value: selectedFlat,
                    items: controller.ncgenerateflat.isNotEmpty
                        ? controller.ncgenerateflat
                            .map((e) => e.flat_name)
                            .toList()
                        : ["No Flats available"],
                    onChanged: (value) {
                      setState(() {
                        selectedFlat = value;
                        controller.flat_id = controller.ncgenerateflat
                            .firstWhere((e) => e.flat_name == value)
                            .flat_id;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Project Activity",
                    hintText: "Select activity",
                    value: selectedActivity,
                    items: controller.ncgenerateactivity.isNotEmpty
                        ? controller.ncgenerateactivity
                            .map((e) => e.name)
                            .toList()
                        : ["Loading...."],
                    onChanged: (value) {
                      setState(() {
                        selectedActivity = value;
                        controller.getActivitylist();
                        controller.activity_id = controller.ncgenerateactivity
                            .firstWhere((e) => e.name == value)
                            .activity_id;
                        controller.getActivityTypelist();
                      });
                    },
                    // //03/12
                    // onChanged: (value) {
                    //   setState(() {
                    //     selectedActivityType = value;
                    //     controller.patn_id = controller.ncgenerateactivitytype
                    //         .firstWhere((e) => e.name == value)
                    //         .patn_id;

                    //     controller.getActivityTypeCheklistlist();
                    //   });
                    // }

//=====================================>
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: "Project Activity Type",
                    hintText: "Select activity type",
                    value: selectedActivityType,
                    items: controller.ncgenerateactivitytype.isNotEmpty
                        ? controller.ncgenerateactivitytype
                            .map((e) => e.name)
                            .toList()
                        : ["Loading...."],
                    onChanged: (value) {
                      setState(() {
                        selectedActivityType = value;
                        controller.patn_id = controller.ncgenerateactivitytype
                            .firstWhere((e) => e.name == value)
                            .patn_id;
                        controller.getActivityTypeCheklistlist();
                      });
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  _buildDropdownField(
                    label: "Checklist Line",
                    hintText: "Select checklist line",
                    value: selectedChecklistLine,
                    items: [
                      ...controller.ncgenerateactivitytypechecklist
                          .map((e) => e.name)
                          .toList(),
                      "Other"
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedChecklistLine = value;
                        isOtherSelected = value == "Other";

                        if (!isOtherSelected) {
                          controller.id = controller
                              .ncgenerateactivitytypechecklist
                              .firstWhere((e) => e.name == value)
                              .id;
                        } else {
                          controller.id = null;
                        }
                      });
                    },
                  ),
                  if (isOtherSelected)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: otherController,
                        decoration: InputDecoration(
                          labelText: "Enter custom checklist item",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: h * 0.02),
                  _buildDescriptionField(
                   label: "Checker/Approver Remarks",
                  // label: AppString.checkerApproverRemarks,
                    hintText: "Add description",
                    controller: descriptionController,
                    maxLine: 2,
                  ),
                  SizedBox(height: h * 0.02),
                  Text(
                    "Checker/Approver Images:",
                 // AppString.checkerApproverImages,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text("Capture"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo),
                        label: Text("Select"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          final imgFile = _selectedImages[index];
                          return GestureDetector(
                            onTap: () => _viewCapturedImage(
                                imgFile), //  Tap to open image
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(imgFile),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  top: 5, // 🔹 changed from bottom: 5 to top: 5
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.redAccent,
                                      radius: 14,
                                      child: Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: h * 0.015, bottom: h * 0.02),
                      child: GestureDetector(
                        // onTap: () async {
                        //   // if (!mounted) return;
                        //   setState(() {
                        //     isLoading = true;
                        //   });
                        //   //remove this for avoid delay to generate nc from checker/approver
                        //   //  await Future.delayed(const Duration(seconds: 2));
                        //   await _submitForm();
                        //   //  if (!mounted) return;
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        // },

                        //02/01/26
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          await _submitForm();

                          setState(() {
                            isLoading = false;
                          });
                        },

//===================>
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )
                            : Container(
                                //child: Container(
                                height: Responsive.isDesktop(context)
                                    ? h * 0.078
                                    : h * 0.058,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: backGroundColor,
                                    ),
                                  ),
                                ),
                              ),
                      )),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                      //23/12
                      Get.back();
                    },
                    child: Container(
                      height:
                          Responsive.isDesktop(context) ? h * 0.078 : h * 0.058,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: backGroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        })));
  }

  Widget _buildDropdownField({
    required String label,
    required dynamic value,
    required List<dynamic> items,
    required ValueChanged<dynamic> onChanged,
    String Function(dynamic)? displayText,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        DropdownSearch<dynamic>(
          items: items,
          selectedItem: value,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: hintText,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search here...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDescriptionField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required int maxLine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadRow() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.image, color: Colors.grey),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.image, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "Select Date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color:
                        selectedDate != null ? Colors.black : Colors.grey[600],
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[800], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

