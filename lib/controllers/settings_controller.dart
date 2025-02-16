import 'package:get/get.dart';
import 'package:thread_clone_app/route/route_names.dart';
import 'package:thread_clone_app/services/storage_service.dart';
import 'package:thread_clone_app/services/supabase_service.dart';
import 'package:thread_clone_app/utils/storage_keys.dart';

class SettingsController extends GetxController {
  void logout() async {
    // remove user session from local storage ans remote
    StorageService.session.remove(StorageKeys.userSession);
    await SupabaseService.client.auth.signOut();
    Get.offAllNamed(RouteNames.login);
  }
}
