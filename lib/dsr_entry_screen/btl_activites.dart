import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker

// Ensure these imports are correct based on your project structure
import 'Meeting_with_new_purchaser.dart';
import 'Meetings_With_Contractor.dart';
import 'any_other_activity.dart';
// This is the current file, keep it
import 'check_sampling_at_site.dart';
import 'dsr_entry.dart';
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
import 'phone_call_with_builder.dart';
import 'phone_call_with_unregisterd_purchaser.dart';
import 'work_from_home.dart';
import '../theme/app_theme.dart';

class BtlActivites extends StatefulWidget {
  const BtlActivites({super.key});

  @override
  State<BtlActivites> createState() => _BtlActivitesState();
}

class _BtlActivitesState extends State<BtlActivites> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem = 'BTL Activities'; // Default to BTL Activities
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

  String _activityTypeItem = 'Select'; // Specific dropdown for BTL Activities
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

  // Controllers for date text fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  // State variables to hold selected dates
  DateTime? _selectedDate;
  DateTime? _selectedReportDate;

  // Controllers for new fields specific to BTL Activities
  final TextEditingController _noOfParticipantsController =
      TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _learningsController = TextEditingController();

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
    _noOfParticipantsController.dispose();
    _townController.dispose();
    _learningsController.dispose();
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
    return Scaffold(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BTL Activities',
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
              // Show help dialog or tooltip
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help information for BTL Activities'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
        backgroundColor: AppTheme.primaryColor,
        elevation: 0, // Remove shadow for a more modern look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Process Section
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
                    items: _processdropdownItems
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
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _processItem = newValue);
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

              const SizedBox(height: 20),
              // Activity Section
              AppTheme.buildSectionCard(
                title: 'Activity',
                icon: Icons.category_outlined,
                children: [
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
                    items: _activityDropDownItems
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
                          _navigateTo(const MeetingWithNewPurchaser());
                        } else if (newValue == 'BTL Activities') {
                          // This is the current page, no navigation needed
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
                    validator: (value) {
                      if (value == null || value == 'Select') {
                        return 'Please select an activity';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // Date Information Section
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
              // BTL Activity Details Section
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
                        horizontal: 16,
                        vertical: 12,
                      ),
                      isCollapsed: true,
                    ),
                    isExpanded: true,
                    items: _activityTypedropdownItems
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
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _activityTypeItem = newValue);
                      }
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

              // Image Upload Section
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
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
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return AppTheme.buildTextField(
      hintText,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  // Helper to build a date input field
  Widget _buildDateField(
    TextEditingController controller,
    VoidCallback onTap,
    String hintText,
  ) {
    return AppTheme.buildDateField(
      context,
      controller,
      onTap,
      hintText,
    );
  }

  // Helper to build a standard text label
  Widget _buildLabel(String text) => AppTheme.buildLabel(text);

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
