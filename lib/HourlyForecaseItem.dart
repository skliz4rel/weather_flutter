import 'package:flutter/material.dart';

class HourlyForecaseItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const HourlyForecaseItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                temperature,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
