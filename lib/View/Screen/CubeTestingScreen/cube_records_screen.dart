import 'package:jhamtani_app/Api/Repo/cube_testing_repo.dart';
import 'package:jhamtani_app/View/Constant/app_color.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_details_screen.dart';
import 'package:jhamtani_app/View/Screen/CubeTestingScreen/cube_testing_form_screen.dart';
import 'package:jhamtani_app/View/Utils/extension.dart';
import 'package:jhamtani_app/View/Widgets/app_bar.dart';
import 'package:jhamtani_app/View/Widgets/back_to_home_button.dart';
import 'package:flutter/material.dart';


class CubeRecordsScreen extends StatefulWidget {
  final int floorId;

  const CubeRecordsScreen({
    super.key,
    required this.floorId,
  });

  @override
  State<CubeRecordsScreen> createState() => _CubeRecordsScreenState();
}

class _CubeRecordsScreenState extends State<CubeRecordsScreen> {
  List records = [];
  bool isLoading = true;

  final CubeTestingRepository repo = CubeTestingRepository();

  String _textFrom(dynamic value) {
    if (value == null) return "";
    final text = value.toString().trim();
    if (text.toLowerCase() == "null") return "";
    return text;
  }

  String _formatGrade(dynamic value) {
    final grade = _textFrom(value);
    if (grade.isEmpty) return "";
    return grade.toUpperCase().replaceAll("FF", " FF").replaceAll("PT", " PT");
  }

  String _cubeIds(dynamic cubeLines, dynamic fallbackCubeId) {
    if (cubeLines is List) {
      final ids = cubeLines
          .whereType<Map>()
          .map((cube) => _textFrom(cube["cube_no"] ?? cube["cube_id"]))
          .where((id) => id.isNotEmpty)
          .toList();
      if (ids.isNotEmpty) {
        return ids.join(", ");
      }
    }
    return _textFrom(fallbackCubeId);
  }

  String _formatAverageStrength(dynamic value) {
    final avg = double.tryParse(_textFrom(value));
    if (avg == null) return "";
    return avg.toStringAsFixed(2);
  }

  String _formatCompressiveStrength(dynamic value) {
    final strength = double.tryParse(_textFrom(value));
    if (strength == null) return "";
    return strength.toStringAsFixed(2);
  }

  String _resolveAge(Map record) {
    final age = _textFrom(record["age_days"]);
    if (age.isNotEmpty) return age;

    final castingDate = DateTime.tryParse(_textFrom(record["date_casting"]));
    final testingDate = DateTime.tryParse(_textFrom(record["date_testing"]));

    if (castingDate != null && testingDate != null) {
      return testingDate.difference(castingDate).inDays.toString();
    }

    return "";
  }

  Future<Map<String, dynamic>> _enrichRecord(dynamic item) async {
    final record = Map<String, dynamic>.from(item as Map);
    final recordId = record["id"] is int
        ? record["id"] as int
        : int.tryParse(_textFrom(record["id"]));

    final needsDetails = _textFrom(record["location_structure"]).isEmpty ||
        _cubeIds(record["cube_lines"] ?? record["cubes"], record["cube_id"])
            .isEmpty ||
        _resolveAge(record).isEmpty;

    if (!needsDetails || recordId == null) {
      return record;
    }

    final details = await repo.getSingleRecord(recordId);
    if (details is Map<String, dynamic>) {
      return {
        ...record,
        ...details,
      };
    }

    return record;
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: "$label : $value".regularRobotoTextStyle(fontSize: 13),
    );
  }

  Future<void> getCubeRecords() async {
    final data = await repo.getRecords(floorId: widget.floorId);
    final enrichedRecords = await Future.wait(data.map(_enrichRecord));

    if (!mounted) return;

    setState(() {
      records = enrichedRecords;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCubeRecords();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButton: const CommonBackToHomeButton(),
      // appBar: AppBarWidget(
      //   title: "Cube Testing Records".boldRobotoTextStyle(fontSize: 20),
      // ),
      appBar: AppBarWidget(
  backGroundColor: const Color(0xFF3498DB), // Sky Blue
  title: "Cube Testing Records".boldRobotoTextStyle(
    fontSize: 20,
    fontColor: Colors.white,
  ),
),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : records.isEmpty
                    ? const Center(child: Text("No Cube Records Found"))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 12),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          final srNo = _textFrom(record["sr_no"]);
                          final towerName = _textFrom(record["tower_name"]);
                          final location =
                              _textFrom(record["location_structure"]);
                          final cubeId = _cubeIds(
                            record["cube_lines"] ?? record["cubes"],
                            record["cube_id"],
                          );
                          final gradeConcrete =
                              _formatGrade(record["grade_concrete"]);
                          final quantity = _textFrom(record["quantity"]);
                          final age = _resolveAge(record);
                          final avgStrength =
                              _formatAverageStrength(record["avg_strength"]);
                          final compressiveStrength =
                              _formatCompressiveStrength(
                                  record["strength_percent"]);

                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CubeDetailsScreen(
                                    data: record,
                                    isEditable: false,
                                  ),
                                ),
                              );

                              if (result == true) {
                                getCubeRecords();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xffE6E6E6)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Sr.No : $srNo"
                                      .boldRobotoTextStyle(fontSize: 16),
                                  const SizedBox(height: 6),
                                  _buildInfoRow("Tower Name", towerName),
                                  _buildInfoRow("Casting Date",
                                      _textFrom(record["date_casting"])),
                                  _buildInfoRow("Testing Date",
                                      _textFrom(record["date_testing"])),
                                  _buildInfoRow("Age (Days)", age),
                                  _buildInfoRow("Location", location),
                                  _buildInfoRow("Cube ID", cubeId),
                                  _buildInfoRow(
                                      "Grade of Concrete", gradeConcrete),
                                  _buildInfoRow("Quantity (m³)", quantity),
                                  _buildInfoRow("Average Compressive Strength",
                                      "$avgStrength N/mm²"),
                                  _buildInfoRow("Compressive Strength",
                                      "$compressiveStrength %"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: "addCubeRecord",
              backgroundColor: Colors.black,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CubeTestingFormScreen(
                      floorId: widget.floorId,
                    ),
                  ),
                );

                if (result == true) {
                  getCubeRecords();
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
