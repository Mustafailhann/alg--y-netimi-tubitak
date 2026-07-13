import 'dart:io';
import 'package:dio/dio.dart';

void main() async {
  // Read original file
  var filePath = r'C:\Users\mustafa\Pictures\resim.jpg';
  var originalBytes = await File(filePath).readAsBytes();
  
  print('Original (First 16):');
  print(originalBytes.sublist(0, 16).map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' '));

  // Simulate Flutter Web upload pipeline
  var multipartFile = MultipartFile.fromBytes(originalBytes, filename: 'resim.jpg');
  
  // Read back what MultipartFile exposes
  var stream = multipartFile.finalize();
  var builder = BytesBuilder(copy: false);
  await for (var chunk in stream) {
    builder.add(chunk);
  }
  var dioOutputBytes = builder.takeBytes();
  
  print('\nDio Pipeline Output (First 16):');
  print(dioOutputBytes.sublist(0, 16).map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' '));
}
