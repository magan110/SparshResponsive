import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:learning2/dsr_entry_screen/phone_call_with_builder.dart';
import 'package:learning2/dsr_entry_screen/phone_call_with_unregisterd_purchaser.dart';
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

class AnyOtherActivity extends StatefulWidget {
  const AnyOtherActivity({super.key});

  @override
  State<AnyOtherActivity> createState() => _AnyOtherActivityState();
}

class _AnyOtherActivityState extends State<AnyOtherActivity> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem = 'Any Other Activity';
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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  // State variables to hold selected dates
  DateTime? _selectedDate;
  DateTime? _selectedReportDate;

  // State variables for image uploads
  final List<int> _uploadRows = [0]; // Tracks the number of image upload rows
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  final List<File?> _selectedImages = [
    null,
  ]; // To hold selected images for each row

  // Global key for the form for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _dateController.dispose();
    _reportDateController.dispose();
    super.dispose();
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
      _selectedImages.removeLast(); // Remove the last image file
    });
  }

  // Function to pick the submission date
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          // Apply a custom theme for the date picker
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black87, // Body text color
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ), // Dialog background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat(
          'dd-MM-yy',
        ).format(picked); // Using a more compact date format
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
          // Apply a custom theme for the date picker
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black87, // Body text color
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ), // Dialog background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedReportDate = picked;
        _reportDateController.text = DateFormat(
          'dd-MM-yy',
        ).format(picked); // Using a more compact date format
      });
    }
  }

  // Function to pick an image for a specific row
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    } else {
      // Print a message if no image was selected
      print('No image selected for row $index.');
    }
  }

  // Function to show a dialog with the selected image
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // Modern light background
        appBar: AppBar(
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              // Navigate back to the DsrEntry screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DsrEntry()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new, // More modern back icon
              color: Colors.white,
            ),
          ),
          title: const Row(
            children: [
              Icon(Icons.assignment_outlined, size: 28), // Add an icon
              SizedBox(width: 10),
              Text(
                'Any Other Activity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5, // Slight letter spacing for modern look
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF3F51B5), // Rich indigo color
          elevation: 0, // Flat design
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
              colors: [const Color(0xFFF5F7FA), Colors.grey.shade100],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Enhanced Instructions Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
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
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.blueAccent,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Activity Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Process Type Dropdown with enhanced styling
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.settings_outlined,
                                    size: 18,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Process Type',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: _buildDropdownField(
                                  value: _processItem,
                                  items: _processdropdownItems,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      setState(() => _processItem = newValue);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Activity Type Dropdown with enhanced styling
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category_outlined,
                                    size: 18,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Activity Type',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: _buildDropdownField(
                                  value: _activityItem,
                                  items: _activityDropDownItems,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      setState(() => _activityItem = newValue);

                                      // Navigation logic based on selected activity
                                      if (newValue == 'Personal Visit') {
                                        _navigateTo(const DsrRetailerInOut());
                                      } else if (newValue ==
                                          'Phone Call with Builder/Stockist') {
                                        _navigateTo(
                                          const PhoneCallWithBuilder(),
                                        );
                                      } else if (newValue ==
                                          'Meetings With Contractor / Stockist') {
                                        _navigateTo(
                                          const MeetingsWithContractor(),
                                        );
                                      } else if (newValue ==
                                          'Visit to Get / Check Sampling at Site') {
                                        _navigateTo(
                                          const CheckSamplingAtSite(),
                                        );
                                      } else if (newValue ==
                                          'Meeting with New Purchaser(Trade Purchaser)/Retailer') {
                                        _navigateTo(
                                          const MeetingWithNewPurchaser(),
                                        );
                                      } else if (newValue == 'BTL Activities') {
                                        _navigateTo(const BtlActivites());
                                      } else if (newValue ==
                                          'Internal Team Meetings / Review Meetings') {
                                        _navigateTo(
                                          const InternalTeamMeeting(),
                                        );
                                      } else if (newValue == 'Office Work') {
                                        _navigateTo(const OfficeWork());
                                      } else if (newValue ==
                                          'On Leave / Holiday / Off Day') {
                                        _navigateTo(const OnLeave());
                                      } else if (newValue == 'Work From Home') {
                                        _navigateTo(const WorkFromHome());
                                      } else if (newValue ==
                                          'Phone call with Unregistered Purchasers') {
                                        _navigateTo(
                                          const PhoneCallWithUnregisterdPurchaser(),
                                        );
                                      }
                                      // No navigation needed for 'Any Other Activity' as it's the current page
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Date Fields Row - side by side for better space utilization
                        Row(
                          children: [
                            // Submission Date Field
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Submission ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueAccent.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: _buildDateField(
                                        _dateController,
                                        _pickDate,
                                        'Select Date',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Report Date Field
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.event_note_outlined,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Report ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueAccent.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: _buildDateField(
                                        _reportDateController,
                                        _pickReportDate,
                                        'Select Date',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Activity Details Section Header
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
                  // Activity Details Text Fields
                  _buildTextField('Activity Details 1'),
                  const SizedBox(
                    height: 16,
                  ), // Consistent spacing between text fields
                  _buildTextField('Activity Details 2'),
                  const SizedBox(height: 16),
                  _buildTextField('Activity Details 3'),
                  const SizedBox(height: 16),
                  _buildTextField('Any Other Points'),
                  const SizedBox(
                    height: 24,
                  ), // Increased spacing before image upload
                  // Image Upload Section - Enhanced UI
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent.withOpacity(
                                          0.1,
                                        ),
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                // Preview of the image if selected
                                if (_selectedImages[i] != null)
                                  GestureDetector(
                                    onTap:
                                        () => _showImageDialog(
                                          _selectedImages[i]!,
                                        ),
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
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                        // Add/Remove buttons in a row at the bottom
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
                  const SizedBox(
                    height: 30,
                  ), // Increased spacing before buttons
                  // Submit Buttons - Enhanced UI
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
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
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Section title
                        Row(
                          children: [
                            const Icon(
                              Icons.save_alt_rounded,
                              color: Colors.blueAccent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Submit Your Activity',
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
                          'Save your activity details and continue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Submit & New Button
                        Container(
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600,
                                Colors.blue.shade800,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: implement submit and new logic
                              if (_formKey.currentState!.validate()) {
                                // Process form data
                                print('Form is valid. Submit and New.');
                              }
                            },
                            icon: const Icon(Icons.save_outlined, size: 20),
                            label: const Text('Submit & New'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Submit & Exit Button
                        Container(
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade500,
                                Colors.green.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: implement submit and exit logic
                              if (_formKey.currentState!.validate()) {
                                // Process form data
                                print('Form is valid. Submit and Exit.');
                              }
                            },
                            icon: const Icon(
                              Icons.check_circle_outline,
                              size: 20,
                            ),
                            label: const Text('Submit & Exit'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // View Submitted Data Button
                        Container(
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: implement view submitted data logic
                              print('View Submitted Data button pressed');
                            },
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 20,
                              color: Colors.blueAccent,
                            ),
                            label: const Text('View Submitted Data'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blueAccent,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing at the
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Methods for Building Widgets ---

  // Helper to build a standard text field with enhanced styling
  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label), // Use the helper for label
        const SizedBox(height: 8), // Consistent spacing
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
            maxLines: 3, // Allow multiple lines
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
            // Add validator if the field is required
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter $label';
            //   }
            //   return null;
            // },
          ),
        ),
      ],
    );
  }

  // Helper to get appropriate icon for text field based on label
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

  // Helper to build a date input field with enhanced styling
  Widget _buildDateField(
    TextEditingController controller,
    VoidCallback onTap,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Make the text field read-only
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
        suffixIcon: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.calendar_today,
              color: Colors.blueAccent,
              size: 20,
            ),
            onPressed: onTap,
          ),
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
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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

  // Helper to build a standard dropdown field with enhanced styling
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 56, // Increased height for better touch target
      padding: const EdgeInsets.symmetric(horizontal: 16), // Increased padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ), // Lighter border
        color: Colors.white, // White background
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                isExpanded: true, // Expand to fill the container
                icon: const SizedBox.shrink(), // Hide the default dropdown icon
                value: value,
                onChanged: onChanged,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                items:
                    items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    item == value
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                color:
                                    item == value
                                        ? Colors.blueAccent
                                        : Colors.black87,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          // Custom dropdown icon with animation
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_drop_down,
              color: Colors.blueAccent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // Helper for navigation
  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  // The original _searchableDropdownField and _iconButton helpers are not used in the current layout
  // but are kept here in case they are needed elsewhere or for future reference.

  // Widget _searchableDropdownField({
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
  //             hintStyle: TextStyle(color: Colors.black),
  //             fillColor: Colors.white,
  //             filled: true,
  //             border: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.white),
  //             ),
  //             isDense: true,
  //             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //           ),
  //         ),
  //         itemBuilder: (context, item, isSelected) => Padding(
  //           padding: const EdgeInsets.all(12),
  //           child: Text(item, style: const TextStyle(color: Colors.black)),
  //         ),
  //       ),
  //       dropdownDecoratorProps: DropDownDecoratorProps(
  //         dropdownSearchDecoration: InputDecoration(
  //           hintText: 'Select',
  //           filled: true,
  //           fillColor: Colors.white,
  //           isDense: true,
  //           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(color: Colors.grey.shade400),
  //           ),
  //         ),
  //       ),
  //     );

  // InputDecoration _inputDecoration(String hint, {IconData? suffix}) =>
  //     InputDecoration(
  //       hintText: hint,
  //       contentPadding:
  //       const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //       suffixIcon: suffix != null
  //           ? IconButton(icon: Icon(suffix), onPressed: _pickDate)
  //           : null,
  //     );

  // Widget _iconButton(IconData icon, VoidCallback onPressed) => Container(
  //   height: 50,
  //   width: 50,
  //   decoration: BoxDecoration(
  //       color: Colors.blue, borderRadius: BorderRadius.circular(10)),
  //   child: IconButton(
  //       icon: Icon(icon, color: Colors.white), onPressed: onPressed),
  // );
}
