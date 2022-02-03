import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Tools{
  static Future<File> urlToFile(String url) async {
    final fname = url.split('/').last;
    print(fname);
    final responseData = await http.get(Uri.parse(url));
    var uint8list = responseData.bodyBytes;
    final buffer = uint8list.buffer;
    var byteData = ByteData.view(buffer);  
    var tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$fname').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
}