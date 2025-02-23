import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/thread_controller.dart';
import 'package:thread_clone_app/core/services/navigation_service.dart';
import 'package:thread_clone_app/core/services/supabase_service.dart';

class AddThreadAppBar extends StatelessWidget {
  AddThreadAppBar({super.key});

  final ThreadController threadController = Get.find<ThreadController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff242424),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.find<NavigationService>().backToPreviouspage();
                  },
                  icon: Icon(Icons.close)),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "New Thead",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Obx(() => TextButton(
                onPressed: () {
                  if (threadController.content.value.isNotEmpty) {
                    threadController.store(
                        Get.find<SupabaseService>().currentUser.value!.id);
                  }
                },
                child: threadController.loading.value ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                ) : Text(
                  "Post",
                  style: TextStyle(fontSize: 15,fontWeight: threadController.content.value.isNotEmpty ? FontWeight.bold : FontWeight.normal),
                ),
              )),
        ],
      ),
    );
  }
}
