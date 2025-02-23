import 'package:flutter/material.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/model/comment_model.dart';

class CommentCardTopbar extends StatelessWidget {
  final CommentModel comment;
  final bool isAuthCard;
  const CommentCardTopbar({
    required this.comment,
    this.isAuthCard = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          comment.user!.metadata!.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(formateDateFromNow(comment.createdAt!)),
            const SizedBox(width: 10),
            isAuthCard
                ? GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : const Icon(Icons.more_horiz),
          ],
        )
      ],
    );
  }
}