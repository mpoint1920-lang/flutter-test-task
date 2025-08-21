import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/helpers/helpers.dart';
import 'package:todo_test_task/models/account.dart';
import 'package:todo_test_task/routes.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final accountCtrl = Get.find<AccountController>();
    final todoCtrl = Get.find<TodoController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final count = todoCtrl.collections.length;
          return Text(
            count == 0 ? 'Collections' : 'Collections ($count)',
          );
        }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _AddCollectionButton(
            accountCtrl: accountCtrl,
            todoCtrl: todoCtrl,
            colorScheme: colorScheme,
          ),
          _NeedMoreCollections(accountCtrl: accountCtrl, todoCtrl: todoCtrl),
          Expanded(child: _CollectionsList(todoCtrl: todoCtrl)),
        ],
      ),
    );
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
