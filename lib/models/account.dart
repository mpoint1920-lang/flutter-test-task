import 'package:flutter/material.dart';
import 'package:todo_test_task/theme/color_palettes.dart';

enum Membership {
  free,
  pro,
}

extension MembershipX on Membership {
  String get label {
    switch (this) {
      case Membership.free:
        return 'Free';
      case Membership.pro:
        return 'Pro';
    }
  }

  Color get color {
    switch (this) {
      case Membership.free:
        return Colors.grey;
      case Membership.pro:
        return ColorPalettes.premiumColor;
    }
  }

  IconData get icon {
    switch (this) {
      case Membership.free:
        return Icons.star_border;
      case Membership.pro:
        return Icons.workspace_premium;
    }
  }

  // Optional: badge background color (lighter variant)
  Color get backgroundColor {
    switch (this) {
      case Membership.free:
        return Colors.grey.shade200;
      case Membership.pro:
        return Colors.amber.shade100;
    }
  }
}

class Account {
  final int id;
  final String name;
  final String? profilePic;
  final Membership membership;
  final DateTime createdAt;

  const Account({
    required this.id,
    required this.name,
    this.profilePic,
    this.membership = Membership.free,
    required this.createdAt,
  });

  Account copyWith({
    int? id,
    String? name,
    String? profilePic,
    Membership? membership,
    DateTime? createdAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      membership: membership ?? this.membership,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePic: json['profilePic'] as String?,
      membership: Membership.values.firstWhere(
        (e) => e.toString() == 'Membership.${json['membership']}',
        orElse: () => Membership.free,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePic': profilePic,
      'membership': membership.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
