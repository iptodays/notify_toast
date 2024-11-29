/*
 * @Author: A kingiswinter@gmail.com
 * @Date: 2024-11-28 22:15:24
 * @LastEditors: A kingiswinter@gmail.com
 * @LastEditTime: 2024-11-29 18:58:16
 * @FilePath: /notify_toast/lib/notify_toast.dart
 * 
 * Copyright (c) 2024 by A kingiswinter@gmail.com, All Rights Reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify_toast/notify_toast_view.dart';

class NotifyToast {
  static NotifyToast? _instance;

  OverlayState? _overlayState;

  OverlayEntry? _overlayEntry;

  NotifyToast._internal() {
    if (kDebugMode) {
      print('NotifyToastController was created!');
    }
  }

  factory NotifyToast() {
    return _instance ??= NotifyToast._internal();
  }

  /// 初始化Overlay
  void initOverlay(BuildContext context) {
    _overlayState = Overlay.of(context);
  }

  /// 显示Toast
  String show(
    BuildContext context, {
    required Widget child,
    String? uniqueId,
    NotifyToastPosition position = NotifyToastPosition.top,
    Duration animationDuration = const Duration(milliseconds: 300),
    Duration delayDismiss = const Duration(milliseconds: 3000),
    BorderRadius borderRadius = BorderRadius.zero,
    Color bgColor = Colors.black,
    double blur = 10,
    Color progressBgColor = Colors.transparent,
    Color progressColor = Colors.white,
    double progressHeight = 2,
    VoidCallback? onDismiss,
  }) {
    hide();
    _overlayState ??= Overlay.of(
      context,
    );
    String key = uniqueId ?? '${DateTime.now().millisecondsSinceEpoch}';
    _overlayEntry = OverlayEntry(
      builder: (_) {
        return NotifyToastView(
          uniqueId: key,
          position: position,
          animationDuration: animationDuration,
          delayDismiss: delayDismiss,
          borderRadius: borderRadius,
          bgColor: bgColor,
          blur: blur,
          progressBgColor: progressBgColor,
          progressColor: progressColor,
          progressHeight: progressHeight,
          onDismiss: (uniqueId) {
            hide();
            onDismiss?.call();
          },
          child: child,
        );
      },
    );
    _overlayState?.insert(_overlayEntry!);
    return key;
  }

  /// 隐藏
  void hide() {
    if (_overlayState != null && _overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
