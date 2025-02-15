import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/profile_controller.dart';
import 'package:thread_clone_app/services/supabase_service.dart';
import 'package:thread_clone_app/widgets/image_circle.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController controller = Get.find<ProfileController>();
  final TextEditingController descriptionController =
      TextEditingController(text: "");
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  void initState() {
    if (supabaseService.currentUser.value?.userMetadata?["description"] != null) {
      descriptionController.text =
        supabaseService.currentUser.value?.userMetadata?["description"];
    }
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          Obx(() => TextButton(
                onPressed: () {
                  controller.updateProfile(
                      supabaseService.currentUser.value!.id,
                      descriptionController.text);
                },
                child: controller.loading.value ? const SizedBox(height: 14,width: 14,child: CircularProgressIndicator(),) : Text('Save'),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Obx(() => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ImageCircle(
                      radius: 80,
                      file: controller.image.value,
                      url: supabaseService
                          .currentUser.value!.userMetadata?["image"],
                    ),
                    IconButton(
                      onPressed: () {
                        controller.pickImage();
                      },
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white60,
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Your Description",
                  label: Text("Discription")),
            ),
          ],
        ),
      ),
    );
  }
}
