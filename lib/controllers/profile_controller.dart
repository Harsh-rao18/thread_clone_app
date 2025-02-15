import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thread_clone_app/services/supabase_service.dart';
import 'package:thread_clone_app/utils/env.dart';
import 'package:thread_clone_app/utils/helpers.dart';

class ProfileController extends GetxController {
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);

  // pickImage
  void pickImage() async {
    File? file = await pickImageFromGallary();

    if (file != null) {
      image.value = file;
    }
  }

  // updateProfile
  Future<void> updateProfile(String userId, String description) async {
    try {
      loading.value = true;
      var uploadedpath = '';

      if (image.value != null && image.value!.existsSync()) {
        final String dir = "$userId/profile.jpg";
        var path =
            await SupabaseService.client.storage.from(Env.s3Bucket).upload(
                  dir,
                  image.value!,
                  fileOptions: const FileOptions(upsert: true),
                );

        uploadedpath = path;
      }

      // update profile

      await SupabaseService.client.auth.updateUser(UserAttributes(data: {
        "description": description,
        "image": uploadedpath.isNotEmpty ? uploadedpath : null,
      }));

      loading.value = false;
      Get.back();
      showSnackbar("Success", "profile updated successfully");
    } on StorageException catch (e) {
      loading.value = false;
      return showSnackbar("Error", e.message);
    } on AuthException catch (e) {
      loading.value = false;
      return showSnackbar("Error", e.message);
    } catch (e) {
      loading.value = false;
      showSnackbar("Error", "Something went Wrong , Please try again");
    }
  }
}
