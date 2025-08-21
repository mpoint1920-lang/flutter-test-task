// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************

import 'package:get/get.dart';

import 'package:todo_test_task/controllers/bindings.dart';
import 'package:todo_test_task/views/home/home_page.dart';
import 'package:todo_test_task/views/home/archived_page.dart';
import 'package:todo_test_task/views/collections/collection_detail_page.dart';
import 'package:todo_test_task/views/settings/setting_page.dart';

class RouteNames {
  static const home = '/home';
  static const archived = '/archived';
  static const collection = '/collections';
  static const settings = '/settings';
}

class AppRoutes {
  static final pages = [
    GetPage(
      name: RouteNames.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteNames.archived,
      page: () => const ArchivedPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '${RouteNames.collection}/:name',
      page: () {
        final encodedName = Get.parameters['name']!;
        final collectionName = Uri.decodeComponent(encodedName);
        return CollectionDetailPage(name: collectionName);
      },
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteNames.settings,
      page: () => const SettingsPage(),
    ),
  ];
}
