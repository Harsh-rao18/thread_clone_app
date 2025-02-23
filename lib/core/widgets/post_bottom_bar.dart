import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/model/post_model.dart';

class PostBottomBar extends StatelessWidget {
  final PostModel post;
  const PostBottomBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
            IconButton(
                onPressed: () {
                  Get.toNamed(RouteNames.replies,arguments: post);
                },
                icon: const Icon(Icons.chat_bubble_outline)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send_outlined)),
          ],
        ),

        // Like & Comment Count
        Row(
          children: [
            Text(
              "${post.likeCount} likes",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "${post.commentCount} comments",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
