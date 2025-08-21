import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:todo_test_task/theme/theme.dart';

class TodoEmpty extends StatelessWidget {
  const TodoEmpty({
    super.key,
    required this.title,
    this.icon,
    this.iconPath,
    this.description = '',
  });

  final Widget? icon;
  final String? iconPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ??
                SvgPicture.asset(
                  iconPath ?? 'assets/no_tasks.svg',
                  width: 240,
                  height: 240,
                  color: ColorPalettes.disabledColor,
                ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
