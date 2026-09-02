// 13 December 2025
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/notification_repo.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/notification_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_details_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:jhamtani_app/Api/ResponseModel/GenerateNcResponseModel/nc_routing_through_notification_res_model.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';

class NotificationController extends GetxController {
  HomeScreenController homeScreenController = Get.find();

  /// Notification data
  List<NotificationData> notificationData = [];
  List<NotificationData> searchNotificationData = [];
  List<NotificationData> notificationFilterData = [];

  final searchController = TextEditingController();

  int selectInspection = 0;
  int selectStatus = 0;

  List<ProjectDetails> projectList = [];
  ProjectDetails? selectedProject;

  List<TowerData> towerList = [];
  TowerData? selectedTower;

  ProjectDetailsResponseModel? projectDetailsRes;
  GetTowerInfoChecklistResponseModel? towerDataRes;

  List checklistStatusList1 = ["Submit", "Checked", "Approved"];
  String selectedCheckListStatus = '';
  bool isFilterApply = false;

  /// --- VB NC Routing Integration ---
  ApiResponse _ncRoutingResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get ncRoutingResponse => _ncRoutingResponse;

  Future<void> getNcRoutingForNotification(int ncId) async {
    _ncRoutingResponse = ApiResponse.loading(message: 'Loading NC details');
    update();
    try {
      final response =
          await ProjectRepo().getNotificationRoutingForNc(map: {'nc_id': ncId});

      if (response != null && response.status.toLowerCase() == 'success') {
        _ncRoutingResponse = ApiResponse.complete(response.nc);
      } else {
        _ncRoutingResponse = ApiResponse.error(
            message: response?.message ?? "Failed to load NC details");
      }
    } catch (e) {
      _ncRoutingResponse = ApiResponse.error(message: e.toString());
      log("Error in getNcRoutingForNotification: $e");
    }
    update();
  }
  /// ---------------------------------

  /// Apply/Clear Filters
  selectInspections(int index) {
    selectInspection = index;
    update();
  }

  selectInspectionStatus(int index) {
    selectStatus = index;
    update();
  }

  clearFilter() {
    isFilterApply = false;
    selectInspection = 0;
    selectStatus = 0;
    searchController.clear();
    selectedProject = null;
    selectedTower = null;
    towerList = [];
    selectedCheckListStatus = '';
    searchNotificationData = notificationData;
    notificationFilterData = [];
    update();
  }

  applyFilter() {
    isFilterApply = true;
    final temp = notificationData;
    searchController.clear();
    searchNotificationData = [];
    notificationFilterData = [];

    for (var element in temp) {
      if (element.detailLine == (selectInspection == 1 ? "mi" : 'wi')) {
        searchNotificationData.add(element);
        notificationFilterData.add(element);
      }
    }
    update();

    if (selectedProject != null) {
      List<NotificationData> projectList = searchNotificationData;
      searchNotificationData = [];
      notificationFilterData = [];
      for (var element in projectList) {
        if ((element.projectId!.isNotEmpty
                ? int.parse("${element.projectId}")
                : element.projectId) ==
            selectedProject?.projectId) {
          searchNotificationData.add(element);
          notificationFilterData.add(element);
        }
      }
      update();
    }

    if (selectedTower != null) {
      List<NotificationData> towerList = searchNotificationData;
      searchNotificationData = [];
      notificationFilterData = [];
      for (var element in towerList) {
        if ((element.towerId!.isNotEmpty
                ? int.parse("${element.towerId}")
                : element.towerId) ==
            selectedTower?.towerId) {
          searchNotificationData.add(element);
          notificationFilterData.add(element);
        }
      }
      update();
    }

    if (selectedCheckListStatus != '') {
      List<NotificationData> checkList = searchNotificationData;
      searchNotificationData = [];
      notificationFilterData = [];
      for (var element in checkList) {
        if (element.checklistStatus?.toLowerCase() ==
            selectedCheckListStatus.toLowerCase()) {
          searchNotificationData.add(element);
          notificationFilterData.add(element);
        }
      }
      update();
    }
    Get.back();
  }

  getProjectData() {
    if (homeScreenController.projectData.isNotEmpty) {
      projectList = homeScreenController.projectData;
    } else {
      homeScreenController
          .getAssignedProjectController()
          .then((value) => projectList = homeScreenController.projectData);
    }
  }

