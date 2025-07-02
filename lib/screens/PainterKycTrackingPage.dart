// File: lib/report_filter_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A fully responsive screen that matches the provided screenshot:
/// - Blue gradient background
/// - White, rounded “filter card” at top
/// - Searchable Report Type dropdown
/// - Start Date / End Date fields with date pickers
/// - “Go” button (blue)
/// - “As on DD/MM/YYYY at HH:MM:SS” timestamp on the right
class PainterKycTrackingPage extends StatefulWidget {
  const PainterKycTrackingPage({super.key});

  @override
  State<PainterKycTrackingPage> createState() => _PainterKycTrackingPageState();
}

class _PainterKycTrackingPageState extends State<PainterKycTrackingPage> {
  // List of report types shown in your screenshot
  final List<String> _reportTypes = [
    'Zone Wise',
    'Logical State Wise',
    'Area Wise',
    'Employee Wise',
    'Incentive Employee Wise',
    'Incentive Employee Wise Dashboard',
    'Incentive Zonal Casc',
    'Incentive Area Casc',
    // Add more items here if needed
  ];

  // Currently selected report type
  String? _selectedReportType;

  // Controllers to hold the date strings (dd/MM/yyyy)
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // DateFormat for “dd/MM/yyyy”
  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    // Default selected type → “Incentive Employee Wise Dashboard” if it exists
    if (_reportTypes.contains('Incentive Employee Wise Dashboard')) {
      _selectedReportType = 'Incentive Employee Wise Dashboard';
    } else {
      _selectedReportType = _reportTypes.first;
    }

    // Default Start Date → (today – 7 days), End Date → today
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
    _startDateController.text = _dateFormatter.format(sevenDaysAgo);
    _endDateController.text = _dateFormatter.format(now);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Opens a DatePicker and updates the given controller
  Future<void> _pickDate(
      BuildContext context,
      TextEditingController controller,
      ) async {
    DateTime initialDate;
    try {
      initialDate = _dateFormatter.parse(controller.text);
    } catch (_) {
      initialDate = DateTime.now();
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = _dateFormatter.format(picked);
      });
    }
  }

  /// Returns “As on DD/MM/YYYY at HH:MM:SS” for the current moment
  String _formattedTimestamp() {
    DateTime now = DateTime.now();
    String datePart = _dateFormatter.format(now);
    String timePart = DateFormat('HH:mm:ss').format(now);
    return 'As on $datePart at $timePart';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We don’t use an AppBar here because the screenshot didn’t show one—
      // the card floats on a gradient background.
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // If width < 600, stack fields vertically.
                bool isMobile = constraints.maxWidth < 600;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The white rounded “filter card”
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.98),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: isMobile
                          ? _buildMobileLayout()
                          : _buildTabletDesktopLayout(),
                    ),

                    // The rest of the page (just a placeholder in this example)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Your content goes here',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: isMobile ? 16 : 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// On a narrow screen, stack all fields vertically (full width).
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1) Report Type (searchable dropdown)
        _buildReportTypeDropdown(),
        const SizedBox(height: 12),

        // 2) Start Date
        _buildDateField(
          label: 'Start Date',
          controller: _startDateController,
        ),
        const SizedBox(height: 12),

        // 3) End Date
        _buildDateField(
          label: 'End Date',
          controller: _endDateController,
        ),
        const SizedBox(height: 12),

        // 4) Go button (full-width)
        ElevatedButton(
          onPressed: () {
            // TODO: wire up your “Go” logic
            final sel = _selectedReportType ?? '(none)';
            final sd = _startDateController.text;
            final ed = _endDateController.text;
            debugPrint('Go pressed → report: $sel, start: $sd, end: $ed');
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Go',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),

        // 5) Timestamp (aligned right)
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            _formattedTimestamp(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  /// On a wider screen, lay out in a single row with spacing.
  Widget _buildTabletDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1) Report Type (takes 2 flex units)
        Expanded(flex: 2, child: _buildReportTypeDropdown()),
        const SizedBox(width: 12),

        // 2) Start Date (1 flex)
        Expanded(
          flex: 1,
          child: _buildDateField(
            label: 'Start Date',
            controller: _startDateController,
          ),
        ),
        const SizedBox(width: 12),

        // 3) End Date (1 flex)
        Expanded(
          flex: 1,
          child: _buildDateField(
            label: 'End Date',
            controller: _endDateController,
          ),
        ),
        const SizedBox(width: 12),

        // 4) Go button (fixed width)
        SizedBox(
          width: 80,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              final sel = _selectedReportType ?? '(none)';
              final sd = _startDateController.text;
              final ed = _endDateController.text;
              debugPrint('Go pressed → report: $sel, start: $sd, end: $ed');
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Go',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 5) Timestamp (takes 2 flex units)
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              _formattedTimestamp(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// A searchable “Report Type” dropdown using dropdown_search package.
  Widget _buildReportTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Report Type',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedReportType,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          items: _reportTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedReportType = value;
            });
          },
        ),
      ],
    );
  }

  /// A date field that opens a date picker when tapped.
  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _pickDate(context, controller),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
