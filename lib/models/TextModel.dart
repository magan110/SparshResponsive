import 'package:flutter/material.dart';

Widget _buildText(String str) {
  return MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(1.0)),
    child: Text(
      str,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}


