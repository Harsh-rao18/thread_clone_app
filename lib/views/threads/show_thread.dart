import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/thread_controller.dart';
import 'package:thread_clone_app/core/widgets/comment_card.dart';
import 'package:thread_clone_app/core/widgets/loading.dart';
import 'package:thread_clone_app/core/widgets/post_card.dart';


class ShowThread extends StatefulWidget {
  const ShowThread({super.key});

  @override
  State<ShowThread> createState() => _ShowThreadState();
}

class _ShowThreadState extends State<ShowThread> {
  final int postId = Get.arguments;
  final ThreadController controller = Get.put(ThreadController());

  @override
  void initState() {
    controller.show(postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thread"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => controller.showThreadloading.value
              ? const Loading()
              : Column(
                  children: [
                    PostCard(post: controller.post.value),

                    const SizedBox(height: 20),
                    // * load thread comments
                    if (controller.showReplyloading.value)
                      const Loading()
                    else if (controller.replies.isNotEmpty &&
                        controller.showReplyloading.value == false)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.replies.length,
                        itemBuilder: (context, index) =>
                            CommentCard(comment: controller.replies[index]),
                      )
                    else
                      const Text("No replies")
                  ],
                ),
        ),
      ),
    );
  }
}