  selectProject(int id) async {
    for (var element in projectList) {
      if (element.projectId == id) {
        selectedProject = element;
      }
    }
    update();
    await projectDetailsContro();
  }

  selectTower(int id) async {
    for (var element in towerList) {
      if (element.towerId == id) {
        selectedTower = element;
      }
    }
    update();
  }

  selectCheckListStatus(String value) async {
    for (var element in checklistStatusList1) {
      if (element == value) {
        selectedCheckListStatus = element;
      }
    }
    update();
  }

  searchData() {
    if (notificationFilterData.isNotEmpty) {
      if (searchController.text.isNotEmpty) {
        searchNotificationData = [];
        for (var element in notificationFilterData) {
          if (element.seq_no
              .toString()
              .toLowerCase()
              .contains(searchController.text.toString().toLowerCase())) {
            searchNotificationData.add(element);
          }
        }
      }
    } else {
      if (searchController.text.isNotEmpty) {
        if (!isFilterApply) {
          searchNotificationData = [];
          for (var element in notificationData) {
            if (element.seq_no
                .toString()
                .toLowerCase()
                .contains(searchController.text.toString().toLowerCase())) {
              searchNotificationData.add(element);
            }
          }
        }
      }
    }
    update();
  }

  /// Notification API
  ApiResponse _getNotificationApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getNotificationApiResponse => _getNotificationApiResponse;

  Future<dynamic> getNotificationController() async {
    notificationData = [];
    searchNotificationData = [];
    _getNotificationApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      NotificationResModel response =
          await NotificationRepo().getNotificationRepo();
      _getNotificationApiResponse = ApiResponse.complete(response);
      notificationData = response.notificationData!;
      searchNotificationData = notificationData;
      log("Notification Fetch Successful");
    } catch (e) {
      _getNotificationApiResponse = ApiResponse.error(message: e.toString());
      log("Notification Error: $e");
    }
    update();
  }

  /// Project & Tower APIs
  ApiResponse _projectDetailsResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get projectDetailsResponse => _projectDetailsResponse;

  Future<dynamic> projectDetailsContro() async {
    _projectDetailsResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      projectDetailsRes = await ProjectRepo()
          .projectDetailsRepo(body: {"project_id": selectedProject?.projectId ?? 0});
      _projectDetailsResponse = ApiResponse.complete(projectDetailsRes);
      await getTowerChecklistController();
    } catch (e) {
      _projectDetailsResponse = ApiResponse.error(message: e.toString());
    }
    update();
  }

  ApiResponse _getTowerChecklistResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getTowerChecklistResponse => _getTowerChecklistResponse;

  Future<dynamic> getTowerChecklistController() async {
    _getTowerChecklistResponse = ApiResponse.loading(message: 'Loading');
    update();
    int? checklistId;

    projectDetailsRes?.projectData?.checklistData?.forEach((element) {
      if (selectInspection == 1) {
        if (element.name!.contains("Material Inspection")) {
          checklistId = element.checklistId;
        }
      } else {
        if (element.name!.contains("Work Inspection")) {
          checklistId = element.checklistId;
        }
      }
    });

    try {
      towerDataRes = await ProjectRepo().towerInfoChecklistRepo(body: {
        "checklist_id": checklistId ?? 0,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0")
      });
      _getTowerChecklistResponse = ApiResponse.complete(towerDataRes);
      if (towerDataRes?.status == "SUCCESS" &&
          towerDataRes?.projectData != null) {
        towerList = towerDataRes?.projectData?.towerData ?? [];
      }
    } catch (e) {
      _getTowerChecklistResponse = ApiResponse.error(message: e.toString());
    }
    update();
  }
}

















// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jhamtani_app/Api/Apis/api_response.dart';
// import 'package:jhamtani_app/Api/Repo/notification_repo.dart';
// import 'package:jhamtani_app/Api/Repo/project_repo.dart';
// import 'package:jhamtani_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/notification_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/project_details_res_model.dart';
// import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
// import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
// import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';

// class NotificationController extends GetxController {
//   HomeScreenController homeScreenController = Get.find();

//   /// GET NOTIFICATION
//   List<NotificationData> notificationData = [];
//   List<NotificationData> searchNotificationData = [];
//   List<NotificationData> notificationFilterData = [];

//   final searchController = TextEditingController();

//   int selectInspection = 0;
//   int selectStatus = 0;

