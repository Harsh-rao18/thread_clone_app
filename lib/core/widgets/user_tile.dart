import 'package:flutter/material.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/core/utils/styles/button_styles.dart';
import 'package:thread_clone_app/core/widgets/image_circle.dart';
import 'package:thread_clone_app/model/user_model.dart';


class UserTile extends StatelessWidget {
  final UserModel user;
  const UserTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: ImageCircle(url: user.metadata?.image,radius: 20,),
      ),
      title: Text(user.metadata!.name!),
      titleAlignment: ListTileTitleAlignment.top,
      trailing: OutlinedButton(
        onPressed: () {
          // Get.toNamed(RouteNames.showProfile, arguments: user.id!);
        },
        style: customOutlineStyle(),
        child: const Text("View profile"),
      ),
      subtitle: Text(formateDateFromNow(user.createdAt!)),
    );
  }
}