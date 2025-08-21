import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/account_controller.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/helpers/ui_helpers.dart';
import 'package:todo_test_task/models/account.dart';
import 'package:todo_test_task/routes.dart';
import 'package:todo_test_task/widgets/app_network_image.dart';
import 'package:todo_test_task/widgets/widgets.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final accountCtrl = Get.find<AccountController>();
    final todoCtrl = Get.find<TodoController>();

    return Scaffold(
      appBar: _AccountAppBar(accountCtrl: accountCtrl),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ArchivedTile(),
            _MembershipTile(accountCtrl: accountCtrl),
            const SizedBox(height: 20),
            const Text(
              'Collections',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _AddCollectionButton(
                accountCtrl: accountCtrl,
                todoCtrl: todoCtrl,
                colorScheme: colorScheme),
            _NeedMoreCollections(accountCtrl: accountCtrl, todoCtrl: todoCtrl),
            Expanded(child: _CollectionsList(todoCtrl: todoCtrl)),
          ],
        ),
      ),
    );
  }
}

/// --- AppBar Section ---
class _AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AccountController accountCtrl;
  const _AccountAppBar({required this.accountCtrl});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Obx(
        () => Row(
          children: [
            CachedImage(
              width: 20,
              height: 20,
              url: accountCtrl.accountInfo.value?.profilePic,
            ),
            const SizedBox(width: 10),
            Text(
              accountCtrl.accountInfo.value?.name ?? '',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Get.toNamed(RouteNames.settings);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// --- Archived Section ---
class _ArchivedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.archive),
      title: const Text('Archived'),
      onTap: () => Get.toNamed(RouteNames.archived),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

/// --- Membership Section ---
class _MembershipTile extends StatelessWidget {
  final AccountController accountCtrl;
  const _MembershipTile({required this.accountCtrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final membership =
          accountCtrl.accountInfo.value?.membership ?? Membership.free;
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(membership.icon, color: membership.color),
        title: const Text('Membership'),
        subtitle: AppChip(title: membership.label, bgColor: membership.color),
        onTap: () => accountCtrl.openSubscriptionSheet(),
        trailing: const Icon(Icons.chevron_right),
      );
    });
  }
}

/// --- Add Collection Section ---
class _AddCollectionButton extends StatelessWidget {
  final AccountController accountCtrl;
  final TodoController todoCtrl;
  final ColorScheme colorScheme;

  const _AddCollectionButton({
    required this.accountCtrl,
    required this.todoCtrl,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: (!accountCtrl.isPro &&
                todoCtrl.collections.length > AppConstants.freeCollectionLimit)
            ? null
            : () async {
                final newCollectionName =
                    await showAddCollectionDialog(context);
                if (newCollectionName != null && newCollectionName.isNotEmpty) {
                  todoCtrl.addCollection(newCollectionName).then(
                    (_) {
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
    );
  }
}

/// --- More Collections Prompt ---
class _NeedMoreCollections extends StatelessWidget {
  final AccountController accountCtrl;
  final TodoController todoCtrl;

  const _NeedMoreCollections({
    required this.accountCtrl,
    required this.todoCtrl,
  });

  @override
  Widget build(BuildContext context) {
    const pro = Membership.pro;
    return Obx(() {
      if (!accountCtrl.isPro &&
          todoCtrl.collections.length > AppConstants.freeCollectionLimit) {
        return ListTile(
          leading: Icon(pro.icon, size: 14, color: pro.color),
          minLeadingWidth: 0,
          title: Text(
            'Need More Collections?',
            style: TextStyle(fontSize: 14, color: pro.color),
          ),
          onTap: accountCtrl.openSubscriptionSheet,
        );
      }
      return const SizedBox.shrink();
    });
  }
}

/// --- Collections List ---
class _CollectionsList extends StatelessWidget {
  final TodoController todoCtrl;
  const _CollectionsList({required this.todoCtrl});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => todoCtrl.collections.isEmpty
          ? const ListTile(
              enabled: false,
              leading: Icon(Icons.folder),
              title: Text('Eg. Work'),
            )
          : ListView.builder(
              itemCount: todoCtrl.collections.length,
              itemBuilder: (c, i) {
                final collection = todoCtrl.collections[i];
                return ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(collection),
                  onTap: () {
                    Get.toNamed(
                        '${RouteNames.collection}/${Uri.encodeComponent(collection)}');
                  },
                );
              },
            ),
    );
  }
}
