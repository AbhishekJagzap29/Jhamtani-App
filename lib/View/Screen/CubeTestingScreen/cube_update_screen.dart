import 'package:jhamtani_app/Api/Repo/cube_testing_repo.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CubeUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> record;

  const CubeUpdateScreen({
    super.key,
    required this.record,
  });

  @override
  State<CubeUpdateScreen> createState() => _CubeUpdateScreenState();
}

class _CubeUpdateScreenState extends State<CubeUpdateScreen> {
  final CubeTestingRepository repo = CubeTestingRepository();
  final TextEditingController srNoController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  final List<TextEditingController> cubeIds =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> lengths =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> breadths =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> heights =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> weights =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> loads =
      List.generate(3, (_) => TextEditingController());

  final Map<String, String> gradeMap = {
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
    "m30ff": "M30 FF",
    "m35ff": "M35 FF",
    "m40ff": "M40 FF",
    "m45ff": "M45 FF",
    "m50ff": "M50 FF",
    "m55ff": "M55 FF",
    "m60ff": "M60 FF",
    "m35pt": "M35 PT",
    "m40pt": "M40 PT",
    "m45pt": "M45 PT",
  };

  DateTime? castingDate;
  DateTime? testingDate;
  String grade = "m20";
  double gradeValue = 20;
  int ageDays = 0;
  final List<double> densities = [0, 0, 0];
  final List<double> strengths = [0, 0, 0];
  double avgStrength = 0;
  double strengthPercent = 0;

  @override
  void initState() {
    super.initState();
    setData(widget.record);
  }

