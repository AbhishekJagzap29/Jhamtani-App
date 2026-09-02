// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jhamtani_app/Api/Apis/api_response.dart';
// import 'package:jhamtani_app/Api/Repo/project_repo.dart';
// import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_category_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_type_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
// import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
// import 'package:jhamtani_app/View/Controller/network_controller.dart';
// import 'package:jhamtani_app/View/Utils/app_layout.dart';

// class HomeScreenController extends GetxController {
//   final searchController = TextEditingController();
//   List<ProjectDetails> projectData = [];
//   List<ProjectDetails> searchDataList = [];
//   bool sync = false;
//   bool loading = false;

//   NetworkController networkController = Get.put(NetworkController());

//   updateSync(value) {
//     sync = value;
//     update();
//   }

//   getData() async {
//     await getAssignedProjectController();
//   }

//   searchData() {
//     if (searchController.text.isNotEmpty) {
//       searchDataList = [];
//       for (var element in projectData) {
//         if (element.name
//             .toString()
//             .toLowerCase()
//             .contains(searchController.text.toString().toLowerCase())) {
//           searchDataList.add(element);
//         }
//       }
//     } else {
//       searchDataList = projectData;
//     }
//     update();
//   }

//   /// API

//   ApiResponse _getAssignedProjectResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getAssignedProjectResponse => _getAssignedProjectResponse;

//   Future<dynamic> getAssignedProjectController() async {
//     if (projectData.isNotEmpty && searchDataList.isNotEmpty) {
//       return;
//     }
//     _getAssignedProjectResponse = ApiResponse.loading(message: 'Loading');

//     update();
//     projectData = [];
//     searchDataList = [];
//     try {
//       AssignedProjectResponseModel response =
//           await ProjectRepo().getAssignedProjectRepo();
//       projectData = response.projectData!;
//       searchDataList = projectData;

//       _getAssignedProjectResponse = ApiResponse.complete(response);
//     } catch (e) {
//       _getAssignedProjectResponse = ApiResponse.error(message: e.toString());
//       log("ProjectScreenController=ERROR=>$e");
//     }
//     update();
//   }

//   changeSyncStatus() {
//     sync = false;
//     String rowData =
//         preferences.getString(SharedPreference.savedActivityData) ?? "";
//     print('rowData::::::::::::::::$rowData');
//     if (rowData.isNotEmpty) {
//       sync = true;
//     }
//     update();
//   }

//   bool syncing = false;

//   syncData() async {
//     syncing = true;
//     update();
//     String rowData =
//         preferences.getString(SharedPreference.savedActivityData) ?? "";
//     if (rowData.isNotEmpty) {
//       List data = jsonDecode(rowData);
//       for (var i = 0; i < data.length; i++) {
//         Map<String, dynamic> body = {
//           "user_id": data[i]["user_id"],
//           "is_draft": data[i]["is_draft"],
//           "activity_type_id": data[i]["activity_type_id"],
//           "checklist_line": data[i]["checklist_line"],
//           "overall_remarks": data[i]["overall_remarks"],
//           "overall_images": data[i]["overall_images"],
//         };
//         await uploadData(body: body);
//         if (i + 1 == data.length) {
//           preferences.removePreference(SharedPreference.savedActivityData);
//           preferences.removePreference(SharedPreference.activityData);
//           successSnackBar("Synced", "Data synced successfully");
//         }
//       }
//     }
//     sync = false;
//     syncing = false;
//     update();
//   }

//   ApiResponse _uploadDataApiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get uploadDataApiResponse => _uploadDataApiResponse;

//   uploadData({required Map<String, dynamic> body}) async {
//     _uploadDataApiResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       SuccessDataResponseModel response =
//           await ProjectRepo().updateChecklistRepo(body: body);
//       _uploadDataApiResponse = ApiResponse.complete(response);

//       log("_makerUploadDataApiResponse==>$response");
//     } catch (e) {
//       _uploadDataApiResponse = ApiResponse.error(message: e.toString());
//       log("_makerUploadDataApiResponse=ERROR=>$e");
//     }
//   }

