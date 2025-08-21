import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TodoShimmer extends StatelessWidget {
  const TodoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            color: isDark ? Colors.grey[900] : Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                radius: 20,
              ),
              title: Container(
                width: double.infinity,
                height: 18.0,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: MediaQuery.of(context).size.width * 0.5,
                height: 14.0,
                color: isDark ? Colors.grey[600] : Colors.grey[200],
              ),
            ),
          );
        },
      ),
    );
  }
}
