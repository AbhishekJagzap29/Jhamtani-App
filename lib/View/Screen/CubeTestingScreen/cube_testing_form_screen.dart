import 'package:jhamtani_app/Api/Repo/cube_testing_repo.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Constant/shared_prefs.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_testing_form_controller.dart';
import 'package:jhamtani_app/View/Utils/app_layout.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CubeTestingFormScreen extends StatefulWidget {
  final int? floorId;

  const CubeTestingFormScreen({
    super.key,
     this.floorId,
  });

  @override
  State<CubeTestingFormScreen> createState() => _CubeTestingFormScreenState();
}

class _CubeTestingFormScreenState extends State<CubeTestingFormScreen> {
  final cubeController = CubeTestingController();
  final TextEditingController srNoController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final Map<String, String> fieldErrors = {};

  bool isLoading = false; 

  /// -------- MULTI CUBE CONTROLLERS --------
  List<TextEditingController> cubeIds =
      List.generate(3, (_) => TextEditingController());
  final TextEditingController sourceController = TextEditingController();

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

  final CubeTestingRepository cubeRepo = CubeTestingRepository();

  // Map<String, String> sourceMap = {
  //   "inhouse": "In-house",
  //   "rmc": "RMC Plant",
  // };

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

  // String source = "inhouse";

  int ageDays = 0;

  List<double> densities = [0, 0, 0];
  List<double> strengths = [0, 0, 0];

  double avgStrength = 0;
  double strengthPercent = 0;

  void calculateAge() {
    if (castingDate != null && testingDate != null) {
      ageDays = testingDate!.difference(castingDate!).inDays;
    }
  }

  void calculateValues() {
    double total = 0;
    int validCount = 0;

    for (int i = 0; i < 3; i++) {
      double w = double.tryParse(weights[i].text) ?? 0;
      double lVal = double.tryParse(lengths[i].text) ?? 0;
      double bVal = double.tryParse(breadths[i].text) ?? 0;
      double hVal = double.tryParse(heights[i].text) ?? 0;
      double loadVal = double.tryParse(loads[i].text) ?? 0;

      // Density
      double volume = (lVal / 1000) * (bVal / 1000) * (hVal / 1000);
      densities[i] = volume != 0 ? w / volume : 0;

      // Strength
      double area = lVal * bVal;
      strengths[i] = area != 0 ? (loadVal * 1000) / area : 0;

      total += strengths[i];
      if (cubeIds[i].text.trim().isNotEmpty) {
        validCount++;
      }
    }

    avgStrength = validCount == 0 ? 0 : total / validCount;

    //COMPRESSIVE STRENGTH %
    strengthPercent = (avgStrength / gradeValue) * 100;

    setState(() {});
  }

