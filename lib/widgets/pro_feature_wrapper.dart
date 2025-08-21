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
import 'package:todo_test_task/controllers/controllers.dart';
import 'package:todo_test_task/models/models.dart';

class ProFeatureWrapper extends GetView<AccountController> {
  const ProFeatureWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
    });
  }
}
