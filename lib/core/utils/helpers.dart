import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:thread_clone_app/core/utils/env.dart';
import 'package:thread_clone_app/core/widgets/confirm_dialog.dart';
import 'package:uuid/uuid.dart';

// snackBar
void showSnackbar(String title, String message) {
  Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      snackStyle: SnackStyle.GROUNDED,
      margin: EdgeInsets.all(0),
      backgroundColor: const Color(0xff252526));
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
Future<File> compressImage(File file, String targetPath) async {
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

// Confirm dialog

void confirmDialog(String title, String text , VoidCallback callback) {
  Get.dialog(ConfirmDialog(title: title, text: text, callback: callback,));
}

// format date
String formateDateFromNow(String date) {
  // Parse UTC timestamp string to DateTime
  DateTime utcDateTime = DateTime.parse(date.split('+')[0].trim());

  // Convert UTC to IST (UTC+5:30 for Indian Standard Time)
  DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));

  // Format the DateTime using Jiffy
  return Jiffy.parseFromDateTime(istDateTime).fromNow();
}
