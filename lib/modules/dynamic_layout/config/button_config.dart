import 'package:flutter/material.dart';

class ButtonConfig {
  String text = '';
  String backgroundColor = '#3FC1BE';
  String textColor = '#3FC1BE';
  Alignment alignment = Alignment.topCenter;

  ButtonConfig(
      {this.text = '',
      this.backgroundColor = '#3FC1BE',
      this.textColor = '#3FC1BE',
      this.alignment = Alignment.topCenter});

  ButtonConfig.fromJson(Map<String, dynamic> json) {
    text = json['text'] ?? '';
    backgroundColor = json['backgroundColor'] ?? '#3FC1BE';
    textColor = json['textColor'] ?? '#3FC1BE';
    alignment = Alignment(json['x'] ?? 0.0, json['y'] ?? 0.0);
  }
}
