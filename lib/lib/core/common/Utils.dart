import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service_locator.dart';

/// This function for move cursor from A to B
/// and will be take 3 parameter
/// [context] to know which screen we are
/// [currentFocus] where are you now ? which text form field
/// [nextFocus] where will be when called this function
fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
/// This for unFocus nodes
unFocusList({@required List<FocusNode>? focus}){
  focus!.forEach((element) {element.unfocus();});
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
