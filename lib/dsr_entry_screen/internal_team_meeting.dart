import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'dsr_entry.dart';

class InternalTeamMeeting extends StatefulWidget {
  const InternalTeamMeeting({super.key});

  @override
  State<InternalTeamMeeting> createState() => _InternalTeamMeetingState();
}

class _InternalTeamMeetingState extends State<InternalTeamMeeting> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  final TextEditingController _submissionDateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  final TextEditingController _meetwithController = TextEditingController();
  final TextEditingController _meetdiscController = TextEditingController();
  final TextEditingController _learnnngController = TextEditingController();

  final List<int> _uploadRows = [0];
  final ImagePicker _picker = ImagePicker();
  List<List<String>> _selectedImagePaths = [[]]; // Multiple images per row

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _submissionDateController.dispose();
    _reportDateController.dispose();
    _meetwithController.dispose();
    _meetdiscController.dispose();
    _learnnngController.dispose();
    super.dispose();
  }

  Future<void> _pickSubmissionDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _submissionDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickReportDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _addRow() {
    setState(() {
      _uploadRows.add(_uploadRows.length);
      _selectedImagePaths.add([]);
    });
  }

  void _removeRow() {
    if (_uploadRows.length <= 1) return;
    setState(() {
      _uploadRows.removeLast();
      _selectedImagePaths.removeLast();
    });
  }

  Future<void> _pickImages(int rowIndex) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImagePaths[rowIndex] = pickedFiles.map((e) => e.path).toList();
      });
    }
  }

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Selected Images',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImagePaths[rowIndex].length,
                    itemBuilder: (context, index) {
                      final imagePath = _selectedImagePaths[rowIndex][index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.file(
                          File(imagePath),
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _getBase64OrEmpty(int imageIndex) async {
    // Returns base64 of the first image in row if exists, else ""
    if (_selectedImagePaths.length > imageIndex &&
        _selectedImagePaths[imageIndex].isNotEmpty) {
      final File imageFile = File(_selectedImagePaths[imageIndex][0]);
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    }
    return "";
  }

  Future<void> _submitToApi() async {
    setState(() => _isLoading = true);

    // Always send "" for images if not present
    String imgfirst = await _getBase64OrEmpty(0);
    String imgscndd = await _getBase64OrEmpty(1);
    String imgthird = await _getBase64OrEmpty(2);

    final Map<String, dynamic> payload = {
      "Proctype": _processItem,
      "Submdate": _submissionDateController.text,
      "Repodate": _reportDateController.text,
      "Meetwith": _meetwithController.text,
      "Meetdisc": _meetdiscController.text,
      "Learnnng": _learnnngController.text,
      "Imgfirst": imgfirst,
      "Imgscndd": imgscndd,
      "Imgthird": imgthird,
    };

    try {
      final res = await http.post(
        Uri.parse("https://qa.birlawhite.com:55232/api/dsrintmeett/submit"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      print('API STATUS: ${res.statusCode}');
      print('Response Body: ${res.body}');

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Submitted successfully!"),
            duration: Duration(seconds: 2),
          ),
        );
        _formKey.currentState?.reset();
        _meetwithController.clear();
        _meetdiscController.clear();
        _learnnngController.clear();
        setState(() {
          _selectedImagePaths = [[]];
          _uploadRows.clear();
          _uploadRows.add(0);
        });
      } else {
        print("API ERROR: ${res.statusCode}");
        print("Response Body: ${res.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
                "Error: ${jsonDecode(res.body)?['title'] ?? "Unknown error"}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('API EXCEPTION: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Network or Server Error!"),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
        ),
        title: const Text('Internal Team Meeting',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: _processItem,
                    decoration: InputDecoration(
                      labelText: "Process Type",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: _processdropdownItems
                        .map(
                          (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _processItem = val);
                    },
                    validator: (value) {
                      if (value == null || value == 'Select') {
                        return 'Please select a process';
                      }
                      return null;
                    },
                  ),
                ),
              ),
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
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _meetwithController,
                  decoration: InputDecoration(
                    labelText: 'Meeting With Whom (required)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Enter Meetwith' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _meetdiscController,
                  decoration: InputDecoration(
                    labelText: 'Meeting Discussion Points (required)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Enter Meetdisc' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _learnnngController,
                  decoration: InputDecoration(
                    labelText: 'Learnings (required)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Enter Learnnng' : null,
                ),
              ),
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
                    ...List.generate(_uploadRows.length, (index) {
                      final i = _uploadRows[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedImagePaths[i].isNotEmpty
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
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Document ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 33, 150, 243),
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
                                        Icon(Icons.check_circle, color: Colors.green, size: 16),
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
                                      image: FileImage(File(_selectedImagePaths[i][0])),
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
                                      child: const Icon(Icons.zoom_in, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _pickImages(i),
                                    icon: Icon(
                                      _selectedImagePaths[i].isNotEmpty ? Icons.refresh : Icons.upload_file,
                                      size: 18,
                                    ),
                                    label: Text(_selectedImagePaths[i].isNotEmpty ? 'Replace' : 'Upload'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: _selectedImagePaths[i].isNotEmpty
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
                                      icon: const Icon(Icons.visibility, size: 18),
                                      label: const Text('View'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green,
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
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
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
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
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
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    _submitToApi();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
