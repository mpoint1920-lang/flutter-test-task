import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/models/models.dart';
import 'package:todo_test_task/routes.dart';
import 'package:todo_test_task/widgets/widgets.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountCtrl = Get.find<AccountController>();

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
        title: Text(
            membership == Membership.free ? 'Upgrade to Pro' : 'Membership'),
        trailing: AppChip(title: membership.label, bgColor: membership.color),
        onTap: () => accountCtrl.openSubscriptionSheet(),
      );
    });
  }
}
