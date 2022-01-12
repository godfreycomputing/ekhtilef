import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fstore/common/tools/tools.dart';
import 'package:fstore/lib/feature/image_editer_pro/bloc/image_editor_step_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fstore/lib/feature/image_editer_pro/bloc/image_editor_step_bloc.dart';
import 'package:inspireui/utils/logs.dart';

class ImageEditorUtils {
  final path;
  final BuildContext context;
  final ImageEditorStepBloc imageEditorStepBloc;
  final imagePicker = ImagePicker();

  ImageEditorUtils(
      {required this.context,
      required this.imageEditorStepBloc,
      required this.path});
  void openPhotoBottomSheetsToAddBaseImageOrSticker(
      ImageEditorStepEvent Function(File baseImage, int height, int width)
          event,
      {bool isSticker = false}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 10.9, color: Colors.grey[400]!)
          ]),
          height: 170,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Select Image Options'),
              ),
              const Divider(
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /// from Gallery
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.photo_library),
                            onPressed: () async {
                              if (isSticker) {
                                var pickedFile =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowCompression: false,
                                  allowMultiple: false,
                                  allowedExtensions: [
                                    'jpg',
                                    'jpeg',
                                    'svg',
                                    'png'
                                  ],
                                );
                                if (pickedFile != null) {
                                  final _imageFromPicker =
                                      File(pickedFile.files.first.path);
                                  var decodedImage = await decodeImageFromList(
                                      _imageFromPicker.readAsBytesSync());
                                  imageEditorStepBloc.add(event(
                                    _imageFromPicker,
                                    decodedImage.height,
                                    decodedImage.width,
                                  ));
                                  Navigator.pop(context);
                                }
                              } else {
                                await Tools.urlToFile(path)
                                    .then((pickedFile) async {
                                 
                                    //printLog('$pickedFile');
                                    //await imagePicker.getImage(source: ImageSource.values,imageQuality: 100);
                                    
                                      var decodedImage =
                                          await decodeImageFromList(
                                              pickedFile!.readAsBytesSync());
                                      // _controller.clear();
                                      imageEditorStepBloc.add(event(
                                        pickedFile,
                                        decodedImage.height,
                                        decodedImage.width,
                                      ));
                                      Navigator.pop(context);
                                    
                                  
                                });
                              }
                            }),
                        const SizedBox(width: 10),
                        const Text('Open Gallery')
                      ],
                    ),
                    const SizedBox(width: 24),

                    /// from Camera
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              final pickedFile = await imagePicker.getImage(
                                  source: ImageSource.camera,
                                  imageQuality: 100);
                              if (pickedFile != null) {
                                final _imageFromPicker = File(pickedFile.path);
                                var decodedImage = await decodeImageFromList(
                                    _imageFromPicker.readAsBytesSync());
                                // _controller.clear();
                                imageEditorStepBloc.add(event(
                                  _imageFromPicker,
                                  decodedImage.height,
                                  decodedImage.width,
                                ));
                                Navigator.pop(context);
                              }
                            }),
                        const SizedBox(width: 10),
                        const Text("Open Camera")
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
