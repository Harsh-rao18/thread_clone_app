import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/thread_controller.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/model/post_model.dart';

class PostBottomBar extends StatefulWidget {
  final PostModel post;
  const PostBottomBar({super.key, required this.post});

  @override
  State<PostBottomBar> createState() => _PostBottomBarState();
}

class _PostBottomBarState extends State<PostBottomBar> {
  String likeStatus = "";
  final ThreadController controller = Get.find<ThreadController>();
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  Future<void> likeDislike(String status) async {
    final currentUser = supabaseService.currentUser.value;
    if (widget.post.id == null || widget.post.userId == null || currentUser == null) {
      return;
    }

    setState(() {
      likeStatus = status;
    });

    if (likeStatus == "0") {
      widget.post.likes = [];
    }

    await controller.likeDislike(status, widget.post.id!, widget.post.userId!, currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (widget.post.likes ?? []).isNotEmpty || likeStatus == "1"
                ? IconButton(
                    onPressed: () => likeDislike("0"),
                    icon: Icon(Icons.favorite, color: Colors.red[700]),
                  )
                : IconButton(
                    onPressed: () => likeDislike("1"),
                    icon: const Icon(Icons.favorite_outline),
                  ),
            IconButton(
              onPressed: () {
                Get.toNamed(RouteNames.replies, arguments: widget.post);
              },
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send_outlined),
            ),
          ],
        ),
        // Like & Comment Count
        Row(
          children: [
            Text(
              "${widget.post.likeCount ?? 0} likes",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
            const SizedBox(width: 10),
            Text(
              "${widget.post.commentCount ?? 0} comments",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }
}
