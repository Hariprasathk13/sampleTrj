import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color tcolor;

  const BottomBar({
    super.key,
    required this.text,
    required this.icon,
    required this.tcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: tcolor),
        const SizedBox(width: 8),
        Expanded( // Fix overflow by allowing text to wrap within available space
          child: Text(
            text,
            style: TextStyle(color: tcolor),
            overflow: TextOverflow.ellipsis, // Optional: Truncate long text
          ),
        ),
      ],
    );
  }
}
