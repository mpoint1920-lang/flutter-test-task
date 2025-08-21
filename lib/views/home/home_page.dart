import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/views/account/account_page.dart';
import 'package:todo_test_task/views/collections/collections_page.dart';
import 'package:todo_test_task/views/todos/todo_page.dart';

class HomePage extends GetView<UiController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentPage.value,
            children: [
              TodoPage(),
              const CollectionsPage(),
              const AccountPage(),
            ],
          )),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.inbox_outlined),
              selectedIcon: Icon(
                Icons.inbox,
              ),
              label: 'Inbox',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder),
              label: 'Collections',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_outlined),
              selectedIcon: Icon(Icons.menu),
              label: 'More',
            ),
          ],
          selectedIndex: controller.currentPage.value,
          onDestinationSelected: controller.updateCurrentPage,
        ),
      ),
    );
  }
}
