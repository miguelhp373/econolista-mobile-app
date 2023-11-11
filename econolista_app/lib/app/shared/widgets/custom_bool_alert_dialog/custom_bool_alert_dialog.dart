import 'dart:async';
import 'package:flutter/material.dart';

class CustomBoolAlertDialog {
  Future<bool?> showBooleanAlertDialog(
    BuildContext context,
    String titleText,
    String contentText,
  ) {
    Completer<bool?> completer = Completer<bool?>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: [
          TextButton(
            child: const Text('Não'),
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(false);
            },
          ),
          TextButton(
            child: const Text('Sim'),
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(true);
            },
          ),
        ],
      ),
    );

    return completer.future;
  }
}
