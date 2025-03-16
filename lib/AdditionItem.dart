import 'package:flutter/material.dart';

class AdditionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Icon(color: Colors.white, icon, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
