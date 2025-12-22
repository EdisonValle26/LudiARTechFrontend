import 'package:flutter/material.dart';

import 'participant_card.dart';
import 'participant_row.dart';

class RankingForm extends StatelessWidget {
  final double scale;
  const RankingForm({super.key, required this.scale});

  final List<Map<String, dynamic>> otherParticipants = const [
    {"number": 4, "name": "Juan Pérez", "points": 2300},
    {"number": 5, "name": "Lucía Torres", "points": 2250},
    {"number": 6, "name": "Mario Sánchez", "points": 2100},
    {"number": 7, "name": "Diana López", "points": 2000},
    {"number": 8, "name": "Diana López", "points": 2000},
    {"number": 9, "name": "Diana López", "points": 2000},
    {"number": 10, "name": "Diana López", "points": 2000},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          w * 0.06 * scale,
          h * 0.03 * scale,
          w * 0.06 * scale,
          h * 0.03 * scale,
        ),
        child: Column(
          children: [
            _buildTop3Card(w, h),
            SizedBox(height: h * 0.03 * scale),
            _buildOtherParticipantsCard(w, h),
          ],
        ),
      ),
    );
  }

  Widget _buildTop3Card(double w, double h) {
    return Container(
      padding: EdgeInsets.all(w * 0.02 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ParticipantCard(
            scale: scale,
            name: "Angeles Narea",
            number: 2,
            color: Colors.grey.shade400,
            colorNumber: Colors.grey.shade300,
            icon1: Icons.person_2_outlined,
            icon2: Icons.workspace_premium_outlined,
            points: 2850,
            crown: false,
            sizeFactor: 1,
          ),
          ParticipantCard(
            scale: scale,
            name: "Carlos Ruiz",
            number: 1,
            color: Colors.amber.shade600,
            colorNumber: Colors.amber.shade500,
            icon1: Icons.person_3_outlined,
            icon2: Icons.emoji_events_outlined,
            points: 3200,
            crown: true,
            sizeFactor: 1.2,
          ),
          ParticipantCard(
            scale: scale,
            name: "Pedro Soto",
            number: 3,
            color: Colors.brown.shade300,
            colorNumber: Colors.brown.shade200,
            icon1: Icons.person_4_outlined,
            icon2: Icons.military_tech_outlined,
            points: 2600,
            crown: false,
            sizeFactor: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildOtherParticipantsCard(double w, double h) {
    return Container(
      height: h * 0.30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: h * 0.015 * scale),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x9F9F5EF0),
                  Color(0xD5D512C8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Text(
                "Otros participantes",
                style: TextStyle(
                  fontSize: w * 0.045 * scale,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: otherParticipants.length,
              itemBuilder: (context, index) {
                final p = otherParticipants[index];
                return ParticipantRow(
                  scale: scale,
                  number: p["number"],
                  name: p["name"],
                  points: p["points"],
                  showDivider: index != otherParticipants.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
