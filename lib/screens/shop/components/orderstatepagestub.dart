import 'package:flutter/material.dart';

class OrderStatePage extends StatelessWidget {
  final String orderNo;
  final String title;

  /// 0-based index of the current step in [steps]
  final int currentStep;

  /// Steps list (can be replaced by API later)
  final List<String> steps;

  /// Optional times per step: key = step string, value = DateTime
  final Map<String, DateTime?> times;

  OrderStatePage({
    Key? key,
    required this.orderNo,
    required this.title,
    int? currentStep,
    List<String>? steps,
    Map<String, DateTime?>? times,
  })  : currentStep = currentStep ?? 0,
        steps = steps ??
            const [
              'new',
              'fraudulent',
              'cancelled',
              'hold',
              'payment_received',
              'sample_collected',
              'processed',
              'report_delivered',
            ],
        times = times ?? const {},
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // const primary = Color(0xFF6C48B6); // purple
      const green = Color(0xFF1F7A53);
    const primary = Color(0xFF0F5C3F);
    const lineGrey = Color(0xFFE1D8F5);
    const textGrey = Color(0xFF6B7280);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order $orderNo'),
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: steps.length,
          itemBuilder: (context, i) {
            final s = steps[i];
            final isFirst = i == 0;
            final isLast = i == steps.length - 1;
            final isPast = i < currentStep;
            final isCurrent = i == currentStep;
            final dt = times[s];

            return _TimelineRow(
              index: i,
              label: _pretty(s),
              date: dt != null ? _fmtDate(dt) : null,
              time: dt != null ? _fmtTime(dt) : null,
              isFirst: isFirst,
              isLast: isLast,
              isPast: isPast,
              isCurrent: isCurrent,
              primary: primary,
              lineGrey: lineGrey,
              textGrey: textGrey,
            );
          },
        ),
      ),
    );
  }

  String _pretty(String raw) {
    // "sample_collected" -> "Sample Collected"
    return raw
        .split('_')
        .map((w) => w.isEmpty ? w : (w[0].toUpperCase() + w.substring(1)))
        .join(' ');
  }

  String _fmtDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d $monthName($m) $y';
  }

  String _fmtTime(DateTime dt) {
    final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h12:$m $ampm';
  }

  String monthName(String mm) {
    const names = {
      '01': 'January',
      '02': 'February',
      '03': 'March',
      '04': 'April',
      '05': 'May',
      '06': 'June',
      '07': 'July',
      '08': 'August',
      '09': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
    };
    return names[mm] ?? mm;
  }
}

// ====================== TIMELINE ROW ======================

class _TimelineRow extends StatelessWidget {
  final int index;
  final String label;
  final String? date;
  final String? time;
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final bool isCurrent;
  final Color primary;
  final Color lineGrey;
  final Color textGrey;

  const _TimelineRow({
    Key? key,
    required this.index,
    required this.label,
    required this.date,
    required this.time,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.isCurrent,
    required this.primary,
    required this.lineGrey,
    required this.textGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lineTopColor = isFirst ? Colors.transparent : (isPast || isCurrent ? primary : lineGrey);
    final lineBottomColor = isLast ? Colors.transparent : (isPast ? primary : lineGrey);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline rail + dot
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(height: 14, width: 2, color: lineTopColor),
              _Dot(
                isPast: isPast,
                isCurrent: isCurrent,
                index: index + 1,
                primary: primary,
              ),
              Container(height: 14, width: 2, color: lineBottomColor),
            ],
          ),
        ),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 4),
                // Date/time (optional)
                if (date != null || time != null)
                  Text(
                    [
                      if (time != null) time!,
                      if (date != null && time != null) '  •  ',
                      if (date != null) date!,
                    ].join(),
                    style: TextStyle(color: textGrey),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isPast;
  final bool isCurrent;
  final int index;
  final Color primary;

  const _Dot({
    Key? key,
    required this.isPast,
    required this.isCurrent,
    required this.index,
    required this.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // past -> filled with white ✓
    if (isPast) {
      return Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    }

    // current -> outlined
    if (isCurrent) {
      return Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primary, width: 3),
          color: Colors.white,
        ),
        child: Icon(Icons.edit, size: 14, color: primary), // small hint like screenshot
      );
    }

    // upcoming -> grey circle with step number
    return Container(
      height: 24,
      width: 24,
      decoration: const BoxDecoration(
        color: Color(0xFFBDBDBD),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$index',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
