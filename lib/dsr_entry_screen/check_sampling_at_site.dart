import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

// Ensure these imports are correct based on your project structure
import 'Meeting_with_new_purchaser.dart';
import 'Meetings_With_Contractor.dart';
import 'any_other_activity.dart';
import 'btl_activites.dart';
// This is the current file, keep it
import 'dsr_entry.dart';
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
import 'phone_call_with_builder.dart';
import 'phone_call_with_unregisterd_purchaser.dart';
import 'work_from_home.dart';

class CheckSamplingAtSite extends StatefulWidget {
  const CheckSamplingAtSite({super.key});

  @override
  State<CheckSamplingAtSite> createState() => _CheckSamplingAtSiteState();
}

class _CheckSamplingAtSiteState extends State<CheckSamplingAtSite> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem =
      'Visit to Get / Check Sampling at Site'; // Default to this activity
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

  String? _siteItem =
      'Select'; // Dropdown for Product for which Sample is applied
  final List<String> _sitedropdownItems = [
    'Select',
    'White Cement',
    'Wall Care putty',
    'Textura',
    'Levelplast',
    'Wall Primer',
  ];

  String? _qualityItem = 'Select'; // Dropdown for Quality of Sample
  final List<String> _qualitydropdownItems = [
    'Select',
    'Average',
    'Medium',
    'Good',
  ];

  String? _statusItem = 'Select'; // Dropdown for Status of Sample
  final List<String> _statusDropdownItems = [
    'Select',
    'Yet To be Checked By Purchaser',
    'Approved',
    'Rejected',
  ];

  // Controllers for date text fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  // State variables to hold selected dates
  DateTime? _selectedDate;
  DateTime? _selectedReportDate;

  // Lists for image uploads
  final List<int> _uploadRows = [0]; // Tracks the number of image upload rows
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  // List to hold selected image paths for each row (multiple images per row)
  List<List<String>> _selectedImagePaths = [
    [],
  ]; // Initialize with an empty list for the first row

  // Global key for the form for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Ensure _selectedImagePaths has an empty list for the initial row
    if (_selectedImagePaths.isEmpty) {
      _selectedImagePaths = [[]];
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _dateController.dispose();
    _reportDateController.dispose();
    super.dispose();
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
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
        _reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Function to add a new image upload row
  void _addRow() {
    setState(() {
      _uploadRows.add(_uploadRows.length); // Add a new index
      _selectedImagePaths.add(
        [],
      ); // Add a new empty list for the new row's images
    });
  }

  // Function to remove the last image upload row
  void _removeRow() {
    if (_uploadRows.length <= 1) return; // Prevent removing the last row
    setState(() {
      _uploadRows.removeLast(); // Remove the last index
      _selectedImagePaths.removeLast(); // Remove the last image path list
    });
  }

  // Function to pick multiple images for a specific row
  Future<void> _pickImages(int rowIndex) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        // Replace the existing images for this row with the newly picked ones
        _selectedImagePaths[rowIndex] = pickedFiles.map((e) => e.path).toList();
      });
    } else {
      // User canceled the image selection.
      print('No images selected for row $rowIndex.');
    }
  }

  // Function to show a dialog with the selected images for a specific row
  void _showImagesDialog(int rowIndex) {
    if (_selectedImagePaths[rowIndex].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No images selected for this row to view.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          // Use a Dialog widget for a modal popup
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Make column size to fit content
              children: [
                const Text(
                  'Selected Images',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ), // Styled title
                ),
                const SizedBox(height: 16), // Increased spacing
                // Use a SizedBox with constrained height and width for the image list
                SizedBox(
                  height: 200, // Limit the height of the image list
                  width: double.maxFinite, // Make it wide
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal list
                    itemCount: _selectedImagePaths[rowIndex].length,
                    itemBuilder: (context, index) {
                      final imagePath = _selectedImagePaths[rowIndex][index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ), // Spacing between images
                        child: Image.file(
                          File(imagePath),
                          height: 180, // Adjust as needed
                          width: 180, // Adjust as needed
                          fit:
                              BoxFit
                                  .cover, // Use cover to fill the space nicely
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), // Increased spacing
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(), // Close the dialog
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ), // Styled button
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background for the body
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigate back to the DsrEntry screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DsrEntry()),
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
            Colors.blueAccent, // A slightly brighter blue for AppBar
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
                  color: Colors.blueAccent, // Match AppBar color
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
                    } else if (newValue == 'Phone Call with Builder/Stockist') {
                      _navigateTo(const PhoneCallWithBuilder());
                    } else if (newValue ==
                        'Meetings With Contractor / Stockist') {
                      _navigateTo(const MeetingsWithContractor());
                    } else if (newValue ==
                        'Visit to Get / Check Sampling at Site') {
                      // This is the current page, no navigation needed
                    } else if (newValue ==
                        'Meeting with New Purchaser(Trade Purchaser)/Retailer') {
                      _navigateTo(const MeetingWithNewPurchaser());
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
              _buildDateField(_dateController, _pickDate, 'Select Date'),
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
              // Site Name Field
              _buildLabel('Site Name'),
              const SizedBox(height: 8),
              _buildTextField('Enter Site Name'),
              const SizedBox(height: 24),

              // Product for which Sample is applied Dropdown
              _buildLabel('Product for which Sample is applied'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _siteItem,
                items: _sitedropdownItems,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _siteItem = newValue);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Approx Potential of Site (MT) Field
              _buildLabel('Approx Potential of Site (MT)'),
              const SizedBox(height: 8),
              _buildTextField(
                'Enter Potential (MT)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Applicator Name Who Applied Sample Field
              _buildLabel('Applicator Name Who Applied Sample'),
              const SizedBox(height: 8),
              _buildTextField('Enter Applicator Name'),
              const SizedBox(height: 24),

              // Quality of Sample Dropdown
              _buildLabel('Quality of Sample'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _qualityItem,
                items:
                    _qualitydropdownItems, // Corrected to use _qualitydropdownItems
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _qualityItem = newValue);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Status of Sample Dropdown
              _buildLabel('Status of Sample'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _statusItem,
                items: _statusDropdownItems,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _statusItem = newValue);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Contact Name Field
              _buildLabel('Contact Name'),
              const SizedBox(height: 8),
              _buildTextField('Enter Contact Name'),
              const SizedBox(height: 24),

              // Mobile no. Field
              _buildLabel('Mobile no.'),
              const SizedBox(height: 8),
              _buildTextField(
                'Enter Mobile Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Image Upload Section
              _buildLabel('Upload Images'),
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
                                _selectedImagePaths[i].isNotEmpty
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
                                if (_selectedImagePaths[i].isNotEmpty)
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
                            if (_selectedImagePaths[i].isNotEmpty)
                              GestureDetector(
                                onTap: () => _showImagesDialog(i),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(_selectedImagePaths[i][0]),
                                      ),
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
                                    onPressed: () => _pickImages(i),
                                    icon: Icon(
                                      _selectedImagePaths[i].isNotEmpty
                                          ? Icons.refresh
                                          : Icons.upload_file,
                                      size: 18,
                                    ),
                                    label: Text(
                                      _selectedImagePaths[i].isNotEmpty
                                          ? 'Replace'
                                          : 'Upload',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          _selectedImagePaths[i].isNotEmpty
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
                                if (_selectedImagePaths[i].isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showImagesDialog(i),
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
                        // Process form data
                        print('Form is valid. Submit and New.');
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
                        // Process form data
                        print('Form is valid. Submit and Exit.');
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
              const SizedBox(height: 20), // Spacing at the
            ],
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label is handled separately before calling this function
        // _buildLabel(label),
        // const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
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
        ),
      ],
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
