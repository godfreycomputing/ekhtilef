import 'package:flutter/material.dart';

import '../constants.dart';

class LanguageModel {
  final int? languageId;
  final String? languageName;
  final Locale? locale;

  LanguageModel({this.languageId,this.languageName,this.locale,});

  static List<LanguageModel> getLanguage() {
    return <LanguageModel>[
      LanguageModel(languageId: 0, languageName: "العربية",locale: Locale(LANG_AR)),
      LanguageModel(languageId: 1, languageName: "English",locale: Locale(LANG_EN)),
    ];
  }
}