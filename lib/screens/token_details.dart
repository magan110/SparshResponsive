import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/token_database.dart';
import 'token_summary.dart';

class TokenDetailsPage extends StatefulWidget {
  final String activeTab;
  final List<String>? tokens;

  const TokenDetailsPage({super.key, this.activeTab = 'Details', this.tokens});

  @override
  State<TokenDetailsPage> createState() => _TokenDetailsPageState();
}

class _TokenDetailsPageState extends State<TokenDetailsPage> {
  late Future<List<Map<String, dynamic>>> tokenDataFuture;
  late List<String> tokens;
  final TokenDatabase _tokenDatabase = TokenDatabase();

  @override
  void initState() {
    super.initState();
    // Initialize tokenDataFuture with an empty list to avoid LateInitializationError
    tokenDataFuture = Future.value([]);
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    try {
      if (widget.tokens != null && widget.tokens!.isNotEmpty) {
        // If tokens are provided via constructor, use them
        tokens = widget.tokens!;
      } else {
        // Otherwise load from database
        tokens = await _tokenDatabase.getAllTokens();
      }

      // If still empty (no tokens in database), show empty state
      if (tokens.isEmpty) {
        tokens = [];
      }

      setState(() {
        tokenDataFuture = fetchTokenData();
      });
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tokens: $e'), backgroundColor: Colors.red),
        );
      }
      tokens = [];
      setState(() {
        tokenDataFuture = Future.value([]);
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchTokenData() async {
    final url = Uri.parse('https://qa.birlawhite.com:55232/api/tokenProc/execute');
    List<Map<String, dynamic>> tokenResults = [];

    for (String token in tokens) {
      try {
        // Using the correct format based on Postman examples with additional headers
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode({'Param1': token}),
        );

        // Parse the response
        Map<String, dynamic> data = {};
        bool isValid = false;

        if (response.statusCode == 200) {
          try {
            if (response.body.startsWith('{') && response.body.endsWith('}')) {
              data = jsonDecode(response.body);

              // Check if isActive parameter is present and is "Y"
              if (data.containsKey('isActive')) {
                // Check if isActive is "Y" (active)
                String isActiveStr = data['isActive'].toString();
                isValid = isActiveStr == 'Y' || isActiveStr == 'y';
              } else {
                // If isActive is not present, fall back to checking for success message
                isValid = response.body.toLowerCase().contains("success");
              }
            } else {
              // If not a JSON object, check if it contains "success"
              isValid = response.body.toLowerCase().contains("success");
            }
          } catch (e) {
            // Log error
            debugPrint('Error parsing token validity response: $e');
            // Fall back to checking for success message
            isValid = response.body.toLowerCase().contains("success");
          }
        }

        tokenResults.add({
          'token': token,
          'isValid': isValid,
          'tokenIdn': isValid ? (data['tokenIdn']?.toString() ?? '') : '',
          'isActive': isValid ? (data['isActive']?.toString() ?? '') : '',
          'ValidDate': isValid ? (data['ValidDate']?.toString() ?? '') : '',
          'scanby': isValid ? (data['scanby']?.toString() ?? '') : '',
          'paramAd1': isValid ? (data['paramAd1']?.toString() ?? '') : '',
          'paramAd2': isValid ? (data['paramAd2']?.toString() ?? '') : '',
          'paramAd3': isValid ? (data['paramAd3']?.toString() ?? '') : '',
          'paramAd4': isValid ? (data['paramAd4']?.toString() ?? '') : '',
          'isActive2': isValid ? (data['isActive2']?.toString() ?? '') : '',
          'ScanCount': isValid ? (data['ScanCount']?.toString() ?? '') : '',
          'ScanAllow': isValid ? (data['ScanAllow']?.toString() ?? '') : '',
          'updateId': isValid ? (data['updateId']?.toString() ?? '') : '',
          'updateId2': isValid ? (data['updateId2']?.toString() ?? '') : '',
          'paramAd5': isValid ? (data['paramAd5']?.toString() ?? '') : '',
          'TokenType': isValid ? (data['TokenType']?.toString() ?? '') : '',
          'exprFlag': isValid ? (data['exprFlag']?.toString() ?? '') : '',
          'numCvvNo': isValid ? (data['numCvvNo']?.toString() ?? '') : '',
        });
      } catch (e) {
        // Log error
        debugPrint('Error fetching token data: $e');
        tokenResults.add({'token': token, 'isValid': false});
      }
    }
    return tokenResults;
  }

  void _navigateToTab(String tab) {
    if (tab == 'Details') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TokenDetailsPage(activeTab: 'Details', tokens: tokens)),
      );
    } else if (tab == 'Summary') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TokenSummaryScreen(activeTab: 'Summary', tokens: tokens)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildTopNav(context, widget.activeTab),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: tokenDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error fetching tokens: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No token data found."));
                }
                final tokens = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: tokens.length,
                  itemBuilder: (context, index) {
                    final token = tokens[index];
                    return _buildTokenCard(token);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(BuildContext context, String activeTab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, 'Details', activeTab == 'Details', () => _navigateToTab('Details')),
            _navItem(context, 'Summary', activeTab == 'Summary', () => _navigateToTab('Summary')),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          onTap();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color.fromRGBO(0, 112, 183, 1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTokenCard(Map<String, dynamic> tokenData) {
    final isValid = tokenData['isValid'] == true;
    return Dismissible(
      key: Key(tokenData['token'] ?? DateTime.now().toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Delete Token'),
                content: Text(
                  'Are you sure you want to delete this token?\n\n${tokenData['token']}',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('DELETE'),
                  ),
                ],
              ),
        );
      },
      onDismissed: (direction) async {
        try {
          // Delete token from database
          if (tokenData['token'] != null) {
            await _tokenDatabase.deleteToken(tokenData['token']);

            // Show success message
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Token deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );

            // Reload tokens
            _loadTokens();
          }
        } catch (e) {
          // Show error message
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting token: $e'), backgroundColor: Colors.red),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: isValid ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tokenData['token'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(Icons.swipe_left, color: Colors.white, size: 16),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: isValid ? _buildValidDetails(tokenData) : _buildErrorCard(tokenData['token']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidDetails(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Token ID and Type
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (data['tokenIdn'] != null && data['tokenIdn'] != '')
              Text(
                'ID: ${data['tokenIdn']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (data['TokenType'] != null && data['TokenType'] != '')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Type: ${data['TokenType']}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Validity information
        if (data['ValidDate'] != null && data['ValidDate'] != '')
          Text(
            'Valid Upto: ${data['ValidDate']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        if (data['exprFlag'] != null && data['exprFlag'] != '')
          Text(
            'Expired: ${data['exprFlag']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: data['exprFlag'] == 'Y' ? Colors.red : Colors.green,
            ),
          ),
        const SizedBox(height: 8),

        // Payment information
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['paramAd1'] != null && data['paramAd1'] != '')
                    Text(
                      'Value: ₹${data['paramAd1']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  if (data['paramAd2'] != null && data['paramAd2'] != '')
                    Text(
                      'Handling: ₹${data['paramAd2']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['paramAd3'] != null && data['paramAd3'] != '')
                    Text(
                      'Tax: ₹${data['paramAd3']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  if (data['paramAd4'] != null && data['paramAd4'] != '')
                    Text(
                      'Total: ₹${data['paramAd4']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Scan information
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['ScanCount'] != null)
                  Text('Scan Count: ${data['ScanCount']}', style: const TextStyle(fontSize: 14)),
                if (data['ScanAllow'] != null)
                  Text('Scan Allowed: ${data['ScanAllow']}', style: const TextStyle(fontSize: 14)),
              ],
            ),
            if (data['updateId'] != null && data['updateId'] != '')
              Text(
                'Update ID: ${data['updateId']}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // PIN section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (data['paramAd5'] != null && data['paramAd5'] != '')
              Text('Param5: ${data['paramAd5']}', style: const TextStyle(fontSize: 14)),
            Row(
              children: [
                if (data['numCvvNo'] != null && data['numCvvNo'] != '') ...[
                  const Text('PIN', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 5),
                  Container(
                    width: 50,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      data['numCvvNo'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Status indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('Accepted', style: TextStyle(color: Colors.white)),
            ),
            if (data['isActive'] != null && data['isActive'] == 'Y')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Active', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorCard(String token) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Error - $token',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const Text(
          'Please check with IT or Company Officer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
          child: const Text('Rejected', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
