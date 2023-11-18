import 'package:flutter/material.dart';

class TopTitlePage extends StatelessWidget {
  const TopTitlePage({
    super.key,
    required this.titleIcon,
    required this.titleText,
  });

  final IconData titleIcon;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15),
      child: Row(
        children: [
          Icon(
            titleIcon,
            size: 26,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          const SizedBox(width: 5),
          Text(
            titleText,
            style: const TextStyle(fontSize: 23),
          ),
        ],
      ),
    );
  }
}
