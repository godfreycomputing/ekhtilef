
// this class for restart app from main
// wrap whole app into a statefulwidget. And when we want to restart app,
// rebuild that statefulwidget with a child that possess a different Key.
//
//This would make you loose the whole state of your app
// you can reset your app from anywhere using RestartWidget.restartApp(context)
import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({required this.child});

  // ignore: always_declare_return_types
  static restartApp(BuildContext context) {
    
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
