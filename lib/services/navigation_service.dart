import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/views/home/home_page.dart';
import 'package:thread_clone_app/views/notification/notifications.dart';
import 'package:thread_clone_app/views/profile/profile.dart';
import 'package:thread_clone_app/views/search/search.dart';
import 'package:thread_clone_app/views/threads/threads.dart';

class NavigationService extends GetxService {
  var currentIndex = 0.obs;
  var previousIndex = 0.obs;

  // all pages
  List<Widget> pages() {
    return [
      const HomePage(),
      const Search(),
      const Notifications(),
      const Threads(),
      const Profile(),
    ];
  }

  // update index
  void updateIndex(int index) {
    previousIndex.value = currentIndex.value;
    currentIndex.value = index;
  }
}
