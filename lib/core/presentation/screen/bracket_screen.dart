import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/appbar_lomba.dart';
import 'package:attandance_simple/core/cubit/cubit_bracket/bracket_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_bracket/bracket_state.dart';
import 'package:attandance_simple/core/models/bracket/get_bracket_public/get_bracket_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BracketScreen extends StatefulWidget {
  final String namaLogo;
  final String ekskul;
  final String namaLomba;
  final String statusLomba;
  final int teamRaceId;

  const BracketScreen({
    Key? key,
    required this.namaLogo,
    required this.ekskul,
    required this.namaLomba,
    required this.statusLomba,
    required this.teamRaceId,
  }) : super(key: key);

  @override
  State<BracketScreen> createState() => _BracketScreenState();
}

class _BracketScreenState extends State<BracketScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BracketCubit>().getTeam(widget.teamRaceId);
  }

  void _eliminateInRound(int roundIdx, int pos, GetBracketPublic bracket) {
    if (roundIdx == 1) {
      // semifinal
      if (pos < 2) {
        context.read<BracketCubit>().setWinnerMatch1(
          widget.teamRaceId,
          pos == 0
              ? (bracket.data?.nameTeam1 ?? "")
              : (bracket.data?.nameTeam2 ?? ""),
        );
      } else {
        context.read<BracketCubit>().setWinnerMatch2(
          widget.teamRaceId,
          pos == 2
              ? (bracket.data?.nameTeam3 ?? "")
              : (bracket.data?.nameTeam4 ?? ""),
        );
      }
    } else if (roundIdx == 2) {
      // final
      context.read<BracketCubit>().setChampion(
        widget.teamRaceId,
        pos == 0
            ? (bracket.data?.winnerMatch1 ?? "")
            : (bracket.data?.winnerMatch2 ?? ""),
      );
    }
  }

  Widget _teamBox(
    String? text,
    double w, {
    VoidCallback? onDoubleTap,
    bool eliminated = false,
  }) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: w,
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: eliminated ? Colors.grey[100] : Colors.white,
          border: Border.all(
            color: eliminated ? Colors.grey.shade300 : Colors.grey.shade400,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text ?? '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: eliminated ? Colors.grey[400] : Colors.black87,
            decoration: eliminated
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildBracket(GetBracketPublic data, double width, double height) {
    final round1 = [
      data.data?.nameTeam1,
      data.data?.nameTeam2,
      data.data?.nameTeam3,
      data.data?.nameTeam4,
    ];
    final round2 = [data.data?.winnerMatch1, data.data?.winnerMatch2];
    final finalWinner = data.data?.champion;

    return Center(
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width * 0.93, height),
            painter: Bracket4Painter(),
          ),
          SizedBox(
            width: width * 0.93,
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: width * 0.23,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (i) {
                      return _teamBox(
                        round1[i],
                        width * 0.19,
                        onDoubleTap: (round1[i] != null && finalWinner == null)
                            ? () => _eliminateInRound(1, i, data)
                            : null,
                        eliminated: round1[i] == null,
                      );
                    }),
                  ),
                ),
                SizedBox(
                  width: width * 0.18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 25),
                      _teamBox(
                        round2[0],
                        width * 0.16,
                        onDoubleTap: (round2[0] != null && finalWinner == null)
                            ? () => _eliminateInRound(2, 0, data)
                            : null,
                        eliminated: round2[0] == null,
                      ),
                      _teamBox(
                        round2[1],
                        width * 0.16,
                        onDoubleTap: (round2[1] != null && finalWinner == null)
                            ? () => _eliminateInRound(2, 1, data)
                            : null,
                        eliminated: round2[1] == null,
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_teamBox(finalWinner, width * 0.16)],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: height / 2 - 38,
            child: Column(
              children: const [
                Icon(Icons.emoji_events, color: Colors.amber, size: 44),
                SizedBox(height: 6),
                Text(
                  "Champion",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * 0.60;

    return Scaffold(
      appBar: AppbarLomba(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.ekskul,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              widget.namaLomba,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              widget.statusLomba,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<BracketCubit, BracketState>(
                builder: (context, state) {
                  if (state is BracketLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BracketLoaded) {
                    return _buildBracket(state.bracket, width, height);
                  } else if (state is Match1Updated || state is Match2Updated) {
                    // reload bracket setelah semifinal
                    context.read<BracketCubit>().getTeam(widget.teamRaceId);
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChampionUpdated) {
                    // ✅ setelah champion di-set, balik ke TeamScreen
                    Future.microtask(() {
                      Navigator.pop(context, true); // return flag true
                    });
                    return const SizedBox();
                  } else if (state is BracketError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bracket4Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 3;

    double boxHeight = 35, boxSpacing = (size.height - 4 * 38) / 3;
    double col1 = 20, col2 = col1 + 30, col3 = col2 + 90;

    List<double> y = [
      0,
      boxHeight + boxSpacing,
      2 * (boxHeight + boxSpacing),
      3 * (boxHeight + boxSpacing),
    ];

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(col1, y[i] + boxHeight / 2),
        Offset(col2, y[i] + boxHeight / 2),
        paint,
      );
    }

    canvas.drawLine(
      Offset(col2, y[0] + boxHeight / 2),
      Offset(col2, y[1] + boxHeight / 2),
      paint,
    );
    canvas.drawLine(
      Offset(col2, y[2] + boxHeight / 2),
      Offset(col2, y[3] + boxHeight / 2),
      paint,
    );

    canvas.drawLine(
      Offset(col2, (y[0] + y[1]) / 2 + boxHeight / 2),
      Offset(col3, (y[0] + y[1]) / 2 + boxHeight / 2),
      paint,
    );
    canvas.drawLine(
      Offset(col2, (y[2] + y[3]) / 2 + boxHeight / 2),
      Offset(col3, (y[2] + y[3]) / 2 + boxHeight / 2),
      paint,
    );

    canvas.drawLine(
      Offset(col3, (y[0] + y[1]) / 2 + boxHeight / 2),
      Offset(col3, (y[2] + y[3]) / 2 + boxHeight / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