  Future pickDate(bool casting) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (casting) {
          castingDate = picked;
          fieldErrors.remove("date_casting");
        } else {
          testingDate = picked;
          fieldErrors.remove("date_testing");
        }
        calculateAge();
      });
    }
  }

  Widget textField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text,
      bool isCalc = false,
      String? fieldKey}) {
    final errorText = fieldKey == null ? null : fieldErrors[fieldKey];
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
            keyboardType: type,
            onChanged: (v) {
              if (fieldKey != null && v.trim().isNotEmpty) {
                setState(() {
                  fieldErrors.remove(fieldKey);
                });
              }
              if (isCalc) {
                calculateValues();
              }
            },
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDateField(String label, DateTime? date, Function() onTap,
      {String? fieldKey}) {
    final errorText = fieldKey == null ? null : fieldErrors[fieldKey];
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
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
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
                //  child: Text(sourceMap[e] ?? gradeMap[e] ?? e),
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

  void _setRequiredError(String fieldKey, bool isMissing) {
    if (isMissing) {
      fieldErrors[fieldKey] = "This field is required";
    } else {
      fieldErrors.remove(fieldKey);
    }
  }

  bool _validateForm() {
    _setRequiredError("sr_no", srNoController.text.trim().isEmpty);
    _setRequiredError("date_casting", castingDate == null);
    _setRequiredError("quantity", quantityController.text.trim().isEmpty);
    _setRequiredError(
        "location_structure", locationController.text.trim().isEmpty);
    _setRequiredError("source_concrete", sourceController.text.trim().isEmpty);
    _setRequiredError("date_testing", testingDate == null);

    for (int i = 0; i < 3; i++) {
      _setRequiredError("cube_id_$i", cubeIds[i].text.trim().isEmpty);
      _setRequiredError("length_$i", lengths[i].text.trim().isEmpty);
      _setRequiredError("breadth_$i", breadths[i].text.trim().isEmpty);
      _setRequiredError("height_$i", heights[i].text.trim().isEmpty);
      _setRequiredError("weight_$i", weights[i].text.trim().isEmpty);
      _setRequiredError("load_$i", loads[i].text.trim().isEmpty);
    }

    setState(() {});
    return fieldErrors.isEmpty;
  }

  /// ----------- CUBE CARD UI -----------
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
          textField("Cube ID", cubeIds[index], fieldKey: "cube_id_$index"),
          Row(
            children: [
              Expanded(
                  child: textField("Length", lengths[index],
                      type: TextInputType.number,
                      isCalc: true,
                      fieldKey: "length_$index")),
              const SizedBox(width: 10),
              Expanded(
                  child: textField("Breadth", breadths[index],
                      type: TextInputType.number,
                      isCalc: true,
                      fieldKey: "breadth_$index")),
              const SizedBox(width: 10),
              Expanded(
                  child: textField("Height", heights[index],
                      type: TextInputType.number,
                      isCalc: true,
                      fieldKey: "height_$index")),
            ],
          ),
          textField("Weight (kg)", weights[index],
              type: TextInputType.number,
              isCalc: true,
              fieldKey: "weight_$index"),
          textField("Load (kN)", loads[index],
              type: TextInputType.number,
              isCalc: true,
              fieldKey: "load_$index"),
          "Density : ${densities[index].toStringAsFixed(2)} Kg/m³"
              .regularRobotoTextStyle(fontSize: 14),
          "Strength : ${strengths[index].toStringAsFixed(2)} N/mm²"
              .regularRobotoTextStyle(fontSize: 14),
        ],
      ),
    );
  }

  /// ----------- SUBMIT -----------
  Future<void> submitCubeRecord() async {
  if (!_validateForm()) {
    errorSnackBar("Validation", "Please fill all required fields");
    return;
  }

  setState(() {
    isLoading = true; // START LOADING
  });

  final cubeLines = List.generate(3, (i) {
    return {
      "cube_no": cubeIds[i].text.trim(),
      "length": double.tryParse(lengths[i].text) ?? 0,
      "breadth": double.tryParse(breadths[i].text) ?? 0,
      "height": double.tryParse(heights[i].text) ?? 0,
      "weight": double.tryParse(weights[i].text) ?? 0,
      "load": double.tryParse(loads[i].text) ?? 0,
    };
  }).toList();

  final userId =
      int.tryParse(preferences.getString(SharedPreference.userId) ?? "0") ?? 0;

  Map<String, dynamic> body = {
    "user_id": userId,
    "sr_no": srNoController.text.trim(),
    "floor_id": widget.floorId,
    "date_casting": DateFormat("yyyy-MM-dd").format(castingDate!),
    "date_testing": DateFormat("yyyy-MM-dd").format(testingDate!),
    "grade_concrete": grade,
    "grade_value": gradeValue,
    "quantity": double.tryParse(quantityController.text) ?? 0,
    "location_structure": locationController.text.trim(),
    "source_concrete": sourceController.text.trim(),
    "age_days": ageDays,
    "cube_lines": cubeLines,
    "avg_strength": avgStrength,
    "strength_percent": strengthPercent
  };

  final response = await cubeRepo.createRecord(body);

  if (!mounted) return;

  setState(() {
    isLoading = false; // STOP LOADING
  });

  if (response != null) {
    successSnackBar("Success", "Cube record created successfully");
    Navigator.pop(context, true);
  } else {
    errorSnackBar("Error", "Failed to create cube record");
  }
}

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButton: const CommonBackToHomeButton(),
      // appBar: AppBarWidget(
      //   title: "Cube Testing Form".boldRobotoTextStyle(fontSize: 20),
      // ),
      appBar: AppBarWidget(
  backGroundColor: const Color(0xFF3498DB), // Sky Blue
  title: "Cube Testing Form".boldRobotoTextStyle(
    fontSize: 20,
    fontColor: Colors.white,
  ),
),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            textField("Sr. No", srNoController, fieldKey: "sr_no"),

            buildDateField(
                "Date of Casting", castingDate, () => pickDate(true),
                fieldKey: "date_casting"),

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

            "Grade Value : $gradeValue N/mm²"
                .regularRobotoTextStyle(fontSize: 14),

            const SizedBox(height: 16),

            textField("Quantity (m³)", quantityController,
                type: TextInputType.number, fieldKey: "quantity"),

            textField("Location / Structure", locationController,
                fieldKey: "location_structure"),

            textField("Concrete Source", sourceController,
                fieldKey: "source_concrete"),

            buildDateField(
                "Date of Testing", testingDate, () => pickDate(false),
                fieldKey: "date_testing"),

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

            "Compressive Strength  : ${strengthPercent.toStringAsFixed(2)} %"
                .boldRobotoTextStyle(fontSize: 16),

            const SizedBox(height: 30),

            GestureDetector(
  onTap: isLoading ? null : submitCubeRecord,
  child: Container(
    height: 55,
    decoration: BoxDecoration(
      color: isLoading ? Colors.grey : Colors.black,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const Text(
              "Submit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
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
