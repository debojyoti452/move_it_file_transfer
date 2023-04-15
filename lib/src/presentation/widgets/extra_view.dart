import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showNotificationView({
  required BuildContext context,
  required String message,
  required VoidCallback onTap,
}) {
  BotToast.showCustomNotification(
    toastBuilder: (cancelFunc) {
      return Material(
        child: InkWell(
          onTap: () {
            cancelFunc();
            onTap();
          },
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      );
    },
    duration: const Duration(seconds: 5),
  );
}

Widget connectedStatusView(bool isConnected) {
  return Text(
    isConnected ? 'Accepted' : 'Re-Connect',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: isConnected ? Colors.green : Colors.red,
      fontSize: 12.sp,
    ),
  );
}
