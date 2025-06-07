import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'dsr_entry.dart';
import '../theme/app_theme.dart';

class BtlActivites extends StatefulWidget {
  const BtlActivites({super.key});

  @override
  State<BtlActivites> createState() => _BtlActivitesState();
}

class _BtlActivitesState extends State<BtlActivites> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String _activityTypeItem = 'Select';
  final List<String> _activityTypedropdownItems = [
    'Select',
    'Retailer Meet',
    'Stokiest Meet',
    'Painter Meet',
    'Architect Meet',
    'Counter Meet',
    'Painter Training Program',
    'Other BTL Activities',
  ];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _selectedReportDate;

  final TextEditingController _noOfParticipantsController =
  TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _learningsController = TextEditingController();

  // For dynamic image fields
  final List<File?> _selectedImages = [null];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _dateController.dispose();
    _reportDateController.dispose();
    _noOfParticipantsController.dispose();
    _townController.dispose();
    _learningsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
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
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
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

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    }
  }

  void _addImageField() {
    setState(() {
      _selectedImages.add(null);
    });
  }

  void _removeImageField(int index) {
    if (_selectedImages.length > 1) {
      setState(() {
        _selectedImages.removeAt(index);
      });
    }
  }

  void _showImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: FileImage(imageFile),
            ),
          ),
        ),
      ),
    );
  }

  // ——— Stubbed submit logic ———
  void _onSubmit(bool exitAfter) {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exitAfter
            ? 'Form validated. Exiting...'
            : 'Form validated. Ready for new entry.'),
      ),
    );

    if (exitAfter) {
      Navigator.of(context).pop();
    } else {
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _processItem = 'Select';
      _activityTypeItem = 'Select';
      _selectedDate = null;
      _selectedReportDate = null;
      _dateController.clear();
      _reportDateController.clear();
      _noOfParticipantsController.clear();
      _townController.clear();
      _learningsController.clear();
      _selectedImages
        ..clear()
        ..add(null);
    });
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DsrEntry()),
          ),
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 22),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BTL Activities',
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
                content: Text('Help information for BTL Activities'),
                duration: Duration(seconds: 2),
              ),
            ),
          ),
        ],
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- Process Section ---
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
                          horizontal: 16, vertical: 12),
                      isCollapsed: true,
                    ),
                    isExpanded: true,
                    items: _processdropdownItems
                        .map(
                          (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14)),
                      ),
                    )
                        .toList(),
                    onChanged: (newValue) {
                      if (newValue != null) setState(() => _processItem = newValue);
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

              // --- Date Section ---
              AppTheme.buildSectionCard(
                title: 'Date Information',
                icon: Icons.date_range_outlined,
                children: [
                  AppTheme.buildLabel('Submission Date'),
                  const SizedBox(height: 8),
                  AppTheme.buildDateField(
                    context,
                    _dateController,
                    _pickDate,
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

              // --- Activity Details Section ---
              AppTheme.buildSectionCard(
                title: 'BTL Activity Details',
                icon: Icons.campaign_outlined,
                children: [
                  AppTheme.buildLabel('Type Of Activity'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _activityTypeItem,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      isCollapsed: true,
                    ),
                    isExpanded: true,
                    items: _activityTypedropdownItems
                        .map(
                          (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14)),
                      ),
                    )
                        .toList(),
                    onChanged: (newValue) {
                      if (newValue != null) setState(() => _activityTypeItem = newValue);
                    },
                    validator: (value) {
                      if (value == null || value == 'Select') {
                        return 'Please select a type of activity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('No. Of Participants'),
                  const SizedBox(height: 8),
                  AppTheme.buildTextField(
                    'Enter number of participants',
                    controller: _noOfParticipantsController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of participants';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Town in Which Activity Conducted'),
                  const SizedBox(height: 8),
                  AppTheme.buildTextField(
                    'Enter town',
                    controller: _townController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter town';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Learning\'s From Activity'),
                  const SizedBox(height: 8),
                  AppTheme.buildTextField(
                    'Enter your learnings',
                    controller: _learningsController,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your learnings';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- Dynamic Image Upload Section ---
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.photo_library_rounded,
                            color: AppTheme.primaryColor, size: 24),
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
                    ...List.generate(_selectedImages.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedImages[index] != null
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
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Document ${index + 1}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 33, 150, 243),
                                        fontSize: 14),
                                  ),
                                ),
                                const Spacer(),
                                if (_selectedImages[index] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'Uploaded',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_selectedImages[index] != null)
                              GestureDetector(
                                onTap: () =>
                                    _showImageDialog(_selectedImages[index]!),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image:
                                      FileImage(_selectedImages[index]!),
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
                                      child: const Icon(Icons.zoom_in,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _pickImage(index),
                                    icon: Icon(
                                        _selectedImages[index] != null
                                            ? Icons.refresh
                                            : Icons.upload_file,
                                        size: 18),
                                    label: Text(_selectedImages[index] != null
                                        ? 'Replace'
                                        : 'Upload'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                      _selectedImages[index] != null
                                          ? Colors.amber.shade600
                                          : Colors.blueAccent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                  ),
                                ),
                                if (_selectedImages.length > 1)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          _removeImageField(index),
                                      icon: const Icon(
                                          Icons.remove_circle_outline,
                                          size: 20),
                                      label: const Text('Remove'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.redAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _addImageField,
                        icon:
                        const Icon(Icons.add_photo_alternate, size: 20),
                        label: const Text('Add Image'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Submit Buttons ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () => _onSubmit(false),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      elevation: 3.0,
                    ),
                    child: const Text('Submit & New'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _onSubmit(true),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      elevation: 3.0,
                    ),
                    child: const Text('Submit & Exit'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print('View Submitted Data button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.blueAccent),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      elevation: 1.0,
                    ),
                    child: const Text('Click to see Submitted Data'),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
