import 'package:flutter/material.dart';

class BannerNotification extends StatefulWidget {
  final String message;
  final Duration duration;
  final bool isSuccess;

  const BannerNotification({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 3),
    this.isSuccess = true,
  });

  static void show(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (_) => BannerNotification(
        message: message,
        duration: duration,
        isSuccess: isSuccess,
      ),
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      entry.remove();
    });
  }

  @override
  State<BannerNotification> createState() => _BannerNotificationState();
}

class _BannerNotificationState extends State<BannerNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0.4, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 12;
    final screenWidth = MediaQuery.of(context).size.width;

    final Color mainColor =
        widget.isSuccess ? Colors.green : Colors.red;

    return Positioned(
      top: topPadding,
      right: 12,
      child: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.85,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.isSuccess
                          ? Icons.check_circle
                          : Icons.error,
                      color: mainColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
