import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dsr_entry.dart';
import '../theme/app_theme.dart';

class WorkFromHome extends StatefulWidget {
  const WorkFromHome({super.key});

  @override
  State<WorkFromHome> createState() => _WorkFromHomeState();
}

class _WorkFromHomeState extends State<WorkFromHome> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];
  final TextEditingController _submissionDateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();
  DateTime? _selectedSubmissionDate;
  DateTime? _selectedReportDate;
  final List<int> _uploadRows = [0];
  final List<File?> _selectedImages = [null];
  final ImagePicker _picker = ImagePicker();
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
              primary: Colors.blueAccent,
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
              primary: Colors.blueAccent,
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
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Unable to load image', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<String> fileToBase64(File? file) async {
    if (file == null) return '';
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final subDateStr = _submissionDateController.text;
    final repDateStr = _reportDateController.text;

    // Always prepare three image fields as per backend structure (can be "")
    String imgfirst = '', imgscndd = '', imgthird = '';
    if (_selectedImages.isNotEmpty) imgfirst = await fileToBase64(_selectedImages[0]);
    if (_selectedImages.length > 1) imgscndd = await fileToBase64(_selectedImages[1]);
    if (_selectedImages.length > 2) imgthird = await fileToBase64(_selectedImages[2]);

    final Map<String, dynamic> payload = {
      'proctype': _processItem ?? '',
      'submdate': subDateStr,
      'repodate': repDateStr,
      'imgfirst': imgfirst,
      'imgscndd': imgscndd,
      'imgthird': imgthird,
    };

    try {
      final response = await HttpClient()
          .postUrl(Uri.parse('https://qa.birlawhite.com:55232/api/dsrworkhome/submit'))
          .then((req) {
        req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
        req.add(utf8.encode(jsonEncode(payload)));
        return req.close();
      });

      final respBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work From Home submitted successfully!'), backgroundColor: Colors.green),
        );
        // Clear form after submission
        _formKey.currentState!.reset();
        setState(() {
          _processItem = 'Select';
          _selectedSubmissionDate = null;
          _submissionDateController.clear();
          _selectedReportDate = null;
          _reportDateController.clear();
          _uploadRows.clear();
          _selectedImages.clear();
          _uploadRows.add(0);
          _selectedImages.add(null);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed (${response.statusCode}): $respBody'), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DsrEntry()));
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Work From Home', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white)),
            Text('Daily Sales Report Entry', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Help information for Work From Home'),
                duration: Duration(seconds: 2),
              ));
            },
          ),
        ],
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      isCollapsed: true,
                    ),
                    isExpanded: true,
                    items: _processdropdownItems.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: Text(item, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 14)),
                      ),
                    )).toList(),
                    onChanged: (value) => setState(() => _processItem = value),
                    validator: (value) => (value == null || value == 'Select') ? 'Please select a process' : null,
                  ),
                ],
              ),
              AppTheme.buildSectionCard(
                title: 'Date Information',
                icon: Icons.date_range_outlined,
                children: [
                  AppTheme.buildLabel('Submission Date'),
                  const SizedBox(height: 8),
                  AppTheme.buildDateField(context, _submissionDateController, _pickSubmissionDate, 'Select Submission Date'),
                  const SizedBox(height: 16),
                  AppTheme.buildLabel('Report Date'),
                  const SizedBox(height: 8),
                  AppTheme.buildDateField(context, _reportDateController, _pickReportDate, 'Select Report Date'),
                ],
              ),
              // Image Upload Card
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.photo_library_rounded, color: AppTheme.primaryColor, size: 24),
                        const SizedBox(width: 8),
                        Text('Supporting Documents', style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Upload images related to your activity (optional)', style: Theme.of(context).textTheme.bodyMedium),
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
                            color: _selectedImages[i] != null ? Colors.green.shade200 : Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('Document ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 33, 150, 243), fontSize: 14)),
                                ),
                                const Spacer(),
                                if (_selectedImages[i] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                                        SizedBox(width: 4),
                                        Text('Uploaded', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_selectedImages[i] != null)
                              GestureDetector(
                                onTap: () => _showImageDialog(_selectedImages[i]!),
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
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _pickImage(i),
                                    icon: Icon(_selectedImages[i] != null ? Icons.refresh : Icons.upload_file, size: 18),
                                    label: Text(_selectedImages[i] != null ? 'Replace' : 'Upload'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: _selectedImages[i] != null ? Colors.amber.shade600 : Colors.blueAccent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                if (_selectedImages[i] != null) ...[
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showImageDialog(_selectedImages[i]!),
                                      icon: const Icon(Icons.visibility, size: 18),
                                      label: const Text('View'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Submit Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DsrEntry()));
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to DSR Entry'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.blueAccent)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        elevation: 1.0,
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
    );
  }
}
