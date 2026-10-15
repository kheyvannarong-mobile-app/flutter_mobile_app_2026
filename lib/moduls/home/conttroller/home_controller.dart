import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}