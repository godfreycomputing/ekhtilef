import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageConverterProvider extends ChangeNotifier {
  late Image _image;
  bool _imageLoading = false;

  ImageConverterProvider();

  Image get convertedImage => _image;
  bool get imageLoading => _imageLoading;

  Future<void> urlToImage(String url) async {
    _imageLoading = true;

    notifyListeners();

    final responseData = await http.get(Uri.parse(url));
    var uint8list = responseData.bodyBytes;
    var image = await decodeImageFromList(uint8list);
    _image = image as Image;
    _imageLoading = false;

    notifyListeners();
  }
}
