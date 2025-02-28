import 'package:get/get.dart';
import 'package:thread_clone_app/model/post_model.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';

class HomeController extends GetxController {
  var loading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();

  @override
  void onInit() async {
    await fetchThreads();
    super.onInit();
  }

  Future<void> fetchThreads() async {
    loading.value = true;

    final List<dynamic> response = await SupabaseService.client.from('posts').select('''
    id,content,image,created_at,comment_count,like_count,user_id,
    user:user_id(email,metadata) , likes:likes(user_id,post_id)

''').order("id", ascending: false);
    loading.value = false;
    if (response.isNotEmpty) {
      posts.value = [for (var item in response) PostModel.fromJson(item)];
      
    }
  }
}
