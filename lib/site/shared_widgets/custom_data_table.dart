import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class TableColumnDef {
  final String label;
  final double widthFactor;
  final Color? labelColor;
  final bool centered;

  const TableColumnDef({
    required this.label,
    required this.widthFactor,
    this.labelColor,
    this.centered = false,
  });
}

class TableCellData {
  final Widget child;
  final double widthFactor;
  final bool centered;

  const TableCellData({
    required this.child,
    required this.widthFactor,
    this.centered = false,
  });
}

class CustomDataTable extends StatefulWidget {
  final List<TableColumnDef> columns;
  final List<List<TableCellData>> rows;
  final void Function(int index)? onRowTap;
  final double minWidth;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.minWidth = 820,
  });

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateIndicator);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  void _updateIndicator() {
    if (!mounted || !_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final cur = _scrollController.offset;
    final canScroll = max > 0 && cur < max - 1;
    if (canScroll != _canScrollRight) {
      setState(() => _canScrollRight = canScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateIndicator);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildTable(double tableWidth) {
    return Container(
      width: tableWidth,
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
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: widget.columns.map((col) {
                final style = TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: col.labelColor ?? AppColors.slate500,
                  letterSpacing: 0.3,
                );
                final label = col.centered
                    ? Center(child: Text(col.label, style: style))
                    : Text(col.label, style: style);
                final padded = Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: label,
                );
                return col.widthFactor == 0
                    ? Expanded(child: padded)
                    : SizedBox(
                        width: tableWidth * col.widthFactor, child: padded);
              }).toList(),
            ),
          ),

          const Divider(height: 1, color: AppColors.slate200),

          // ── Rows ────────────────────────────────────────────────
          ListView.separated(
            itemCount: widget.rows.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.slate100),
            itemBuilder: (context, i) {
              return _HoverableRow(
                onTap: widget.onRowTap != null
                    ? () => widget.onRowTap!(i)
                    : null,
                isLast: i == widget.rows.length - 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.rows[i].map((cell) {
                      final content = cell.centered
                          ? Center(child: cell.child)
                          : cell.child;
                      return cell.widthFactor == 0
                          ? Expanded(child: content)
                          : SizedBox(
                              width: tableWidth * cell.widthFactor,
                              child: content,
                            );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth > widget.minWidth
            ? constraints.maxWidth
            : widget.minWidth;

        return Stack(
          children: [
            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: _buildTable(tableWidth),
              ),
            ),

            // fade shadow when there's more content to the right
            if (_canScrollRight)
              Positioned(
                right: 0,
                top: 0,
                bottom: 8,
                width: 48,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ── Hoverable row ─────────────────────────────────────────────────────────────

class _HoverableRow extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isLast;

  const _HoverableRow({
    required this.child,
    this.onTap,
    required this.isLast,
  });

  @override
  State<_HoverableRow> createState() => _HoverableRowState();
}

class _HoverableRowState extends State<_HoverableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.slate50 : Colors.white,
          borderRadius: widget.isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : null,
        ),
        // Use InkWell instead of GestureDetector so inner buttons
        // can still receive their own taps via proper hit-test bubbling
        child: widget.onTap != null
            ? InkWell(
                onTap: widget.onTap,
                child: widget.child,
              )
            : widget.child,
      ),
    );
  }
}

// ── Helper cell builders ──────────────────────────────────────────────────────

Widget studentAvatarCell({
  required String initials,
  required String name,
  double? screenWidth,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryXL,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF102B45),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF102B45),
            ),
            softWrap: true,
          ),
        ),
      ],
    ),
  );
}

Widget scoreCell(int score, [double? screenWidth]) {
  final Color color;
  if (score >= 85) {
    color = AppColors.success;
  } else if (score >= 70) {
    color = AppColors.warning;
  } else {
    color = AppColors.danger;
  }

  return Text(
    '$score%',
    style: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      color: color,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget statusBadge(String status, [double? screenWidth]) {
  final isApproved = status == 'Approved';

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: isApproved ? AppColors.successBg : AppColors.dangerBg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isApproved ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 13,
          color: isApproved ? AppColors.success : AppColors.danger,
        ),
        const SizedBox(width: 4),
        Text(
          status,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isApproved ? AppColors.success : AppColors.danger,
          ),
        ),
      ],
    ),
  );
}

// ── Shared error+retry widget ─────────────────────────────────────────────────

class ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorRetry({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.slate600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
}