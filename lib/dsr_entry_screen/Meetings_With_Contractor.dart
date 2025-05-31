import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../theme/app_theme.dart';
import 'dsr_entry.dart';

class MeetingsWithContractor extends StatefulWidget {
  const MeetingsWithContractor({super.key});

  @override
  State<MeetingsWithContractor> createState() => _MeetingsWithContractorState();
}

class _MeetingsWithContractorState extends State<MeetingsWithContractor> {
  String? _processItem = 'Select';
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];
  String? _areaCode = 'Select';
  final List<String> _majorCitiesInIndia = [
    'Select', 'Mumbai', 'Delhi', 'Ahmedabad', 'Pune', 'Surat'
    // (add more cities as you wish)
  ];

  // Coordinates map - (use yours)
  final Map<String, Map<String, double>> _cityCoordinates = {
    'Mumbai': {'latitude': 19.0760, 'longitude': 72.8777},
    'Delhi': {'latitude': 28.7041, 'longitude': 77.1025},
    'Ahmedabad': {'latitude': 23.0225, 'longitude': 72.5714},
    'Pune': {'latitude': 18.5204, 'longitude': 73.8567},
    'Surat': {'latitude': 21.1702, 'longitude': 72.8311},
  };

  String? _purchaserItem = 'Select';
  final List<String> _purchaserdropdownItems = [
    'Select',
    'Purchaser(Non Trade)',
    'AUTHORISED DEALER',
  ];

  final TextEditingController _submissionDateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();
  DateTime? _selectedSubmissionDate;
  DateTime? _selectedReportDate;

  final List<int> _uploadRows = [0];
  final ImagePicker _picker = ImagePicker();
  final List<File?> _selectedImages = [null];

  // Controllers for coordinates
  final TextEditingController _yourLatitudeController = TextEditingController();
  final TextEditingController _yourLongitudeController = TextEditingController();
  final TextEditingController _custLatitudeController = TextEditingController();
  final TextEditingController _custLongitudeController = TextEditingController();

  // HIDDEN required controllers
  final TextEditingController _contrnamController = TextEditingController();
  final TextEditingController _topcdissController = TextEditingController();
  final TextEditingController _remarkscController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _submissionDateController.dispose();
    _reportDateController.dispose();
    _yourLatitudeController.dispose();
    _yourLongitudeController.dispose();
    _custLatitudeController.dispose();
    _custLongitudeController.dispose();
    _contrnamController.dispose();
    _topcdissController.dispose();
    _remarkscController.dispose();
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
            dialogTheme: const DialogThemeData(
              backgroundColor: AppTheme.primaryColor,
            ),
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
            dialogTheme: const DialogThemeData(
              backgroundColor: AppTheme.primaryColor,
            ),
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

  // ----------------------- API LOGIC -------------------------------
  Future<void> _submitForm({bool exitAfter = false}) async {
    if (!_formKey.currentState!.validate()) return;

    // Fill required API fields if empty (adjust as needed)
    if (_contrnamController.text.isEmpty) _contrnamController.text = "Contractor Name";
    if (_topcdissController.text.isEmpty) _topcdissController.text = "Meeting Topic";
    if (_remarkscController.text.isEmpty) _remarkscController.text = "Remarks";

    // Only send first 3 images
    Future<String> fileToBase64(File? file) async {
      if (file == null) return '';
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    }

    final imgfirst  = _selectedImages.length > 0 && _selectedImages[0] != null ? await fileToBase64(_selectedImages[0]) : '';
    final imgscndd  = _selectedImages.length > 1 && _selectedImages[1] != null ? await fileToBase64(_selectedImages[1]) : '';
    final imgthird  = _selectedImages.length > 2 && _selectedImages[2] != null ? await fileToBase64(_selectedImages[2]) : '';

    // Prepare payload
    final Map<String, dynamic> payload = {
      "Proctype": _processItem ?? '',
      "Submdate": _submissionDateController.text,
      "Repodate": _reportDateController.text,
      "Areacode": _areaCode ?? '',
      "Purchtype": _purchaserItem ?? '',
      "Code": "",           // Add logic if you have a code field
      "Neworder": "",       // Add logic if you have these fields
      "Ugrecov": "",
      "Grievanc": "",
      "Anyothpt": "",
      "Contrnam": _contrnamController.text,
      "Remarksc": _remarkscController.text,
      "Topcdiss": _topcdissController.text,
      "imgfirst": imgfirst,
      "imgscndd": imgscndd,
      "imgthird": imgthird,
      "custlat": _custLatitudeController.text,
      "custlng": _custLongitudeController.text,
    };

    debugPrint("API PAYLOAD: ${jsonEncode(payload)}");

    try {
      final response = await HttpClient()
          .postUrl(Uri.parse('https://qa.birlawhite.com:55232/api/dsrmeetconr/submit'))
          .then((request) {
        request.headers.set('Content-Type', 'application/json');
        request.add(utf8.encode(jsonEncode(payload)));
        return request.close();
      });

      final responseBody = await response.transform(utf8.decoder).join();
      debugPrint('API STATUS: ${response.statusCode}');
      debugPrint('API RESPONSE: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meeting submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (exitAfter) Navigator.of(context).pop();
        else _formKey.currentState!.reset();
      } else {
        debugPrint('API ERROR: ${response.statusCode}');
        debugPrint('Response Body: $responseBody');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Submission failed: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('API EXCEPTION: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submission failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  // ---------------------- END API LOGIC ----------------------

  // UI Helper Widgets (unchanged from your original code)
  Widget _buildTextField(
      String hintText, {
        TextEditingController? controller,
        TextInputType? keyboardType,
        int maxLines = 1,
        String? Function(String?)? validator,
        bool readOnly = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDateField(
      TextEditingController controller,
      VoidCallback onTap,
      String hintText,
      ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          onPressed: onTap,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  );

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(),
        value: value,
        onChanged: onChanged,
        items: items
            .map(
              (item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildSearchableDropdownField({
    required String selected,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) => DropdownSearch<String>(
    items: items,
    selectedItem: selected,
    onChanged: onChanged,
    validator: validator,
    popupProps: PopupProps.menu(
      showSearchBox: true,
      searchFieldProps: const TextFieldProps(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.black54),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      itemBuilder: (context, item, isSelected) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(item, style: const TextStyle(color: Colors.black87)),
      ),
    ),
    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        hintText: 'Select',
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    ),
  );

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) => Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(10),
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
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
          title: const Text(
            'Meetings With Contractor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
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
                  // ... (your existing UI as above) ...
                  _buildLabel('Process type'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _processItem,
                    items: _processdropdownItems,
                    onChanged: (newValue) {
                      if (newValue != null) setState(() => _processItem = newValue);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Submission Date'),
                  const SizedBox(height: 8),
                  _buildDateField(_submissionDateController, _pickSubmissionDate, 'Select Date'),
                  const SizedBox(height: 24),
                  _buildLabel('Report Date'),
                  const SizedBox(height: 8),
                  _buildDateField(_reportDateController, _pickReportDate, 'Select Date'),
                  const SizedBox(height: 24),
                  _buildLabel('Area code *:'),
                  const SizedBox(height: 8),
                  _buildSearchableDropdownField(
                    selected: _areaCode!,
                    items: _majorCitiesInIndia,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _areaCode = val;
                          if (_cityCoordinates.containsKey(val)) {
                            _custLatitudeController.text = _cityCoordinates[val]!['latitude']!.toString();
                            _custLongitudeController.text = _cityCoordinates[val]!['longitude']!.toString();
                          } else {
                            _custLatitudeController.clear();
                            _custLongitudeController.clear();
                          }
                        });
                      }
                    },
                    validator: (value) => (value == null || value == 'Select') ? 'Please select an Area Code' : null,
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Purchaser'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _purchaserItem,
                    items: _purchaserdropdownItems,
                    onChanged: (newValue) {
                      if (newValue != null) setState(() => _purchaserItem = newValue);
                    },
                  ),
                  // ... your other fields ...
                  const SizedBox(height: 24),
                  _buildLabel('Upload Supporting'),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.photo_library_rounded, color: AppTheme.primaryColor, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Supporting Documents',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Upload images related to your activity',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text('Document ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 14)),
                                    ),
                                    const Spacer(),
                                    if (_selectedImages[i] != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20)),
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
                                        image: DecorationImage(image: FileImage(_selectedImages[i]!), fit: BoxFit.cover),
                                      ),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                                          child: const Icon(Icons.zoom_in, color: Colors.white, size: 20),
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
                                          backgroundColor: _selectedImages[i] != null ? Colors.amber.shade600 : AppTheme.primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                    if (_uploadRows.length > 1)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: ElevatedButton.icon(
                                          onPressed: _removeRow,
                                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                                          label: const Text('Remove'),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.redAccent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          ),
                                        ),
                                      ),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => _submitForm(exitAfter: false),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          elevation: 3.0,
                        ),
                        child: const Text('Submit & New'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _submitForm(exitAfter: true),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          elevation: 3.0,
                        ),
                        child: const Text('Submit & Exit'),
                      ),
                    ],
                  ),
                  // Offstage hidden fields for API-required values
                  Offstage(
                    offstage: true,
                    child: Column(
                      children: [
                        TextFormField(controller: _contrnamController),
                        TextFormField(controller: _topcdissController),
                        TextFormField(controller: _remarkscController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