//   List<ProjectDetails> projectList = [];
//   ProjectDetails? selectedProject;

//   List<TowerData> towerList = [];
//   TowerData? selectedTower;

//   ProjectDetailsResponseModel? projectDetailsRes;
//   GetTowerInfoChecklistResponseModel? towerDataRes;

// /*  List checklistStatusList = [
//     "Pending",
//     "Completed",
//   ];*/

//   List checklistStatusList1 = [
//     "Submit",
//     "Checked",
//     "Approved",
//   ];
//   String selectedCheckListStatus = '';

//   bool isFilterApply = false;

//   /// SELECTION Inspections
//   selectInspections(int index) {
//     selectInspection = index;
//     update();
//   }

//   /// SELECTION Status
//   selectInspectionStatus(int index) {
//     selectStatus = index;
//     update();
//   }

//   /// CLEAR FILTER
//   clearFilter() {
//     isFilterApply = false;
//     selectInspection = 0;
//     selectStatus = 0;
//     searchController.clear();
//     selectedProject = null;
//     selectedTower = null;
//     towerList = [];
//     selectedCheckListStatus = '';
//     searchNotificationData = notificationData;
//     notificationFilterData = [];
//     update();
//   }

//   /// APPLY FILTER
//   applyFilter() {
//     isFilterApply = true;
//     final temp = notificationData;
//     searchController.clear();
//     searchNotificationData = [];
//     notificationFilterData = [];

//     for (var element in temp) {
//       if (element.detailLine == (selectInspection == 1 ? "mi" : 'wi')) {
//         searchNotificationData.add(element);
//         notificationFilterData.add(element);
//       }
//     }
//     update();

//     /// select Project

//     if (selectedProject != null) {
//       List<NotificationData> projectList = searchNotificationData;
//       update();

//       searchNotificationData = [];
//       notificationFilterData = [];
//       for (var element in projectList) {
//         if ((element.projectId!.isNotEmpty
//                 ? int.parse("${element.projectId}")
//                 : element.projectId) ==
//             selectedProject?.projectId) {
//           searchNotificationData.add(element);
//           notificationFilterData.add(element);
//         }
//       }
//       update();
//     }

//     /// select Tower

//     if (selectedTower != null) {
//       List<NotificationData> towerList = searchNotificationData;
//       update();
//       searchNotificationData = [];
//       notificationFilterData = [];
//       for (var element in towerList) {
//         if ((element.towerId!.isNotEmpty
//                 ? int.parse("${element.towerId}")
//                 : element.towerId) ==
//             selectedTower?.towerId) {
//           searchNotificationData.add(element);
//           notificationFilterData.add(element);
//         }
//       }
//       update();
//     }

//     /// select CheckList Status

//     if (selectedCheckListStatus != '') {
//       List<NotificationData> checkList = searchNotificationData;
//       update();
//       searchNotificationData = [];
//       notificationFilterData = [];
//       for (var element in checkList) {
//         if (selectedCheckListStatus == "Submit") {
//           if (element.checklistStatus?.toLowerCase() == "submit") {
//             searchNotificationData.add(element);
//             notificationFilterData.add(element);
//           }
//         } else if (selectedCheckListStatus == "Checked") {
//           if (element.checklistStatus?.toLowerCase() == "checked") {
//             searchNotificationData.add(element);
//             notificationFilterData.add(element);
//           }
//         } else {
//           if (element.checklistStatus?.toLowerCase() == "approve") {
//             searchNotificationData.add(element);
//             notificationFilterData.add(element);
//           }
//         }
//       }
//       update();
//     }
//     Get.back();
//   }

//   getProjectData() {
//     if (homeScreenController.projectData.isNotEmpty) {
//       projectList = homeScreenController.projectData;
//     } else {
//       homeScreenController
//           .getAssignedProjectController()
//           .then((value) => projectList = homeScreenController.projectData);
//     }
//   }

//   selectProject(int id) async {
//     for (var element in projectList) {
//       if (element.projectId == id) {
//         selectedProject = element;
//       }
//     }
//     update();

//     await projectDetailsContro();
//   }

//   selectTower(int id) async {
//     for (var element in towerList) {
//       if (element.towerId == id) {
//         selectedTower = element;
//       }
//     }
//     update();
//   }

//   selectCheckListStatus(String value) async {
//     for (var element in checklistStatusList1) {
//       if (element == value) {
//         selectedCheckListStatus = element;
//       }
//     }
//     update();
//   }

