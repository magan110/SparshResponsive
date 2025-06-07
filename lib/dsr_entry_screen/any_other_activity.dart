import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'package:learning2/dsr_entry_screen/phone_call_with_builder.dart';
import 'package:learning2/dsr_entry_screen/work_from_home.dart';
import 'Meeting_with_new_purchaser.dart';
import 'Meetings_With_Contractor.dart';
import 'btl_activites.dart';
import 'check_sampling_at_site.dart';
import 'dsr_entry.dart';
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
import '../theme/app_theme.dart';

class AnyOtherActivity extends StatefulWidget {
  const AnyOtherActivity({super.key});

  @override
  State<AnyOtherActivity> createState() => _AnyOtherActivityState();
}

class _AnyOtherActivityState extends State<AnyOtherActivity> {
  // 1) CONTROLLERS for dropdowns and dates
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  // 2) CONTROLLERS for text fields
  final TextEditingController _activity1Controller = TextEditingController();
  final TextEditingController _activity2Controller = TextEditingController();
  final TextEditingController _activity3Controller = TextEditingController();
  final TextEditingController _anyOtherPointsController = TextEditingController();

  // Controllers for date text fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  // State variables to hold selected dates
  DateTime? _selectedDate;
  DateTime? _selectedReportDate;

  // 3) Image-upload state (up to 3)
  final List<int> _uploadRows = [0];
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _selectedImages = [null];

