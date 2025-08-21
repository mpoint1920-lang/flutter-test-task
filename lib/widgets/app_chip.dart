import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.title,
    this.bgColor,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
  });

  final String title;
  final Color? bgColor;
  final void Function()? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: padding,
              child: Text(
                title,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