//   /// get Issue Category and types

//   ApiResponse _issueDataResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get issueDataResponse => _issueDataResponse;

//   List<IssueCategoryData> issueCategoryList = [];
//   List<IssueTypeData> issueTypeList = [];

//   /// Combined data structure: each category with its issue types
//   List<Map<String, dynamic>> categoryWithTypes = [];

//   Future<void> fetchAndStoreIssueData() async {
//     _issueDataResponse = ApiResponse.loading(message: 'Loading...');
//     update();

//     try {
//       // 🔹 Step 0: Load local storage if exists
//       String? localData =
//           preferences.getString(SharedPreference.issueCategoriesWithTypes);
//       if (localData != null && localData.isNotEmpty) {
//         List<dynamic> decoded = jsonDecode(localData);
//         categoryWithTypes = decoded.map<Map<String, dynamic>>((item) {
//           return {
//             "category": item["category"],
//             "types": item["types"],
//           };
//         }).toList();
//       }

//       // 🔹 Step 1: Fetch issue categories from API
//       IssueCategoryResponseModel categoryResponse =
//           await ProjectRepo().issueCategoryRepo();

//       if (categoryResponse.data != null && categoryResponse.data!.isNotEmpty) {
//         issueCategoryList = categoryResponse.data!;

//         // 🔹 Step 2: Check each category against local storage
//         for (var category in issueCategoryList) {
//           bool existsInLocal = categoryWithTypes.any((item) {
//             return item["category"]["name"]?.toString() == category.name;
//           });

//           if (!existsInLocal) {
//             // If new category, fetch its types
//             IssueTypeResponseModel typeResponse =
//                 await ProjectRepo().issueTypeRepo(
//               body: {"issue_category_id": category.id},
//             );

//             List<IssueTypeData> types = [];
//             if (typeResponse.data != null && typeResponse.data!.isNotEmpty) {
//               types = typeResponse.data!;
//             }

//             categoryWithTypes.add({
//               "category": category.toJson(),
//               "types": types.map((t) => t.toJson()).toList(),
//             });
//           }
//         }

//         // 🔹 Step 3: Store updated combined data in local storage
//         String encodedData = jsonEncode(categoryWithTypes);
//         log('issueCategoriesWithTypes::::STORE_IN_LOCALLY::::$encodedData');
//         preferences.putString(
//             SharedPreference.issueCategoriesWithTypes, encodedData);

//         _issueDataResponse = ApiResponse.complete(categoryWithTypes);
//       } else {
//         _issueDataResponse =
//             ApiResponse.error(message: 'No issue categories found');
//       }
//     } catch (e, st) {
//       log("❌ Error fetching issue categories/types: $e");
//       log("Stacktrace: $st");
//       _issueDataResponse = ApiResponse.error(message: e.toString());
//     }

//     update();
//   }

//   /// Optional: read back from local storage
//   void loadIssueDataFromLocal() {
//     String? resData =
//         preferences.getString(SharedPreference.issueCategoriesWithTypes);
//     if (resData != null && resData.isNotEmpty) {
//       List<dynamic> decoded = jsonDecode(resData);
//       categoryWithTypes = decoded.map<Map<String, dynamic>>((item) {
//         return {
//           "category": item["category"],
//           "types": item["types"],
//         };
//       }).toList();

//       _issueDataResponse = ApiResponse.complete(categoryWithTypes);
//       update();
//     }
//   }
// }

/// Updated file for offline img
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_category_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/issue_type_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'dart:io'; // For File

class HomeScreenController extends GetxController {
  final searchController = TextEditingController();
  List<ProjectDetails> projectData = [];
  List<ProjectDetails> searchDataList = [];
  bool sync = false;
  bool loading = false;

  NetworkController networkController = Get.put(NetworkController());

  updateSync(value) {
    sync = value;
    update();
  }

  getData() async {
    await getAssignedProjectController();
  }

