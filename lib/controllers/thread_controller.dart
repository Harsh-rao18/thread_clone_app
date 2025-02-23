import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thread_clone_app/core/services/navigation_service.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/core/utils/env.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:uuid/uuid.dart';

class ThreadController extends GetxController {
  final textEditingController = TextEditingController(text: '');
  Rx<File?> image = Rx<File?>(null);

  var content = "".obs;
  var loading = false.obs;

  void pickImage() async {
    File? file = await pickImageFromGallary();
    if (file != null) {
      image.value = file;
    }
  }

  void store(String userId) async {
    try {
      loading.value = true;
      const uuid = Uuid();
      final dir = "$userId/${uuid.v6()}";
      var imgPath = '';

      if (image.value != null && image.value!.existsSync()) {
        imgPath = await SupabaseService.client.storage
            .from(Env.s3Bucket)
            .upload(dir, image.value!);
      }

      // Add post in DB
      await SupabaseService.client.from("posts").insert({
        "content": content.value,
        "user_id": userId,
        "image": imgPath.isNotEmpty ? imgPath : null,
      });

      loading.value = false;
      reset();
      Get.find<NavigationService>().currentIndex.value = 0;
      showSnackbar("Success", "Thread added successfully!");
    } on StorageException catch (e) {
      loading.value = false;
      showSnackbar("Error", e.message);
    } catch(e){
      loading.value = false;
      showSnackbar("Error", "Something went wrong");
    }
  }

  // to reset thread state
  void reset() {
    textEditingController.clear();
    image.value = null;
    content.value = '';
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}
