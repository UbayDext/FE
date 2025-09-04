import 'dart:math' as math;
import 'package:attandance_simple/core/component/appbar_ekskul.dart';
import 'package:attandance_simple/core/cubit/cubit_rekap/rekap_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_rekap/rekap_state.dart';
import 'package:attandance_simple/core/presentation/screen/attendance_ekskul_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateEkskulView extends StatelessWidget {
  final String namaEkskul;
  final String infoEkskul;

  const DateEkskulView({
    super.key,
    required this.namaEkskul,
    required this.infoEkskul,
  });

  String _fmt(DateTime d) => DateFormat('d MMMM y', 'id_ID').format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarEkskul(),
      body: BlocBuilder<RekapCubit, RekapState>(
        builder: (context, state) {
          final cubit = context.read<RekapCubit>();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'Jadwal Kehadiran untuk:',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  namaEkskul,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // === DeskCalendar (custom) ===
                DeskCalendar(
                  initialMonth: state.selectedDate,
                  selected: state.selectedDate,
                  startOnMonday: true,
                  onDaySelected: (d) => cubit.setDate(d),
                ),

                const SizedBox(height: 12),

                // Rekap ringkas per status
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Colors.grey[50],
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _fmt(state.selectedDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _rekapItem('Hadir', state.h, Colors.green),
                            _rekapItem('Izin', state.i, Colors.blue),
                            _rekapItem('Sakit', state.s, Colors.orange),
                            _rekapItem('Alpa', state.a, Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.playlist_add_check),
                    label: const Text('Lihat Kehadiran Ekskul'),
                    onPressed: () async {
                      final rekapCubit = context.read<RekapCubit>();
                      final currentState = rekapCubit.state;
                      final bool? saveSuccess = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttendanceEkskulScreen(
                            namaEkskul: namaEkskul,
                            selectedDate: currentState.selectedDate,
                            ekskulId: rekapCubit.ekskulId,
                            classroomId: rekapCubit.classroomId,
                            studiId: rekapCubit.studiId,
                          ),
                        ),
                      );
                      if (saveSuccess == true && context.mounted) {
                        rekapCubit.fetch();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _rekapItem(String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}

/// =======================
///  DESK CALENDAR WIDGET
/// =======================
class DeskCalendar extends StatefulWidget {
  final DateTime initialMonth; // bulan yang ditampilkan
  final DateTime selected; // tanggal terpilih (sinkron dengan Cubit)
  final bool startOnMonday; // Senin sebagai awal pekan
  final ValueChanged<DateTime>? onDaySelected;

  const DeskCalendar({
    super.key,
    required this.initialMonth,
    required this.selected,
    this.startOnMonday = true,
    this.onDaySelected,
  });

  @override
  State<DeskCalendar> createState() => _DeskCalendarState();
}

class _DeskCalendarState extends State<DeskCalendar> {
  late DateTime _visibleMonth; // tanggal apa pun di bulan yang tampil
  static const _corner = 16.0;
  static const _coilHeight = 28.0;

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(
      widget.initialMonth.year,
      widget.initialMonth.month,
      1,
    );
  }

  @override
  void didUpdateWidget(covariant DeskCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika selected berpindah bulan dari luar, sinkronkan
    if (oldWidget.selected.year != widget.selected.year ||
        oldWidget.selected.month != widget.selected.month) {
      _visibleMonth = DateTime(widget.selected.year, widget.selected.month, 1);
    }
  }

  void _prevMonth() => setState(() {
    _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
  });
  void _nextMonth() => setState(() {
    _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
  });

  @override
  Widget build(BuildContext context) {
    final days = _generateDays(
      _visibleMonth,
      startOnMonday: widget.startOnMonday,
    );
    final monthName = _monthName(_visibleMonth).toUpperCase();

    return Material(
      elevation: 6,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_corner),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_corner),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_corner),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Spiral binder
              SizedBox(
                height: _coilHeight,
                child: CustomPaint(
                  painter: _SpiralBindingPainter(),
                  child: const SizedBox.expand(),
                ),
              ),

              // Header bulan + prev/next
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _prevMonth,
                      icon: const Icon(Icons.chevron_left, size: 28),
                    ),
                    Expanded(
                      child: Text(
                        monthName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          letterSpacing: 2,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _nextMonth,
                      icon: const Icon(Icons.chevron_right, size: 28),
                    ),
                  ],
                ),
              ),

              // Baris nama hari
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xffEFECEF))),
                ),
                child: Row(
                  children: _weekdayLabels(widget.startOnMonday)
                      .map(
                        (e) => Expanded(
                          child: Center(
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff9BA1A6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              // Grid 6x7
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 14),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final cellW = (c.maxWidth - 6 * 6) / 7;
                    return Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(42, (i) {
                        final item = days[i];
                        final isSelected = _isSameDate(
                          item.date,
                          widget.selected,
                        );
                        final isToday = _isSameDate(item.date, DateTime.now());
                        return _DayCell(
                          width: cellW,
                          day: item.date.day,
                          inMonth: item.inMonth,
                          isToday: isToday,
                          isSelected: isSelected,
                          onTap: () => widget.onDaySelected?.call(item.date),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helpers
  List<_DayItem> _generateDays(DateTime month, {required bool startOnMonday}) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = first.weekday; // Mon=1..Sun=7

    final startOffset = startOnMonday
        ? (firstWeekday - 1) % 7
        : (firstWeekday % 7);
    final totalDays = last.day;
    final List<_DayItem> out = [];

    // leading
    for (int i = startOffset - 1; i >= 0; i--) {
      final d = first.subtract(Duration(days: i + 1));
      out.add(_DayItem(date: d, inMonth: false));
    }
    // current month
    for (int d = 1; d <= totalDays; d++) {
      out.add(
        _DayItem(date: DateTime(month.year, month.month, d), inMonth: true),
      );
    }
    // trailing sampai 42
    while (out.length < 42) {
      final lastDate = out.last.date;
      out.add(
        _DayItem(date: lastDate.add(const Duration(days: 1)), inMonth: false),
      );
    }
    return out;
  }

  String _monthName(DateTime dt) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[dt.month - 1];
  }

  List<String> _weekdayLabels(bool startOnMonday) {
    const monFirst = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];
    const sunFirst = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
    return startOnMonday ? monFirst : sunFirst;
  }

  bool _isSameDate(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayItem {
  final DateTime date;
  final bool inMonth;
  _DayItem({required this.date, required this.inMonth});
}

class _DayCell extends StatelessWidget {
  final double width;
  final int day;
  final bool inMonth;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayCell({
    super.key,
    required this.width,
    required this.day,
    required this.inMonth,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? const Color(0xffE7F0FF) : Colors.white;

    // Perbaikan: gunakan BorderSide, bukan Border
    final BorderSide borderSide = isSelected
        ? const BorderSide(color: Color(0xff3B82F6), width: 2)
        : const BorderSide(color: Color(0xffECEBED), width: 1);

    final textColor = inMonth
        ? const Color(0xff2A2F33)
        : const Color(0xffB9BDC2);

    return SizedBox(
      width: width,
      height: width * 0.9,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: borderSide, // <-- fixed
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 8,
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
              if (isToday)
                const Positioned(
                  right: 8,
                  bottom: 8,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xff22C55E),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Spiral binding dekoratif
class _SpiralBindingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final coilCount = (size.width / 22).floor();
    final centerY = size.height * 0.55;

    final linePaint = Paint()
      ..color = const Color(0xffE6E3E9)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), linePaint);

    final ringPaint = Paint()
      ..color = const Color(0xffBFC3C9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < coilCount; i++) {
      final cx = 12 + i * 22;
      const r = 7.5;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx.toDouble(), centerY - 4), radius: r),
        math.pi * 0.2,
        math.pi * 1.6,
        false,
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
