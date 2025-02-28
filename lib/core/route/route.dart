import 'package:get/get.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/views/auth/login.dart';
import 'package:thread_clone_app/views/auth/register.dart';
import 'package:thread_clone_app/views/home.dart';
import 'package:thread_clone_app/views/profile/edit_profile.dart';
import 'package:thread_clone_app/views/profile/show_user.dart';
import 'package:thread_clone_app/views/replies/add_reply.dart';
import 'package:thread_clone_app/views/settings/settings.dart';
import 'package:thread_clone_app/views/threads/show_image.dart';
import 'package:thread_clone_app/views/threads/show_thread.dart';

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
    GetPage(
      name: RouteNames.settings,
      page: () => Settings(),
      transition: Transition.rightToLeft
    ),
    GetPage(
      name: RouteNames.replies,
      page: () => AddComment(),
      transition: Transition.downToUp
    ),
    GetPage(
      name: RouteNames.showThread,
      page: () => ShowThread(),
      transition: Transition.leftToRight
    ),
    GetPage(
      name: RouteNames.showImage,
      page: () => ShowImage(),
      transition: Transition.leftToRight
    ),
    GetPage(
      name: RouteNames.showProfile,
      page: () => ShowProfile(),
      transition: Transition.leftToRight
    ),
  ];
}
