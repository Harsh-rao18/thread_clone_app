import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/core/utils/env.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/model/comment_model.dart';
import 'package:thread_clone_app/model/post_model.dart';

class ProfileController extends GetxController {
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);
  var postLoading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  var replyLoading = false.obs;
  RxList<CommentModel?> comments = RxList<CommentModel?>();

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

  Future<void> fetchPosts(String userId) async {
  try {
    postLoading.value = true;
    print("Fetching posts for user: $userId"); // Debug log

    final List<dynamic> data = await SupabaseService.client.from('posts')
    .select('id, content, image, created_at, comment_count, like_count, user_id, users(email, metadata)').eq("user_id", userId).order("id", ascending: false);

    print("Fetched data: $data"); // Debug log

    posts.value = data.map((item) => PostModel.fromJson(item)).toList();
  } catch (e) {
    print("Error fetching posts: $e"); // Debug log
    showSnackbar("Error", "Something went wrong while fetching posts");
  } finally {
    postLoading.value = false;
  }
}


  // * Fetch user replies
  Future<void> fetchComments(String userId) async {
    try {
      replyLoading.value = true;
      final List<dynamic> data =
          await SupabaseService.client.from("comments").select('''
        id , user_id , post_id ,reply ,created_at ,user:user_id (email , metadata)
''').eq("user_id", userId).order("id", ascending: false);
      replyLoading.value = false;
      comments.value = [for (var item in data) CommentModel.fromJson(item)];
    } catch (e) {
      showSnackbar("Error", "something wnt wrong");
    }
  }
}
