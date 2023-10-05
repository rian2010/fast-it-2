import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  CustomInkWell({
    required this.color,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashFactory: InkRipple.splashFactory, // Use default splashFactory
          splashColor: Colors.grey.withOpacity(0.5),
          highlightColor: Colors.grey.withOpacity(0.3),
          child: Container(
            height: 80.0,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
