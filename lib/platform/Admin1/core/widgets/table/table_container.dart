import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class TableContainer extends StatelessWidget {
  final Widget child;
  final double minWidth;

  const TableContainer({super.key, required this.child, this.minWidth = 620});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
         color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final needsScroll = constraints.maxWidth < minWidth;
          return needsScroll
              ? _ScrollableTable(minWidth: minWidth, child: child)
              : child;
        },
      ),
    );
  }
}

class _ScrollableTable extends StatefulWidget {
  final double minWidth;
  final Widget child;
  const _ScrollableTable({required this.minWidth, required this.child});

  @override
  State<_ScrollableTable> createState() => _ScrollableTableState();
}

class _ScrollableTableState extends State<_ScrollableTable> {
  final _scrollCtrl = ScrollController();

  @override
  void dispose() { _scrollCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollCtrl,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,       
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        scrollDirection: Axis.horizontal,
        child: SizedBox(width: widget.minWidth, child: widget.child),
      ),
    );
  }
}