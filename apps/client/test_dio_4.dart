import 'package:dio/dio.dart';
void main() {
  var file = MultipartFile.fromBytes([255, 216]);
  print('mime 1: ' + (file.contentType?.mimeType ?? 'null'));
  var file2 = MultipartFile.fromBytes([255, 216], filename: 'test.jpg');
  print('mime 2: ' + (file2.contentType?.mimeType ?? 'null'));
}
