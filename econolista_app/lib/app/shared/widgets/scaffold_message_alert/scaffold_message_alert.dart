import 'package:flutter/material.dart';

class ScaffoldMessengeAlert {
  //////////////////////////////////////////
  void showMessageOnDisplay(BuildContext context, String messageText) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info,
                size: 36,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                messageText,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  //////////////////////////////////////////////
  showMessageOnDisplayBottom(
    BuildContext context,
    String messageText,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          messageText,
        ),
      ),
    );
  }
}
