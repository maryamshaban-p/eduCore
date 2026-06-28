import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

/// One shared widget for the load → loading-spinner → (error+retry | content)
/// pattern that was being copy-pasted (with small visual differences) in
/// every moderator screen.
///
/// Usage:
/// ```dart
/// Expanded(
///   child: LoadingErrorView(
///     isLoading: _isLoading,
///     error: _error,
///     onRetry: _loadData,
///     builder: (context) => MyContentWidget(...),
///   ),
/// )
/// ```
class LoadingErrorView extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final WidgetBuilder builder;

  /// Set false for compact spots (e.g. inside a small floating widget)
  /// where a 40px icon + padded card would be too large.
  final bool compact;

  const LoadingErrorView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    required this.builder,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      final iconSize = compact ? 28.0 : 40.0;
      final fontSize = compact ? 11.0 : 13.0;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, color: AppColors.danger, size: iconSize),
              const SizedBox(height: 10),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: fontSize, color: AppColors.slate600),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry', style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return builder(context);
  }
}

/// Same idea as [LoadingErrorView] but for spots that show an inline empty
/// message instead of a spinner (e.g. "No messages yet.") — kept separate
/// so callers stay explicit about which case they're in.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyStateView({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.slate300),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate400),
            ),
          ],
        ),
      ),
    );
  }
}