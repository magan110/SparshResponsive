import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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
  State<MeetingWithNewPurchaser> createState() => _MeetingWithNewPurchaserState();
}

class _MeetingWithNewPurchaserState extends State<MeetingWithNewPurchaser> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  final TextEditingController _submissionDateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  final TextEditingController _purchaserNameController = TextEditingController();
  final TextEditingController _topicDiscussedController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

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
    _purchaserNameController.dispose();
    _topicDiscussedController.dispose();
    _remarksController.dispose();
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

  // Helper: Map UI to API JSON keys for POST
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Always provide base64 strings for images, even if blank
    String imgfirst = '';
    String imgscndd = '';
    String imgthird = '';

    if (_selectedImages.length > 0 && _selectedImages[0] != null) {
      imgfirst = base64Encode(await _selectedImages[0]!.readAsBytes());
    }
    if (_selectedImages.length > 1 && _selectedImages[1] != null) {
      imgscndd = base64Encode(await _selectedImages[1]!.readAsBytes());
    }
    if (_selectedImages.length > 2 && _selectedImages[2] != null) {
      imgthird = base64Encode(await _selectedImages[2]!.readAsBytes());
    }

    final Map<String, dynamic> payload = {
      "Proctype": _processItem,
      "Submdate": _submissionDateController.text,
      "Repodate": _reportDateController.text,
      "Bldrname": _purchaserNameController.text,
      "Topcdiss": _topicDiscussedController.text,
      "Remarksf": _remarksController.text,
      "Imgfirst": imgfirst,
      "Imgscndd": imgscndd,
      "Imgthird": imgthird,
    };

    final url = Uri.parse(
        "https://qa.birlawhite.com:55232/api/dsrmeetnpur/submit");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
      _showOutcomeSnackbar(response.statusCode, response.body);
    } catch (e) {
      _showOutcomeSnackbar(0, 'Exception: $e');
    }
  }

    void _showOutcomeSnackbar(int status, String message) {
    final isSuccess = status == 200;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSuccess ? 'Submitted successfully!' : message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
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
                  content: Text('Help information for Meeting with New Purchaser'),
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
                        Icon(Icons.settings_outlined, color: AppTheme.primaryColor),
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
                          Icon(Icons.date_range_outlined, color: AppTheme.primaryColor),
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

              // Purchaser Name
              TextFormField(
                controller: _purchaserNameController,
                decoration: InputDecoration(
                  labelText: 'Purchaser Name',
                  hintText: 'Enter Purchaser Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Topic Discussed
              TextFormField(
                controller: _topicDiscussedController,
                decoration: InputDecoration(
                  labelText: 'Topic Discussed',
                  hintText: 'Enter Topic Discussed',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Remarks
              TextFormField(
                controller: _remarksController,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  hintText: 'Enter Remarks',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                minLines: 2,
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

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
                onPressed: _submitForm,
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
