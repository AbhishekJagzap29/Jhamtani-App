class ApiRouts {

//jhamtani Live server
 static String databaseName = 'jhamtani';
 static String base = 'http://143.198.123.92:8069/';
 static String basic = 'http://143.198.123.92:8069/';


//jhamtaniApp TEST/Demo server
  // static String databaseName = 'quality__merge';
  // static String base  = 'http://157.245.102.113:8079/';
  // static String basic = 'http://157.245.102.113:8079/';
  

  static String baseUrl = '${base}session/auth';

  /// APIS
  static String loginAPI = '$baseUrl/login';

  static String registerAPI = '$baseUrl/signup';
  static String logOutAPI = '$baseUrl/logout';
  static String getAssignedProject = '$baseUrl/get/assigned/projects';
  static String changePassword = '$baseUrl/change_password';

  ///
  static String getMaterialInspection = '$baseUrl/get/material/inspection';
  static String projectDetails = '$baseUrl/get/project_info';
  static String towerInfoCheckList = '$baseUrl/get/checklist/tower';
  static String getFlatFloor = '$baseUrl/get/flat/floor';
  static String getCommonActivityData = '$baseUrl/get/activity/common';
  static String getCommonActivityTypeData = '$baseUrl/get/checklist';
  static String getDevelopmentActivityData =
      '$baseUrl/get/activity/development';

  static String getFlatActivity = '$baseUrl/get/flat/activites';
  static String getFloorActivity = '$baseUrl/get/floor/activites';
  static String getCheckListByActivity =
      '$baseUrl/get/checklist'; //// save for offline
  static String getMaterialInspectionCheckList = '$baseUrl/get/mi/checklist';
  static String createMaterialInspection =
      '$baseUrl/create/material/inspection';
  static String deleteMaterialInspection = '$baseUrl/delete/mi';
  static String replicateMaterialInspection = '$baseUrl/replicate/mi';

  ///----
  static String updateMaterialInspection = '$baseUrl/update/mi';
  static String updateCheckerData = '$baseUrl/checker/checklist/update';
  static String updateMakerData = '$baseUrl/maker/checklist/update';
  static String updateApproverData = '$baseUrl/approver/checklist/update';
  static String rejectMakerData = '$baseUrl/checker/checklist/reject';
  static String rejectCheckerData = '$baseUrl/approver/checklist/reject';
  static String oneSignal = '${base}onesignal/my_endpoint';
  static String notification = '${base}get/user/notifications';
  static String projectChecklistByAc = '${base}get/activity/details';
  // static String userLocation = '$baseUrl/update/user/location';

  /// NC

  static String ncProjectData = '$baseUrl/get/project/nc';
  static String ncTowerData = '$baseUrl/get/project/tower_floor/nc';
  static String ncFloorData = '$baseUrl/get/tower/floor/nc';
  static String ncFloorAcData = '$baseUrl/get/floor/activity/nc';
  static String ncFloorAcTypeData = '$baseUrl/get/floor/activity_type/nc';
  static String ncFloorChecklistData = '$baseUrl/get/floor/checklist/nc';
  static String ncFlatData = '$baseUrl/get/tower/flat/nc';
  static String ncFlatAcData = '$baseUrl/get/flat/activity/nc';
  static String ncFlatAcTypeData = '$baseUrl/get/flat/activity_type/nc';
  static String ncFlatChecklistData = '$baseUrl/get/flat/checklist/nc';

  static String duplicateActivity = '$baseUrl/duplicate/activities/create';
  static String deleteActivity = '$baseUrl/delete/activity';

  static String duplicateActivityForCommonAndDevelopment =
      '$baseUrl/create/replicate/activitie/common/development';

  ///---
  static String updateMaker = '$baseUrl/maker/mi/update';
  static String updateChecker = '$baseUrl/checker/mi/update';
  static String updateApprover = '$baseUrl/approver/mi/update';
  static String rejectChecker = '$baseUrl/checker/mi/reject';
  static String rejectApprover = '$baseUrl/approver/mi/reject';

  ///Report
  static String getTower = '$baseUrl/get/towers';
  static String addCheckReport = '$baseUrl/create/training/report';
  static String getReport = '$baseUrl/get/training/report';
  static String updateReport = '$baseUrl/update/training/report';

  /// get/material/inspection
  static String getMaterialProject = '$baseUrl/get/business/unit';
  static String getMaterialSupplierName = '$baseUrl/get/ledger/description';
  // static String getMaterialquantity = '$baseUrl/get/poline/qty';
  static String getMaterialdescription =
      '$baseUrl/get/poline/material/description';
  static String getUomCode = '$baseUrl/get/poline/uomcode';
  static String getDocumentNo = '$baseUrl/get/po/docno';

///// material count
  static String getmaterialcount = '$baseUrl/material/completed_report_counts';

///////////////// Home Inspection /////////////////////////
  static String issueType = '$baseUrl/get/issue/type';
  static String issueCategory = '$baseUrl/get/issue/category';
  static String categoryRating = '$baseUrl/get/observation/category';
  static String submitFlatForHQI = '$baseUrl/submit/hqi/flat';
  static String hqiFlatList = '$baseUrl/get/hqi/flats';
  static String hqiSiteVisit = '$baseUrl/get/flat/visits';
  static String hqiTowerdata = '$baseUrl/get/hqi/towers';
  static String submitObservationForm =
      "$baseUrl/flat/observation/return-to-maker"; //////submit observation form
  static String fetchObservationForm =
      "$baseUrl/get/flat/sv/location/obseration"; ////// get all submittind observation
  static String flatCompletedForHQI =
      "$baseUrl/flat/observation/completed"; ///////////// if no issue checker will aporove it
  static String flatResubmittoChecker =
      "$baseUrl/flat/observation/resubmit-to-checker"; ///////////////maker submit the observation to checker

static String multiobservationsubmit = "$baseUrl/flat/observation/multi-return-to-maker";

  static String getAttachmentDetail = "$baseUrl/get/";
  static String downloadPdfForHQI = "$baseUrl/get/site/visit/pdf";
  static String observationHistory = "$baseUrl/get/hqi/observation/history";
  static String completeForHQI = "$baseUrl/complete/hqi/flats";
  static String replicatelocationforhqi = "$baseUrl/replicate/hqi/observation";
  static String siteVisitSaveOffline = "$baseUrl/get/hqi/flats/offline";
  static String siteVisitSaveOfflineLocObs =
      "$baseUrl/get/flat/sv/location/observation/offline";
  static String getHQIFlatOffline = "$baseUrl/get/hqi/flats/offline";

  static String downloadPdfForHqiFlat = "$baseUrl/get/flat/hqi/pdf";

   /// generate nc by app
  static String ncGetProject = '$baseUrl/api/project/info';
  static String ncGetTower = '$baseUrl/api/tower/info';
  static String ncGetFloor = '$baseUrl/api/floor/info';
  static String ncGetFlat = '$baseUrl/api/flat/info';
  static String ncGetActivity = '$baseUrl/api/activities/info';
  static String ncGetActivityType = '$baseUrl/api/activity/type/info';
  static String ncGetActivityTypeChecklist =
      '$baseUrl/api/activity/checklist/info';
  static String ncsubmitbutton = '$baseUrl/api/nc/create';
  static String ncfetchalldata = '$baseUrl/api/nc/fetch_all';
  static String ncprojectresponsiblelist = '$baseUrl/api/users/list';
  static String ncclosestate = '$baseUrl/api/nc/submit';
  //27/11
  static String approverRejectNc = '$baseUrl/api/approver/nc/reject';
  //28//11
  static String approverCloseNc = '$baseUrl/api/approver/nc/close';

//// nc routing through notifcation
  static String ncRoutingThroughNotification = '$baseUrl/api/nc/fetch';



  /// WRITE THIS APIS OF CUBE TESTING
  /// ------------------ CUBE TESTING ------------------
  static String getCubeTestingList = '${basic}api/cube-testing/list';

  static String getSingleCubeTesting = '${basic}api/cube-testing/get';

  static String createCubeTesting = '${basic}api/cube-testing/create';

// use id after this

  static String updateCubeTesting = '${basic}api/cube-testing/update';
// use id after this

  // static String deleteCubeTesting = '${basic}api/cube-testing/delete';
  static String deleteCubeTesting = '${basic}api/cube-testing/delete/';
// use id after this

  static String searchCubeTesting = '${basic}api/cube-testing/search';
  
}
