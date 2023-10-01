import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showPlatformAwareDialog<T>({
  required BuildContext context,
  WidgetBuilder? titleBuilder,
  WidgetBuilder? contentBuilder,
  List<Widget> Function(BuildContext context,)? actionsBuilder,
}) async {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: titleBuilder?.call(_,),
          content: contentBuilder?.call(_,),
          actions: (actionsBuilder?.call(_,) ?? []).map(
            (action) {
              if (action is ButtonStyleButton) {
                return CupertinoDialogAction(
                  onPressed: action.onPressed,
                  child: action.child ?? const SizedBox.shrink(),
                );
              }
              return action;
            },
          ).toList(),
        );
      },
    );
  }
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: titleBuilder?.call(_,),
        content: contentBuilder?.call(_,),
        actions: actionsBuilder?.call(_,) ?? [],
      );
    },
  );
}