import 'package:flutter/material.dart';
import 'package:thread_clone_app/model/post_model.dart';

class PostTopBar extends StatelessWidget {
  final PostModel post;
  const PostTopBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            post.user?.metadata?.name ?? "Unknown",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            Text(
              "9 hours ago", // Replace with actual timestamp logic
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {}, // Add menu actions
            ),
          ],
        ),
      ],
    );
  }
}
