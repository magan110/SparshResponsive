import 'package:flutter/material.dart';

Widget buildText(BuildContext context, String str) {
  return MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Text(
      str,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}
