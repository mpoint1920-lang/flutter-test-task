import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/helpers/ui_helpers.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final todoCtrl = Get.find<TodoController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://avatars.githubusercontent.com/u/88554326?v=4',
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Yeabsera Mekonnen',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Get.snackbar('Notification', 'You tapped notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Get.snackbar('Settings', 'You tapped settings');
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.archive),
              title: const Text('Archived'),
              onTap: () {
                Get.toNamed('/archived');
              },
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.star_border_purple500),
              title: const Text('Membership'),
              onTap: () {
                Get.toNamed('/membership');
              },
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 20),
            const Text(
              'Collections',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                final newCollectionName =
                    await showAddCollectionDialog(context);
                if (newCollectionName != null && newCollectionName.isNotEmpty) {
                  todoCtrl.addCollection(newCollectionName).then(
                    (v) {
                      showInfoSnackBar(
                        context: Get.context!,
                        message:
                            'Collection "$newCollectionName" has been added.',
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Collection'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Example existing collections
            Expanded(
              child: Obx(
                () => todoCtrl.collections.isEmpty
                    ? const ListTile(
                        enabled: false,
                        leading: Icon(Icons.folder),
                        title: Text('Eg. Work'),
                        onTap: null,
                      )
                    : ListView.builder(
                        itemCount: todoCtrl.collections.length,
                        itemBuilder: (c, i) {
                          final collection = todoCtrl.collections[i];
                          return ListTile(
                            leading: const Icon(Icons.folder),
                            title: Text(collection),
                            onTap: () {
                              Get.toNamed('/collections/$collection');
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
