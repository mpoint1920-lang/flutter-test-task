import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
      body: ListView(
        padding: const EdgeInsets.all(12),
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
          const SizedBox(height: 20),
          const Text(
            'Collections',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Get.snackbar('Collections', 'Add a new collection');
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
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Work'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Personal'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
