import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/core/utils/type_def.dart';
import 'package:thread_clone_app/model/post_model.dart';
import 'package:thread_clone_app/core/widgets/image_circle.dart';
import 'package:thread_clone_app/core/widgets/post_bottom_bar.dart';
import 'package:thread_clone_app/core/widgets/post_card_image.dart';
import 'package:thread_clone_app/core/widgets/post_top_bar.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isAuthCard;
  final DeleteCallBack? callBack;
  const PostCard({super.key, required this.post, this.isAuthCard = false, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for User Info & Timestamp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCircle(
                radius: 22,
                url: post.user?.metadata?.image,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostTopBar(post: post,isAuthCard: isAuthCard, callBack: callBack,),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => {
                        Get.toNamed(RouteNames.showThread, arguments: post.id),
                      },
                      child: Text(
                        post.content ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (post.image != null)
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNames.showImage,
                              arguments: post.image!);
                        },
                        child: PostCardImage(
                          url: post.image!,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Action Buttons (Like, Comment, Share)
          PostBottomBar(post: post),

          const SizedBox(height: 10),
          const Divider(color: Color(0xff242424)),
        ],
      ),
    );
  }
}
