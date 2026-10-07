import 'package:flutter/material.dart';

class Room {
  const Room({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.deviceCountLabel,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String deviceCountLabel;
}
