import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/profile_controller.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/core/widgets/comment_card.dart';
import 'package:thread_clone_app/core/widgets/image_circle.dart';
import 'package:thread_clone_app/core/widgets/loading.dart';
import 'package:thread_clone_app/core/widgets/post_card.dart';
import 'package:thread_clone_app/views/profile/profile.dart';


class ShowProfile extends StatefulWidget {
  const ShowProfile({super.key});

  @override
  State<ShowProfile> createState() => _ProfileState();
}

class _ProfileState extends State<ShowProfile> {
  final String userId = Get.arguments;
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    controller.getUser(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(RouteNames.settings),
              icon: const Icon(Icons.sort))
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 100,
                collapsedHeight: 100,
                automaticallyImplyLeading: false,
                flexibleSpace: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => controller.userLoading.value
                                    ? const Loading()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller
                                                .user.value!.metadata!.name!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.width * 0.60,
                                            child: Text(controller.user.value!
                                                .metadata!.description!),
                                          ),
                                        ],
                                      ),
                              ),
                              Obx(
                                () => ImageCircle(
                                  url: controller.user.value?.metadata?.image,
                                  radius: 40,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: SliverAppBarDelegate(
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'Threads'),
                      Tab(text: 'Replies'),
                    ],
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              Obx(
                () => SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      if (controller.postLoading.value)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (controller.posts.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.posts.length,
                          itemBuilder: (context, index) =>
                              PostCard(post: controller.posts[index]),
                        )
                      else
                        const Center(
                          child: Text("No Post found"),
                        )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Obx(
                  () => controller.replyLoading.value
                      ? const Loading()
                      : Column(
                          children: [
                            const SizedBox(height: 10),
                            if (controller.comments.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.comments.length,
                                itemBuilder: (context, index) => CommentCard(
                                    comment: controller.comments[index]!),
                              )
                            else
                              const Center(
                                child: Text("No reply found"),
                              )
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}