  searchData() {
    if (searchController.text.isNotEmpty) {
      searchDataList = [];
      for (var element in projectData) {
        if (element.name
            .toString()
            .toLowerCase()
            .contains(searchController.text.toString().toLowerCase())) {
          searchDataList.add(element);
        }
      }
    } else {
      searchDataList = projectData;
    }
    update();
  }

  /// API

  ApiResponse _getAssignedProjectResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAssignedProjectResponse => _getAssignedProjectResponse;

  Future<dynamic> getAssignedProjectController() async {
    if (projectData.isNotEmpty && searchDataList.isNotEmpty) {
      return;
    }
    _getAssignedProjectResponse = ApiResponse.loading(message: 'Loading');

    update();
    projectData = [];
    searchDataList = [];
    try {
      AssignedProjectResponseModel response =
          await ProjectRepo().getAssignedProjectRepo();
      projectData = response.projectData!;
      searchDataList = projectData;

      _getAssignedProjectResponse = ApiResponse.complete(response);
    } catch (e) {
      _getAssignedProjectResponse = ApiResponse.error(message: e.toString());
      log("ProjectScreenController=ERROR=>$e");
    }
    update();
  }

  changeSyncStatus() {
    sync = false;
    String rowData =
        preferences.getString(SharedPreference.savedActivityData) ?? "";
    log('savedActivityData length: ${rowData.length}');
    if (rowData.isNotEmpty) {
      sync = true;
    }
    log('changeSyncStatus sync: $sync');
    update();
  }

  bool syncing = false;

  // syncData() async {
  //   syncing = true;
  //   update();
  //   String rowData =
  //       preferences.getString(SharedPreference.savedActivityData) ?? "";
  //   if (rowData.isNotEmpty) {
  //     List data = jsonDecode(rowData);
  //     for (var i = 0; i < data.length; i++) {
  //       Map<String, dynamic> body = {
  //         "user_id": data[i]["user_id"],
  //         "is_draft": data[i]["is_draft"],
  //         "activity_type_id": data[i]["activity_type_id"],
  //         "checklist_line": data[i]["checklist_line"],
  //         "overall_remarks": data[i]["overall_remarks"],
  //         "overall_images": data[i]["overall_images"],
  //       };
  //       await uploadData(body: body);
  //       if (i + 1 == data.length) {
  //         preferences.removePreference(SharedPreference.savedActivityData);
  //         preferences.removePreference(SharedPreference.activityData);
  //         successSnackBar("Synced", "Data synced successfully");
  //       }
  //     }
  //   }
  //   sync = false;
  //   syncing = false;
  //   update();
  // }
  syncData() async {
    syncing = true;
    update();
    String rowData =
        preferences.getString(SharedPreference.savedActivityData) ?? "";
    log('syncData started, savedActivityData length: ${rowData.length}');
    try {
      if (rowData.isNotEmpty) {
        List data = jsonDecode(rowData);
        log('syncData offline records: ${data.length}');
        for (var i = 0; i < data.length; i++) {
          log('syncData processing record ${i + 1}/${data.length}');
          // Convert local image paths to base64 strings
          List<String> overallImagesBase64 = [];
          List<String> imagePaths =
              List<String>.from(data[i]["overall_images"] ?? []);
          for (String path in imagePaths) {
            try {
              File imageFile = File(path);
              if (await imageFile.exists()) {
                List<int> imageBytes = await imageFile.readAsBytes();
                String base64Image =
                    base64Encode(imageBytes); // Encode to base64
                overallImagesBase64.add(base64Image);
                // Optional: Delete local file after reading to save space
                // await imageFile.delete();
              } else {
                log("Warning: Image file not found at $path");
              }
            } catch (e) {
              log("Error reading image at $path: $e");
              // Optionally, skip or add a placeholder
            }
          }

          Map<String, dynamic> body = {
            "user_id": data[i]["user_id"],
            "is_draft": data[i]["is_draft"],
            "activity_type_id": data[i]["activity_type_id"],
            "checklist_line": data[i]["checklist_line"],
            "overall_remarks": data[i]["overall_remarks"],
            "overall_images":
                overallImagesBase64, // Use base64 list instead of paths
          };
          await uploadData(body: body);
          if (i + 1 == data.length) {
            preferences.removePreference(SharedPreference.savedActivityData);
            preferences.removePreference(SharedPreference.activityData);
            successSnackBar("Synced", "Data synced successfully");
          }
        }
      }
    } catch (e, st) {
      log('syncData error: $e');
      log('syncData stacktrace: $st');
    }
    sync = false;
    syncing = false;
    update();
    log('syncData finished');
  }

