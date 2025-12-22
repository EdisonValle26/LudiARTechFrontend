import 'package:flutter/material.dart';

import 'info_section.dart';

class InfoCard extends StatelessWidget {
  final double w;
  final double h;
  final String title;
  final List<InfoSection> sections;

  const InfoCard({
    super.key,
    required this.w,
    required this.h,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * w),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18 * w,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16 * h),

          Column(
            children: List.generate(sections.length, (i) {
              final section = sections[i];

              return Column(
                children: [
                  Row(
                    children: [
                      Icon(section.icon,
                          size: 28 * w, color: Colors.deepPurple),
                      SizedBox(width: 12 * w),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: TextStyle(
                              fontSize: 16 * w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            section.subtitle,
                            style: TextStyle(
                              fontSize: 14 * w,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (i < sections.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12 * h),
                      child: Divider(height: 1, color: Colors.grey[300]),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
