import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class DsrRetailerInOut extends StatefulWidget {
  const DsrRetailerInOut({super.key});

  @override
  State<DsrRetailerInOut> createState() => _DsrRetailerInOutState();
}

class _DsrRetailerInOutState extends State<DsrRetailerInOut>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // State
  String? _purchaserRetailerItem = 'Select';
  String? _areaCode = 'Select';
  DateTime? _selectedDate;

  // Controllers
  final _dateController            = TextEditingController();
  final _yourLatitudeController    = TextEditingController();
  final _yourLongitudeController   = TextEditingController();
  final _custLatitudeController    = TextEditingController();
  final _custLongitudeController   = TextEditingController();
  final _codeSearchController      = TextEditingController();
  final _customerNameController    = TextEditingController();

  // Dropdown data
  final _purchaserRetailerItems = [
    'Select',
    'AD',
    'Stokiest/Urban Stokiest',
    'Direct Dealer',
    'Retailer',
    'Rural Stokiest',
  ];
  final _majorCitiesInIndia = [
    'Select',
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Hyderabad',
    'Ahmedabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Jaipur',
    'Surat',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
  ];
  final _cityCoordinates = {
    'Mumbai': {'latitude': 19.0760, 'longitude': 72.8777},
    'Delhi': {'latitude': 28.7041, 'longitude': 77.1025},
    'Bengaluru': {'latitude': 12.9716, 'longitude': 77.5946},
    'Hyderabad': {'latitude': 17.3850, 'longitude': 78.4867},
    'Ahmedabad': {'latitude': 23.0225, 'longitude': 72.5714},
    'Chennai': {'latitude': 13.0827, 'longitude': 80.2707},
    'Kolkata': {'latitude': 22.5726, 'longitude': 88.3639},
    'Pune': {'latitude': 18.5204, 'longitude': 73.8567},
    'Jaipur': {'latitude': 26.9124, 'longitude': 75.7873},
    'Surat': {'latitude': 21.1702, 'longitude': 72.8311},
  };

  final _formKey = GlobalKey<FormState>();
  final List<XFile?> _selectedImages = [null];
  final _picker = ImagePicker();

  // Colors
  final _primaryColor    = const Color(0xFF2962FF);
  final _secondaryColor  = const Color(0xFF448AFF);
  final _backgroundColor = const Color(0xFFF5F7FA);
  final _cardColor       = Colors.white;
  final _textColor       = const Color(0xFF263238);
  final _hintColor       = const Color(0xFF90A4AE);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController, curve: Curves.easeInOut,
    );
    _animationController.forward();

    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dateController.dispose();
    _yourLatitudeController.dispose();
    _yourLongitudeController.dispose();
    _custLatitudeController.dispose();
    _custLongitudeController.dispose();
    _codeSearchController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Location services are disabled.';
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _captureYourLocation() async {
    try {
      final pos = await _determinePosition();
      _yourLatitudeController.text  = pos.latitude.toStringAsFixed(6);
      _yourLongitudeController.text = pos.longitude.toStringAsFixed(6);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _captureCustomerLocation() async {
    try {
      final pos = await _determinePosition();
      _custLatitudeController.text  = pos.latitude.toStringAsFixed(6);
      _custLongitudeController.text = pos.longitude.toStringAsFixed(6);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: _primaryColor,
            onPrimary: Colors.white,
            onSurface: _textColor,
          ),
          dialogTheme: const DialogThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _onSubmit(String entryType) {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form validated. Entry type: $entryType'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      color: _cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: _textColor)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText, String? labelText}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: TextStyle(color: _hintColor),
      labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
      filled: true,
      fillColor: _cardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildElevatedButton(
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _secondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildActionButton(
      {required String label, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildImageRow(int idx) {
    final file = _selectedImages[idx];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Document ${idx + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(file != null ? Icons.refresh : Icons.upload_file),
              label: Text(file != null ? 'Replace' : 'Upload'),
              onPressed: () async {
                final img = await _picker.pickImage(source: ImageSource.gallery);
                if (img != null) setState(() => _selectedImages[idx] = img);
              },
            ),
            const SizedBox(width: 12),
            if (file != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.visibility),
                label: const Text('View'),
                onPressed: () => _showImage(file),
              ),
            const Spacer(),
            if (_selectedImages.length > 1 && idx == _selectedImages.length - 1)
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => setState(() => _selectedImages.removeLast()),
              ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _showImage(XFile file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Image.file(
          File(file.path),
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DSR Retailer IN OUT',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Daily Sales Report Entry',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Help information for DSR Retailer IN OUT'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildCard(
                  title: 'Purchaser / Retailer',
                  child: DropdownButtonFormField<String>(
                    value: _purchaserRetailerItem,
                    isExpanded: true,
                    decoration: _inputDecoration(),
                    items: _purchaserRetailerItems
                        .map((it) => DropdownMenuItem(value: it, child: Text(it)))
                        .toList(),
                    onChanged: (v) => setState(() => _purchaserRetailerItem = v),
                    validator: (v) => (v == null || v == 'Select') ? 'Required' : null,
                  ),
                ),
                _buildCard(
                  title: 'Area Code',
                  child: DropdownSearch<String>(
                    selectedItem: _areaCode,
                    items: _majorCitiesInIndia,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: _inputDecoration(hintText: 'Search…')
                            .copyWith(prefixIcon: const Icon(Icons.search)),
                      ),
                    ),
                    dropdownDecoratorProps:
                    DropDownDecoratorProps(dropdownSearchDecoration: _inputDecoration()),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _areaCode = v);
                        if (_cityCoordinates.containsKey(v)) {
                          final coords = _cityCoordinates[v]!;
                          _custLatitudeController.text  = coords['latitude']!.toStringAsFixed(6);
                          _custLongitudeController.text = coords['longitude']!.toStringAsFixed(6);
                        }
                      }
                    },
                  ),
                ),
                _buildCard(
                  title: 'Code Search',
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeSearchController,
                          decoration: _inputDecoration(hintText: 'Enter code'),
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {/* noop */},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _secondaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Customer Details',
                  child: TextFormField(
                    controller: _customerNameController,
                    decoration: _inputDecoration(hintText: 'Customer Name'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
                _buildCard(
                  title: 'Date',
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: _inputDecoration(hintText: 'Select Date').copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: _pickDate,
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
                _buildCard(
                  title: 'Your Location',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _yourLatitudeController,
                        readOnly: true,
                        decoration: _inputDecoration(labelText: 'Latitude'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _yourLongitudeController,
                        readOnly: true,
                        decoration: _inputDecoration(labelText: 'Longitude'),
                      ),
                      const SizedBox(height: 8),
                      _buildElevatedButton(
                        icon: Icons.my_location,
                        label: 'Capture Your Location',
                        onPressed: _captureYourLocation,
                      ),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Customer Location',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _custLatitudeController,
                        readOnly: true,
                        decoration: _inputDecoration(labelText: 'Latitude'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _custLongitudeController,
                        readOnly: true,
                        decoration: _inputDecoration(labelText: 'Longitude'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login, size: 24),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'IN',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () => _onSubmit('IN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.error_outline, size: 24),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Exception Entry',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () => _onSubmit('Exception'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
