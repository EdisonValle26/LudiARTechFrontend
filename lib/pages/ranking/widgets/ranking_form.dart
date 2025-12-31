import 'package:LudiArtech/models/ranking_entry.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:flutter/material.dart';

import '../../../services/ranking_service.dart';
import 'participant_card.dart';
import 'participant_row.dart';

class RankingForm extends StatefulWidget {
  final double scale;
  const RankingForm({super.key, required this.scale});

  @override
  State<RankingForm> createState() => _RankingFormState();
}

class _RankingFormState extends State<RankingForm> {
  late Future<List<RankingEntry>> _rankingFuture;

  final RankingService rankingService =
      RankingService(ApiService(ApiConstants.baseUrl));

  @override
  void initState() {
    super.initState();
    _rankingFuture = _loadRanking();
  }

  Future<List<RankingEntry>> _loadRanking() async {
    final token = await TokenStorage.getToken();
    return rankingService.getRanking(token: token!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return FutureBuilder<List<RankingEntry>>(
      future: _rankingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (snapshot.hasError) {
        //   return Center(
        //     child: Text(
        //       "Error al cargar ranking",
        //       style: const TextStyle(color: Colors.red),
        //     ),
        //   );
        // }

        final ranking = snapshot.data!;

        final first = ranking.firstWhere((e) => e.position == 1);
        final second = ranking.firstWhere((e) => e.position == 2);
        final third = ranking.firstWhere((e) => e.position == 3);
        final others = ranking.where((e) => e.position > 3).toList();

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              w * 0.06 * widget.scale,
              h * 0.03 * widget.scale,
              w * 0.06 * widget.scale,
              h * 0.03 * widget.scale,
            ),
            child: Column(
              children: [
                _buildTop3Card(w, h, second, first, third),
                SizedBox(height: h * 0.03 * widget.scale),
                _buildOtherParticipantsCard(w, h, others),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTop3Card(
    double w,
    double h,
    RankingEntry second,
    RankingEntry first,
    RankingEntry third,
  ) {
    return Container(
      padding: EdgeInsets.all(w * 0.02 * widget.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ParticipantCard(
            scale: widget.scale,
            name: second.fullname,
            number: second.position,
            color: Colors.grey.shade400,
            colorNumber: Colors.grey.shade300,
            icon2: Icons.workspace_premium_outlined,
            points: second.points,
            crown: false,
            sizeFactor: 1,
          ),

          ParticipantCard(
            scale: widget.scale,
            name: first.fullname,
            number: first.position,
            color: Colors.amber.shade600,
            colorNumber: Colors.amber.shade500,
            icon2: Icons.emoji_events_outlined,
            points: first.points,
            crown: true,
            sizeFactor: 1.2,
          ),

          ParticipantCard(
            scale: widget.scale,
            name: third.fullname,
            number: third.position,
            color: Colors.brown.shade300,
            colorNumber: Colors.brown.shade200,
            icon2: Icons.military_tech_outlined,
            points: third.points,
            crown: false,
            sizeFactor: 1,
          ),
        ],
      ),
    );
  }


  Widget _buildOtherParticipantsCard(
    double w,
    double h,
    List<RankingEntry> others,
  ) {
    return Container(
      height: h * 0.30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: h * 0.015 * widget.scale),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x9F9F5EF0), Color(0xD5D512C8)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Text(
                "Otros participantes",
                style: TextStyle(
                  fontSize: w * 0.045 * widget.scale,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: others.length,
              itemBuilder: (context, index) {
                final p = others[index];
                return ParticipantRow(
                  scale: widget.scale,
                  number: p.position,
                  name: p.fullname,
                  points: p.points,
                  showDivider: index != others.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
