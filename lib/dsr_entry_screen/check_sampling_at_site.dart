import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../theme/app_theme.dart';
import 'dsr_entry.dart';

class CheckSamplingAtSite extends StatefulWidget {
  const CheckSamplingAtSite({super.key});

  @override
  State<CheckSamplingAtSite> createState() => _CheckSamplingAtSiteState();
}

class _CheckSamplingAtSiteState extends State<CheckSamplingAtSite> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();

  DateTime? _selectedDate;
  DateTime? _selectedReportDate;

  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _potentialController = TextEditingController();
  final TextEditingController _applicatorController = TextEditingController();
  String? _qualityItem = 'Select';
  final List<String> _qualitydropdownItems = ['Select', 'Average', 'Medium', 'Good'];
  String? _statusItem = 'Select';
  final List<String> _statusDropdownItems = ['Select', 'Yet To be Checked By Purchaser', 'Approved', 'Rejected'];
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  // Images: start with one, can add up to 3
  List<File?> _selectedImages = [null];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _dateController.dispose();
    _reportDateController.dispose();
    _siteController.dispose();
    _productController.dispose();
    _potentialController.dispose();
    _applicatorController.dispose();
    _contactNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
    );
    if (picked != null) {
      setState(() {
        _selectedReportDate = picked;
        _reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  Future<String> fileToBase64(File? file) async {
    if (file == null) return "";
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _submitForm({bool exitAfter = false}) async {
    if (!_formKey.currentState!.validate()) return;

    // Always send three keys; fill with "" if not present
    final imgfirst = await fileToBase64(_selectedImages.length > 0 ? _selectedImages[0] : null);
    final imgscndd = await fileToBase64(_selectedImages.length > 1 ? _selectedImages[1] : null);
    final imgthird = await fileToBase64(_selectedImages.length > 2 ? _selectedImages[2] : null);

    final Map<String, dynamic> payload = {
      'proctype': _processItem ?? '',
      'submdate': _dateController.text,
      'repodate': _reportDateController.text,
      'sitename': _siteController.text,
      'prodname': _productController.text,
      'potentil': _potentialController.text,
      'applname': _applicatorController.text,
      'qualsamp': _qualityItem ?? '',
      'statsamp': _statusItem ?? '',
      'contname': _contactNameController.text,
      'mobnumbr': _mobileController.text,
      'imgfirst': imgfirst,
      'imgscndd': imgscndd,
      'imgthird': imgthird,
    };

    debugPrint("Payload: ${jsonEncode(payload)}");

    try {
      final response = await http.post(
        Uri.parse('https://qa.birlawhite.com:55232/api/dsrsampling/submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      debugPrint("Status code: ${response.statusCode}");
      debugPrint("👉 Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submitted!'), backgroundColor: Colors.green),
        );
        if (exitAfter) Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DsrEntry())),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
        ),
        title: Text('Check Sampling at Site', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Process type'),
              _buildDropdownField(
                value: _processItem,
                items: _processdropdownItems,
                onChanged: (val) => setState(() => _processItem = val),
              ),
              const SizedBox(height: 10),

              _buildLabel('Submission Date'),
              _buildDateField(_dateController, _pickDate, 'Select Submission Date'),
              const SizedBox(height: 10),

              _buildLabel('Report Date'),
              _buildDateField(_reportDateController, _pickReportDate, 'Select Report Date'),
              const SizedBox(height: 10),

              _buildLabel('Site Name'),
              _buildTextField('Enter Site Name', controller: _siteController),
              const SizedBox(height: 10),

              _buildLabel('Product Name'),
              _buildTextField('Enter Product Name', controller: _productController),
              const SizedBox(height: 10),

              _buildLabel('Potential (MT)'),
              _buildTextField('Enter Potential', controller: _potentialController, keyboardType: TextInputType.number),
              const SizedBox(height: 10),

              _buildLabel('Applicator Name'),
              _buildTextField('Enter Applicator Name', controller: _applicatorController),
              const SizedBox(height: 10),

              _buildLabel('Quality of Sample'),
              _buildDropdownField(
                value: _qualityItem,
                items: _qualitydropdownItems,
                onChanged: (val) => setState(() => _qualityItem = val),
              ),
              const SizedBox(height: 10),

              _buildLabel('Status of Sample'),
              _buildDropdownField(
                value: _statusItem,
                items: _statusDropdownItems,
                onChanged: (val) => setState(() => _statusItem = val),
              ),
              const SizedBox(height: 10),

              _buildLabel('Contact Name'),
              _buildTextField('Enter Contact Name', controller: _contactNameController),
              const SizedBox(height: 10),

              _buildLabel('Mobile Number'),
              _buildTextField('Enter Mobile Number', controller: _mobileController, keyboardType: TextInputType.phone),
              const SizedBox(height: 18),

              _buildLabel('Upload Images'),
              const SizedBox(height: 8),
              ...List.generate(_selectedImages.length, (i) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
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
                          Text('Document ${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const Spacer(),
                          if (_selectedImages[i] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text('Uploaded', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 13)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImage(i),
                              icon: Icon(_selectedImages[i] != null ? Icons.refresh : Icons.upload_file, size: 18),
                              label: Text(_selectedImages[i] != null ? 'Replace' : 'Upload'),
                            ),
                          ),
                          if (_selectedImages[i] != null) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showImageDialog(_selectedImages[i]!),
                                icon: const Icon(Icons.visibility, size: 18),
                                label: const Text('View'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedImages.removeAt(i);
                                });
                              },
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                );
              }),
              // "Add More Image" button if less than 3 images
              if (_selectedImages.length < 3)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedImages.add(null);
                      });
                    },
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add More Image'),
                  ),
                ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submitForm(exitAfter: false),
                      child: const Text('Submit & New'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submitForm(exitAfter: true),
                      child: const Text('Submit & Exit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
    ),
  );

  Widget _buildTextField(
      String hint, {
        TextEditingController? controller,
        TextInputType? keyboardType,
      }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      );

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          color: Colors.white,
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          underline: Container(),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      );

  Widget _buildDateField(TextEditingController controller, VoidCallback onTap, String hint) =>
      TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: onTap),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
        onTap: onTap,
        validator: (val) => val == null || val.isEmpty ? 'Select date' : null,
      );
}
