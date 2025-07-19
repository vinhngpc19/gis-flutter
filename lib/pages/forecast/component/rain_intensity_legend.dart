import 'package:flutter/material.dart';
import 'package:gis_disaster_flutter/base/base_widget.dart';

class RainIntensityLegend extends BaseWidget {
  RainIntensityLegend({super.key});

  @override
  Widget builder() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gradient bar
          Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF87CEEB), // Light blue
                  Color(0xFF4682B4), // Steel blue
                  Color(0xFF0000FF), // Blue
                  Color(0xFFFFFF00), // Yellow
                  Color(0xFFFFA500), // Orange
                  Color(0xFFFF0000), // Red
                  Color(0xFF8B008B), // Purple
                ],
                stops: [0.0, 0.16, 0.32, 0.48, 0.64, 0.8, 1.0],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Intensity labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1', style: textStyle.regular(size: 12)),
              Text('5', style: textStyle.regular(size: 12)),
              Text('10', style: textStyle.regular(size: 12)),
              Text('20', style: textStyle.regular(size: 12)),
              Text('30', style: textStyle.regular(size: 12)),
              Text('50', style: textStyle.regular(size: 12)),
              Text('80', style: textStyle.regular(size: 12)),
            ],
          ),
          const SizedBox(height: 2),
          // Unit label
          Align(
            alignment: Alignment.centerRight,
            child: Text('(mm/h)',
                style: textStyle.regular(size: 10, color: color.greyTextColor)),
          ),
        ],
      ),
    );
  }
}
