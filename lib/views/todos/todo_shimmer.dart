import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TodoShimmer extends StatelessWidget {
  const TodoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
              ),
              title: Container(
                width: double.infinity,
                height: 18.0,
                color: Colors.white,
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: MediaQuery.of(context).size.width * 0.5,
                height: 14.0,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
