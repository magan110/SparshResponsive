import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

// Import all activity screens for navigation
import 'dsr_entry.dart';
import 'dsr_retailer_in_out.dart'; // Personal Visit
import 'phone_call_with_builder.dart'; // Phone Call with Builder/Stockist
import 'Meetings_With_Contractor.dart'; // Meetings With Contractor / Stockist
import 'check_sampling_at_site.dart'; // Visit to Get / Check Sampling at Site
import 'Meeting_with_new_purchaser.dart'; // Meeting with New Purchaser
import 'btl_activites.dart'; // BTL Activities
import 'internal_team_meeting.dart'; // Internal Team Meetings
import 'office_work.dart'; // Office Work
import 'on_leave.dart'; // On Leave / Holiday / Off Day
// This is the current file (work_from_home.dart)
import 'any_other_activity.dart'; // Any Other Activity
import 'phone_call_with_unregisterd_purchaser.dart'; // Phone call with Unregistered Purchasers
import '../theme/app_theme.dart';

class WorkFromHome extends StatefulWidget {
  const WorkFromHome({super.key});

  @override
  State<WorkFromHome> createState() => _WorkFromHomeState();
}

class _WorkFromHomeState extends State<WorkFromHome> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem = 'Work From Home';

  // Shortened version for display
  String get _activityItemShort {
    if (_activityItem == null) return 'Select';
    return (_activityItem!.length > 30)
      ? '${_activityItem!.substring(0, 27)}...'
      : _activityItem!;
  }

  // Controllers for date text fields
  final TextEditingController _submissionDateController =
      TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  // State variables to hold selected dates
  DateTime? _selectedSubmissionDate;
  DateTime? _selectedReportDate;

  // Lists for image uploads
  final List<int> _uploadRows = [0];
  final ImagePicker _picker = ImagePicker();
  final List<File?> _selectedImages = [null];

  // Global key for the form for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _submissionDateController.dispose();
    _reportDateController.dispose();
    super.dispose();
  }

  // Function to pick the submission date
  Future<void> _pickSubmissionDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedSubmissionDate ?? now,
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
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedSubmissionDate = picked;
        _submissionDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked);
      });
    }
  }

  // Function to pick the report date
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
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedReportDate = picked;
        _reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Function to add a new image upload row
  void _addRow() {
    setState(() {
      _uploadRows.add(_uploadRows.length);
      _selectedImages.add(null);
    });
  }

  // Function to remove the last image upload row
  void _removeRow() {
    if (_uploadRows.length <= 1) return;
    setState(() {
      _uploadRows.removeLast();
      _selectedImages.removeLast();
    });
  }

  // Function to handle image picking for a specific row
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    }
  }

  // Function to show the selected image in a dialog
  void _showImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
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
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }

  // Helper for navigation
  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  // Helper method to show a success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Work From Home',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'Daily Sales Report Entry',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help information for Work From Home'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Process Selection Card
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isCollapsed: true,
                        ),
                        isExpanded: true,
                        items:
                            _processdropdownItems
                                .map(
                                  (item) => DropdownMenuItem<String>(
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
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _processItem = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == 'Select') {
                            return 'Please select a process';
                          }
                          return null;
                        },
                      ),
                ],
              ),

              // Date Selection Card
              AppTheme.buildSectionCard(
                title: 'Date Information',
                icon: Icons.date_range_outlined,
                children: [
                  AppTheme.buildLabel('Submission Date'),
                  const SizedBox(height: 8),
                  AppTheme.buildDateField(
                    context,
                    _submissionDateController,
                    _pickSubmissionDate,
                    'Select Submission Date',
                  ),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Report Date'),
                  const SizedBox(height: 8),
                  AppTheme.buildDateField(
                    context,
                    _reportDateController,
                    _pickReportDate,
                    'Select Report Date',
                  ),
                ],
              ),

              // Image Upload Card
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.photo_library_rounded,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Supporting Documents',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload images related to your activity',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    // Image upload rows with enhanced UI
                    ...List.generate(_uploadRows.length, (index) {
                      final i = _uploadRows[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _selectedImages[i] != null
                                    ? Colors.green.shade200
                                    : Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Document header row with status
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
                                      color: Color.fromARGB(
                                        255,
                                        33,
                                        150,
                                        243,
                                      ),
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
                            // Image preview if selected
                            if (_selectedImages[i] != null)
                              GestureDetector(
                                onTap:
                                    () => _showImageDialog(_selectedImages[i]!),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _selectedImages[i]!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 120,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 120,
                                              width: double.infinity,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Icon(Icons.broken_image, size: 40),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Align(
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
                                    ],
                                  ),
                                ),
                              ),
                            // Action buttons
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
                                      _selectedImages[i] != null
                                          ? 'Replace'
                                          : 'Upload',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          _selectedImages[i] != null
                                              ? Colors.amber.shade600
                                              : Colors.blueAccent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                                      onPressed:
                                          () => _showImageDialog(
                                            _selectedImages[i]!,
                                          ),
                                      icon: const Icon(
                                        Icons.visibility,
                                        size: 18,
                                      ),
                                      label: const Text('View'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                    // Add/Remove document buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _addRow,
                          icon: const Icon(Icons.add_photo_alternate, size: 20),
                          label: const Text('Document'),
                          style: Theme.of(context).elevatedButtonTheme.style,
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

              // Submit Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                          _showSuccessDialog('Form submitted successfully');
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Submit'),
                      style: Theme.of(context).elevatedButtonTheme.style,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DsrEntry()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to DSR Entry'),
                      style: Theme.of(context).outlinedButtonTheme.style,
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

  // Helper to build a standard text field
  Widget _buildTextField(
    String hintText, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      style: theme.textTheme.bodyMedium?.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
        prefixIcon: _getIconForField(hintText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorStyle: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
      validator: validator,
    );
  }

  // Helper method to get appropriate icons for fields
  Widget? _getIconForField(String fieldName) {
    final String fieldLower = fieldName.toLowerCase();
    IconData iconData;

    if (fieldLower.contains('hour')) {
      iconData = Icons.access_time;
    } else if (fieldLower.contains('work')) {
      iconData = Icons.work;
    } else if (fieldLower.contains('date')) {
      iconData = Icons.calendar_today;
    } else if (fieldLower.contains('process')) {
      iconData = Icons.settings;
    } else if (fieldLower.contains('activity')) {
      iconData = Icons.category;
    } else if (fieldLower.contains('document') ||
        fieldLower.contains('upload')) {
      iconData = Icons.upload_file;
    } else {
      iconData = Icons.edit;
    }

    return Icon(iconData, color: Theme.of(context).primaryColor);
  }

  // Helper to build a date input field
  Widget _buildDateField(
    TextEditingController controller,
    VoidCallback onTap,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          onPressed: onTap,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  // Helper to build a standard text label
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // Helper to build a standard dropdown field
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        isExpanded: true,
        menuMaxHeight: 300,
        value: value,
        onChanged: onChanged,
        validator: validator,
        icon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.arrow_drop_down),
        ),
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        overflow: TextOverflow.ellipsis,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                )
                .toList(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
