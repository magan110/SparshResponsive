import 'package:flutter/material.dart';

class DsrVisitScreen extends StatefulWidget {
  const DsrVisitScreen({Key? key}) : super(key: key);

  @override
  State<DsrVisitScreen> createState() => _DsrVisitScreenState();
}

class _DsrVisitScreenState extends State<DsrVisitScreen> {
  // Form controllers and variables
  String processType = 'A';
  String? documentNo;
  String? purchaserType;
  String? areaCode;
  String? purchaserCode;
  String? kycStatus = 'Verified';
  String? reportDate;
  String? marketName;
  String? displayContest;
  String? pendingIssue;
  String? pendingIssueDetail;
  String? issueDetail;
  String? wcEnrolment;
  String? wcpEnrolment;
  String? vapEnrolment;
  String? wcStock;
  String? wcpStock;
  String? vapStock;
  String? slWcVolume;
  String? slWpVolume;
  String? orderExecutionDate;
  String? remarks;
  String? cityReason;
  String? tileAdhesiveSeller;
  String? tileAdhesiveStock;
  String? name = '';
  String? kycEditUrl;

  // Dynamic lists
  List<Map<String, String>> productList = [];
  List<Map<String, String>> giftList = [];
  List<Map<String, String>> marketSkuList = [];

  // Brands selling checkboxes
  Map<String, bool> brandsWc = {
    'BW': false,
    'JK': false,
    'RK': false,
    'OT': false,
  };
  Map<String, bool> brandsWcp = {
    'BW': false,
    'JK': false,
    'AP': false,
    'BG': false,
    'AC': false,
    'PM': false,
    'OT': false,
  };

  // Averages (mock data)
  Map<String, String> last3MonthsAvg = {
    'JK_WC': '0',
    'JK_WCP': '0',
    'AS_WC': '0',
    'AS_WCP': '0',
    'OT_WC': '0',
    'OT_WCP': '0',
  };
  Map<String, String> currentMonthBW = {
    'WC': '0.00',
    'WCP': '0.00',
    'VAP': '0.00',
  };

  final _formKey = GlobalKey<FormState>();

  // Mock data for dropdowns
  final List<String> documentNoList = ['Doc001', 'Doc002', 'Doc003'];
  final List<String> purchaserTypeList = [
    'Retailer',
    'Rural Retailer',
    'Stockiest',
    'Direct Dealer',
    'Rural Stockiest',
    'AD',
    'UBS',
  ];
  final List<String> areaCodeList = ['Area1', 'Area2', 'Area3'];
  final List<String> pendingIssueDetails = ['Token', 'Scheme', 'Product', 'Other'];
  final List<String> cityReasons = [
    'Network Issue',
    'Battery Low',
    'Mobile Not working',
    'Location not capturing',
    'Wrong Location OF Retailer',
    'Wrong Location Captured',
  ];
  final List<String> tileAdhesiveOptions = ['YES', 'NO'];

  // Mock data for last billing date as per Tally
  final List<Map<String, String>> lastBillingData = [
    {'product': 'White Cement', 'date': '16 Nov 2023', 'qty': '0.65000'},
    {'product': 'Water Proofing Compound', 'date': '22 Jul 2023', 'qty': '0.01500'},
  ];

  // Helper to add product row
  void addProductRow() {
    setState(() {
      productList.add({
        'product': '',
        'sku': '',
        'qty': '',
      });
    });
  }

  void removeProductRow(int index) {
    setState(() {
      productList.removeAt(index);
    });
  }

  // Helper to add gift row
  void addGiftRow() {
    setState(() {
      giftList.add({
        'giftType': '',
        'qty': '',
      });
    });
  }

  void removeGiftRow(int index) {
    setState(() {
      giftList.removeAt(index);
    });
  }

  // Helper to add market SKU row
  void addMarketSkuRow() {
    setState(() {
      marketSkuList.add({
        'brand': '',
        'product': '',
        'priceB': '',
        'priceC': '',
      });
    });
  }

