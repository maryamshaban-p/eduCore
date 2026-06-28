import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/shared_widgets/custom_data_table.dart';
import 'package:edulink_app/site/shared_widgets/custom_exportCSV_button.dart';
import 'package:flutter/material.dart';

class CustomEnrollmentTableCard extends StatelessWidget {
  final List<List<TableCellData>> tableRows;
  final double? screenWidth;
  final double? screenHeight;

  const CustomEnrollmentTableCard({
    super.key,
    required this.tableRows,
    this.screenWidth,
    this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Enrollment Records',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate800,
                ),
              ),
              const CustomExportCsvButton(),
            ],
          ),
          const SizedBox(height: 16),

          // Table (horizontal scroll on narrow)
          LayoutBuilder(
            builder: (context, constraints) {
              const minTableWidth = 600.0;
              final needsScroll = constraints.maxWidth < minTableWidth;

              final table = CustomDataTable(
                columns: const [
                  TableColumnDef(label: 'Student', widthFactor: 0.18),
                  TableColumnDef(label: 'Teacher', widthFactor: 0.22),
                  TableColumnDef(label: 'Subject', widthFactor: 0.18),
                  TableColumnDef(label: 'Date Enrolled', widthFactor: 0),
                ],
                rows: tableRows,
                onRowTap: (_) {},
              );

              if (needsScroll) {
                return Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(width: minTableWidth, child: table),
                  ),
                );
              }
              return table;
            },
          ),
        ],
      ),
    );
  }
}
