import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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
import 'package:learning2/screens/Home_screen.dart';
import 'package:learning2/theme/app_theme.dart';

class DsrEntry extends StatefulWidget {
  const DsrEntry({super.key});

  @override
  _DsrEntryState createState() => _DsrEntryState();
}

class _DsrEntryState extends State<DsrEntry> {
  final List<String> _processdropdownItems = ['Select', 'Add', 'Update'];

  String? _activityItem = 'Select';
  final List<String> _activityDropDownItems = [
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

  // Icon mapping for activities
  final Map<String, IconData> _activityIcons = {
    'Personal Visit': Icons.person_pin_circle,
    'Phone Call with Builder/Stockist': Icons.phone_in_talk,
    'Meetings With Contractor / Stockist': Icons.groups,
    'Visit to Get / Check Sampling at Site': Icons.fact_check,
    'Meeting with New Purchaser(Trade Purchaser)/Retailer': Icons.handshake,
    'BTL Activities': Icons.campaign,
    'Internal Team Meetings / Review Meetings': Icons.people_outline,
    'Office Work': Icons.desktop_windows,
    'On Leave / Holiday / Off Day': Icons.beach_access,
    'Work From Home': Icons.home_work,
    'Any Other Activity': Icons.miscellaneous_services,
    'Phone call with Unregistered Purchasers': Icons.call,
  };

  final TextEditingController _submissionDateController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();
  DateTime? _selectedSubmissionDate;
  DateTime? _selectedReportDate;

  final _formKey = GlobalKey<FormState>();
  final List<int> _uploadRows = [0];
  final Map<int, File?> _selectedImages = {};

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
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
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
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppTheme.primaryColor,
            onPrimary: Colors.white,
            onSurface: AppTheme.primaryTextColor,
          ),
          dialogTheme: AppTheme.dialogTheme,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedReportDate = picked;
        _reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _addRow() {
    setState(() => _uploadRows.add(_uploadRows.isEmpty ? 0 : _uploadRows.last + 1));
  }

  void _removeRow() {
    if (_uploadRows.length > 1) {
      final last = _uploadRows.removeLast();
      _selectedImages.remove(last);
      setState(() {});
    }
  }

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _selectedImages[index] = File(img.path));
    }
  }

  void _showImageDialog(File image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
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
              title: const Text('Document Preview', style: TextStyle(color: Colors.black)),
            ),
            Image.file(image),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildActivityGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.18,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemCount: _activityDropDownItems.length,
      itemBuilder: (context, i) {
        final label = _activityDropDownItems[i];
        final selected = _activityItem == label;
        return GestureDetector(
          onTap: () {
            setState(() => _activityItem = label);
            switch (label) {
              case 'Personal Visit':
                _navigateTo(const DsrRetailerInOut());
                break;
              case 'Phone Call with Builder/Stockist':
                _navigateTo(const PhoneCallWithBuilder());
                break;
              case 'Meetings With Contractor / Stockist':
                _navigateTo(const MeetingsWithContractor());
                break;
              case 'Visit to Get / Check Sampling at Site':
                _navigateTo(const CheckSamplingAtSite());
                break;
              case 'Meeting with New Purchaser(Trade Purchaser)/Retailer':
                _navigateTo(const MeetingWithNewPurchaser());
                break;
              case 'BTL Activities':
                _navigateTo(const BtlActivites());
                break;
              case 'Internal Team Meetings / Review Meetings':
                _navigateTo(const InternalTeamMeeting());
                break;
              case 'Office Work':
                _navigateTo(const OfficeWork());
                break;
              case 'On Leave / Holiday / Off Day':
                _navigateTo(const OnLeave());
                break;
              case 'Work From Home':
                _navigateTo(const WorkFromHome());
                break;
              case 'Any Other Activity':
                _navigateTo(const AnyOtherActivity());
                break;
              case 'Phone call with Unregistered Purchasers':
                _navigateTo(const PhoneCallWithUnregisterdPurchaser());
                break;
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.ease,
            decoration: BoxDecoration(
              color: Colors.white, // Always white background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.19),
                  blurRadius: 18,
                  spreadRadius: 3,
                  offset: const Offset(0, 7),
                ),
              ],
              border: Border.all(
                color: selected ? AppTheme.primaryColor : Colors.grey.shade200,
                width: selected ? 2.5 : 1.1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.11),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _activityIcons[label] ?? Icons.assignment,
                      size: 27,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.7,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
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
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
          ),
          title: Row(
            children: [
              const Icon(Icons.assignment_outlined, size: 28),
              const SizedBox(width: 10),
              Text('DSR Entry', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white)),
            ],
          ),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.scaffoldBackgroundColor, Colors.grey.shade100],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            Icon(Icons.info_outline, color: Colors.white, size: 24),
                            Text('Instructions',
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            Chip(label: Text('Daily Sales Report', style: TextStyle(color: Colors.white)),
                              backgroundColor: Color.fromARGB(255, 26, 115, 232),
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

                  // Activity Information
                  AppTheme.buildSectionCard(
                    title: 'Activity Information',
                    icon: Icons.category_outlined,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 4),
                          child: Text('Activity Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildActivityGrid(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
