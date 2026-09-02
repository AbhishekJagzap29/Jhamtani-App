//27/03/2026 - Updated according to new API response

import 'package:jhamtani_app/Api/Repo/cube_testing_repo.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_update_screen.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CubeDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isEditable;

  const CubeDetailsScreen({
    super.key,
    required this.data,
    this.isEditable = false,
  });

  @override
  State<CubeDetailsScreen> createState() => _CubeDetailsScreenState();
}

class _CubeDetailsScreenState extends State<CubeDetailsScreen> {
  final CubeTestingRepository repo = CubeTestingRepository();
  final TextEditingController srNoController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  /// -------- MULTI CUBE CONTROLLERS --------
  List<TextEditingController> cubeIds =
      List.generate(3, (_) => TextEditingController());

  List<TextEditingController> lengths =
      List.generate(3, (_) => TextEditingController());

  List<TextEditingController> breadths =
      List.generate(3, (_) => TextEditingController());

  List<TextEditingController> heights =
      List.generate(3, (_) => TextEditingController());

  List<TextEditingController> weights =
      List.generate(3, (_) => TextEditingController());

  List<TextEditingController> loads =
      List.generate(3, (_) => TextEditingController());

 

  Map<String, String> gradeMap = {
    "m15": "M15",
    "m20": "M20",
    "m25": "M25",
    "m30": "M30",
    "m35": "M35",
    "m40": "M40",
    "m45": "M45",
    "m50": "M50",
    "m55": "M55",
    "m60": "M60",

    // FF grades
    "m30ff": "M30 FF",
    "m35ff": "M35 FF",
    "m40ff": "M40 FF",
    "m45ff": "M45 FF",
    "m50ff": "M50 FF",
    "m55ff": "M55 FF",
    "m60ff": "M60 FF",

    // PT grades
    "m35pt": "M35 PT",
    "m40pt": "M40 PT",
    "m45pt": "M45 PT",
  };

  DateTime? castingDate;
  DateTime? testingDate;

  String grade = "m20";
  double gradeValue = 20;

  int ageDays = 0;

  List<double> densities = [0, 0, 0];
  List<double> strengths = [0, 0, 0];

  double avgStrength = 0;
  double strengthPercent = 0;
  bool isLoading = true;
  Map<String, dynamic> recordData = {};

  @override
  void initState() {
    super.initState();
    fetchRecordDetails();
  }

  /// -------- PREFILL DATA --------
  Future<void> fetchRecordDetails() async {
    final int? recordId = widget.data["id"] is int
        ? widget.data["id"] as int
        : int.tryParse(widget.data["id"]?.toString() ?? "");

    Map<String, dynamic> data = Map<String, dynamic>.from(widget.data);

    if (recordId != null) {
      final response = await repo.getSingleRecord(recordId);
      if (response is Map<String, dynamic>) {
        data = response;
      }
    }

    if (!mounted) return;

    recordData = data;
    setData(data);

    setState(() {
      isLoading = false;
    });
  }

  void setData(Map<String, dynamic> data) {
    srNoController.clear();
    quantityController.clear();
    locationController.clear();

    for (int i = 0; i < 3; i++) {
      cubeIds[i].clear();
      lengths[i].clear();
      breadths[i].clear();
      heights[i].clear();
      weights[i].clear();
      loads[i].clear();
      densities[i] = 0;
      strengths[i] = 0;
    }

    srNoController.text = data["sr_no"]?.toString() ?? "";
    quantityController.text = data["quantity"]?.toString() ?? "";

    locationController.text = data["location_structure"]?.toString() ?? "";
    sourceController.text = data["source_concrete"]?.toString() ?? "";

    grade = (data["grade_concrete"]?.toString() ?? "m20").toLowerCase();
    if (!gradeMap.containsKey(grade)) {
      grade = "m20";
    }

    if (data["grade_value"] != null) {
      gradeValue = double.tryParse(data["grade_value"].toString()) ?? 20;
    } else {
      String gradeText = gradeMap[grade] ?? "M20";
      RegExp regExp = RegExp(r'\d+');
      Match? match = regExp.firstMatch(gradeText);
      gradeValue = match != null ? double.parse(match.group(0)!) : 20;
    }

    castingDate = null;
    testingDate = null;

    if (data["date_casting"] != null) {
      castingDate = DateTime.parse(data["date_casting"]);
    }

    if (data["date_testing"] != null) {
      testingDate = DateTime.parse(data["date_testing"]);
    }

    final cubeLines = data["cube_lines"] ?? data["cubes"];

    if (cubeLines != null) {
      for (int i = 0; i < cubeLines.length && i < 3; i++) {
        var cube = cubeLines[i];

        // cubeIds[i].text = cube["cube_id"] ?? "";
        cubeIds[i].text =
            cube["cube_no"]?.toString() ?? cube["cube_id"]?.toString() ?? "";
        lengths[i].text = cube["length"].toString();
        breadths[i].text = cube["breadth"].toString();
        heights[i].text = cube["height"].toString();
        weights[i].text = cube["weight"].toString();
        loads[i].text = cube["load"].toString();
      }
    }

    calculateValues(isInit: true);
    calculateAge();
  }

  void calculateAge() {
    if (castingDate != null && testingDate != null) {
      ageDays = testingDate!.difference(castingDate!).inDays;
    }
  }