  // Global key for the form (validation)
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _dateController.dispose();
    _reportDateController.dispose();
    _activity1Controller.dispose();
    _activity2Controller.dispose();
    _activity3Controller.dispose();
    _anyOtherPointsController.dispose();
    super.dispose();
  }

  // ▶️ Add a new image-upload row (max 3)
  void _addRow() {
    if (_uploadRows.length >= 3) return;
    setState(() {
      _uploadRows.add(_uploadRows.length);
      _selectedImages.add(null);
    });
  }

  // ▶️ Remove the last image-upload row
  void _removeRow() {
    if (_uploadRows.length <= 1) return;
    setState(() {
      _uploadRows.removeLast();
      _selectedImages.removeLast();
    });
  }

  // ▶️ Pick the submission date
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yy').format(picked);
      });
    }
  }

  // ▶️ Pick the report date
  Future<void> _pickReportDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedReportDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedReportDate = picked;
        _reportDateController.text = DateFormat('dd-MM-yy').format(picked);
      });
    }
  }

  // ▶️ Pick an image for a specific row
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = pickedFile;
      });
    } else {
      print('No image selected for row $index.');
    }
  }

  // ▶️ Show a full-screen dialog with the selected image
  void _showImageDialog(XFile imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: FileImage(File(imageFile.path)),
              ),
            ),
          ),
        );
      },
    );
  }

  // ▶️ Stubbed submit: validate and reset/exit
  void _onSubmit(bool exitAfter) {
    if (!_formKey.currentState!.validate()) return;
    if (exitAfter) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form validated. Exiting...")),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form validated. Ready for new entry.")),
      );
      _resetForm();
    }
  }

  // ▶️ Clear all fields (for “Submit & New”)
  void _resetForm() {
    setState(() {
      _processItem = 'Select';
      _dateController.clear();
      _reportDateController.clear();
      _selectedDate = null;
      _selectedReportDate = null;
      _activity1Controller.clear();
      _activity2Controller.clear();
      _activity3Controller.clear();
      _anyOtherPointsController.clear();
      _uploadRows
        ..clear()
        ..add(0);
      _selectedImages
        ..clear()
        ..add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DsrEntry()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 22,
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.assignment_outlined, size: 28),
              const SizedBox(width: 10),
              Text(
                'Any Other Activity',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.scaffoldBackgroundColor, Colors.grey.shade100],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  AppTheme.buildSectionCard(
                    title: 'Activity Information',
                    icon: Icons.info_outline,
                    children: [
                      // -- Process Type Dropdown --
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isCollapsed: true,
                        ),
                        isExpanded: true,
                        items: _processdropdownItems
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: Text(
                              item,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _processItem = val);
                        },
                        validator: (value) {
                          if (value == null || value == 'Select') {
                            return 'Please select a process';
                          }
                          return null;
                        },
                      ),

                      // -- Date Fields Section --
                      const SizedBox(height: 16),
                      AppTheme.buildSectionCard(
                        title: 'Date Information',
                        icon: Icons.calendar_today,
                        children: [
                          AppTheme.buildLabel('Submission Date'),
                          const SizedBox(height: 8),
                          AppTheme.buildDateField(
                            context,
                            _dateController,
                            _pickDate,
                            'Select Date',
                          ),
                          const SizedBox(height: 16),
                          AppTheme.buildLabel('Report Date'),
                          const SizedBox(height: 8),
                          AppTheme.buildDateField(
                            context,
                            _reportDateController,
                            _pickReportDate,
                            'Select Date',
                          ),
                        ],
                      ),

                      // -- Activity Details Section --
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.description_outlined,
                                color: Colors.amber.shade800,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Activity Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTextField('Activity Details 1', _activity1Controller),
                      const SizedBox(height: 16),
                      _buildTextField('Activity Details 2', _activity2Controller),
                      const SizedBox(height: 16),
                      _buildTextField('Activity Details 3', _activity3Controller),
                      const SizedBox(height: 16),
                      _buildTextField('Any Other Points', _anyOtherPointsController),
                      const SizedBox(height: 24),

                      // -- Image Upload Section --
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_rounded,
                                  color: Colors.blueAccent,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Supporting Documents',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Upload images related to your activity',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(_uploadRows.length, (index) {
                              final i = _uploadRows[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedImages[i] != null
                                        ? Colors.green.shade200
                                        : Colors.grey.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Document ${index + 1}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        if (_selectedImages[i] != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Uploaded',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    if (_selectedImages[i] != null)
                                      GestureDetector(
                                        onTap: () => _showImageDialog(_selectedImages[i]!),
                                        child: Container(
                                          height: 120,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: FileImage(File(_selectedImages[i]!.path)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin: const EdgeInsets.all(8),
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.6),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.zoom_in,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () => _pickImage(i),
                                            icon: Icon(
                                              _selectedImages[i] != null
                                                  ? Icons.refresh
                                                  : Icons.upload_file,
                                              size: 18,
                                            ),
                                            label: Text(
                                              _selectedImages[i] != null ? 'Replace' : 'Upload',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: _selectedImages[i] != null
                                                  ? Colors.amber.shade600
                                                  : AppTheme.primaryColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (_selectedImages[i] != null) ...[
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () => _showImageDialog(_selectedImages[i]!),
                                              icon: const Icon(
                                                Icons.visibility,
                                                size: 18,
                                              ),
                                              label: const Text('View'),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: AppTheme.successColor,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _addRow,
                                  icon: const Icon(
                                    Icons.add_photo_alternate,
                                    size: 20,
                                  ),
                                  label: const Text('Document'),
                                ),
                                const SizedBox(width: 12),
                                if (_uploadRows.length > 1)
                                  ElevatedButton.icon(
                                    onPressed: _removeRow,
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      size: 20,
                                    ),
                                    label: const Text('Remove'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: AppTheme.dangerButtonColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // -- Submit Buttons --
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: AppTheme.cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.save_alt_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Submit Your Activity',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Save your activity details and continue',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => _onSubmit(false),
                              icon: const Icon(Icons.save_outlined, size: 20),
                              label: const Text('Submit & New'),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _onSubmit(true),
                              icon: const Icon(Icons.check_circle_outline, size: 20),
                              label: const Text('Submit & Exit'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppTheme.successColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                print('View Submitted Data button pressed');
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 20,
                              ),
                              label: const Text('View Submitted Data'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // === HELPERS ===

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              prefixIcon: Icon(
                _getIconForLabel(label),
                color: Colors.blueAccent.withOpacity(0.7),
                size: 22,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForLabel(String label) {
    if (label.contains('Activity Details 1')) {
      return Icons.assignment;
    } else if (label.contains('Activity Details 2')) {
      return Icons.article;
    } else if (label.contains('Activity Details 3')) {
      return Icons.description;
    } else if (label.contains('Any Other Points')) {
      return Icons.lightbulb_outline;
    } else {
      return Icons.edit;
    }
  }

  Widget _buildLabel(String text) => AppTheme.buildLabel(text);
}
