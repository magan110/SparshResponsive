import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

// Ensure these imports are correct based on your project structure
import 'Meeting_with_new_purchaser.dart';
import 'Meetings_With_Contractor.dart';
import 'any_other_activity.dart';
import 'btl_activites.dart';
import 'check_sampling_at_site.dart';
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
import 'phone_call_with_builder.dart';
import 'phone_call_with_unregisterd_purchaser.dart';
import 'work_from_home.dart';
import 'package:learning2/screens/Home_screen.dart'; // Assuming HomeScreen is in this path
import 'package:learning2/theme/app_theme.dart';

class DsrEntry extends StatefulWidget {
  const DsrEntry({super.key});

  @override
  _DsrEntryState createState() => _DsrEntryState();
}

class _DsrEntryState extends State<DsrEntry> {
  // State variables for dropdowns and date pickers
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem = 'Select'; // Default to 'Select'
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
      TextEditingController();
  final TextEditingController _reportDateController =
      TextEditingController(); // Separate controller for Report Date

  // State variables to hold selected dates
  DateTime? _selectedSubmissionDate;
  DateTime? _selectedReportDate; // Separate state variable for Report Date

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Lists for image uploads
  final List<int> _uploadRows = [0]; // Start with one upload row
  final Map<int, File?> _selectedImages = {};

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _submissionDateController.dispose();
    _reportDateController.dispose(); // Dispose the Report Date controller
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
              primary: Colors.blue, // Header background color
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
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: AppTheme.primaryTextColor, // Body text color
            ),
            dialogTheme: AppTheme.dialogTheme, // Dialog background
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
      _uploadRows.add(_uploadRows.isEmpty ? 0 : _uploadRows.last + 1);
    });
  }

  // Function to remove the last image upload row
  void _removeRow() {
    if (_uploadRows.length > 1) {
      setState(() {
        int lastIndex = _uploadRows.last;
        _selectedImages.remove(lastIndex);
        _uploadRows.removeLast();
      });
    }
  }

  // Function to handle image picking for a specific row
  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImages[index] = File(image.path);
      });
    }
  }

  // Function to show the selected image in a dialog
  void _showImageDialog(File image) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'Document Preview',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Image.file(image),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  // Helper for navigation
  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // Navigate back to the HomeScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.assignment_outlined, size: 28),
              const SizedBox(width: 10),
              Text(
                'DSR Entry',
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
                  // Header with instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Instructions',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Daily Sales Report',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Fill in the details below to submit your daily sales report.',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Process and Activity Section
                  _buildSectionCard(
                    title: 'Activity Information',
                    icon: Icons.category_outlined,
                    children: [
                      _buildLabel('Process type'),
                      const SizedBox(height: 8),
                      _buildDropdownField(
                        value: _processItem,
                        items: _processdropdownItems,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() => _processItem = newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Activity Type'),
                      const SizedBox(height: 8),
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
                              _navigateTo(const OfficeWork());
                            } else if (newValue ==
                                'On Leave / Holiday / Off Day') {
                              _navigateTo(const OnLeave());
                            } else if (newValue == 'Work From Home') {
                              _navigateTo(const WorkFromHome());
                            } else if (newValue == 'Any Other Activity') {
                              _navigateTo(const AnyOtherActivity());
                            } else if (newValue ==
                                'Phone call with Unregistered Purchasers') {
                              _navigateTo(
                                const PhoneCallWithUnregisterdPurchaser(),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Date Section
                  _buildSectionCard(
                    title: 'Date Information',
                    icon: Icons.date_range_outlined,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Submission Date'),
                                const SizedBox(height: 8),
                                _buildDateField(
                                  _submissionDateController,
                                  _pickSubmissionDate,
                                  'Select Date',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Report Date'),
                                const SizedBox(height: 8),
                                _buildDateField(
                                  _reportDateController,
                                  _pickReportDate,
                                  'Select Date',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Details Section
                  _buildSectionCard(
                    title: 'Report Details',
                    icon: Icons.description_outlined,
                    children: [
                      _buildLabel('Topic Discussed'),
                      const SizedBox(height: 8),
                      _buildTextField('Enter Topic Discussed', maxLines: 3),
                      const SizedBox(height: 16),

                      _buildLabel('Ugai Recovery Plans'),
                      const SizedBox(height: 8),
                      _buildTextField('Enter Ugai Recovery Plans', maxLines: 3),
                      const SizedBox(height: 16),

                      _buildLabel('Any Purchaser Grievances'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        'Enter Any Purchaser Grievances',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('Any Other Points'),
                      const SizedBox(height: 8),
                      _buildTextField('Enter Any Other Points', maxLines: 3),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Image Upload Section
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
                                        color: Colors.blueAccent.withOpacity(
                                          0.1,
                                        ),
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
                                // Image preview if selected
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

                  const SizedBox(height: 30),

                  // Submit Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: implement submit and new logic
                            if (_formKey.currentState!.validate()) {
                              print('Form is valid. Submit and New.');
                              // Add your submission logic here
                            }
                          },
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Submit & New'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(
                              255,
                              33,
                              150,
                              243,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: implement submit and exit logic
                            if (_formKey.currentState!.validate()) {
                              print('Form is valid. Submit and Exit.');
                              // Add your submission logic here and then navigate back
                            }
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Submit & Exit'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: implement view submitted data logic
                            print('View Submitted Data button pressed');
                            // Add logic to view submitted data
                          },
                          icon: const Icon(Icons.visibility_outlined),
                          label: const Text('View Submitted Data'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              33,
                              150,
                              243,
                            ),
                            side: const BorderSide(color: Color(0xFF3F51B5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a section card
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return AppTheme.buildSectionCard(
      title: title,
      icon: icon,
      children: children,
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

  // Helper to build a standard dropdown field (not searchable)
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 56, // Increased height for better touch target
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            isExpanded: true,
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color.fromARGB(255, 33, 150, 243),
                size: 20,
              ),
            ),
            value: value,
            onChanged: onChanged,
            hint: Text(
              'Select',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
            items:
                items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  // Helper to build a standard text label
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 4),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    ),
  );
}
