import 'package:dio/dio.dart'; void main() { var file = MultipartFile.fromBytes([255, 216], filename: 'test.jpg'); print(file.contentType); }
