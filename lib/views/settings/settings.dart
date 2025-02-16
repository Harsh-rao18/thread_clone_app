import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/settings_controller.dart';
import 'package:thread_clone_app/utils/helpers.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                confirmDialog(
                  "Are you sure?",
                  " This action will logout you from app",
                  controller.logout
                );
              },
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              trailing: Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
