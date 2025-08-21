import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/theme/color_palettes.dart';
import 'package:todo_test_task/widgets/app_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    required this.errorMessage,
    required this.onRetry,
    this.iconColor = ColorPalettes.errorColor,
    this.iconPath,
    Key? key,
  }) : super(key: key);

  final String? iconPath;
  final Color iconColor;
  final String errorMessage;
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath ?? 'assets/error.svg',
              width: 124,
              height: 124,
              color: iconColor,
            ),
            const SizedBox(height: 24),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              width: Get.width * .6,
              title: "Retry",
              type: AppButtonType.error,
              prefixIcon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
