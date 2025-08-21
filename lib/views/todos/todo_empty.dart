import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_test_task/theme/color_palettes.dart';

class TodoEmpty extends StatelessWidget {
  const TodoEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/no_tasks.svg',
              width: 240,
              height: 240,
              color: ColorPalettes.disabledColor,
            ),
            const SizedBox(height: 24),
            Text(
              "You're all caught up!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Enjoy the rest of your day.",
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
