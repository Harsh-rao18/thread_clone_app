import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thread_clone_app/route/route_names.dart';
import 'package:thread_clone_app/services/storage_service.dart';
import 'package:thread_clone_app/services/supabase_service.dart';
import 'package:thread_clone_app/utils/helpers.dart';
import 'package:thread_clone_app/utils/storage_keys.dart';

class AuthController extends GetxController {
  var registerLoading = false.obs;
  var loginLoading = false.obs;
  // register a user
  Future<void> register(String name, String email, String password) async {
    try {
      registerLoading.value = true;
      final AuthResponse data = await SupabaseService.client.auth
          .signUp(email: email, password: password, data: {
        'name': name,
      });

      registerLoading.value = false;

      if (data.user != null) {
        StorageService.session
            .write(StorageKeys.userSession, data.session!.toJson());
        Get.offAllNamed(RouteNames.login);
      }
    } on AuthException catch (e) {
      registerLoading.value = false;
      showSnackbar("Error", e.message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      loginLoading.value = false;
      final AuthResponse data = await SupabaseService.client.auth
          .signInWithPassword(email: email, password: password);
      loginLoading.value = true;
      if (data.user != null) {
        StorageService.session
            .write(StorageKeys.userSession, data.session!.toJson());
        Get.offAllNamed(RouteNames.home);
      }
    } on AuthException catch (e) {
      loginLoading.value = false;
      showSnackbar("Error", e.message);
    }
  }
}
