// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/models/models.dart';
import 'package:todo_test_task/services/services.dart';
import 'package:todo_test_task/theme/color_palettes.dart';

class AccountController extends GetxController {
  AccountController({required this.storageService});

  final StorageService storageService;

  @override
  void onInit() {
    super.onInit();
    final storedAccount = storageService.getAccount();
    accountInfo.value = storedAccount ?? accountInfo.value;
  }

  final Rx<Account?> accountInfo = Rx<Account?>(
    Account(
      id: 1,
      name: 'Yeabsera Mekonnen',
      profilePic: 'https://avatars.githubusercontent.com/u/88554326?v=4',
      createdAt: DateTime.now(),
    ),
  );

  bool get isPro => accountInfo.value?.membership == Membership.pro;

  /// Update membership
  Future<void> updateMembership(Membership membership) async {
    final current = accountInfo.value;
    if (current != null) {
      accountInfo.value = current.copyWith(membership: membership);
      await storageService.saveAccount(accountInfo.value!);
    }
  }

  void openSubscriptionSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Choose Membership',
              style: Get.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final currentMembership =
                  accountInfo.value?.membership ?? Membership.free;

              return Column(
                children: Membership.values.map((membership) {
                  final isSelected = currentMembership == membership;
                  final isPro = membership == Membership.pro;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isPro
                              ? ColorPalettes.premiumColor
                                  .withValues(alpha: 0.2)
                              : Theme.of(Get.context!)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.1))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? (isPro
                                ? ColorPalettes.premiumColor
                                : Colors.blueGrey)
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: membership.color,
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white)
                                : Icon(
                                    isPro
                                        ? Icons.workspace_premium
                                        : Icons.star_border,
                                    color: Colors.white),
                          ),
                          title: Text(
                            membership.label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: isPro
                              ? const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('\$4.99 / month'),
                                    SizedBox(height: 4),
                                    Text('• Unlimited collections'),
                                    Text('• Deadline support'),
                                  ],
                                )
                              : const Text('Basic features'),
                          onTap: () {
                            updateMembership(membership);
                            Get.back();
                          },
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Current',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
