import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/core/widgets/comment_top_bar.dart';
import 'package:thread_clone_app/core/widgets/image_circle.dart';
import 'package:thread_clone_app/model/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: context.width * 0.12,
              child: ImageCircle(radius: 20,url: comment.user?.metadata?.image,),
            ),
            const SizedBox(width: 10,),
            SizedBox(
              width: context.width * 0.80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentCardTopbar(comment: comment),
                  Text(comment.reply!),
                ],
              ),
            ),
          ],
        ),
        const Divider(color: Color(0xff242424),),
      ],
    );
  }
}
