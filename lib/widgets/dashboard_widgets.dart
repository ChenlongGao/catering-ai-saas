import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/* ── 大通栏 KPI 卡 ── */
class FullKpiCard extends StatelessWidget {
  final String value, label, trend;
  final bool trendUp;
  final VoidCallback? onTap;
  const FullKpiCard({super.key, required this.value, required this.label, required this.trend, this.trendUp = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -1, height: 1.0)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: trendUp ? const Color(0xFFE6F9F0) : const Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(trendUp ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: trendUp ? AppTheme.success : AppTheme.error),
                  const SizedBox(width: 2),
                  Text(trend, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: trendUp ? const Color(0xFF059669) : const Color(0xFFDC2626))),
                ]),
              ),
            ]),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
        ]),
      ),
    );
  }
}

/* ── 小 KPI 卡 ── */
class HalfKpiCard extends StatelessWidget {
  final String value, label, trend;
  final bool trendUp;
  final VoidCallback? onTap;
  const HalfKpiCard({super.key, required this.value, required this.label, required this.trend, this.trendUp = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: trendUp ? const Color(0xFFE6F9F0) : const Color(0xFFFDE8E8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(trendUp ? Icons.arrow_upward : Icons.arrow_downward, size: 10, color: trendUp ? AppTheme.success : AppTheme.error),
                const SizedBox(width: 1),
                Text(trend, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: trendUp ? const Color(0xFF059669) : const Color(0xFFDC2626))),
              ]),
            ),
          ]),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ]),
      ),
    );
  }
}

/* ── 趋势图（带刻度） ── */
class TrendChart extends StatelessWidget {
  final String title;
  final List<double> data;
  final Color color;
  final String unit;
  const TrendChart({super.key, required this.title, required this.data, required this.color, this.unit = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        SizedBox(height: 160, child: CustomPaint(size: Size.infinite, painter: _TrendP(data: data, color: color, unit: unit))),
      ]),
    );
  }
}

class _TrendP extends CustomPainter {
  final List<double> data;
  final Color color;
  final String unit;
  _TrendP({required this.data, required this.color, required this.unit});

  @override
  void paint(Canvas cvs, Size sz) {
    if (data.length < 2) return;
    final mx = data.reduce((a, b) => a > b ? a : b);
    final mn = data.reduce((a, b) => a < b ? a : b);
    final r = mx - mn > 0 ? mx - mn : 1;
    final step = sz.width / (data.length - 1);
    const pad = 24.0, bot = 24.0, top = 4.0;
    final chartH = sz.height - bot - top;

    // Fill
    final fill = Path()..moveTo(0, sz.height - bot);
    for (int i = 0; i < data.length; i++) {
      final y = sz.height - bot - ((data[i] - mn) / r) * chartH;
      i == 0 ? fill.lineTo(0, y) : fill.lineTo(i * step, y);
    }
    fill..lineTo(sz.width, sz.height - bot)..close();
    cvs.drawPath(fill, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.0)]).createShader(Rect.fromLTWH(0, 0, sz.width, sz.height)));

    // Line
    final line = Path();
    for (int i = 0; i < data.length; i++) {
      final y = sz.height - bot - ((data[i] - mn) / r) * chartH;
      i == 0 ? line.moveTo(0, y) : line.lineTo(i * step, y);
    }
    cvs.drawPath(line, Paint()..color = color..strokeWidth = 2.2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);

    // End dot
    final lx = (data.length - 1) * step;
    final ly = sz.height - bot - ((data.last - mn) / r) * chartH;
    cvs.drawCircle(Offset(lx, ly), 5, Paint()..color = Colors.white);
    cvs.drawCircle(Offset(lx, ly), 4, Paint()..color = color);

    // Y axis labels (max / min)
    final tp = TextPainter(textDirection: TextDirection.ltr);
    tp.text = TextSpan(text: '${(mx / 1000).toStringAsFixed(1)}K$unit', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary));
    tp.layout(); tp.paint(cvs, Offset(pad - tp.width - 4, top));
    tp.text = TextSpan(text: '${(mn / 1000).toStringAsFixed(1)}K', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary));
    tp.layout(); tp.paint(cvs, Offset(pad - tp.width - 4, sz.height - bot - 12));

    // X labels
    final steps = [0, data.length ~/ 4, data.length ~/ 2, data.length * 3 ~/ 4, data.length - 1];
    tp.text = TextSpan(text: '', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary));
    for (final s in steps.where((s) => s < data.length)) {
      tp.text = TextSpan(text: '${s + 1}', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary));
      tp.layout(); tp.paint(cvs, Offset(s * step - tp.width / 2, sz.height - 14));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => true;
}

/* ── 排行榜柱状图 ── */
class BarChart extends StatelessWidget {
  final String title;
  final List<BarItem> items;
  final Color color;
  const BarChart({super.key, required this.title, required this.items, required this.color});

  @override
  Widget build(BuildContext context) {
    final mx = items.map((i) => i.value).reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        ...items.take(8).map((i) {
          final w = (i.value / mx).clamp(0.05, 1.0);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              SizedBox(width: 22, child: Text('${items.indexOf(i) + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(i.name, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 6),
                  Text(i.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: FractionallySizedBox(
                    widthFactor: w,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.5)]),
                      ),
                    ),
                  ),
                ),
              ])),
            ]),
          );
        }),
      ]),
    );
  }
}

class BarItem {
  final String name;
  final double value;
  final String label;
  const BarItem({required this.name, required this.value, required this.label});
}

/* ── 版块标题 ── */
class SecTitle extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const SecTitle({super.key, required this.text, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text)),
      ]),
    );
  }
}
