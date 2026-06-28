import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/subject/data/summarize_model.dart';
import 'package:edulink_app/students/features/subject/data/summarize_repo.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// Full-page screen: pick a PDF, send it to POST /api/ai/summarize, and
/// show the returned summary with copy/download actions. Pushed via
/// Navigator.push from the "Summarize" card on the student home screen —
/// not a bottom sheet/dialog, since the result is a long block of text
/// that deserves full reading space plus its own app bar actions.
class SummarizePdfScreen extends StatefulWidget {
  
  const SummarizePdfScreen({super.key});

  @override
  State<SummarizePdfScreen> createState() => _SummarizePdfScreenState();
}

enum _ScreenState { empty, loading, result, error }

class _SummarizePdfScreenState extends State<SummarizePdfScreen> {
  final SummarizeRepository _repository = SummarizeRepository();

  _ScreenState _state = _ScreenState.empty;
  String? _pickedFileName;
  SummarizeResultModel? _result;
  String? _errorMessage;

  // Shows a brief "Copied" confirmation on the copy button instead of a
  // snackbar, so it doesn't compete with the long summary text on screen.
  bool _justCopied = false;

  Future<void> _pickAndSummarize() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // required so bytes are available without a file path
    );
    if (picked == null || picked.files.isEmpty) return;

    final file = picked.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      setState(() {
        _state = _ScreenState.error;
        _errorMessage = 'Could not read the selected file. Please try again.'.tr();
      });
      return;
    }

    setState(() {
      _state = _ScreenState.loading;
      _pickedFileName = file.name;
      _errorMessage = null;
    });

    try {
      final result = await _repository.summarizePdf(
        pdfBytes: bytes,
        fileName: file.name,
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _state = _ScreenState.result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _ScreenState.error;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _reset() {
    setState(() {
      _state = _ScreenState.empty;
      _pickedFileName = null;
      _result = null;
      _errorMessage = null;
      _justCopied = false;
    });
  }

  Future<void> _copySummary() async {
    final summary = _result?.summary ?? '';
    if (summary.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: summary));
    if (!mounted) return;
    setState(() => _justCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _justCopied = false);
    });
  }

  Future<void> _downloadSummary() async {
    // No filesystem-write package is confirmed available for this app
    // (only file_picker for reads), so "Download" falls back to copying
    // the summary to the clipboard plus a clear toast, rather than
    // silently doing nothing or guessing at a save-file API that might
    // not be wired up yet.
    final summary = _result?.summary ?? '';
    if (summary.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: summary));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text('Summary copied — paste it anywhere to save it.'.tr()),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        final isDark =  Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark? Theme.of(context).scaffoldBackgroundColor:  AppColors.lightWhiteBlue,
      appBar: AppBar(
        backgroundColor: isDark? Theme.of(context).scaffoldBackgroundColor: AppColors.whiteColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title:  Center(
          child: Text(
            'Summarize PDF'.tr(),
            style: TextStyle(
              color:isDark? Theme.of(context).colorScheme.onSurface: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _ScreenState.loading:
        return _buildLoading();
      case _ScreenState.result:
        return _buildResult();
      case _ScreenState.error:
        return _buildError();
      case _ScreenState.empty:
        return _buildEmpty();
    }
  }

    Widget _buildEmpty() {
          final isDark =  Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _iconBadge(Icons.picture_as_pdf_outlined, AppColors.deepBlue),
          const SizedBox(height: 20),
           Text(
            'Summarize a PDF'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark? Theme.of(context).colorScheme.onSurface: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Upload a lesson PDF and get an instant, easy-to-read summary.'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: isDark? Theme.of(context).colorScheme.onSurface: AppColors.greyColor),
            ),
          ),
          const SizedBox(height: 28),
          _primaryButton(
            label: 'Choose PDF File'.tr(),
            icon: Icons.upload_file_rounded,
            onTap: _pickAndSummarize,
          ),
        ],
      ),
    );
  }

  // ── Loading state ─────────────────────────────────────────────────────
  Widget _buildLoading() {
        final isDark =  Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _iconBadge(Icons.auto_awesome_rounded, AppColors.meduimBlue),
          const SizedBox(height: 20),
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
           Text(
            'Summarizing your PDF...'.tr(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark? Theme.of(context).colorScheme.onSurface: AppColors.primaryColor,
            ),
          ),
          if (_pickedFileName != null) ...[
            const SizedBox(height: 6),
            Text(
              _pickedFileName!,
              style: TextStyle(fontSize: 12.5, color: isDark? Theme.of(context).colorScheme.onSurface: AppColors.greyColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _iconBadge(Icons.error_outline_rounded, AppColors.deepRed),
          const SizedBox(height: 20),
           Text(
            'Something went wrong'.tr(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _errorMessage ?? 'Please try again.'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: AppColors.greyColor),
            ),
          ),
          const SizedBox(height: 24),
          _primaryButton(
            label: 'Try Again'.tr(),
            icon: Icons.refresh_rounded,
            onTap: _pickAndSummarize,
          ),
        ],
      ),
    );
  }

  // ── Result state ──────────────────────────────────────────────────────
  Widget _buildResult() {
    final result = _result!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File header card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.lightWhiteBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.picture_as_pdf_rounded,
                    color: AppColors.deepRed, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.filename.isEmpty ? 'Summary'.tr() : result.filename,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'AI-generated summary'.tr(),
                      style: TextStyle(
                          fontSize: 11.5, color: AppColors.greyColor),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _reset,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded,
                      size: 18, color: AppColors.greyColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Summary text card — scrollable, fills remaining space
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Text(
                result.summary.isEmpty
                    ? 'No summary text was returned.'.tr()
                    : result.summary,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.55,
                  color: AppColors.charcoalGray,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Actions row — Copy / Download, mirroring the Swagger response
        // actions shown for this endpoint.
        Row(
          children: [
            Expanded(
              child: _secondaryButton(
                label: _justCopied ? 'Copied!' : 'Copy',
                icon: _justCopied
                    ? Icons.check_rounded
                    : Icons.copy_rounded,
                color: _justCopied ? AppColors.greenColor : AppColors.primaryColor,
                onTap: _copySummary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _primaryButton(
                label: 'Download'.tr(),
                icon: Icons.download_rounded,
                onTap: _downloadSummary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.add_rounded,
                size: 17, color: AppColors.meduimBlue),
            label:  Text(
              'Summarize Another File'.tr(),
              style: TextStyle(
                color: AppColors.meduimBlue,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Shared small widgets ──────────────────────────────────────────────
  Widget _iconBadge(IconData icon, Color color) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 32, color: color),
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.4)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}