import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/tools/tools.dart';
import '../bloc/image_editor_step_bloc.dart';
import '../screen/image_editor_pro.dart';


class ImageEditorFirstStepInitialAddImageWidget extends StatefulWidget {
  final ImageEditorStepBloc imageEditorStepBloc;
  final String path;

  const ImageEditorFirstStepInitialAddImageWidget(
      {Key? key, required this.imageEditorStepBloc,required  this.path})
      : super(key: key);
  @override
  _ImageEditorFirstStepInitialAddImageWidgetState createState() =>
      _ImageEditorFirstStepInitialAddImageWidgetState();
}

class _ImageEditorFirstStepInitialAddImageWidgetState
    extends State<ImageEditorFirstStepInitialAddImageWidget> {
  //late ImageEditorUtils utils;

  late final ImageEditorStepBloc imageEditorStepBloc;

  void chargeImage(ImageEditorStepEvent Function(
      File baseImage,
      int height,
      int width
      ) event, ImageEditorStepBloc imageEditorStepBloc, String s) async {
        if(s != ''){
      print('STARTED $s');
      await Tools.urlToFile(s)
          .then((pickedFile) async {
        var decodedImage =
            await decodeImageFromList(pickedFile.readAsBytesSync());
        imageEditorStepBloc.add(event(
          pickedFile,
          decodedImage.height,
          decodedImage.width,
        ));
        await Navigator.of(context).push(CupertinoPageRoute<void>(
          builder: (BuildContext context) =>  TShirtEditor(path: s)
          ),
        );
        print('DONEEE');
      });}
    }
  @override
  void initState() {
        chargeImage((image, height, width) =>
                AddImageEvent(
                  baseImage: image,
                  height: height,
                  width: width,
                ), widget.imageEditorStepBloc, widget.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(
      child: CircularProgressIndicator(),
    ));
    
  }
}
