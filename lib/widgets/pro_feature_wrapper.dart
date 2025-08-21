import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_test_task/controllers/account_controller.dart';
import 'package:todo_test_task/models/account.dart';

class ProFeatureWrapper extends GetView<AccountController> {
  const ProFeatureWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (controller.isPro) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            Expanded(child: child),
          ],
        ),
        Positioned(
          top: -5,
          right: -5,
          child: Container(
            decoration: BoxDecoration(
              color: Membership.pro.color,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                Membership.pro.icon,
                // color: Membership.pro.color,
              ),
            ),
          ),
        )
      ],
    );
  }
}
