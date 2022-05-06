import 'package:flutter/material.dart';

typedef DialgueOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialogue<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialgueOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialogue(
    context: context,
    title: "An error occurred",
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialogue(
    context: context,
    title: "Log out",
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> switchUserDialog(
  BuildContext context,
) {
  return showGenericDialogue(
    context: context,
    title: "Switch User",
    content:
        'do you want to switch user? \n Note: This action would log you out',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
