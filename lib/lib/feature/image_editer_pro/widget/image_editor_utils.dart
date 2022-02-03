import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fstore/lib/core/tools/tools.dart';
import 'package:fstore/lib/feature/image_editer_pro/bloc/image_editor_step_bloc.dart';


class ImageEditorUtils{
  final BuildContext context;
  final ImageEditorStepBloc imageEditorStepBloc;
  final imagePicker = ImagePicker();

  ImageEditorUtils({required this.context, required this.imageEditorStepBloc});
  
  void openPhotoBottomSheetsToAddBaseImageOrSticker(ImageEditorStepEvent event(
      File baseImage,
      int height,
      int width
      ), {bool isSticker = false}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return  Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 10.9, color: Colors.grey[400]!)
          ]),
          height: 170,
          child:  Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child:  Text("Select Image Options"),
              ),
              Divider(
                height: 1,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /// from Gallery
                    Container(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.photo_library),
                              onPressed: () async {
                                if (isSticker){
                                  var pickedFile = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowCompression: false,
                                    allowMultiple: false,
                                    allowedExtensions: ['jpg', 'jpeg', 'svg', 'png'],
                                  );
                                  if(pickedFile != null){
                                    print(pickedFile.files.first.path);
                                    final _imageFromPicker = File(pickedFile.files.first.path!);
                                    var decodedImage =
                                    await decodeImageFromList(
                                        _imageFromPicker.readAsBytesSync());
                                    imageEditorStepBloc.add(event(
                                      _imageFromPicker,
                                      decodedImage.height,
                                      decodedImage.width,
                                    ));
                                    Navigator.pop(context);
                                  }
                                }
                                else{
                                  // final pickedFile = await imagePicker.getImage(
                                  //     source: ImageSource.gallery,imageQuality: 100);
                                  await Tools.urlToFile('https://ekhtilaf.com/wp-content/uploads/2021/10/1.png')
                                  .then((pickedFile) async {
                                   // final _imageFromPicker = pickedFile;
                                    var decodedImage =
                                    await decodeImageFromList(
                                        pickedFile.readAsBytesSync());
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
                          Text("Open Gallery")
                        ],
                      ),
                    ),
                    SizedBox(width: 24),
                    /// from Camera
                    Container(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () async {
                                final pickedFile = await imagePicker.getImage(
                                    source: ImageSource.camera,imageQuality: 100);
                                if (pickedFile != null) {
                                  final _imageFromPicker = File(pickedFile.path);
                                  var decodedImage =
                                  await decodeImageFromList(
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
                          SizedBox(width: 10),
                          Text("Open Camera")
                        ],
                      ),
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