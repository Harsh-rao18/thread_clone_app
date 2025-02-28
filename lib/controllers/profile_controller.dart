import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/core/utils/env.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/model/comment_model.dart';
import 'package:thread_clone_app/model/post_model.dart';
import 'package:thread_clone_app/model/user_model.dart';

class ProfileController extends GetxController {
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);
  var postLoading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  var replyLoading = false.obs;
  RxList<CommentModel?> comments = RxList<CommentModel?>();

  var userLoading = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);

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

  // get user
    Future<void> getUser(String userId) async {
    userLoading.value = true;
    var data = await SupabaseService.client
        .from("users")
        .select("*")
        .eq("id", userId)
        .single();
    userLoading.value = false;
    user.value = UserModel.fromJson(data);

    // * Fetch posts and comments
    fetchPosts(userId);
    fetchComments(userId);
  }

   // * Delete thread
  Future<void> deleteThread(int postId) async {
    try {
      await SupabaseService.client.from("posts").delete().eq("id", postId);

      posts.removeWhere((element) => element.id == postId);
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      showSnackbar("Success", "thread deleted successfully!");
    } catch (e) {
      showSnackbar("Error", "Something went wrong.pls try again.");
    }
  }

  // * Delete comments
  Future<void> deleteReply(int replyId) async {
    try {
      await SupabaseService.client.from("comments").delete().eq("id", replyId);

      comments.removeWhere((element) => element?.id == replyId);
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      showSnackbar("Success", "Reply deleted successfully!");
    } catch (e) {
      showSnackbar("Error", "Something went wrong.pls try again.");
    }
  }

}
