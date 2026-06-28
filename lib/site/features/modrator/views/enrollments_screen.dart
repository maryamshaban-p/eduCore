import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_enrollment_service.dart';
import 'package:edulink_app/site/shared_widgets/custom_data_table.dart';
import 'package:edulink_app/site/shared_widgets/custom_exportCSV_button.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:flutter/material.dart';

class EnrollmentsScreen extends StatefulWidget {
  const EnrollmentsScreen({super.key});
  @override
  State<EnrollmentsScreen> createState() => _EnrollmentsScreenState();
}

class _EnrollmentsScreenState extends State<EnrollmentsScreen> {
  final ModeratorEnrollmentService _service = ModeratorEnrollmentService();
  final ScrollController _horizontalScrollController = ScrollController();
  List<EnrollmentRecord> _records = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEnrollments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.getEnrollments();
      if (!mounted) return;
      setState(() {
        _records = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text(
              'Enrollment Records',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.slate800,
              ),
            ),
            const Spacer(),
            const CustomExportCsvButton(),
          ]),
          const SizedBox(height: 16),

          Expanded(
            child: LoadingErrorView(
              isLoading: _isLoading,
              error: _error,
              onRetry: _loadEnrollments,
              builder: (context) => SingleChildScrollView( // ← FIX: prevents overflow
                child: LayoutBuilder(
                  builder: (ctx, c) {
                    const minW = 620.0;
                    final table = Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.slate200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomDataTable(
                        columns: const [
                          TableColumnDef(label: 'Student',       widthFactor: 0),
                          TableColumnDef(label: 'Teacher',       widthFactor: 0.24),
                          TableColumnDef(label: 'Subject',       widthFactor: 0.20),
                          TableColumnDef(label: 'Date Enrolled', widthFactor: 0.20),
                        ],
                        rows: _records.map((r) => [
                          TableCellData(
                            widthFactor: 0,
                            child: Text(
                              r.studentName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.slate800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TableCellData(
                            widthFactor: 0.24,
                            child: Text(
                              r.teacherName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.slate600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TableCellData(
                            widthFactor: 0.20,
                            child: Text(
                              r.subject,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.slate600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TableCellData(
                            widthFactor: 0.20,
                            child: Text(
                              r.dateEnrolled,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.slate500,
                              ),
                            ),
                          ),
                        ]).toList(),
                      ),
                    );

                    if (c.maxWidth < minW) {
                      return Scrollbar(
                        controller: _horizontalScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(width: minW, child: table),
                        ),
                      );
                    }
                    return table;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}