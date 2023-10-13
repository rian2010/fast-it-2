import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final int notificationCount;
  final Widget child;

  Badge({required this.notificationCount, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (notificationCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red, // You can customize the badge color
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
