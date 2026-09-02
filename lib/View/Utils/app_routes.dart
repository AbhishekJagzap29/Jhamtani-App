import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/GenerateNc/generated_nc_complete_details_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/nc_controller.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_details_screen.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_records_screen.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_testing_form_screen.dart';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/ResponseModel/HomeInspection/fetch_observation_form_res_model.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/ActivityDetails/activity_details_screen.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/edit_activity_screen.dart';
import 'package:jhamtani_app/View/Screen/ActivityScreen/EditActivity/history_screen.dart';
import 'package:jhamtani_app/View/Screen/Admin/admin_dashboard_screen.dart';
import 'package:jhamtani_app/View/Screen/Admin/admin_project_details_screen.dart';
import 'package:jhamtani_app/View/Screen/AuthScreen/forgot_password_screen.dart';
import 'package:jhamtani_app/View/Screen/AuthScreen/login_screen.dart';
import 'package:jhamtani_app/View/Screen/AuthScreen/register_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/filter_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Dashboard/nc_details_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/HomeScreen/home_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Notification/notification_filter_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Profile/update_password_screen.dart';
import 'package:jhamtani_app/View/Screen/BottomBarScreen/Report/report_details_screen.dart';
import 'package:jhamtani_app/View/Screen/FlatFloorActivityScreen/flat_activity_screen.dart';
import 'package:jhamtani_app/View/Screen/FlatFloorActivityScreen/floor_activity_screen.dart';
import 'package:jhamtani_app/View/Screen/FlatFloorActivityScreen/pdf_view_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/add_observation_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/attachment_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/flat_sub_location_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_flat_list_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/hqi_tower_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/observation_history_screen.dart';
import 'package:jhamtani_app/View/Screen/HomeInscpection/site_visit_list_view_screen.dart';
import 'package:jhamtani_app/View/Screen/IntroScreen/intro_screen.dart';
import 'package:jhamtani_app/View/Screen/IntroScreen/splash_screen.dart';
import 'package:jhamtani_app/View/Screen/MaterialInspectionScreen/create_mi_screen.dart';
import 'package:jhamtani_app/View/Screen/MaterialInspectionScreen/material_inspection_screen.dart';
import 'package:jhamtani_app/View/Screen/MaterialInspectionScreen/update_mi_screen.dart';
import 'package:jhamtani_app/View/Screen/ProjectScreen/Checklist/project_checklist_screen.dart';
import 'package:jhamtani_app/View/Screen/ProjectScreen/Details/project_details_screen.dart';
import 'package:jhamtani_app/View/Screen/SavedActivityScren/show_offline_data_screen.dart';
import 'package:jhamtani_app/View/Screen/SavedActivityScren/show_save_activity_screen_new.dart';
import 'package:jhamtani_app/View/Screen/SavedActivityScren/show_save_hqi_screen.dart';
import 'package:jhamtani_app/View/Screen/SavedActivityScren/show_saved_activity_screen.dart';
import 'package:jhamtani_app/View/Screen/TowerScreen/tower_details_screen.dart';
import 'package:jhamtani_app/View/Screen/bottom_bar.dart';

class Routes {
  static String splashScreen = "/";
  static String bottomBar = "/bottomBar";

  static String introScreen = "/introScreen";
  static String loginScreen = "/loginScreen";
  static String homeScreen = "/homeScreen";
  static String projectChecklistScreen = "/projectChecklistScreen";
  static String projectDetailsScreen = "/projectScreen";
  static String towerDetailsScreen = "/towerDetailsScreen";
  static String flatActivityScreen = "/flatActivityScreen";
  static String floorActivityScreen = "/floorActivityScreen";
  static String activityDetailsScreen = "/activityDetailsScreen";
  static String editActivityScreen = "/editActivityScreen";
  static String adminDashboardScreen = "/adminDashboardScreen";
  static String adminProjectDetailsScreen = "/adminProjectDetailsScreen";
  static String forGotPasswordScreen = "/forGotPasswordScreen";
  static String registerScreen = "/registerScreen";
  static String viewPdf = "/viewPdf";
  static String historyScreen = "/historyScreen";
  static String ncDetailsScreen = "/ncDetailsScreen";
  static String filterScreen = "/filterScreen";
  static String saveActivityScreen = "/saveActivityScreen";
  static String saveActivityScreenNew = "/saveActivityScreenNew";
  static String showSaveHQIScreen = "/ShowSaveHQIScreen";
  static String showOfflineDataScreen = "/showOfflineDataScreen";

