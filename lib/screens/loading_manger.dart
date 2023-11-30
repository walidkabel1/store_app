import 'package:flutter/material.dart';

class LoadingManger extends StatelessWidget {
  const LoadingManger(
      {super.key, required this.isloading, required this.child});
  final bool isloading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isloading) ...[
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        ]
      ],
    );
  }
}
