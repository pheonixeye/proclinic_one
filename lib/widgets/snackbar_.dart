import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
SnackBar Isnackbar(String message, BuildContext context) {
  return SnackBar(
    action: SnackBarAction(
      label: 'X',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
    duration: const Duration(seconds: 5),
    content: Text(message),
    behavior: SnackBarBehavior.floating,
  );
}
