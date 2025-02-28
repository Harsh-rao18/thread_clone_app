import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/notification_controller.dart';
import 'package:thread_clone_app/core/route/route_names.dart';
import 'package:thread_clone_app/core/services/navigation_service.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';
import 'package:thread_clone_app/core/widgets/image_circle.dart';
import 'package:thread_clone_app/core/widgets/loading.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    controller
        .fetchNotifications(Get.find<SupabaseService>().currentUser.value!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.find<NavigationService>().backToPreviouspage(),
            icon: Icon(Icons.close)),
        title: Text('Notification'),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => controller.loading.value
              ? const Loading()
              : Column(
                  children: [
                    if (controller.notifications.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.notifications.length,
                        itemBuilder: (context,index) => ListTile(
                          onTap: () => Get.toNamed(RouteNames.showThread,arguments: controller.notifications[index]!.postId),
                          leading: ImageCircle(radius: 20,url: controller.notifications[index]?.user?.metadata?.image,),
                          title: Text(controller.notifications[index]!.user!.metadata!.name!),
                          subtitle: Text(controller.notifications[index]!.notification!),
                          trailing: Text(formateDateFromNow(controller.notifications[index]!.createdAt!)),

                        ),
                      )
                    else
                    const Center(child: Text("No Notifications Yet"),),
                  ],
                ),
        ),
      ),
    );
  }
}
