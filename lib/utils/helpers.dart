import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thread_clone_app/utils/env.dart';
import 'package:uuid/uuid.dart';

// snackBar
void showSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
    snackStyle: SnackStyle.GROUNDED,
    margin: EdgeInsets.all(0),
    backgroundColor: const Color(0xff252526)
  );
}

// pick image
Future<File?> pickImageFromGallary() async {

  // to give a specific id to the image
  const uuid = Uuid();

  // image picker
  final ImagePicker picker = ImagePicker();

  // pick image from gallery
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  // return image
  if (image == null) return null;

  // return image file
  final dir = Directory.systemTemp;
  final targetPath = "${dir.absolute.path}/${uuid.v6()}.jpg";

  // compress image
  File file = await compressImage(File(image.path), targetPath);

  return file;

}

// compress image file
Future<File> compressImage(File file, String targetPath ) async {
  
  // compress image
  var compressedFile = await FlutterImageCompress.compressAndGetFile(
    file.path,
    targetPath,
    quality: 70,
  );

  // return compressed image
  return File(compressedFile!.path);
}

// to get s3 url
String getS3Url(String path) {
  return "${Env.supabaseUrl}/storage/v1/object/public/$path";
}