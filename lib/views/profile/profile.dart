import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/profile_controller.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/core/utils/styles/button_styles.dart';
import 'package:thread_clone_app/core/widgets/comment_card.dart';
import 'package:thread_clone_app/core/widgets/image_circle.dart';
import 'package:thread_clone_app/core/widgets/loading.dart';
import 'package:thread_clone_app/core/widgets/post_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController profileController = Get.put(ProfileController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

@override
void initState() {
  super.initState();
  final userId = supabaseService.currentUser.value?.id;
  if (userId != null) {
    profileController.fetchPosts(userId);
    profileController.fetchComments(userId);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.language),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteNames.settings);
            },
            icon: Icon(Icons.sort_rounded),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 160,
                collapsedHeight: 160,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      supabaseService.currentUser.value!
                                          .userMetadata?["name"],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: context.width * 0.70,
                                      child: Text(supabaseService
                                              .currentUser
                                              .value
                                              ?.userMetadata?["description"] ??
                                          ' Hello!!'),
                                    ),
                                  ],
                                )),
                          ),
                          Flexible(
                            child: ImageCircle(
                              radius: 40,
                              url: supabaseService
                                  .currentUser.value?.userMetadata?["image"],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Get.toNamed(RouteNames.editProfile),
                                style: customOutlineStyle(),
                                child: const Text('Edit Profile'),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: customOutlineStyle(),
                                child: const Text('Show Profile'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: SliverAppBarDelegate(
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        text: "Threads",
                      ),
                      Tab(
                        text: "Replies",
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Obx(
                () => SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      if (profileController.postLoading.value)
                        const Loading()
                      else if (profileController.posts.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: profileController.posts.length,
                          itemBuilder: (context,index)=> PostCard(post: profileController.posts[index]),
                        )
                      else
                      const Center(child: Text("No Posts yet"),),
                    ],
                  ),
                ),
              ),
              Obx(()=> SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    if(profileController.replyLoading.value)
                        const Loading()
                      else if (profileController.comments.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: profileController.comments.length,
                          itemBuilder: (context,index)=> CommentCard(comment: profileController.comments[index]!),
                        )
                      else
                      const Center(child: Text("No replies yet"),),
                  ],
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}

// Sliver persistenceHeader

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  SliverAppBarDelegate(this._tabBar);

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
