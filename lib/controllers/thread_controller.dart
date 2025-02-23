import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thread_clone_app/core/services/navigation_service.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/core/utils/env.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/model/comment_model.dart';
import 'package:thread_clone_app/model/post_model.dart';
import 'package:uuid/uuid.dart';

class ThreadController extends GetxController {
  final textEditingController = TextEditingController(text: '');
  Rx<File?> image = Rx<File?>(null);

  var content = "".obs;
  var loading = false.obs;

  var showThreadloading = false.obs;
  Rx<PostModel> post = Rx<PostModel>(PostModel());

  var showReplyloading = false.obs;
  RxList<CommentModel> replies = RxList<CommentModel>();

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
    } catch (e) {
      loading.value = false;
      showSnackbar("Error", "Something went wrong");
    }
  }

  void show(int postId) async {
    try {
      post.value = PostModel();
      replies.value = [];
      showThreadloading.value = true;
      final response = await SupabaseService.client.from("posts").select('''
    id,content,image,created_at,comment_count,like_count,user_id,
    user:user_id(email,metadata)

''').eq("id", postId).single();
      showThreadloading.value = false;
      post.value = PostModel.fromJson(response);

      // Fetch replies
      fetchPostreplies(postId);
    } catch (e) {
      showThreadloading.value = false;
      showSnackbar("Error", "Something went wrong");
    }
  }

  void fetchPostreplies(int postId) async {
    try {
      showReplyloading.value = true;
      final List<dynamic> data =
          await SupabaseService.client.from("comments").select('''
        id , user_id , post_id ,reply ,created_at ,user:user_id (email , metadata)
''').eq("post_id", postId);
      showReplyloading.value = false;

      if (data.isNotEmpty) {
        replies.value = [for (var item in data) CommentModel.fromJson(item)];
      }
    } catch (e) {
      showReplyloading.value = false;
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