  ApiResponse _uploadDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get uploadDataApiResponse => _uploadDataApiResponse;

  uploadData({required Map<String, dynamic> body}) async {
    _uploadDataApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      SuccessDataResponseModel response =
          await ProjectRepo().updateChecklistRepo(body: body);
      _uploadDataApiResponse = ApiResponse.complete(response);

      log("_makerUploadDataApiResponse==>$response");
    } catch (e) {
      _uploadDataApiResponse = ApiResponse.error(message: e.toString());
      log("_makerUploadDataApiResponse=ERROR=>$e");
    }
  }

  /// get Issue Category and types

  ApiResponse _issueDataResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get issueDataResponse => _issueDataResponse;

  List<IssueCategoryData> issueCategoryList = [];
  List<IssueTypeData> issueTypeList = [];

  /// Combined data structure: each category with its issue types
  List<Map<String, dynamic>> categoryWithTypes = [];

  Future<void> fetchAndStoreIssueData() async {
    _issueDataResponse = ApiResponse.loading(message: 'Loading...');
    update();

    try {
      // 🔹 Step 0: Load local storage if exists
      String? localData =
          preferences.getString(SharedPreference.issueCategoriesWithTypes);
      if (localData != null && localData.isNotEmpty) {
        List<dynamic> decoded = jsonDecode(localData);
        categoryWithTypes = decoded.map<Map<String, dynamic>>((item) {
          return {
            "category": item["category"],
            "types": item["types"],
          };
        }).toList();
      }

      // 🔹 Step 1: Fetch issue categories from API
      IssueCategoryResponseModel categoryResponse =
          await ProjectRepo().issueCategoryRepo();

      if (categoryResponse.data != null && categoryResponse.data!.isNotEmpty) {
        issueCategoryList = categoryResponse.data!;

        // 🔹 Step 2: Check each category against local storage
        for (var category in issueCategoryList) {
          bool existsInLocal = categoryWithTypes.any((item) {
            return item["category"]["name"]?.toString() == category.name;
          });

          if (!existsInLocal) {
            // If new category, fetch its types
            IssueTypeResponseModel typeResponse =
                await ProjectRepo().issueTypeRepo(
              body: {"issue_category_id": category.id},
            );

            List<IssueTypeData> types = [];
            if (typeResponse.data != null && typeResponse.data!.isNotEmpty) {
              types = typeResponse.data!;
            }

            categoryWithTypes.add({
              "category": category.toJson(),
              "types": types.map((t) => t.toJson()).toList(),
            });
          }
        }

        // 🔹 Step 3: Store updated combined data in local storage
        String encodedData = jsonEncode(categoryWithTypes);
        log('issueCategoriesWithTypes::::STORE_IN_LOCALLY::::$encodedData');
        preferences.putString(
            SharedPreference.issueCategoriesWithTypes, encodedData);

        _issueDataResponse = ApiResponse.complete(categoryWithTypes);
      } else {
        _issueDataResponse =
            ApiResponse.error(message: 'No issue categories found');
      }
    } catch (e, st) {
      log("❌ Error fetching issue categories/types: $e");
      log("Stacktrace: $st");
      _issueDataResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }

  /// Optional: read back from local storage
  void loadIssueDataFromLocal() {
    String? resData =
        preferences.getString(SharedPreference.issueCategoriesWithTypes);
    if (resData != null && resData.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(resData);
      categoryWithTypes = decoded.map<Map<String, dynamic>>((item) {
        return {
          "category": item["category"],
          "types": item["types"],
        };
      }).toList();

      _issueDataResponse = ApiResponse.complete(categoryWithTypes);
      update();
    }
  }
}
