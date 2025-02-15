import 'package:get/get.dart';
import 'package:thread_clone_app/route/route_names.dart';
import 'package:thread_clone_app/views/auth/login.dart';
import 'package:thread_clone_app/views/auth/register.dart';
import 'package:thread_clone_app/views/home.dart';
import 'package:thread_clone_app/views/profile/edit_profile.dart';

class Routes {
  static final pages = [
    GetPage(name: RouteNames.home, page: () => Home()),
    GetPage(
        name: RouteNames.login,
        page: () => const Login(),
        transition: Transition.fadeIn),
    GetPage(
      name: RouteNames.register,
      page: () => const Register(),
      transition: Transition.fadeIn
    ),
    GetPage(
      name: RouteNames.editProfile,
      page: () => const EditProfile(),
      transition: Transition.leftToRight
    ),
  ];
}
