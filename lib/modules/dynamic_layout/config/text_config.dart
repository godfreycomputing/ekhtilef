import 'package:flutter/material.dart';

class TextConfig {
  String text = '';
  String fontFamily = 'Roboto';
  double fontSize = 20.0;
  String color = '#3FC1BE';
  bool enableShadow = false;

  Alignment alignment = Alignment.topCenter;
  TextConfig({
    this.text = '',
    this.fontFamily = 'Roboto',
    this.fontSize = 20.0,
    this.color = '#3FC1BE',
    this.alignment = Alignment.topCenter,
    this.enableShadow = false,
  });

  TextConfig.fromJson(Map<String, dynamic> json) {
    text = json['text'] ?? '';
    fontFamily = json['fontFamily'] ?? 'Roboto';
    fontSize = json['fontSize'] ?? 20.0;
    color = json['color'] ?? '#3FC1BE';
    alignment = Alignment(json['x'] ?? 0.0, json['y'] ?? 0.0);
    enableShadow = json['enableShadow'] ?? false;
  }
}
