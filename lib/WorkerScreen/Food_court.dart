import 'package:flutter/material.dart';

class FoodCourt extends StatefulWidget {
  const FoodCourt({super.key});

  @override
  State<FoodCourt> createState() => _FoodCourtState();
}

class _FoodCourtState extends State<FoodCourt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Court'),
      ),
      body: const Column(
        children: [

        ],
      ),
    );
  }
}
