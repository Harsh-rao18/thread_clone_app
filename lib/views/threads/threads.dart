import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/thread_controller.dart';
import 'package:thread_clone_app/services/supabase_service.dart';
import 'package:thread_clone_app/widgets/add_thread_app_bar.dart';
import 'package:thread_clone_app/widgets/image_circle.dart';
import 'package:thread_clone_app/widgets/thread_image_preview.dart';

class Threads extends StatelessWidget {
  Threads({super.key});

  final SupabaseService supabaseService = Get.find<SupabaseService>();
  final ThreadController threadController = Get.put(ThreadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddThreadAppBar(),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => ImageCircle(
                      url: supabaseService.currentUser.value!.userMetadata?["image"],
                      radius: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            supabaseService.currentUser.value!.userMetadata?["name"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            autofocus: true,
                            controller: threadController.textEditingController,
                            onChanged: (value) => threadController.content.value = value,
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                            maxLines: 10,
                            minLines: 1,
                            maxLength: 1000,
                            decoration: const InputDecoration(
                              hintText: "Type a thread...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => threadController.pickImage(),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.attach_file,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          if (threadController.image.value != null) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: 1.0,
                              child: Container(
                                width: double.infinity, // Takes full width
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: ThreadImagePreview(), // Ensure this widget allows flexible width
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
