import 'dart:developer';
import 'package:get/get.dart';
import 'package:jhamtani_app/Api/Apis/api_response.dart';
import 'package:jhamtani_app/Api/Repo/project_repo.dart';
import 'package:jhamtani_app/Api/ResponseModel/project_details_res_model.dart';
import 'package:jhamtani_app/View/Controller/network_controller.dart';

class ProjectCheckListController extends GetxController {
  String projectId = "${Get.arguments['id'] ?? 0}";
  String projectName = "${Get.arguments['name'] ?? 0}";
  int count = Get.arguments['count'] ?? 0;
  int buId = Get.arguments['buId'] ?? 0;

  NetworkController networkController = Get.put(NetworkController());
  ProjectDetailsResponseModel? projectDetailsRes;
  bool loading = false;

  // fetchSqlData() async {
  //   loading = true;
  //   update();
  //   final fetchProjectData = await dbHelper.getDataById(tableName: 'ProjectData', id: int.parse(projectId));
  //   ProjectDataModel projData = ProjectDataModel.fromJson(fetchProjectData!);
  //
  //   log('fetchProjectData==========>>>>>> $fetchProjectData');
  //
  //   final fetchDetailsLine = await dbHelper.getDataFromTable(
  //       tableName: 'DetailsLine', id: int.parse(projectId), where: "projectId");
  //
  //   log('fetchDetailsLine==========>>>>>> $fetchDetailsLine');
  //
  //   List<DetailsLineModel> temp =
  //       List<DetailsLineModel>.from(fetchDetailsLine.map((x) => DetailsLineModel.fromJson(x)));
  //   List<ChecklistData> checkListData = [];
  //   for (var element in temp) {
  //     ChecklistData data = ChecklistData(
  //       checklistId: element.id,
  //       image: element.detailsLineImage,
  //       name: element.detailsLineName,
  //     );
  //     checkListData.add(data);
  //   }
  //   projectData.ProjectData detailsData = projectData.ProjectData(
  //       projectName: projData.projectName, checklistData: checkListData, imageUrl: projData.projectImage);
  //   projectDetailsRes = ProjectDetailsResponseModel(projectData: detailsData);
  //   loading = false;
  //   update();
  // }

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await projectDetailsController();
    // fetchSqlData();
    update();
  }

  /// API

  ApiResponse _projectDetailsResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get projectDetailsResponse => _projectDetailsResponse;

  Future<dynamic> projectDetailsController() async {
    _projectDetailsResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      projectDetailsRes = await ProjectRepo()
          .projectDetailsRepo(body: {"project_id": projectId});
      _projectDetailsResponse = ApiResponse.complete(projectDetailsRes);
      log("_projectDetailsResponse==>$projectDetailsRes");
    } catch (e) {
      _projectDetailsResponse = ApiResponse.error(message: e.toString());
      log("_projectDetailsResponse=ERROR=>$e");
    }
    update();
  }
}