  @override
  void dispose() {
    srNoController.dispose();
    quantityController.dispose();
    locationController.dispose();
    sourceController.dispose();
    for (final controller in [
      ...cubeIds,
      ...lengths,
      ...breadths,
      ...heights,
      ...weights,
      ...loads,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String _textFrom(dynamic value) {
    if (value == null) return "";
    final text = value.toString().trim();
    if (text.toLowerCase() == "null") return "";
    return text;
  }

  DateTime? _parseDate(dynamic value) {
    final text = _textFrom(value);
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }

  double _extractGradeValue(String gradeKey) {
    final gradeText = gradeMap[gradeKey] ?? gradeKey;
    final match = RegExp(r'\d+').firstMatch(gradeText);
    return double.tryParse(match?.group(0) ?? "") ?? 20;
  }

  void setData(Map<String, dynamic> data) {
    srNoController.text = _textFrom(data["sr_no"]);
    quantityController.text = _textFrom(data["quantity"]);
    locationController.text = _textFrom(data["location_structure"]);
    sourceController.text = _textFrom(
      data["source_concrete"] ?? data["concrete_source"],
    );

    castingDate = _parseDate(data["date_casting"]);
    testingDate = _parseDate(data["date_testing"]);
//28/03/2026
    grade = _textFrom(data["grade_concrete"]).isNotEmpty
        ? _textFrom(data["grade_concrete"]).toLowerCase()
        : "m20";

    if (!gradeMap.containsKey(grade)) {
      grade = "m20";
    }

    gradeValue = _extractGradeValue(grade);
//

    final cubeLinesRaw = data["cube_lines"] ?? data["cubes"];
    final cubeLines = cubeLinesRaw is List
        ? cubeLinesRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
        : <Map<String, dynamic>>[];

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

    for (int i = 0; i < cubeLines.length && i < 3; i++) {
      final cube = cubeLines[i];
      cubeIds[i].text = _textFrom(cube["cube_no"] ?? cube["cube_id"]);
      lengths[i].text = _textFrom(cube["length"]);
      breadths[i].text = _textFrom(cube["breadth"]);
      heights[i].text = _textFrom(cube["height"]);
      weights[i].text = _textFrom(cube["weight"]);
      loads[i].text = _textFrom(cube["load"]);
    }

    if (cubeLines.isEmpty) {
      cubeIds[0].text = _textFrom(data["cube_id"]);
      weights[0].text = _textFrom(data["weight1"]);
      weights[1].text = _textFrom(data["weight2"]);
      weights[2].text = _textFrom(data["weight3"]);
      loads[0].text = _textFrom(data["load1"]);
      loads[1].text = _textFrom(data["load2"]);
      loads[2].text = _textFrom(data["load3"]);
    }

    calculateAge();
    calculateValues(isInit: true);
  }

  void calculateAge() {
    if (castingDate != null && testingDate != null) {
      ageDays = testingDate!.difference(castingDate!).inDays;
    } else {
      ageDays = 0;
    }
  }

  void calculateValues({bool isInit = false}) {
    double total = 0;
    int validCount = 0;

    for (int i = 0; i < 3; i++) {
      final weight = double.tryParse(weights[i].text) ?? 0;
      final length = double.tryParse(lengths[i].text) ?? 0;
      final breadth = double.tryParse(breadths[i].text) ?? 0;
      final height = double.tryParse(heights[i].text) ?? 0;
      final load = double.tryParse(loads[i].text) ?? 0;

      final volume = (length / 1000) * (breadth / 1000) * (height / 1000);
      densities[i] = volume == 0 ? 0 : weight / volume;

      final area = length * breadth;
      strengths[i] = area == 0 ? 0 : (load * 1000) / area;

      total += strengths[i];
      if (cubeIds[i].text.trim().isNotEmpty) {
        validCount++;
      }
    }

    avgStrength = validCount == 0 ? 0 : total / validCount;
    strengthPercent = gradeValue == 0 ? 0 : (avgStrength / gradeValue) * 100;

    if (!isInit && mounted) {
      setState(() {});
    }
  }

  Future<void> pickDate(bool isCasting) async {
    final initialDate = isCasting
        ? (castingDate ?? DateTime.now())
        : (testingDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: initialDate,
    );

    if (picked != null) {
      setState(() {
        if (isCasting) {
          castingDate = picked;
        } else {
          testingDate = picked;
        }
        calculateAge();
      });
    }
  }

  Future<void> onUpdateClick() async {
    if (srNoController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        sourceController.text.trim().isEmpty) {
      errorSnackBar("Validation", "Please fill all required fields");
      return;
    }

    if (castingDate == null || testingDate == null) {
      errorSnackBar("Validation", "Please select casting and testing date");
      return;
    }

    final hasAnyCube = List.generate(
      3,
      (i) =>
          cubeIds[i].text.trim().isNotEmpty ||
          weights[i].text.trim().isNotEmpty ||
          loads[i].text.trim().isNotEmpty,
    ).any((value) => value);

    if (!hasAnyCube) {
      errorSnackBar("Validation", "Please enter at least one cube");
      return;
    }

    calculateValues();

    final cubeLines = List.generate(3, (i) {
      if (cubeIds[i].text.trim().isEmpty &&
          weights[i].text.trim().isEmpty &&
          loads[i].text.trim().isEmpty) {
        return null;
      }

      final weight = double.tryParse(weights[i].text) ?? 0;
      final load = double.tryParse(loads[i].text) ?? 0;

      return {
        "cube_no": cubeIds[i].text.trim(),
        "length": double.tryParse(lengths[i].text) ?? 150,
        "breadth": double.tryParse(breadths[i].text) ?? 150,
        "height": double.tryParse(heights[i].text) ?? 150,
        "weight": weight,
        "load": load,
      };
    }).whereType<Map<String, dynamic>>().toList();

    if (cubeLines.isEmpty) {
      errorSnackBar("Validation", "Please enter at least one cube");
      return;
    }

    final userId =
        int.tryParse(preferences.getString(SharedPreference.userId) ?? "0") ?? 0;

    final body = {
      "user_id": userId,
      "sr_no": srNoController.text.trim(),
      "date_casting": DateFormat("yyyy-MM-dd").format(castingDate!),
      "date_testing": DateFormat("yyyy-MM-dd").format(testingDate!),
      "grade_concrete": grade,
      "grade_value": gradeValue.toInt(),
      "quantity": double.tryParse(quantityController.text) ?? 0,
      "location_structure": locationController.text.trim(),
      "source_concrete": sourceController.text.trim(),
      "age_days": ageDays,
      "avg_strength": avgStrength,
      "strength_percent": strengthPercent,
      "cube_lines": cubeLines,
    };

    try {
      final success = await repo.updateCubeRecord(widget.record["id"], body);

      if (!mounted) return;

      if (success) {
        successSnackBar("Success", "Record Updated Successfully");
        Navigator.pop(context, true);
      } else {
        errorSnackBar("Error", "Update Failed");
      }
    } catch (_) {
      if (!mounted) return;
      errorSnackBar("Error", "Something went wrong");
    }
  }

  Widget textField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool isCalc = false,
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
            keyboardType: type,
            onChanged: isCalc ? (_) => calculateValues() : null,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDateField(String label, DateTime? date, VoidCallback onTap) {
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null
                      ? DateFormat('dd MMM yyyy').format(date)
                      : "Select Date",
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget dropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
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
                child: Text(gradeMap[e] ?? e),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

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
                child: textField(
                  "Length",
                  lengths[index],
                  type: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: textField(
                  "Breadth",
                  breadths[index],
                  type: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: textField(
                  "Height",
                  heights[index],
                  type: TextInputType.number,
                ),
              ),
            ],
          ),
          textField(
            "Weight (kg)",
            weights[index],
            type: TextInputType.number,
            isCalc: true,
          ),
          textField(
            "Load (kN)",
            loads[index],
            type: TextInputType.number,
            isCalc: true,
          ),
          "Density : ${densities[index].toStringAsFixed(2)} Kg/m3"
              .regularRobotoTextStyle(fontSize: 14),
          "Strength : ${strengths[index].toStringAsFixed(2)} N/mm2"
              .regularRobotoTextStyle(fontSize: 14),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButton: const CommonBackToHomeButton(),
      // appBar: AppBarWidget(
      //   title: "Update Cube Record".boldRobotoTextStyle(fontSize: 20),
      // ),
            appBar: AppBarWidget(
              backGroundColor: const Color(0xFF3498DB),
              title:
                  "Update Cube Record".boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            textField("Sr. No", srNoController),
            buildDateField(
                "Date of Casting", castingDate, () => pickDate(true)),
            dropdownField(
              "Grade of Concrete",
              grade,
              gradeMap.keys.toList(),
              (value) {
                setState(() {
                  grade = value!;
                  gradeValue = _extractGradeValue(grade);
                  calculateValues(isInit: true);
                });
              },
            ),
            "Grade Value : $gradeValue N/mm2"
                .regularRobotoTextStyle(fontSize: 14),
            const SizedBox(height: 16),
            textField(
              "Quantity (m3)",
              quantityController,
              type: TextInputType.number,
            ),
            textField("Location / Structure", locationController),
            textField("Concrete Source", sourceController),
            buildDateField(
                "Date of Testing", testingDate, () => pickDate(false)),
            "Age (Days): $ageDays".boldRobotoTextStyle(fontSize: 16),
            const SizedBox(height: 20),
            cubeCard(0),
            cubeCard(1),
            cubeCard(2),
            const SizedBox(height: 10),
            "Average Strength : ${avgStrength.toStringAsFixed(2)}"
                .boldRobotoTextStyle(fontSize: 16),
            const SizedBox(height: 8),
            "Compressive Strength % : ${strengthPercent.toStringAsFixed(2)} %"
                .boldRobotoTextStyle(fontSize: 16),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: onUpdateClick,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 17, 12, 147),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
