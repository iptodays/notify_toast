/*
 * @Author: A kingiswinter@gmail.com
 * @Date: 2024-11-28 22:14:20
 * @LastEditors: A kingiswinter@gmail.com
 * @LastEditTime: 2024-11-29 14:33:54
 * @FilePath: /stripey/notify_toast/lib/notify_toast.dart
 * 
 * Copyright (c) 2024 by A kingiswinter@gmail.com, All Rights Reserved.
 */

import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

enum NotifyToastPosition { top, bottom }

class NotifyToastView extends StatefulWidget {
  // Set position of alert, default AlertPosition.TOP
  final NotifyToastPosition position;

  final String uniqueId;

  final Duration animationDuration;

  final Duration delayDismiss;

  final Widget child;

  final BorderRadius borderRadius;

  final Color bgColor;

  final double blur;

  final Color progressBgColor;

  final Color progressColor;

  final double progressHeight;

  final void Function(String) onDismiss;

  const NotifyToastView({
    super.key,
    required this.uniqueId,
    required this.position,
    required this.animationDuration,
    required this.delayDismiss,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.bgColor = Colors.black,
    this.blur = 10,
    this.progressBgColor = Colors.transparent,
    this.progressColor = Colors.white,
    this.progressHeight = 2,
    required this.onDismiss,
  });

  @override
  State<StatefulWidget> createState() => _NotifyToastViewState();
}

class _NotifyToastViewState extends State<NotifyToastView>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  late Animation animationPush;

  Timer? timer;

  StreamController<double> streamController = StreamController();

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    animationPush = Tween(begin: -180.0, end: 0.0).animate(
      animationController,
    );
    animationController.addStatusListener(animationStateChanged);
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (c, v) => Positioned(
        top: widget.position == NotifyToastPosition.top
            ? animationPush.value
            : null,
        bottom: widget.position == NotifyToastPosition.bottom
            ? animationPush.value
            : null,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: Colors.transparent,
            child: BlurryContainer(
              color: widget.bgColor,
              borderRadius: widget.borderRadius,
              blur: widget.blur,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  widget.child,
                  StreamBuilder<double>(
                    initialData: 1,
                    stream: streamController.stream,
                    builder: (_, snap) {
                      return LinearProgressIndicator(
                        value: snap.data ?? 0,
                        backgroundColor: widget.progressBgColor,
                        color: widget.progressColor,
                        minHeight: widget.progressHeight,
                        borderRadius: BorderRadius.circular(
                          widget.progressHeight / 2,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void animationStateChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      int ms = widget.delayDismiss.inMilliseconds;
      timer = Timer.periodic(const Duration(milliseconds: 1), (t) {
        ms -= 1;
        streamController.sink.add(ms / widget.delayDismiss.inMilliseconds);
        if (ms <= 0) {
          t.cancel();
          animationController.reverse();
        }
      });
    } else if (status == AnimationStatus.dismissed) {
      timer?.cancel();
      widget.onDismiss(widget.uniqueId);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    streamController.close();
    animationController.removeStatusListener(animationStateChanged);
    animationController.dispose();
    super.dispose();
  }
}
