import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/thread_controller.dart';

class ThreadImagePreview extends StatelessWidget {
  
  ThreadImagePreview({super.key});
  final ThreadController threadController = Get.find<ThreadController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              threadController.image.value!,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              width: double.infinity, // Make it take full width
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: CircleAvatar(
              radius: 14, // Reduced size
              backgroundColor: Colors.white24, // Slight transparency
              child: IconButton(
                onPressed: () {
                  threadController.image.value = null;
                },
                icon: const Icon(Icons.close, size: 14), // Smaller icon
                padding: EdgeInsets.zero, // Removes extra padding
                constraints: const BoxConstraints(), // Ensures minimal size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
