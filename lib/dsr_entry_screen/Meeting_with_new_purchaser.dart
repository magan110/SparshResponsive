import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

// Import all the required screens
import 'Meetings_With_Contractor.dart';
import 'any_other_activity.dart';
import 'btl_activites.dart';
import 'check_sampling_at_site.dart';
import 'dsr_entry.dart';
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
import 'phone_call_with_builder.dart';
import 'phone_call_with_unregisterd_purchaser.dart';
import 'work_from_home.dart';

class MeetingWithNewPurchaser extends StatefulWidget {
  const MeetingWithNewPurchaser({super.key});

  @override
  State<MeetingWithNewPurchaser> createState() =>
      _MeetingWithNewPurchaserState();
}

class _MeetingWithNewPurchaserState extends State<MeetingWithNewPurchaser> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem =
      'Meeting with New Purchaser(Trade Purchaser)/Retailer';
  final List<String> _activityDropDownItems = [
    'Select',
    'Personal Visit',
    'Phone Call with Builder/Stockist',
    'Meetings With Contractor / Stockist',
    'Visit to Get / Check Sampling at Site',
    'Meeting with New Purchaser(Trade Purchaser)/Retailer',
    'BTL Activities',
    'Internal Team Meetings / Review Meetings',
    'Office Work',
    'On Leave / Holiday / Off Day',
    'Work From Home',
    'Any Other Activity',
    'Phone call with Unregistered Purchasers',
  ];

  final TextEditingController _submissionDateController =
  TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  DateTime? _selectedSubmissionDate;
  DateTime? _selectedReportDate;

  final List<int> _uploadRows = [0];
  final ImagePicker _picker = ImagePicker();
  final List<File?> _selectedImages = [null];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _submissionDateController.dispose();
    _reportDateController.dispose();
    super.dispose();
  }

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
              primary: AppTheme.primaryColor,
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
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
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
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    } else {
      print('No image selected for row $index.');
    }
  }

  void _showImageDialog(File imageFile) {
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
                image: FileImage(imageFile),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDateField(
      TextEditingController controller, VoidCallback onTap, String hintText) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: onTap,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              'Meeting with New Purchaser',
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
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Help information for Meeting with New Purchaser',
                  ),
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
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings_outlined,
                            color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Process',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          .map(
                            (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Container(
                            constraints:
                            const BoxConstraints(maxWidth: 250),
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
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _processItem = val);
                        }
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
              ),

              // Activity Selection Card
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.category_outlined, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Activity',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _activityItem,
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
                        items: _activityDropDownItems
                            .map(
                              (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Container(
                              constraints:
                              const BoxConstraints(maxWidth: 250),
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
                        onChanged: (String? selectedValue) {
                          if (selectedValue == null) return;
                          setState(() => _activityItem = selectedValue);

                          // Navigation logic based on selected activity
                          if (selectedValue == 'Personal Visit') {
                            _navigateTo(const DsrRetailerInOut());
                          } else if (selectedValue ==
                              'Phone Call with Builder/Stockist') {
                            _navigateTo(const PhoneCallWithBuilder());
                          } else if (selectedValue ==
                              'Meetings With Contractor / Stockist') {
                            _navigateTo(const MeetingsWithContractor());
                          } else if (selectedValue ==
                              'Visit to Get / Check Sampling at Site') {
                            _navigateTo(const CheckSamplingAtSite());
                          } else if (selectedValue ==
                              'Meeting with New Purchaser(Trade Purchaser)/Retailer') {
                            // This is the current page, no navigation needed
                          } else if (selectedValue == 'BTL Activities') {
                            _navigateTo(const BtlActivites());
                          } else if (selectedValue ==
                              'Internal Team Meetings / Review Meetings') {
                            _navigateTo(const InternalTeamMeeting());
                          } else if (selectedValue == 'Office Work') {
                            _navigateTo(const OfficeWork());
                          } else if (selectedValue ==
                              'On Leave / Holiday / Off Day') {
                            _navigateTo(const OnLeave());
                          } else if (selectedValue == 'Work From Home') {
                            _navigateTo(const WorkFromHome());
                          } else if (selectedValue == 'Any Other Activity') {
                            _navigateTo(const AnyOtherActivity());
                          } else if (selectedValue ==
                              'Phone call with Unregistered Purchasers') {
                            _navigateTo(
                                const PhoneCallWithUnregisterdPurchaser());
                          }
                        },
                        validator: (value) {
                          if (value == null || value == 'Select') {
                            return 'Please select an activity';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Date Selection Card
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.date_range_outlined,
                              color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Date Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Submission Date',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _submissionDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Submission Date',
                          hintText: 'Select Submission Date',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _pickSubmissionDate,
                          ),
                        ),
                        onTap: _pickSubmissionDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a submission date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Report Date',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _reportDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Report Date',
                          hintText: 'Select Report Date',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _pickReportDate,
                          ),
                        ),
                        onTap: _pickReportDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a report date';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Image Upload Card
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.photo_library_rounded,
                                color: Colors.blue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Supporting Documents',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                color: Colors.blue,
                                onPressed: _addRow,
                                tooltip: 'Add Image Row',
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                color: Colors.red,
                                onPressed: _removeRow,
                                tooltip: 'Remove Image Row',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Upload images related to your activity',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _uploadRows.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedImages[index] == null
                                          ? 'No image selected'
                                          : 'Image selected',
                                      style: TextStyle(
                                        color: _selectedImages[index] == null
                                            ? Colors.grey[600]
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _pickImage(index),
                                    icon: const Icon(Icons.add_photo_alternate),
                                    label: const Text('Select'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  if (_selectedImages[index] != null) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () => _showImageDialog(
                                          _selectedImages[index]!),
                                      tooltip: 'View Image',
                                      color: Colors.blue,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing Data'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}