  void removeMarketSkuRow(int index) {
    setState(() {
      marketSkuList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    // Add one row by default for each dynamic list
    if (productList.isEmpty) addProductRow();
    if (giftList.isEmpty) addGiftRow();
    if (marketSkuList.isEmpty) addMarketSkuRow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DSR Visit Entry')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Process Type ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Process Type', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'A',
                              groupValue: processType,
                              onChanged: (v) => setState(() => processType = v!),
                            ),
                            const Text('Add'),
                            Radio<String>(
                              value: 'U',
                              groupValue: processType,
                              onChanged: (v) => setState(() => processType = v!),
                            ),
                            const Text('Update'),
                            Radio<String>(
                              value: 'D',
                              groupValue: processType,
                              onChanged: (v) => setState(() => processType = v!),
                            ),
                            const Text('Delete'),
                          ],
                        ),
                        if (processType != 'A')
                          DropdownButtonFormField<String>(
                            value: documentNo,
                            decoration: const InputDecoration(labelText: 'Document No'),
                            items: documentNoList
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) => setState(() => documentNo = v),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Purchaser/Retailer Type, Area Code, Purchaser Code, Name, KYC ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: purchaserType,
                          decoration: const InputDecoration(labelText: 'Purchaser / Retailer Type *'),
                          items: purchaserTypeList
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => purchaserType = v),
                          validator: (v) => v == null ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: areaCode,
                          decoration: const InputDecoration(labelText: 'Area Code *'),
                          items: areaCodeList
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => areaCode = v),
                          validator: (v) => v == null ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Purchaser Code *',
                            suffixIcon: Icon(Icons.search),
                          ),
                          onChanged: (v) => purchaserCode = v,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        // Name display
                        Row(
                          children: [
                            const Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(name ?? '', style: const TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Edit KYC Button
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement KYC edit navigation
                          },
                          child: const Text('Edit KYC'),
                        ),
                        const SizedBox(height: 8),
                        // KYC Status
                        DropdownButtonFormField<String>(
                          value: kycStatus,
                          decoration: const InputDecoration(labelText: 'KYC Status'),
                          items: ['Verified', 'Not Verified']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: null, // Disabled
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Report Date, Market Name, Display Contest, Pending Issues ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Report Date *',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 3)),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                reportDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                              });
                            }
                          },
                          controller: TextEditingController(text: reportDate),
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Market Name (Location Or Road Name) *'),
                          onChanged: (v) => marketName = v,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 8),
                        // Display Contest
                        const Text('Participation of Display Contest *'),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Y',
                              groupValue: displayContest,
                              onChanged: (v) => setState(() => displayContest = v),
                            ),
                            const Text('Yes'),
                            Radio<String>(
                              value: 'N',
                              groupValue: displayContest,
                              onChanged: (v) => setState(() => displayContest = v),
                            ),
                            const Text('No'),
                            Radio<String>(
                              value: 'NA',
                              groupValue: displayContest,
                              onChanged: (v) => setState(() => displayContest = v),
                            ),
                            const Text('NA'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Pending Issues
                        const Text('Any Pending Issues (Yes/No) *'),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Y',
                              groupValue: pendingIssue,
                              onChanged: (v) => setState(() => pendingIssue = v),
                            ),
                            const Text('Yes'),
                            Radio<String>(
                              value: 'N',
                              groupValue: pendingIssue,
                              onChanged: (v) => setState(() => pendingIssue = v),
                            ),
                            const Text('No'),
                          ],
                        ),
                        if (pendingIssue == 'Y') ...[
                          DropdownButtonFormField<String>(
                            value: pendingIssueDetail,
                            decoration: const InputDecoration(labelText: 'If Yes, pending issue details *'),
                            items: pendingIssueDetails
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) => setState(() => pendingIssueDetail = v),
                            validator: (v) => v == null ? 'Required' : null,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'If Yes, Specify Issue'),
                            onChanged: (v) => issueDetail = v,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Enrolment Slab ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Enrolment Slab (in MT) *'),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'WC'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => wcEnrolment = v,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'WCP'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => wcpEnrolment = v,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'VAP'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => vapEnrolment = v,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- BW Stocks Availability ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BW Stocks Availability (in MT) *'),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'WC'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => wcStock = v,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'WCP'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => wcpStock = v,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'VAP'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => vapStock = v,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Brands Selling ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Brands selling - WC (Industry Volume)'),
                        Wrap(
                          spacing: 8,
                          children: brandsWc.keys.map((brand) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: brandsWc[brand],
                                  onChanged: (v) => setState(() => brandsWc[brand] = v ?? false),
                                ),
                                Text(brand),
                              ],
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'WC Industry Volume in (MT)'),
                          onChanged: (v) => slWcVolume = v,
                        ),
                        const SizedBox(height: 8),
                        const Text('Brands selling - WCP (Industry Volume)'),
                        Wrap(
                          spacing: 8,
                          children: brandsWcp.keys.map((brand) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: brandsWcp[brand],
                                  onChanged: (v) => setState(() => brandsWcp[brand] = v ?? false),
                                ),
                                Text(brand),
                              ],
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'WCP Industry Volume in (MT)'),
                          onChanged: (v) => slWpVolume = v,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Last 3 Months Average ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Last 3 Months Average'),
                        Table(
                          border: TableBorder.all(),
                          children: [
                            const TableRow(children: [
                              SizedBox(),
                              Center(child: Text('WC Qty')),
                              Center(child: Text('WCP Qty')),
                            ]),
                            TableRow(children: [
                              const Center(child: Text('JK')),
                              TextFormField(
                                initialValue: last3MonthsAvg['JK_WC'],
                                decoration: const InputDecoration(),
                                onChanged: (v) => last3MonthsAvg['JK_WC'] = v,
                              ),
                              TextFormField(
                                initialValue: last3MonthsAvg['JK_WCP'],
                                decoration: const InputDecoration(),
                                onChanged: (v) => last3MonthsAvg['JK_WCP'] = v,
                              ),
                            ]),
                            TableRow(children: [
                              const Center(child: Text('Asian')),
                              TextFormField(
                                initialValue: last3MonthsAvg['AS_WC'],
                                decoration: const InputDecoration(),
                                onChanged: (v) => last3MonthsAvg['AS_WC'] = v,
                              ),
                              TextFormField(
                                initialValue: last3MonthsAvg['AS_WCP'],
                                decoration: const InputDecoration(),
                                onChanged: (v) => last3MonthsAvg['AS_WCP'] = v,
                              ),
                            ]),
                            TableRow(children: [
                              const Center(child: Text('Other')),
                              TextFormField(
                                initialValue: last3MonthsAvg['OT_WC'],
                                decoration: const InputDecoration(),
                                onChanged: (v) => last3MonthsAvg['OT_WC'] = v,
                              ),
                              TextFormField(
                                initialValue: last3MonthsAvg['OT_WCP'],
                                decoration: const InputDecoration(),
                                onChanged: (v) => last3MonthsAvg['OT_WCP'] = v,
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Current Month - BW ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Month - BW (in MT)'),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: currentMonthBW['WC'],
                                decoration: const InputDecoration(labelText: 'WC'),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: currentMonthBW['WCP'],
                                decoration: const InputDecoration(labelText: 'WCP'),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: currentMonthBW['VAP'],
                                decoration: const InputDecoration(labelText: 'VAP'),
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Order Booked in call/e meet (Dynamic List) ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Order Booked in call/e meet'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: addProductRow,
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: productList.length,
                          itemBuilder: (context, idx) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Product'),
                                    onChanged: (v) => productList[idx]['product'] = v,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'SKU'),
                                    onChanged: (v) => productList[idx]['sku'] = v,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Qty'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) => productList[idx]['qty'] = v,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => removeProductRow(idx),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Market -- WCP (Highest selling SKU) (Dynamic List) ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Market -- WCP (Highest selling SKU)'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: addMarketSkuRow,
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: marketSkuList.length,
                          itemBuilder: (context, idx) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Brand'),
                                    onChanged: (v) => marketSkuList[idx]['brand'] = v,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Product'),
                                    onChanged: (v) => marketSkuList[idx]['product'] = v,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Price - B'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) => marketSkuList[idx]['priceB'] = v,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Price - C'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) => marketSkuList[idx]['priceC'] = v,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => removeMarketSkuRow(idx),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Gift Distribution (Dynamic List) ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Gift Distribution'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: addGiftRow,
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: giftList.length,
                          itemBuilder: (context, idx) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Gift Type'),
                                    onChanged: (v) => giftList[idx]['giftType'] = v,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Qty'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) => giftList[idx]['qty'] = v,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => removeGiftRow(idx),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Tile Adhesives ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tile Adhesives'),
                        DropdownButtonFormField<String>(
                          value: tileAdhesiveSeller,
                          decoration: const InputDecoration(labelText: 'Is this Tile Adhesives seller?'),
                          items: tileAdhesiveOptions
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => tileAdhesiveSeller = v),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Tile Adhesive Stock'),
                          onChanged: (v) => tileAdhesiveStock = v,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Order Execution Date, Remarks, Reason ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Order Execution date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 30)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() {
                                orderExecutionDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                              });
                            }
                          },
                          controller: TextEditingController(text: orderExecutionDate),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Any other Remarks'),
                          onChanged: (v) => remarks = v,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: cityReason,
                          decoration: const InputDecoration(labelText: 'Select Reason'),
                          items: cityReasons
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => cityReason = v),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Map/Location Placeholder ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Map/Location (to be implemented)'),
                        SizedBox(height: 100, child: Center(child: Text('Map widget placeholder'))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Last Billing date as per Tally ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Last Billing date as per Tally'),
                        const SizedBox(height: 8),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text('Qty.', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ]),
                            ...lastBillingData.map((row) => TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(row['product'] ?? ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(row['date'] ?? ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(row['qty'] ?? ''),
                              ),
                            ])).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // --- Bottom Action Buttons ---
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Add another activity logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add Another Activity (mock)')),
                        );
                      },
                      child: const Text('Add Another Activity'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Handle submit & exit
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Submitted & Exit (mock)')),
                          );
                        }
                      },
                      child: const Text('Submit & Exit'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Show submitted data logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Show Submitted Data (mock)')),
                        );
                      },
                      child: const Text('Click to See Submitted Data'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
