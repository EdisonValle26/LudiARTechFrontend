import 'package:flutter/material.dart';

class ActivityCardWidget extends StatelessWidget {
  final double scale;

  final Color leftSquareColor;
  final String title;
  final String subtitle;

  // final String leftValue;
  // final String leftCaption;
  // final String rightValue;
  // final String rightCaption;

  final IconData leftButtonIcon;
  final String leftButtonText;
  final void Function()? onLeftTap;

  // final IconData rightButtonIcon;
  // final String rightButtonText;
  // final void Function()? onRightTap;

  const ActivityCardWidget({
    super.key,
    required this.scale,
    required this.leftSquareColor,
    required this.title,
    required this.subtitle,
    // required this.leftValue,
    // required this.leftCaption,
    // required this.rightValue,
    // required this.rightCaption,
    required this.leftButtonIcon,
    required this.leftButtonText,
    required this.onLeftTap,
    // required this.rightButtonIcon,
    // required this.rightButtonText,
    // required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    final buttonScale = (w / 390) * scale;

    return Container(
      margin: EdgeInsets.symmetric(vertical: w * 0.03),
      padding: EdgeInsets.all(w * 0.05 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w * 0.20 * scale,
                height: w * 0.20 * scale,
                decoration: BoxDecoration(
                  color: leftSquareColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      softWrap: true,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: w * 0.045 * scale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      softWrap: true,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: w * 0.036 * scale,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: w * 0.06),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Column(
          //       children: [
          //         Text(
          //           leftValue,
          //           style: TextStyle(
          //             color: const Color(0xFFBA44FF),
          //             fontSize: w * 0.07 * scale,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         SizedBox(height: 4),
          //         Text(
          //           leftCaption,
          //           style: TextStyle(
          //             color: Colors.grey[600],
          //             fontSize: w * 0.035 * scale,
          //           ),
          //         ),
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         Text(
          //           rightValue,
          //           style: TextStyle(
          //             color: const Color(0xFFBA44FF),
          //             fontSize: w * 0.07 * scale,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         SizedBox(height: 4),
          //         Text(
          //           rightCaption,
          //           style: TextStyle(
          //             color: Colors.grey[600],
          //             fontSize: w * 0.035 * scale,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),

          // SizedBox(height: w * 0.05 * scale),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onLeftTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA44FF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: 10 * buttonScale,
                      horizontal: 6 * buttonScale,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    leftButtonIcon,
                    size: 18 * buttonScale,
                  ),
                  label: FittedBox(
                    child: Text(
                      leftButtonText,
                      style: TextStyle(fontSize: 14 * buttonScale),
                    ),
                  ),
                ),
              ),
              // SizedBox(width: w * 0.03),
              // Expanded(
              //   child: ElevatedButton.icon(
              //     onPressed: onRightTap,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.grey[300],
              //       foregroundColor: Colors.black87,
              //       padding: EdgeInsets.symmetric(
              //         vertical: 10 * buttonScale,
              //         horizontal: 6 * buttonScale,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     icon: Icon(
              //       rightButtonIcon,
              //       size: 18 * buttonScale,
              //     ),
              //     label: FittedBox(
              //       child: Text(
              //         rightButtonText,
              //         style: TextStyle(fontSize: 14 * buttonScale),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
