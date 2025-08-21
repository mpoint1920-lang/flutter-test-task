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
import 'package:todo_test_task/controllers/ui_controller.dart';
import 'package:todo_test_task/helpers/ui_helpers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uiCtrl = Get.find<UiController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 10),

          /// --- Theme Switcher ---
          Obx(() {
            final currentMode = uiCtrl.themeMode.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text('theme'.tr),
                  subtitle: Text('choose_theme'.tr),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ThemeOption(
                      icon: Icons.phone_iphone,
                      label: "system".tr,
                      selected: currentMode == AppThemeMode.system,
                      onTap: () => uiCtrl.updateTheme(AppThemeMode.system),
                      activeColor: theme.colorScheme.primary,
                    ),
                    _ThemeOption(
                      icon: Icons.light_mode_outlined,
                      label: "light".tr,
                      selected: currentMode == AppThemeMode.light,
                      onTap: () => uiCtrl.updateTheme(AppThemeMode.light),
                      activeColor: Colors.amber,
                    ),
                    _ThemeOption(
                      icon: Icons.dark_mode_outlined,
                      label: "dark".tr,
                      selected: currentMode == AppThemeMode.dark,
                      onTap: () => uiCtrl.updateTheme(AppThemeMode.dark),
                      activeColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ],
            );
          }),

          const Divider(height: 32),

          /// --- Language Switcher ---
          Obx(() {
            final current = uiCtrl.currentLocale.value.languageCode;

            Widget langOption({
              required String code,
              required String label,
              required String flag,
              required Locale locale,
            }) {
              final selected = current == code;
              return GestureDetector(
                onTap: () => uiCtrl.updateLocale(locale),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade400,
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18),
                      ]
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('language'.tr),
                  subtitle: Text('choose_language'.tr),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        langOption(
                          code: 'en',
                          label: 'English',
                          flag: '🇺🇸',
                          locale: const Locale('en', 'US'),
                        ),
                        langOption(
                          code: 'am',
                          label: 'አማርኛ',
                          flag: '🇪🇹',
                          locale: const Locale('am', 'ET'),
                        ),
                        langOption(
                          code: 'zh',
                          label: '中文',
                          flag: '🇨🇳',
                          locale: const Locale('zh', 'CN'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),

          const Divider(height: 32),

          /// --- Logout ---
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('logout'.tr),
            onTap: () {
              showConfirmationDialog(
                context: context,
                title: 'logout'.tr,
                content: 'logout_confirmation'.tr,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Reusable theme option button
class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? activeColor.withOpacity(0.15)
                  : theme.colorScheme.surfaceVariant.withOpacity(0.3),
              border: Border.all(
                color: selected ? activeColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: selected ? activeColor : theme.iconTheme.color,
              size: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? activeColor : theme.textTheme.bodyMedium?.color,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
