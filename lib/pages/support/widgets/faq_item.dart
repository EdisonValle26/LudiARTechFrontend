import 'package:flutter/material.dart';

class FAQItem extends StatefulWidget {
  final IconData icon;
  final String question;
  final String answer;
  final double scale;

  const FAQItem({
    super.key,
    required this.icon,
    required this.question,
    required this.answer,
    required this.scale,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(14 * widget.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * widget.scale),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(widget.icon, size: 28 * widget.scale, color: Colors.deepPurple),
              SizedBox(width: 12 * widget.scale),
              Expanded(
                child: Text(
                  widget.question,
                  style: TextStyle(
                    fontSize: 16 * widget.scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 28 * widget.scale,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          if (_expanded)
            Padding(
              padding: EdgeInsets.only(
                top: 12 * widget.scale,
                left: 4 * widget.scale,
                right: 4 * widget.scale,
              ),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 14 * widget.scale,
                  color: Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
