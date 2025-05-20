import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../theme/app_theme.dart'; // Import AppTheme

// Ensure these imports are correct based on your project structure
import 'Meeting_with_new_purchaser.dart';
import 'Meetings_With_Contractor.dart';
import 'any_other_activity.dart';
import 'btl_activites.dart';
import 'check_sampling_at_site.dart';
import 'dsr_entry.dart'; // Assuming DsrEntry is the main entry point
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
// This is the current file, keep it
import 'on_leave.dart';
import 'phone_call_with_builder.dart';
import 'phone_call_with_unregisterd_purchaser.dart';
import 'work_from_home.dart';
// Assuming HomeScreen is not directly navigated to from here, but keep if needed
// import 'package:learning2/screens/Home_screen.dart';

class OfficeWork extends StatefulWidget {
  const OfficeWork({super.key});

  @override
  State<OfficeWork> createState() => _OfficeWorkState();
}

class _OfficeWorkState extends State<OfficeWork> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem = 'Office Work'; // Default to this activity
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
          // Apply a custom theme for the date picker
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor, // Header background color
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
          // Apply a custom theme for the date picker
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor, // Header background color
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor, // Light grey background for the body
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // Navigate back to the DsrEntry screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DsrEntry(),
                ), // Navigate back to DsrEntry
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white, // White back arrow icon
            ),
          ),
          title: const Text(
            'DSR Entry',
            style: TextStyle(
              color: Colors.white, // White title text
              fontSize: 24, // Slightly smaller font size for a cleaner look
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor:
              AppTheme.primaryColor, // A slightly brighter blue for AppBar
          elevation: 4.0, // Add shadow to AppBar
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Reduced padding slightly
          child: Form(
            key: _formKey, // Assign the form key
            child: ListView(
              children: [
                // Instructions Section
                const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 24, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor, // Match AppBar color
                  ),
                ),
                const SizedBox(height: 24), // Increased spacing
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
                      } else if (newValue ==
                          'Phone Call with Builder/Stockist') {
                        _navigateTo(const PhoneCallWithBuilder());
                      } else if (newValue ==
                          'Meetings With Contractor / Stockist') {
                        _navigateTo(const MeetingsWithContractor());
                      } else if (newValue ==
                          'Visit to Get / Check Sampling at Site') {
                        _navigateTo(const CheckSamplingAtSite());
                      } else if (newValue ==
                          'Meeting with New Purchaser(Trade Purchaser)/Retailer') {
                        _navigateTo(const MeetingWithNewPurchaser());
                      } else if (newValue == 'BTL Activities') {
                        _navigateTo(const BtlActivites());
                      } else if (newValue ==
                          'Internal Team Meetings / Review Meetings') {
                        _navigateTo(const InternalTeamMeeting());
                      } else if (newValue == 'Office Work') {
                        // This is the current page, no navigation needed
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
                // Work Related To Field
                _buildLabel('Work Related To'),
                const SizedBox(height: 8),
                _buildTextField(
                  'Enter Work Related To',
                  maxLines: 3,
                ), // Using the helper method, multi-line
                const SizedBox(height: 24), // Increased spacing
                // No. of Hours Spent Field
                _buildLabel('No. of Hours Spent'),
                const SizedBox(height: 8),
                _buildTextField(
                  'Enter Number of Hours',
                  keyboardType: TextInputType.number,
                ), // Using the helper method, number input
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
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Supporting Documents',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
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
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Document ${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
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
                                      () =>
                                          _showImageDialog(_selectedImages[i]!),
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
                const SizedBox(height: 30), // Increased spacing before buttons
                // Submit Buttons
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch, // Stretch buttons to full width
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: implement submit and new logic
                        if (_formKey.currentState!.validate()) {
                          print('Form is valid. Submit and New.');
                          // Add your submission logic here
                          _showSuccessDialog(
                            "Data submitted successfully (Submit & New)!",
                          );
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
                          _showSuccessDialog(
                            "Data submitted successfully (Submit & Exit)!",
                          );
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
      ),
    );
  }

  // --- Helper Methods for Building Widgets ---

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

  // Helper method to show a success dialog
}