//   searchData() {
//     if (notificationFilterData.isNotEmpty) {
//       if (searchController.text.isNotEmpty) {
//         searchNotificationData = [];
//         for (var element in notificationFilterData) {
//           if (element.seq_no
//               .toString()
//               .toLowerCase()
//               .contains(searchController.text.toString().toLowerCase())) {
//             searchNotificationData.add(element);
//           }
//         }
//       } else {}
//     } else {
//       if (searchController.text.isNotEmpty) {
//         if (isFilterApply == false) {
//           searchNotificationData = [];
//           for (var element in notificationData) {
//             if (element.seq_no
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchController.text.toString().toLowerCase())) {
//               searchNotificationData.add(element);
//             }
//           }
//         }
//       }
//     }
//     update();
//   }

 
//   /// API

//   ApiResponse _getNotificationApiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getNotificationApiResponse => _getNotificationApiResponse;

//   Future<dynamic> getNotificationController() async {
//     notificationData = [];
//     searchNotificationData = [];
//     _getNotificationApiResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       NotificationResModel response =
//           await NotificationRepo().getNotificationRepo();
//       _getNotificationApiResponse = ApiResponse.complete(response);
//       notificationData = response.notificationData!;
//       searchNotificationData = notificationData;
//       log("_getNotificationApiResponse==>$response");
//     } catch (e) {
//       _getNotificationApiResponse = ApiResponse.error(message: e.toString());
//       log("_getNotificationApiResponse=ERROR=>$e");
//     }
//     update();
//   }

//   /// API

//   ApiResponse _projectDetailsResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get projectDetailsResponse => _projectDetailsResponse;

//   Future<dynamic> projectDetailsContro() async {
//     _projectDetailsResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       projectDetailsRes = await ProjectRepo().projectDetailsRepo(
//           body: {"project_id": selectedProject?.projectId ?? 0});
//       _projectDetailsResponse = ApiResponse.complete(projectDetailsRes);
//       update();

//       /// get Tower List API
//       await getTowerChecklistController();
//       log("_projectDetailsResponse=11=>$projectDetailsRes");
//     } catch (e) {
//       _projectDetailsResponse = ApiResponse.error(message: e.toString());
//       log("_projectDetailsResponse=ERROR=11=>$e");
//     }
//     update();
//   }

//   /// API

//   ApiResponse _getTowerChecklistResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getTowerChecklistResponse => _getTowerChecklistResponse;

//   Future<dynamic> getTowerChecklistController() async {
//     _getTowerChecklistResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     int? checklistId;

//     projectDetailsRes?.projectData?.checklistData?.forEach((element) {
//       if (selectInspection == 1) {
//         if (element.name!.contains("Material Inspection")) {
//           checklistId = element.checklistId;
//           update();
//         }
//       } else {
//         if (element.name!.contains("Work Inspection")) {
//           checklistId = element.checklistId;
//           update();
//         }
//       }
//     });

//     try {
//       towerDataRes = await ProjectRepo().towerInfoChecklistRepo(body: {
//         "checklist_id": checklistId ?? 0,
//         "user_id":
//             int.parse(preferences.getString(SharedPreference.userId) ?? "0")
//       });
//       _getTowerChecklistResponse = ApiResponse.complete(towerDataRes);

//       log("_getTowerChecklistResponse=11=>$towerDataRes");

//       if (towerDataRes?.status == "SUCCESS" &&
//           towerDataRes?.projectData != null) {
//         towerList = towerDataRes?.projectData?.towerData ?? [];
//         update();
//       }
//     } catch (e) {
//       _getTowerChecklistResponse = ApiResponse.error(message: e.toString());
//       log("_getTowerChecklistResponse=ERROR=11=>$e");
//     }
//     update();
//   }
// }


























































// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:jhamtani_app/Api/Apis/api_response.dart';
// // import 'package:jhamtani_app/Api/Repo/notification_repo.dart';
// // import 'package:jhamtani_app/Api/Repo/project_repo.dart';
// // import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/get_tower_res_model.dart';
// // import 'package:jhamtani_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
// // import 'package:jhamtani_app/Api/ResponseModel/notification_res_model.dart';
// // import 'package:jhamtani_app/Api/ResponseModel/project_details_res_model.dart';
// // import 'package:jhamtani_app/Api/ResponseModel/project_screen_res_model.dart';
// // import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
// // import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';

// // class NotificationController extends GetxController {
// //   HomeScreenController homeScreenController = Get.find();

// //   /// GET NOTIFICATION
// //   List<NotificationData> notificationData = [];
// //   List<NotificationData> searchNotificationData = [];
// //   List<NotificationData> notificationFilterData = [];

// //   var checkListId = Get.arguments['cId'];
// //   var projectId = Get.arguments['pId'];
// //   var projectName = Get.arguments['pName'];
// //   int buId = Get.arguments['buId'];
// //   var name = Get.arguments['name'];
// //   var cName = Get.arguments['cName'];

// //   GetHQITowersResponseModel? hqiTowerData;
// //   List<HQITower> hqiTowersList = [];

// //   final searchController = TextEditingController();

// //   int selectInspection = 0;
// //   int selectStatus = 0;

// //   List<ProjectDetails> projectList = [];
// //   ProjectDetails? selectedProject;

// //   List<TowerData> towerList = [];
// //   TowerData? selectedTower;

// //   ProjectDetailsResponseModel? projectDetailsRes;
// //   GetTowerInfoChecklistResponseModel? towerDataRes;

// //   List checklistStatusList1 = [
// //     "Submit",
// //     "Checked",
// //     "Approved",
// //   ];
// //   String selectedCheckListStatus = '';

// //   bool isFilterApply = false;

// //   final List<String> inspectionTypes = ['wi', 'mi', 'hqi'];

// //   /// SELECTION Inspections
// //   // selectInspections(int index) {
// //   //   selectInspection = index;
// //   //   update();
// //   // }

// //   selectInspections(int index) {
// //     selectInspection = index;
// //     selectedProject = null;
// //     selectedTower = null;
// //     towerList = [];
// //     hqiTowersList = [];
// //     selectedCheckListStatus = '';

// //     if (inspectionTypes[index] == 'hqi') {
// //       getHQITowersController();
// //     }

// //     update();
// //   }

// //   /// SELECTION Status
// //   selectInspectionStatus(int index) {
// //     selectStatus = index;
// //     update();
// //   }

// //   /// CLEAR FILTER
// //   clearFilter() {
// //     isFilterApply = false;
// //     selectInspection = 0;
// //     selectStatus = 0;
// //     searchController.clear();
// //     selectedProject = null;
// //     selectedTower = null;
// //     towerList = [];
// //     selectedCheckListStatus = '';
// //     searchNotificationData = notificationData;
// //     notificationFilterData = [];
// //     update();
// //   }

// //   /// APPLY FILTER
// //   applyFilter() {
// //     isFilterApply = true;
// //     final temp = notificationData;
// //     searchController.clear();
// //     searchNotificationData = [];
// //     notificationFilterData = [];

// //     for (var element in temp) {
// //       // if (element.detailLine == (selectInspection == 1 ? "mi" : 'wi')) {
// //       if (element.detailLine == inspectionTypes[selectInspection]) {
// //         searchNotificationData.add(element);
// //         notificationFilterData.add(element);
// //       }
// //     }
// //     update();

// //     /// select Project

// //     if (selectedProject != null) {
// //       List<NotificationData> projectList = searchNotificationData;
// //       update();

// //       searchNotificationData = [];
// //       notificationFilterData = [];
// //       for (var element in projectList) {
// //         if ((element.projectId!.isNotEmpty
// //                 ? int.parse("${element.projectId}")
// //                 : element.projectId) ==
// //             selectedProject?.projectId) {
// //           searchNotificationData.add(element);
// //           notificationFilterData.add(element);
// //         }
// //       }
// //       update();
// //     }

// //     /// select Tower

// //     // if (selectedTower != null) {
// //     //   List<NotificationData> towerList = searchNotificationData;
// //     //   update();
// //     //   searchNotificationData = [];
// //     //   notificationFilterData = [];
// //     //   for (var element in towerList) {
// //     //     if ((element.towerId!.isNotEmpty
// //     //             ? int.parse("${element.towerId}")
// //     //             : element.towerId) ==
// //     //         selectedTower?.towerId) {
// //     //       searchNotificationData.add(element);
// //     //       notificationFilterData.add(element);
// //     //     }
// //     //   }
// //     //   update();
// //     // }

// //     /// select Tower
// //     if (selectedTower != null) {
// //       List<NotificationData> towerListTemp = searchNotificationData;
// //       searchNotificationData = [];
// //       notificationFilterData = [];

// //       for (var element in towerListTemp) {
// //         if ((element.towerId?.isNotEmpty ?? false
// //                 ? int.parse("${element.towerId}")
// //                 : element.towerId) ==
// //             selectedTower?.towerId) {
// //           searchNotificationData.add(element);
// //           notificationFilterData.add(element);
// //         }
// //       }
// //       update();
// //     }

// //     /// select CheckList Status

// //     if (selectedCheckListStatus != '') {
// //       List<NotificationData> checkList = searchNotificationData;
// //       update();
// //       searchNotificationData = [];
// //       notificationFilterData = [];
// //       for (var element in checkList) {
// //         if (selectedCheckListStatus == "Submit") {
// //           if (element.checklistStatus?.toLowerCase() == "submit") {
// //             searchNotificationData.add(element);
// //             notificationFilterData.add(element);
// //           }
// //         } else if (selectedCheckListStatus == "Checked") {
// //           if (element.checklistStatus?.toLowerCase() == "checked") {
// //             searchNotificationData.add(element);
// //             notificationFilterData.add(element);
// //           }
// //         } else {
// //           if (element.checklistStatus?.toLowerCase() == "approve") {
// //             searchNotificationData.add(element);
// //             notificationFilterData.add(element);
// //           }
// //         }
// //       }
// //       update();
// //     }
// //     Get.back();
// //   }

// //   getProjectData() {
// //     if (homeScreenController.projectData.isNotEmpty) {
// //       projectList = homeScreenController.projectData;
// //     } else {
// //       homeScreenController
// //           .getAssignedProjectController()
// //           .then((value) => projectList = homeScreenController.projectData);
// //     }
// //   }

// //   selectProject(int id) async {
// //     for (var element in projectList) {
// //       if (element.projectId == id) {
// //         selectedProject = element;
// //       }
// //     }
// //     update();

// //     await projectDetailsContro();

// //     if (inspectionTypes[selectInspection] == 'hqi') {
// //       projectId = selectedProject?.projectId;
// //       await getHQITowersController();
// //     }
// //   }

// //   // selectTower(int id) async {
// //   //   for (var element in towerList) {
// //   //     if (element.towerId == id) {
// //   //       selectedTower = element;
// //   //     }
// //   //   }
// //   //   update();
// //   // }

// //   selectTower(int? id) async {
// //     if (inspectionTypes[selectInspection] == 'hqi') {
// //       for (var element in hqiTowersList) {
// //         if (element.id == id) {
// //           selectedTower =
// //               TowerData(towerId: element.id, name: element.name);
// //         }
// //       }
// //     } else {
// //       for (var element in towerList) {
// //         if (element.towerId == id) {
// //           selectedTower = element;
// //         }
// //       }
// //     }
// //     update();
// //   }

// //   selectCheckListStatus(String value) async {
// //     for (var element in checklistStatusList1) {
// //       if (element == value) {
// //         selectedCheckListStatus = element;
// //       }
// //     }
// //     update();
// //   }

// //   searchData() {
// //     if (notificationFilterData.isNotEmpty) {
// //       if (searchController.text.isNotEmpty) {
// //         searchNotificationData = [];
// //         for (var element in notificationFilterData) {
// //           if (element.seq_no
// //               .toString()
// //               .toLowerCase()
// //               .contains(searchController.text.toString().toLowerCase())) {
// //             searchNotificationData.add(element);
// //           }
// //         }
// //       } else {}
// //     } else {
// //       if (searchController.text.isNotEmpty) {
// //         if (isFilterApply == false) {
// //           searchNotificationData = [];
// //           for (var element in notificationData) {
// //             if (element.seq_no
// //                 .toString()
// //                 .toLowerCase()
// //                 .contains(searchController.text.toString().toLowerCase())) {
// //               searchNotificationData.add(element);
// //             }
// //           }
// //         }
// //       }
// //     }
// //     update();
// //   }

// //   /// API

// //   ApiResponse _getNotificationApiResponse =
// //       ApiResponse.initial(message: 'Initialization');

// //   ApiResponse get getNotificationApiResponse => _getNotificationApiResponse;

// //   Future<dynamic> getNotificationController() async {
// //     notificationData = [];
// //     searchNotificationData = [];
// //     _getNotificationApiResponse = ApiResponse.loading(message: 'Loading');
// //     update();
// //     try {
// //       NotificationResModel response =
// //           await NotificationRepo().getNotificationRepo();
// //       _getNotificationApiResponse = ApiResponse.complete(response);
// //       notificationData = response.notificationData!;
// //       searchNotificationData = notificationData;
// //       log("_getNotificationApiResponse==>$response");
// //     } catch (e) {
// //       _getNotificationApiResponse = ApiResponse.error(message: e.toString());
// //       log("_getNotificationApiResponse=ERROR=>$e");
// //     }
// //     update();
// //   }

// //   /// API

// //   ApiResponse _projectDetailsResponse =
// //       ApiResponse.initial(message: 'Initialization');

// //   ApiResponse get projectDetailsResponse => _projectDetailsResponse;

// //   Future<dynamic> projectDetailsContro() async {
// //     _projectDetailsResponse = ApiResponse.loading(message: 'Loading');
// //     update();
// //     try {
// //       projectDetailsRes = await ProjectRepo().projectDetailsRepo(
// //           body: {"project_id": selectedProject?.projectId ?? 0});
// //       _projectDetailsResponse = ApiResponse.complete(projectDetailsRes);
// //       update();

// //       /// get Tower List API
// //       await getTowerChecklistController();
// //       log("_projectDetailsResponse=11=>$projectDetailsRes");
// //     } catch (e) {
// //       _projectDetailsResponse = ApiResponse.error(message: e.toString());
// //       log("_projectDetailsResponse=ERROR=11=>$e");
// //     }
// //     update();
// //   }

// //   /// API

// //   ApiResponse _getTowerChecklistResponse =
// //       ApiResponse.initial(message: 'Initialization');

// //   ApiResponse get getTowerChecklistResponse => _getTowerChecklistResponse;

// //   Future<dynamic> getTowerChecklistController() async {
// //     _getTowerChecklistResponse = ApiResponse.loading(message: 'Loading');
// //     update();
// //     int? checklistId;

// //     projectDetailsRes?.projectData?.checklistData?.forEach((element) {
// //       if (selectInspection == 1) {
// //         if (element.name!.contains("Material Inspection")) {
// //           checklistId = element.checklistId;
// //           update();
// //         }
// //       } else {
// //         if (element.name!.contains("Work Inspection")) {
// //           checklistId = element.checklistId;
// //           update();
// //         }
// //       }
// //     });

// //     try {
// //       towerDataRes = await ProjectRepo().towerInfoChecklistRepo(body: {
// //         "checklist_id": checklistId ?? 0,
// //         "user_id":
// //             int.parse(preferences.getString(SharedPreference.userId) ?? "0")
// //       });
// //       _getTowerChecklistResponse = ApiResponse.complete(towerDataRes);

// //       log("_getTowerChecklistResponse=11=>$towerDataRes");

// //       if (towerDataRes?.status == "SUCCESS" &&
// //           towerDataRes?.projectData != null) {
// //         towerList = towerDataRes?.projectData?.towerData ?? [];
// //         update();
// //       }
// //     } catch (e) {
// //       _getTowerChecklistResponse = ApiResponse.error(message: e.toString());
// //       log("_getTowerChecklistResponse=ERROR=11=>$e");
// //     }
// //     update();
// //   }

// // ///// hqi tower
// //   ApiResponse _getHQITowersResponse =
// //       ApiResponse.initial(message: 'Initialization');
// //   ApiResponse get getHQITowersResponse => _getHQITowersResponse;

// //   Future<void> getHQITowersController() async {
// //     _getHQITowersResponse = ApiResponse.loading(message: 'Loading');
// //     update();
// //     try {
// //       var body = {
// //         "project_id": projectId,
// //         "user_id":
// //             int.parse(preferences.getString(SharedPreference.userId) ?? "0"),
// //       };
// //       final response = await ProjectRepo().getHQITowersRepo(body: body);
// //       hqiTowerData = response;
// //       hqiTowersList = hqiTowerData?.data?.towerData ?? [];

// //       _getHQITowersResponse = ApiResponse.complete(hqiTowerData);
// //       log("HQI Towers fetched: ${hqiTowerData?.data?.towerData?.length}");
// //     } catch (e) {
// //       _getHQITowersResponse = ApiResponse.error(message: e.toString());
// //       log("Error fetching HQI towers: $e");
// //     }
// //     update();
// //   }
// // }
