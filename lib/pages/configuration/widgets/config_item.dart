import 'package:flutter/material.dart';

class ConfigItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isToggle;
  final bool initialValue;
  final VoidCallback? onTap;


  const ConfigItem({
    required this.label,
    required this.icon,
    this.iconColor = Colors.black54,
    this.isToggle = false,
    this.initialValue = false,
    this.onTap,
  });
}
