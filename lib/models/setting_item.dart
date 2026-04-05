
import 'package:flutter/material.dart';

class SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isToggle;
  final bool? value;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isToggle = false,
    this.value,
    this.onToggle,
    this.onTap,
  });
}