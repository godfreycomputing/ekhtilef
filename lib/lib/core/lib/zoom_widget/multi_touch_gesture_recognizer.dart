import 'package:flutter/gestures.dart';

class MultiTouchGestureRecognizer extends MultiTapGestureRecognizer {
  late MultiTouchGestureRecognizerCallback onMultiTap;
  late SingleTouchGestureRecognizerCallback onSingleTap;
  late Offset firstPoint;
  var numberOfTouches = 0;

  MultiTouchGestureRecognizer() {
    super.onTapDown = addTouch;
    super.onTapUp = removeTouch;
    super.onTapCancel = cancelTouch;
    super.onTap = captureDefaultTap;
    
  }

  void addTouch(int pointer, TapDownDetails details) {
    numberOfTouches++; 
    if(numberOfTouches==1){
      firstPoint=details.localPosition;
      onSingleTap(details.localPosition);
    }

    if(numberOfTouches==2){
      onMultiTap(firstPoint,details.localPosition);
    }
  }

  void removeTouch(int pointer, TapUpDetails details) {

    numberOfTouches = 0;
  }

  void cancelTouch(int pointer) {
    numberOfTouches = 0;
  }

  void captureDefaultTap(int pointer) {}
  
  @override
  set onTapDown(_onTapDown) {}

  @override
  set onTapUp(_onTapUp) {}

  @override
  set onTapCancel(_onTapCancel) {}

  @override
  set onTap(_onTap) {}
}

typedef MultiTouchGestureRecognizerCallback = void Function(Offset firstPoint, Offset secondPoint);
typedef SingleTouchGestureRecognizerCallback = void Function(Offset point);