  void calculateValues({bool isInit = false}) {
    double total = 0;
    int validCount = 0;

    for (int i = 0; i < 3; i++) {
      double w = double.tryParse(weights[i].text) ?? 0;
      double lVal = double.tryParse(lengths[i].text) ?? 0;
      double bVal = double.tryParse(breadths[i].text) ?? 0;
      double hVal = double.tryParse(heights[i].text) ?? 0;
      double loadVal = double.tryParse(loads[i].text) ?? 0;

      double volume = (lVal / 1000) * (bVal / 1000) * (hVal / 1000);
      densities[i] = volume != 0 ? w / volume : 0;

      double area = lVal * bVal;
      strengths[i] = area != 0 ? (loadVal * 1000) / area : 0;

      total += strengths[i];
      if (cubeIds[i].text.trim().isNotEmpty) {
        validCount++;
      }
    }

    avgStrength = validCount == 0 ? 0 : total / validCount;
    strengthPercent = gradeValue == 0 ? 0 : (avgStrength / gradeValue) * 100;

    ///  prevent rebuild loop
    if (!isInit) {
      setState(() {});
    }
  }

  /// -------- COMMON TEXT FIELD --------
  Widget textField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text, bool isCalc = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: TextField(
            controller: controller,
            enabled: widget.isEditable,
            keyboardType: type,
            onChanged: isCalc ? (v) => calculateValues() : null,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// -------- DATE FIELD --------
  Widget buildDateField(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Text(
            date != null ? DateFormat('dd MMM yyyy').format(date) : "No Date",
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget dropdownField(String label, String value, List<String> items,
      Function(String?) onChanged) {
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
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                // child: Text(sourceMap[e] ?? gradeMap[e] ?? e),
                child: Text(gradeMap[e] ?? e),
              );
            }).toList(),
            // onChanged: onChanged,
            //30/03/2026
            onChanged: widget.isEditable ? onChanged : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

//delete record
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteRecord();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteRecord() async {
    bool success =
        await repo.deleteCubeRecord(recordData["id"] ?? widget.data["id"]);

    if (success) {
      Navigator.pop(context, true);
    }
  }

  /// -------- CUBE CARD --------
  Widget cubeCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Cube ${index + 1}".boldRobotoTextStyle(fontSize: 18),
          const SizedBox(height: 10),
          textField("Cube ID", cubeIds[index]),
          Row(
            children: [
              Expanded(
                  child: textField("Length", lengths[index],
                      type: TextInputType.number)),
              const SizedBox(width: 10),
              Expanded(
                  child: textField("Breadth", breadths[index],
                      type: TextInputType.number)),
              const SizedBox(width: 10),
              Expanded(
                  child: textField("Height", heights[index],
                      type: TextInputType.number)),
            ],
          ),
          textField("Weight (kg)", weights[index],
              type: TextInputType.number, isCalc: true),
          textField("Load (kN)", loads[index],
              type: TextInputType.number, isCalc: true),
          "Density : ${densities[index].toStringAsFixed(2)} Kg/m³"
              .regularRobotoTextStyle(fontSize: 14),
          "Strength : ${strengths[index].toStringAsFixed(2)} N/mm²"
              .regularRobotoTextStyle(fontSize: 14),
        ],
      ),
    );
  }

  /// -------- MAIN UI --------
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final bool isApprover =
        preferences.getString(SharedPreference.userType)!.toLowerCase() ==
            "approver";

    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButton: const CommonBackToHomeButton(),
      appBar: AppBarWidget(
         backGroundColor: const Color(0xFF3498DB),
        title: "Cube Details".boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  textField("Sr. No", srNoController),

                  buildDateField("Date of Casting", castingDate),
                  //
                  dropdownField(
                    "Grade of Concrete",
                    grade,
                    gradeMap.keys.toList(),
                    (v) {
                      setState(() {
                        grade = v!;

                        String gradeText = gradeMap[v]!;

                        // Extract only number from string (M55 → 55, M40 PT → 40)
                        RegExp regExp = RegExp(r'\d+');
                        Match? match = regExp.firstMatch(gradeText);

                        if (match != null) {
                          gradeValue = double.parse(match.group(0)!);
                        }
                      });
                    },
                  ),

                  "Grade Value : $gradeValue"
                      .regularRobotoTextStyle(fontSize: 14),

                  const SizedBox(height: 16),
                  //

                  textField("Quantity (m³)", quantityController,
                      type: TextInputType.number),

                  textField("Location / Structure", locationController),
                  textField("Concrete Source", sourceController),

                  buildDateField("Date of Testing", testingDate),

                  "Age (Days): $ageDays".boldRobotoTextStyle(fontSize: 16),

                  const SizedBox(height: 20),

                  /// -------- CUBE CARDS --------
                  cubeCard(0),
                  cubeCard(1),
                  cubeCard(2),

                  const SizedBox(height: 10),

                  "Average Compressive Strength : ${avgStrength.toStringAsFixed(2)} N/mm²"
                      .boldRobotoTextStyle(fontSize: 16),

                  const SizedBox(height: 8),

                  "Compressive Strength : ${strengthPercent.toStringAsFixed(2)} %"
                      .boldRobotoTextStyle(fontSize: 16),
                  const SizedBox(height: 30),

                  if (isApprover)
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CubeUpdateScreen(
                              record: recordData, // pass full record
                            ),
                          ),
                        );

                        if (result == true) {
                          Navigator.pop(context, true); // refresh list
                        }
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 17, 12, 147),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Update Record",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  if (isApprover)
                    // const SizedBox(height: 10),

                    if (isApprover)
                      GestureDetector(
                        onTap: confirmDelete,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Delete Record",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
