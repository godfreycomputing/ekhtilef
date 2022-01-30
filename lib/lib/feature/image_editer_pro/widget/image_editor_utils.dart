import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/image_editor_step_bloc.dart';

class ImageEditorUtils {
  final BuildContext context;
  final ImageEditorStepBloc imageEditorStepBloc;
  final imagePicker = ImagePicker();
  final path;

  ImageEditorUtils(
      {required this.context,
      required this.imageEditorStepBloc,
      required this.path});
  Future<File> urlToFile(String url) async {
    final responseData = await http.get(Uri.parse(url));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    var byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    var file = await File('${tempDir.path}/img').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Select Image Options"),
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
                                    print(pickedFile.files.first.path);
                                    final _imageFromPicker =
                                        File(pickedFile.files.first.path!);
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
                                } else {
                                  // final pickedFile = await imagePicker.getImage(
                                  //     source: ImageSource.gallery,imageQuality: 100);
                                  await urlToFile(path)
                                      .then((pickedFile) async {
                                    if (pickedFile != null) {
                                      final _imageFromPicker =
                                          File(pickedFile.path);
                                      var decodedImage =
                                          await decodeImageFromList(
                                              _imageFromPicker
                                                  .readAsBytesSync());
                                      // _controller.clear();
                                      imageEditorStepBloc.add(event(
                                        _imageFromPicker,
                                        decodedImage.height,
                                        decodedImage.width,
                                      ));
                                      Navigator.pop(context);
                                    }
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
                                    source: ImageSource.camera,
                                    imageQuality: 100);
                                if (pickedFile != null) {
                                  final _imageFromPicker =
                                      File(pickedFile.path);
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
