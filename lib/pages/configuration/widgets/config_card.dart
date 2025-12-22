import 'package:flutter/material.dart';

import 'config_item.dart';

class ConfigCard extends StatefulWidget {
  final String title;
  final List<dynamic> items;
  final double w;
  final double h;

  const ConfigCard({
    super.key,
    required this.title,
    required this.items,
    required this.w,
    required this.h,
  });

  @override
  State<ConfigCard> createState() => _ConfigCardState();
}

class _ConfigCardState extends State<ConfigCard> {
  late List<bool> toggleValues;

  @override
  void initState() {
    super.initState();

    toggleValues = widget.items.map((e) {
      if (e is ConfigItem && e.isToggle) {
        return e.initialValue;
      }
      return false; 
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 18 * widget.w, vertical: 18 * widget.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18 * widget.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12 * widget.w,
            offset: Offset(0, 4 * widget.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16 * widget.w,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 6 * widget.h),
          Divider(height: 1, color: Colors.grey.shade300),
          SizedBox(height: 8 * widget.h),

          Column(
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              if (item is Widget && item is! ConfigItem) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8 * widget.h),
                  child: item,
                );
              }

              final config = item as ConfigItem;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8 * widget.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(config.icon, size: 18, color: config.iconColor),
                        SizedBox(width: 10 * widget.w),
                        Text(
                          config.label,
                          style: TextStyle(
                            fontSize: 14 * widget.w,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    config.isToggle
                        ? SizedBox(
                            height: 22 * widget.h,
                            child: Transform.scale(
                              scale: 0.72,
                              child: Switch(
                                value: toggleValues[index],
                                activeTrackColor: Colors.green,
                                inactiveTrackColor: Colors.grey.shade300,
                                onChanged: (v) {
                                  setState(() => toggleValues[index] = v);
                                },
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: config.onTap,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black38,
                            ),
                          ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
