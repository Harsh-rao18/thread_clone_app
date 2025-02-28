import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/core/utils/type_def.dart';
import 'package:thread_clone_app/model/post_model.dart';

class PostTopBar extends StatelessWidget {
  final PostModel post;
  final bool isAuthCard;
  final DeleteCallBack? callBack;
  const PostTopBar(
      {super.key, required this.post, this.isAuthCard = false, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () =>
                Get.toNamed(RouteNames.showProfile, arguments: post.userId),
            child: Text(
              post.user?.metadata?.name ?? "Unknown",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              formateDateFromNow(post.createdAt!),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 10),
            isAuthCard
                ? GestureDetector(
                    onTap: () {
                      confirmDialog("Are you sure ?", "Recovery not possible",
                          () {
                        callBack!(post.id!);
                      });
                    },
                    child: Icon(Icons.delete),
                  )
                : Icon(Icons.more_horiz)
          ],
        ),
      ],
    );
  }
}
