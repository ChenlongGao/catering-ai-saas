import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dashboard_widgets.dart';
import '../../widgets/filter_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _period = '近30天';
  String _store = '全部门店';

  // 时段数据

  // 根据时段返回不同数据
  double _rev() { switch (_period) { case '昨日': return 46768; case '近7天': return 323840; case '近30天': return 1385600; default: return 52380; } }
  int _ord() { switch (_period) { case '昨日': return 1182; case '近7天': return 8200; case '近30天': return 35120; default: return 1286; } }
  double _asp() { switch (_period) { case '昨日': return 39.6; case '近7天': return 39.5; case '近30天': return 40.1; default: return 40.7; } }
  double _turn() { switch (_period) { case '昨日': return 3.1; case '近7天': return 3.3; case '近30天': return 3.4; default: return 3.2; } }
  double _margin() { switch (_period) { case '昨日': return 63.8; case '近7天': return 64.0; case '近30天': return 64.5; default: return 64.3; } }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Image.asset('assets/images/logo.png', width: 32, height: 32), const SizedBox(width: 10), const Text('云盯360')]),
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined, size: 22), onPressed: () {})],
      ),
      body: Column(children: [
        FilterBar(period: _period, store: _store, onPeriod: (p) => setState(() => _period = p), onStore: (s) => setState(() => _store = s)),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
          child: Column(children: [
            _operation(),
      const SizedBox(height: AppTheme.sectionGap),
      _location(),
      const SizedBox(height: AppTheme.sectionGap),
      _traffic(),
      const SizedBox(height: AppTheme.sectionGap),
      _inspection(),
      const SizedBox(height: AppTheme.sectionGap),
            _training(),
          ]),
        )),
      ]),
    );
  }

  // ═══ 经营 ═══
  Widget _operation() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SecTitle(text: '经营数据', icon: Icons.trending_up, color: AppTheme.primary),
      FullKpiCard(value: '${(_rev() / 10000).toStringAsFixed(1)}万', label: '总营收（元）', trend: '+12%', trendUp: true),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '${_ord()}', label: '总单量（笔）', trend: '+8%', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '${_asp().toStringAsFixed(1)}', label: '客单价（元）', trend: '-3%', trendUp: false)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '${_turn().toStringAsFixed(1)}', label: '翻台率（次）', trend: '+0.3', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '${_margin().toStringAsFixed(1)}', label: '毛利率（%）', trend: '+2.1%', trendUp: true)),
      ]),
      const SizedBox(height: 16),
      TrendChart(title: '营收趋势', data: List.generate(30, (i) => 38000 + Random(i).nextInt(22000).toDouble()), color: AppTheme.primary, unit: '元'),
      const SizedBox(height: 16),
      BarChart(title: '门店营收排名', color: AppTheme.primary, items: const [
        BarItem(name: '茶颜悦色·新街口店', value: 9.8, label: '¥9.8K'),
        BarItem(name: '茶颜悦色·太平街店', value: 9.2, label: '¥9.2K'),
        BarItem(name: '茶颜悦色·华强北店', value: 8.6, label: '¥8.6K'),
        BarItem(name: '茶颜悦色·江汉路店', value: 7.9, label: '¥7.9K'),
        BarItem(name: '茶颜悦色·湖滨银泰店', value: 7.2, label: '¥7.2K'),
        BarItem(name: '茶颜悦色·五一广场店', value: 6.8, label: '¥6.8K'),
        BarItem(name: '茶颜悦色·光谷店', value: 5.5, label: '¥5.5K'),
        BarItem(name: '茶颜悦色·步行街店', value: 4.9, label: '¥4.9K'),
      ]),
    ]);
  }

  // ═══ 选址 ═══
  Widget _location() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SecTitle(text: '选址拓店', icon: Icons.location_on, color: AppTheme.accent),
      FullKpiCard(value: '108家', label: '已开业门店', trend: '+5家', trendUp: true),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '6', label: '待开业', trend: '+2', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '12', label: '选址评估中', trend: '+3', trendUp: true)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '14月', label: '平均回本周期', trend: '-2月', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '86%', label: '选址成功率', trend: '+5%', trendUp: true)),
      ]),
      const SizedBox(height: 16),
      TrendChart(title: '月度新开店数', data: [2, 3, 1, 4, 2, 5, 3, 2, 4, 3, 1, 2], color: AppTheme.accent, unit: '家'),
      const SizedBox(height: 16),
      BarChart(title: '商圈潜力排名', color: AppTheme.accent, items: const [
        BarItem(name: '杭州·西溪商圈', value: 92, label: '92分'),
        BarItem(name: '成都·春熙路商圈', value: 88, label: '88分'),
        BarItem(name: '深圳·南山科技园', value: 85, label: '85分'),
        BarItem(name: '武汉·光谷商圈', value: 82, label: '82分'),
        BarItem(name: '南京·新街口商圈', value: 79, label: '79分'),
        BarItem(name: '上海·陆家嘴商圈', value: 75, label: '75分'),
        BarItem(name: '北京·三里屯商圈', value: 72, label: '72分'),
        BarItem(name: '广州·天河商圈', value: 68, label: '68分'),
      ]),
    ]);
  }

  // ═══ 客流 ═══
  Widget _traffic() {
    final vc = AppTheme.trafficColor; // blue
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SecTitle(text: '客流分析', icon: Icons.people, color: vc),
      FullKpiCard(value: '18,560', label: '今日总客流（人次）', trend: '+15%', trendUp: true),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '32.5%', label: '进店转化率', trend: '+2%', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '22min', label: '平均停留时长', trend: '+3', trendUp: true)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '58%', label: '会员占比', trend: '-2%', trendUp: false)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '42%', label: '新客占比', trend: '+5%', trendUp: true)),
      ]),
      const SizedBox(height: 16),
      TrendChart(title: '客流时段分布', data: _hourly(), color: vc, unit: '人'),
      const SizedBox(height: 16),
      BarChart(title: '门店客流排名', color: vc, items: const [
        BarItem(name: '茶颜悦色·太平街店', value: 3200, label: '3200人'),
        BarItem(name: '茶颜悦色·新街口店', value: 2900, label: '2900人'),
        BarItem(name: '茶颜悦色·五一广场店', value: 2650, label: '2650人'),
        BarItem(name: '茶颜悦色·江汉路店', value: 2400, label: '2400人'),
        BarItem(name: '茶颜悦色·华强北店', value: 2150, label: '2150人'),
        BarItem(name: '茶颜悦色·湖滨银泰店', value: 1980, label: '1980人'),
        BarItem(name: '茶颜悦色·光谷店', value: 1600, label: '1600人'),
        BarItem(name: '茶颜悦色·步行街店', value: 1350, label: '1350人'),
      ]),
    ]);
  }

  List<double> _hourly() {
    final r = Random(42);
    return List.generate(24, (i) {
      if (i < 7) return r.nextInt(80).toDouble();
      if (i < 10) return 120 + r.nextInt(200).toDouble();
      if (i < 14) return 300 + r.nextInt(300).toDouble();
      if (i < 17) return 180 + r.nextInt(200).toDouble();
      if (i < 20) return 220 + r.nextInt(250).toDouble();
      return 80 + r.nextInt(120).toDouble();
    });
  }

  // ═══ 巡检 ═══
  Widget _inspection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SecTitle(text: '巡检合规', icon: Icons.visibility, color: AppTheme.success),
      FullKpiCard(value: '94%', label: '巡检完成率', trend: '+3%', trendUp: true),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '87%', label: '问题整改率', trend: '-5%', trendUp: false)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '98.2', label: '食安合规率（%）', trend: '+1', trendUp: true)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '86.5', label: '平均巡检得分', trend: '+2.3', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '23', label: '待整改问题数', trend: '-4', trendUp: true)),
      ]),
      const SizedBox(height: 16),
      TrendChart(title: '巡检得分趋势', data: [82, 84, 83, 86, 85, 87, 86.5], color: AppTheme.success, unit: '分'),
      const SizedBox(height: 16),
      BarChart(title: '门店巡检得分排名', color: AppTheme.success, items: const [
        BarItem(name: '茶颜悦色·新街口店', value: 96, label: '96分'),
        BarItem(name: '茶颜悦色·华强北店', value: 94, label: '94分'),
        BarItem(name: '茶颜悦色·太平街店', value: 92, label: '92分'),
        BarItem(name: '茶颜悦色·江汉路店', value: 89, label: '89分'),
        BarItem(name: '茶颜悦色·湖滨银泰店', value: 87, label: '87分'),
        BarItem(name: '茶颜悦色·五一广场店', value: 84, label: '84分'),
        BarItem(name: '茶颜悦色·光谷店', value: 78, label: '78分'),
        BarItem(name: '茶颜悦色·解放西路店', value: 72, label: '72分'),
      ]),
    ]);
  }

  // ═══ 培训 ═══
  Widget _training() {
    final tc = AppTheme.trainingColor; // purple
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SecTitle(text: '培训管理', icon: Icons.school, color: tc),
      FullKpiCard(value: '82%', label: '培训完成率', trend: '+6%', trendUp: true),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '91.3', label: '考试通过率（%）', trend: '+2', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '6.2h', label: '人均培训时长', trend: '-0.5', trendUp: false)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: HalfKpiCard(value: '88%', label: '技能达标率', trend: '+4%', trendUp: true)),
        const SizedBox(width: 10),
        Expanded(child: HalfKpiCard(value: '18', label: '不及格人数', trend: '-3', trendUp: true)),
      ]),
      const SizedBox(height: 16),
      TrendChart(title: '培训完成率趋势', data: [75, 78, 80, 82, 83, 82], color: tc, unit: '%'),
      const SizedBox(height: 16),
      BarChart(title: '门店培训完成率排名', color: tc, items: const [
        BarItem(name: '茶颜悦色·新街口店', value: 98, label: '98%'),
        BarItem(name: '茶颜悦色·太平街店', value: 95, label: '95%'),
        BarItem(name: '茶颜悦色·华强北店', value: 92, label: '92%'),
        BarItem(name: '茶颜悦色·江汉路店', value: 88, label: '88%'),
        BarItem(name: '茶颜悦色·湖滨银泰店', value: 85, label: '85%'),
        BarItem(name: '茶颜悦色·五一广场店', value: 80, label: '80%'),
        BarItem(name: '茶颜悦色·光谷店', value: 72, label: '72%'),
        BarItem(name: '茶颜悦色·解放西路店', value: 65, label: '65%'),
      ]),
    ]);
  }
}
