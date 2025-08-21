import 'package:flutter/material.dart';

import 'package:todo_test_task/common/common.dart';
import 'package:todo_test_task/theme/theme.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? prefixIcon;
  final AppButtonType type;
  final bool expanded;
  final double? width;

  const AppButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.prefixIcon,
    this.type = AppButtonType.primary,
    this.expanded = true,
    this.width,
  }) : super(key: key);

  Color _backgroundColor(BuildContext context) {
    switch (type) {
      case AppButtonType.success:
        return Theme.of(context).colorScheme.primary;
      case AppButtonType.error:
        return ColorPalettes.disabledColor;
      case AppButtonType.secondary:
        return Theme.of(context).colorScheme.secondary;
      case AppButtonType.primary:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _foregroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _foregroundColor(context),
                  fontWeight: FontWeight.w600,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final btn = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _backgroundColor(context),
        foregroundColor: _foregroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: buttonChild,
    );

    if (expanded) {
      return SizedBox(width: width ?? double.infinity, child: btn);
    }
    return SizedBox(width: width, child: btn);
  }
}
