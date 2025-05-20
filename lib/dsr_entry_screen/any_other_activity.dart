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
import '../theme/app_theme.dart';

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
        backgroundColor: AppTheme.scaffoldBackgroundColor,
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
                  // Enhanced Instructions Section
                  AppTheme.buildSectionCard(
                    title: 'Activity Information',
                    icon: Icons.info_outline,
                    children: [
                      // Process Type Dropdown with enhanced styling
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
                                      constraints: const BoxConstraints(
                                        maxWidth: 250,
                                      ),
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

                      // Activity Type Dropdown with enhanced styling
                      const SizedBox(height: 16),
                      AppTheme.buildLabel('Activity Type'),
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
                          isCollapsed: true,
                        ),
                        isExpanded: true,
                        items:
                            _activityDropDownItems
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 250,
                                      ),
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
                        validator: (value) {
                          if (value == null || value == 'Select') {
                            return 'Please select an activity';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  // Date Fields Section
                  const SizedBox(height: 16),
                  AppTheme.buildSectionCard(
                    title: 'Date Information',
                    icon: Icons.calendar_today,
                    children: [
                      // Submission Date Field
                      AppTheme.buildLabel('Submission Date'),
                      const SizedBox(height: 8),
                      AppTheme.buildDateField(
                        context,
                        _dateController,
                        _pickDate,
                        'Select Date',
                      ),

                      // Report Date Field
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
                                                  : AppTheme.primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
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
                                            backgroundColor:
                                                AppTheme.successColor,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                              style:
                                  Theme.of(context).elevatedButtonTheme.style,
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
                  const SizedBox(
                    height: 30,
                  ), // Increased spacing before buttons
                  // Submit Buttons - Enhanced UI
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Section title
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

                        // Submit & New Button
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: implement submit and new logic
                            if (_formKey.currentState!.validate()) {
                              // Process form data
                              print('Form is valid. Submit and New.');
                            }
                          },
                          icon: const Icon(Icons.save_outlined, size: 20),
                          label: const Text('Submit & New'),
                          style: Theme.of(context).elevatedButtonTheme.style,
                        ),

                        const SizedBox(height: 16),

                        // Submit & Exit Button
                        ElevatedButton.icon(
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

                        // View Submitted Data Button
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: implement view submitted data logic
                            print('View Submitted Data button pressed');
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 20),
                          label: const Text('View Submitted Data'),
                          style: Theme.of(context).outlinedButtonTheme.style,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing at the bottom
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
    return AppTheme.buildDateField(context, controller, onTap, hintText);
  }

  // Helper to build a standard text label
  Widget _buildLabel(String text) => AppTheme.buildLabel(text);

  // Helper to build a standard dropdown field with enhanced styling
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
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
          items
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
      onChanged: onChanged,
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
