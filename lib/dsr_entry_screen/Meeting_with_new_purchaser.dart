import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

// Ensure these imports are correct based on your project structure
// This is the current file, keep it
import 'Meetings_With_Contractor.dart';
import 'any_other_activity.dart';
import 'btl_activites.dart';
import 'check_sampling_at_site.dart';
import 'dsr_entry.dart'; // Assuming DsrEntry is the main entry point
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
import 'phone_call_with_builder.dart';
import 'phone_call_with_unregisterd_purchaser.dart';
import 'work_from_home.dart';
// Assuming HomeScreen is not directly navigated to from here, but keep if needed
// import 'package:learning2/screens/Home_screen.dart';

class MeetingWithNewPurchaser extends StatefulWidget {
  const MeetingWithNewPurchaser({super.key});

  @override
  State<MeetingWithNewPurchaser> createState() =>
      _MeetingWithNewPurchaserState();
}

class _MeetingWithNewPurchaserState extends State<MeetingWithNewPurchaser> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem =
      'Meeting with New Purchaser(Trade Purchaser)/Retailer'; // Default to this activity
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

  // Controllers for date text fields
  final TextEditingController _submissionDateController =
      TextEditingController(); // Renamed for clarity
  final TextEditingController _reportDateController = TextEditingController();

  // State variables to hold selected dates
  DateTime? _selectedSubmissionDate; // Renamed for clarity
  DateTime? _selectedReportDate;

  // Lists for image uploads
  final List<int> _uploadRows = [0]; // Tracks the number of image upload rows
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  // List to hold selected image files for each row
  final List<File?> _selectedImages = [
    null,
  ]; // Initialize with null for the first row

  // Global key for the form for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
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
              primary: Color.fromARGB(
                255,
                33,
                150,
                243,
              ), // Match dsr_entry color
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
              primary: Color.fromARGB(
                255,
                33,
                150,
                243,
              ), // Match dsr_entry color
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
      _uploadRows.add(_uploadRows.length); // Add a new index
      _selectedImages.add(null); // Add null for the new row's image
    });
  }

  // Function to remove the last image upload row
  void _removeRow() {
    if (_uploadRows.length <= 1) return; // Prevent removing the last row
    setState(() {
      _uploadRows.removeLast(); // Remove the last index
      _selectedImages.removeLast(); // Remove the last image entry
    });
  }

  // Function to handle image picking for a specific row
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    } else {
      print('No image selected for row $index.'); // Important for debugging
    }
  }

  // Function to show the selected image in a dialog
  void _showImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          // Use a Dialog widget for a modal popup
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            height:
                MediaQuery.of(context).size.height *
                0.6, // 60% of screen height
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain, // Fit the image within the container
                image: FileImage(imageFile), // Load image from file
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper for navigation (similar to other DSR screens)
  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meeting with New Purchaser',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Daily Sales Report Entry',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.normal,
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
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Process',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
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
                        ),
                        items:
                            _processdropdownItems
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
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
              ),
              // Activity Selection Card
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Activity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                        ),
                        items:
                            _activityDropDownItems
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
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
                              const PhoneCallWithUnregisterdPurchaser(),
                            );
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
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _submissionDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Submission Date',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _pickSubmissionDate,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select submission date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _reportDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Report Date',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _pickReportDate,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select report date';
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
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upload Images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
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
                                        color:
                                            _selectedImages[index] == null
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
                                      onPressed:
                                          () => _showImageDialog(
                                            _selectedImages[index]!,
                                          ),
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
                    // Handle form submission
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
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 24),
              // Process Type Dropdown
              _buildLabel('Process type'),
              const SizedBox(height: 8), // Reduced spacing below label
              _buildDropdownField(
                value: _processItem,
                items: _processdropdownItems,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _processItem = newValue);
                  }
                },
              ),
              const SizedBox(height: 24), // Increased spacing
              // Activity Type Dropdown (for navigation)
              _buildLabel('Activity Type'),
              const SizedBox(height: 8), // Reduced spacing below label
              _buildDropdownField(
                value: _activityItem,
                items: _activityDropDownItems,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _activityItem = newValue);

                    // Navigation logic based on selected activity
                    if (newValue == 'Personal Visit') {
                      _navigateTo(const DsrRetailerInOut());
                    } else if (newValue == 'Phone Call with Builder/Stockist') {
                      _navigateTo(const PhoneCallWithBuilder());
                    } else if (newValue ==
                        'Meetings With Contractor / Stockist') {
                      _navigateTo(const MeetingsWithContractor());
                    } else if (newValue ==
                        'Visit to Get / Check Sampling at Site') {
                      _navigateTo(const CheckSamplingAtSite());
                    } else if (newValue ==
                        'Meeting with New Purchaser(Trade Purchaser)/Retailer') {
                      // This is the current page, no navigation needed
                    } else if (newValue == 'BTL Activities') {
                      _navigateTo(const BtlActivites());
                    } else if (newValue ==
                        'Internal Team Meetings / Review Meetings') {
                      _navigateTo(const InternalTeamMeeting());
                    } else if (newValue == 'Office Work') {
                      _navigateTo(const OfficeWork());
                    } else if (newValue == 'On Leave / Holiday / Off Day') {
                      _navigateTo(const OnLeave());
                    } else if (newValue == 'Work From Home') {
                      _navigateTo(const WorkFromHome());
                    } else if (newValue == 'Any Other Activity') {
                      _navigateTo(const AnyOtherActivity());
                    } else if (newValue ==
                        'Phone call with Unregistered Purchasers') {
                      _navigateTo(const PhoneCallWithUnregisterdPurchaser());
                    }
                  }
                },
              ),
              const SizedBox(height: 24), // Increased spacing
              // Submission Date Field
              _buildLabel('Submission Date'),
              const SizedBox(height: 8), // Reduced spacing below label
              _buildDateField(
                _submissionDateController,
                _pickSubmissionDate,
                'Select Date',
              ),
              const SizedBox(height: 24), // Increased spacing
              // Report Date Field
              _buildLabel('Report Date'),
              const SizedBox(height: 8), // Reduced spacing below label
              _buildDateField(
                _reportDateController,
                _pickReportDate,
                'Select Date',
              ),
              const SizedBox(height: 24), // Increased spacing
              // Image Upload Section
              _buildLabel('Upload Supporting'),
              const SizedBox(height: 8),

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
                    const Row(
                      children: [
                        Icon(
                          Icons.photo_library_rounded,
                          color: Color.fromARGB(255, 33, 150, 243),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Supporting Documents',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 33, 150, 243),
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
                                    image: DecorationImage(
                                      image: FileImage(_selectedImages[i]!),
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
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
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
                              backgroundColor: Colors.redAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 30), // Increased spacing before buttons
              // Submit Buttons
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Stretch buttons to full width
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: implement submit and new logic
                      if (_formKey.currentState!.validate()) {
                        print('Form is valid. Submit and New.');
                        // Add your submission logic here
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent, // Match theme color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ), // Increased vertical padding
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ), // Larger, bold text
                      elevation: 3.0, // Add slight elevation
                    ),
                    child: const Text('Submit & New'),
                  ),
                  const SizedBox(height: 16), // Spacing between buttons
                  ElevatedButton(
                    onPressed: () {
                      // TODO: implement submit and exit logic
                      if (_formKey.currentState!.validate()) {
                        print('Form is valid. Submit and Exit.');
                        // Add your submission logic here and then navigate back
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent, // Match theme color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 3.0,
                    ),
                    child: const Text('Submit & Exit'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: implement view submitted data logic
                      print('View Submitted Data button pressed');
                      // Add logic to view submitted data
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueAccent, // Blue text
                      backgroundColor: Colors.white, // White background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.blueAccent,
                        ), // Blue border
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 1.0, // Less elevation
                    ),
                    child: const Text('Click to see Submitted Data'),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods for Building Widgets (Copied from previous screens) ---

  // Helper to build a standard text field
  Widget _buildTextField(
    String hintText, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1, // Default to single line
    String? Function(String?)? validator,
    bool readOnly = false, // Added readOnly parameter
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly, // Apply readOnly property
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500], // Slightly darker grey hint text
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: BorderSide.none, // No visible border line
        ),
        filled: true, // Add a background fill
        fillColor: Colors.white, // White background for text fields
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ), // Adjusted padding
      ),
      validator: validator, // Assign the validator function
    );
  }

  // Helper to build a date input field
  Widget _buildDateField(
    TextEditingController controller,
    VoidCallback onTap,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Make the text field read-only
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.blueAccent,
          ), // Blue calendar icon
          onPressed: onTap, // Call the provided onTap function
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // No visible border line
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      onTap: onTap, // Allow tapping the field itself to open date picker
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  // Helper to build a standard text label
  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 16, // Slightly smaller label font size
      fontWeight: FontWeight.w600, // Slightly bolder
      color: Colors.black87, // Darker text color
    ),
  );

  // Helper to build a standard dropdown field (not searchable)
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50, // Fixed height for consistency
      padding: const EdgeInsets.symmetric(horizontal: 12), // Adjusted padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ), // Lighter border
        color: Colors.white, // White background
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        isExpanded: true, // Expand to fill the container
        underline: Container(), // Remove the default underline
        value: value,
        onChanged: onChanged,
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
                      ), // Darker text color
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  // Helper to build a searchable dropdown field (using dropdown_search) - Not used in this screen but kept for reference
  // Widget _buildSearchableDropdownField({
  //   required String selected,
  //   required List<String> items,
  //   required ValueChanged<String?> onChanged,
  // }) =>
  //     DropdownSearch<String>(
  //       items: items,
  //       selectedItem: selected,
  //       onChanged: onChanged,
  //       popupProps: PopupProps.menu(
  //         showSearchBox: true,
  //         searchFieldProps: const TextFieldProps(
  //           decoration: InputDecoration(
  //             hintText: 'Search...',
  //             hintStyle: TextStyle(color: Colors.black54), // Darker hint text
  //             fillColor: Colors.white,
  //             filled: true,
  //             border: OutlineInputBorder(
  //                borderRadius: BorderRadius.all(Radius.circular(8.0)), // Rounded corners
  //               borderSide: BorderSide(color: Colors.blueAccent), // Blue border
  //             ),
  //             isDense: true,
  //             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //           ),
  //         ),
  //         itemBuilder: (context, item, isSelected) => Padding(
  //           padding: const EdgeInsets.all(12),
  //           child: Text(item, style: const TextStyle(color: Colors.black87)), // Darker text color
  //         ),
  //       ),
  //       dropdownDecoratorProps: DropDownDecoratorProps(
  //         dropdownSearchDecoration: InputDecoration(
  //           hintText: 'Select',
  //           filled: true,
  //           fillColor: Colors.white,
  //           isDense: true,
  //           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Adjusted padding
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10), // Rounded corners
  //             borderSide: BorderSide(color: Colors.grey.shade300), // Lighter border
  //           ),
  //         ),
  //       ),
  //     );

  // Helper to build an icon button (e.g., search icon) - Not used in this screen but kept for reference
  // Widget _buildIconButton(IconData icon, VoidCallback onPressed) => Container(
  //   height: 50, // Match height of text fields/dropdowns
  //   width: 50, // Fixed width
  //   decoration: BoxDecoration(
  //       color: Colors.blueAccent, // Match theme color
  //       borderRadius: BorderRadius.circular(10)), // Rounded corners
  //   child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed),
  // );

  // Helper to build a standard elevated button
  Widget _buildButton(String label, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blueAccent, // Match theme color
      padding: const EdgeInsets.symmetric(vertical: 14), // Adjusted padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ), // Larger, bold text
      elevation: 3.0, // Add slight elevation
    ),
    child: Text(label),
  );
}