  static String materialInspectionScreen = "/materialInspectionScreen";
  static String createMaterialInspectionScreen =
      "/createMaterialInspectionScreen";
  static String updateMaterialInspectionScreen =
      "/updateMaterialInspectionScreen";
  static String notificationFilterScreen = "/notificationFilterScreen";
  static String updatePasswordScreen = "/updatePasswordScreen";
  static String reportDetailScreen = "/reportDetailScreen";
  static String hqiFlatScreen = "/hqiFlatScreen";
  static String hqiTowerDetailsScreen = "/hqiTowerDetailsScreen";
  static String flatSubLocationScreen = "/flatSubLocationScreen";
  static String addObservationScreen = "/addObservationScreen";
  static String attachmentScreen = "/attachmentScreen";
  static String siteVisitListViewScreen = '/siteVisitListViewScreen';
  static String observationHistoryScreen = '/observationHistoryScreen';
  static const generateNcScreen = '/generateNcScreen';
  static const generateNcDetailsScreen = '/generateNcDetailsScreen';
  static const String generateNcCompleteDetailsScreen = '/generateNcCompleteDetailsScreen';

  //11/03/2026 CUBE TESTING
  static String cubeRecordsScreen = "/cubeRecordsScreen";
  static String cubeTestingFormScreen = "/cubeTestingFormScreen";
  static String cubeDetailsScreen = "/cubeDetailsScreen";


  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bottomBar,
      page: () => const BottomBar(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: introScreen,
      page: () => const IntroScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: projectChecklistScreen,
      page: () => const ProjectChecklistScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: projectDetailsScreen,
      page: () => const ProjectDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: towerDetailsScreen,
      page: () => TowerDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: hqiTowerDetailsScreen,
      page: () => HQITowerDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: flatActivityScreen,
      page: () => const FlatActivityScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: floorActivityScreen,
      page: () => const FloorActivityScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: hqiFlatScreen,
      page: () => const HQLFlatScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: flatSubLocationScreen,
      page: () => const FlatSubLocationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addObservationScreen,
      page: () => const AddObservationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.attachmentScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return AttachmentDialogPopup(
          observationId: args['observation_id'] ?? 0,
          locationId: args['location_id'] ?? 0,
          state: args['state'] ?? '',
          sequence: args['sequence'] ?? 0,
          visitDetails: args['visitDetails'] ?? VisitDetails(),
          observationData: args['observationData'] ?? FetchObservationData(),
          flatId: args['flatId'] ?? 0,
          projectId: args['projectId'] ?? 0,
                observationCategory: args['observationCategory'] ?? '',


        );
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.siteVisitListViewScreen,
      page: () => const SiteVisitListViewScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: activityDetailsScreen,
      page: () => const ActivityDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: editActivityScreen,
      page: () => const EditActivityScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: adminDashboardScreen,
      page: () => const AdminDashBoardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: adminProjectDetailsScreen,
      page: () => const AdminProjectDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: forGotPasswordScreen,
      page: () => const ForGotPasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: registerScreen,
      page: () => const RegisterScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: viewPdf,
      page: () => const PdfViewScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: historyScreen,
      page: () => const HistoryScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ncDetailsScreen,
      page: () => const NcDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: filterScreen,
      page: () => const FilterScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: saveActivityScreen,
      page: () => const SaveActivityScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: saveActivityScreenNew,
      page: () => const SaveActivityScreenNew(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: showSaveHQIScreen,
      page: () => const ShowSaveHQIScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: showOfflineDataScreen,
      page: () => const ShowOfflineDataScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: materialInspectionScreen,
      page: () => const MaterialInspectionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: createMaterialInspectionScreen,
      page: () => const CreateMaterialInspectionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: updateMaterialInspectionScreen,
      page: () => const UpdateMaterialInspectionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notificationFilterScreen,
      page: () => const NotificationFilterScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: updatePasswordScreen,
      page: () => const UpdatePasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: reportDetailScreen,
      page: () => const ReportDetailScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: observationHistoryScreen,
      page: () => const ObservationHistoryScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: generateNcCompleteDetailsScreen,
      page: () => GenerateNcCompleteDetailsScreen(),
      transition: Transition.fadeIn,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => NcController(), fenix: true);
      }),
    ),

    //14/03/2026

    GetPage(
      name: cubeRecordsScreen,
      page: () => CubeRecordsScreen(
        floorId: Get.arguments['floorId'],
      ),
    ),

    GetPage(
      name: cubeTestingFormScreen,
      page: () => CubeTestingFormScreen(
        floorId: Get.arguments['floorId'],
      ),
    ),

   GetPage(
  name: cubeDetailsScreen,
  page: () {
    final args = Get.arguments as Map<String, dynamic>;

    return CubeDetailsScreen(
      data: args["data"],
      isEditable: args["isEditable"] ?? false,
    );
  },
  transition: Transition.fadeIn,
),
  ];
}
