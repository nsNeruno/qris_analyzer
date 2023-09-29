import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double heightRatio = 0.5,
}) async {

  heightRatio = heightRatio.clamp(0.0, 1.0,);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      final mq = MediaQuery.of(context,);
      return Padding(
        padding: EdgeInsets.only(bottom: mq.viewInsets.bottom,),
        child: SizedBox(
          height: mq.size.height * heightRatio,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12,),
              ),
            ),
            child: RPadding(
              padding: const EdgeInsets.all(24.0,),
              child: builder(_,),
            ),
          ),
        ),
      );
    },
  );
}