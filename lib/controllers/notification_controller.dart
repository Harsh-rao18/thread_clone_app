import 'package:get/get.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/model/notification_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel?> notifications = RxList<NotificationModel?>();
  var loading = false.obs;

  Future<void> fetchNotifications(String userId) async {
    try {
      loading.value = true;
      final List<dynamic> data =
          await SupabaseService.client.from("notifications").select('''
  id, post_id, notification,created_at , user_id ,user:user_id (email , metadata)
''').eq("to_user_id", userId).order("id", ascending: false);

      loading.value = false;
      if (data.isNotEmpty) {
        notifications.value = [
          for (var item in data) NotificationModel.fromJson(item)
        ];
      }
    } catch (e) {
      showSnackbar('Error', 'Something went wrong');
    }
  }
}
