// import 'package:edulink_app/site/features/teacher/services/teacher_student_service.dart';
// import 'package:edulink_app/site/shared_widgets/custom_data_table.dart';
// import 'package:edulink_app/site/shared_widgets/custom_exportCSV_button.dart';
// import 'package:edulink_app/core/theme/app_theam.dart';
// import 'package:flutter/material.dart';

// class GradesScreen extends StatefulWidget {
//   const GradesScreen({super.key});
//   @override
//   State<GradesScreen> createState() => _GradesScreenState();
// }

// class _GradesScreenState extends State<GradesScreen> {
//   final TeacherStudentService _service = TeacherStudentService();
//   List<Map<String, dynamic>> _grades = [];
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() { super.initState(); _loadGrades(); }

//   Future<void> _loadGrades() async {
//     try {
//       final data = await _service.getGrades();
//       setState(() { _grades = data; _isLoading = false; });
//     } catch (e) {
//       setState(() { _error = e.toString(); _isLoading = false; });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               const Text('Grades', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slate800)),
//               const Spacer(),
//               const CustomExportCsvButton(),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Table
//           if (_isLoading)
//             const Expanded(child: Center(child: CircularProgressIndicator()))
//           else if (_error != null)
//             Expanded(child: ErrorRetry(message: _error!, onRetry: () { setState(() { _isLoading = true; _error = null; }); _loadGrades(); }))
//           else
//             Expanded(
//               child: LayoutBuilder(builder: (ctx, c) {
//                 const minW = 580.0;
//                 final table = CustomDataTable(
//                   columns: const [
//                     TableColumnDef(label: 'Student',    widthFactor: 0),
//                     TableColumnDef(label: 'Homework',   widthFactor: 0.22, labelColor: AppColors.teal),
//                     TableColumnDef(label: 'Entry Test', widthFactor: 0.22, labelColor: AppColors.teal),
//                     TableColumnDef(label: 'Overall',    widthFactor: 0.18, labelColor: AppColors.teal),
//                   ],
//                   rows: _grades.map((g) => [
//                     TableCellData(widthFactor: 0,    child: Text(g['studentName'] ?? '', style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate800), overflow: TextOverflow.ellipsis)),
//                     TableCellData(widthFactor: 0.22, child: scoreCell((g['averageHomework'] ?? 0).toInt())),
//                     TableCellData(widthFactor: 0.22, child: scoreCell((g['averageQuiz'] ?? 0).toInt())),
//                     TableCellData(widthFactor: 0.18, child: scoreCell((g['overallAverage'] ?? 0).toInt())),
//                   ]).toList(),
//                 );
//                 if (c.maxWidth < minW) {
//                   return Scrollbar(thumbVisibility: true, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: SizedBox(width: minW, child: table)));
//                 }
//                 return table;
//               }),
//             ),
//         ],
//       ),
//     );
//   }
// }
