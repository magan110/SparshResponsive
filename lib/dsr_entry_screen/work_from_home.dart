import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dsr_entry.dart';
import '../theme/app_theme.dart';

class WorkFromHome extends StatefulWidget {
  const WorkFromHome({super.key});

  @override
  State<WorkFromHome> createState() => _WorkFromHomeState();
}

class _WorkFromHomeState extends State<WorkFromHome> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  final TextEditingController _submissionDateController = TextEditingController();
  final TextEditingController _reportDateController     = TextEditingController();
  DateTime? _selectedSubmissionDate;
  DateTime? _selectedReportDate;

  // ─── NEW CONTROLLERS ─────────────────────────────────────────────────────────
  final TextEditingController _activityDetails1Controller = TextEditingController();
  final TextEditingController _activityDetails2Controller = TextEditingController();
  final TextEditingController _activityDetails3Controller = TextEditingController();
  final TextEditingController _otherPointsController      = TextEditingController();
  // ─────────────────────────────────────────────────────────────────────────────

  final List<int> _uploadRows       = [0];
  final List<File?> _selectedImages = [null];
  final ImagePicker _picker         = ImagePicker();
  final _formKey                    = GlobalKey<FormState>();

  @override
  void dispose() {
    _submissionDateController.dispose();
    _reportDateController.dispose();

    // ─── DISPOSE NEW CONTROLLERS ──────────────────────────────────────────────
    _activityDetails1Controller.dispose();
    _activityDetails2Controller.dispose();
    _activityDetails3Controller.dispose();
    _otherPointsController.dispose();
    // ──────────────────────────────────────────────────────────────────────────

    super.dispose();
  }

  Future<void> _pickSubmissionDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedSubmissionDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blueAccent,
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedSubmissionDate = picked;
        _submissionDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickReportDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedReportDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blueAccent,
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedReportDate = picked;
        _reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _addRow() {
    setState(() {
      _uploadRows.add(_uploadRows.length);
      _selectedImages.add(null);
    });
  }

  void _removeRow() {
    if (_uploadRows.length <= 1) return;
    setState(() {
      _uploadRows.removeLast();
      _selectedImages.removeLast();
    });
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImages[index] = File(pickedFile.path));
    }
  }

  void _showImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Unable to load image', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Work From Home submitted! (local only)'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form
    _formKey.currentState!.reset();
    setState(() {
      _processItem = 'Select';
      _selectedSubmissionDate = null;
      _submissionDateController.clear();
      _selectedReportDate = null;
      _reportDateController.clear();
      _uploadRows
        ..clear()
        ..add(0);
      _selectedImages
        ..clear()
        ..add(null);

      // ─── CLEAR NEW FIELDS ────────────────────────────────────────────────
      _activityDetails1Controller.clear();
      _activityDetails2Controller.clear();
      _activityDetails3Controller.clear();
      _otherPointsController.clear();
      // ─────────────────────────────────────────────────────────────────────
    });
  }

  InputDecoration get _multilineDecoration => InputDecoration(
    hintText: '',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    isCollapsed: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const DsrEntry())),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Work From Home',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.white),
            ),
            Text(
              'Daily Sales Report Entry',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 24),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Help information for Work From Home'),
                duration: Duration(seconds: 2),
              ),
            ),
          )
        ],
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Process Section ──────────────────────────────────────────────
              AppTheme.buildSectionCard(
                title: 'Process',
                icon: Icons.settings_outlined,
                children: [
                  AppTheme.buildLabel('Process Type'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _processItem,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      isCollapsed: true,
                    ),
                    isExpanded: true,
                    items: _processdropdownItems
                        .map((item) => DropdownMenuItem(
                      value: item,
                      child: Container(
                        constraints:
                        const BoxConstraints(maxWidth: 250),
                        child: Text(item,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ))
                        .toList(),
                    onChanged: (v) => setState(() => _processItem = v),
                    validator: (v) =>
                    (v == null || v == 'Select') ? 'Required' : null,
                  ),
                ],
              ),

              // ─── Date Section ─────────────────────────────────────────────────
              AppTheme.buildSectionCard(
                title: 'Date Information',
                icon: Icons.date_range_outlined,
                children: [
                  AppTheme.buildLabel('Submission Date'),
                  const SizedBox(height: 8),
                  AppTheme.buildDateField(
                      context, _submissionDateController, _pickSubmissionDate, 'Select Submission Date'),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Report Date'),
                  const SizedBox(height: 8),
                  AppTheme.buildDateField(
                      context, _reportDateController, _pickReportDate, 'Select Report Date'),
                ],
              ),

              // ─── NEW: Activity Details Section ───────────────────────────────
              AppTheme.buildSectionCard(
                title: 'Activity Details',
                icon: Icons.description_outlined,
                children: [
                  AppTheme.buildLabel('Activity Details 1'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _activityDetails1Controller,
                    maxLines: 3,
                    decoration: _multilineDecoration.copyWith(
                      hintText: 'Activity Details 1',
                    ),
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Activity Details 2'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _activityDetails2Controller,
                    maxLines: 3,
                    decoration: _multilineDecoration.copyWith(
                      hintText: 'Activity Details 2',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Activity Details 3'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _activityDetails3Controller,
                    maxLines: 3,
                    decoration: _multilineDecoration.copyWith(
                      hintText: 'Activity Details 3',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Other Points'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _otherPointsController,
                    maxLines: 3,
                    decoration: _multilineDecoration.copyWith(
                      hintText: 'Other Points',
                    ),
                  ),
                ],
              ),

              // ─── Upload Supporting Documents ──────────────────────────────────
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // … your existing upload UI unchanged …
                  ],
                ),
              ),

              // ─── Submit Button Card ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DsrEntry())),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to DSR Entry'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.blueAccent)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        elevation: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
