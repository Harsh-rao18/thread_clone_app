import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thread_clone_app/model/post_model.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/model/user_model.dart';

class HomeController extends GetxController {
  var loading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();

  @override
  void onInit() async {
    await fetchThreads();
    listenPostChange();
    super.onInit();
  }

  Future<void> fetchThreads() async {
    loading.value = true;

    final List<dynamic> response =
        await SupabaseService.client.from('posts').select('''
    id,content,image,created_at,comment_count,like_count,user_id,
    user:user_id(email,metadata) , likes:likes(user_id,post_id)

''').order("id", ascending: false);
    loading.value = false;
    if (response.isNotEmpty) {
      posts.value = [for (var item in response) PostModel.fromJson(item)];
    }
  }

  // listen realtime thread changes
  void listenPostChange() {
    SupabaseService.client
        .channel('public:posts')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'posts',
          callback: (payload) {
            final PostModel post = PostModel.fromJson(payload.newRecord);
            updateFeed(post);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'posts',
          callback: (payload) {
            posts.removeWhere(
                (element) => element.id == payload.oldRecord["id"]);
          },
        )
        .subscribe();
  }

  // update the feed
  void updateFeed(PostModel post) async {
    var user = await SupabaseService.client
        .from("users")
        .select("*")
        .eq("id", post.userId!)
        .single();

    // * Fetch likes
    post.likes = [];
    post.user = UserModel.fromJson(user);
    posts.insert(0, post);
  }
}
