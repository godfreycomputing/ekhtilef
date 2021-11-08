import 'package:flutter/material.dart';

const defaultIcon = 'news';
const defaultIconFontFamily = 'CupertinoIcons';
const defaultId = 'web-12'; //web, post, title

class GeneralSettingItem {
  String id = defaultId;
  String title = '';
  String icon = defaultIcon;
  String iconFontFamily = defaultIconFontFamily;
  int? pageId;
  String? webUrl;
  double? fontSize;
  String? titleColor;
  Offset? verticalPadding;
  bool enableDivider = false;
  bool requiredLogin = false;
  bool webViewMode = false;

  GeneralSettingItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? defaultId;
    title = json['title'] ?? '';
    icon = json['icon'] ?? defaultIcon;
    iconFontFamily = json['iconFontFamily'] ?? defaultIconFontFamily;
    pageId =
        json['pageId'] != null ? int.tryParse(json['pageId'].toString()) : null;
    webUrl = json['webUrl'];
    fontSize = json['fontSize'] != null
        ? double.tryParse(json['fontSize'].toString())
        : null;
    titleColor = json['titleColor'];
    verticalPadding = json['verticalPadding'] != null
        ? Offset(
            double.tryParse((json['verticalPadding']['x']).toString()) ?? 0.0,
            double.tryParse((json['verticalPadding']['y']).toString()) ?? 0.0)
        : null;
    enableDivider = json['enableDivider'] ?? false;
    requiredLogin = json['requiredLogin'] ?? false;
    webViewMode = json['webViewMode'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>.from({
      'id': id,
      'title': title,
      'icon': icon,
      'iconFontFamily': iconFontFamily
    });
    if (pageId != null) json['pageId'] = pageId;
    if (webUrl != null) json['webUrl'] = webUrl;
    if (fontSize != null) json['fontSize'] = fontSize;
    if (titleColor != null) json['titleColor'] = titleColor;
    if (verticalPadding != null) {
      json['verticalPadding'] = {
        'x': verticalPadding?.dx,
        'y': verticalPadding?.dy,
      };
    }
    if (enableDivider) json['enableDivider'] = enableDivider;
    if (webViewMode) json['webViewMode'] = webViewMode;
    if (requiredLogin) json['requiredLogin'] = requiredLogin;
    return json;
  }
}
