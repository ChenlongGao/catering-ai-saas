import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../inspection/inspection_page.dart';
import '../training/training_page.dart';
import '../delivery/delivery_page.dart';
import '../location/location_page.dart';

class AppCenterPage extends StatelessWidget {
  const AppCenterPage({super.key});

  static final _apps = [
    _AppInfo(title: 'AI 一键巡检', desc: '门店设备巡检 · AI抓图 · 智能评分', icon: Icons.visibility, color: AppTheme.appColors[0], badge: '核心功能', page: const InspectionPage()),
    _AppInfo(title: 'AI 陪练打卡', desc: '拍照录像分析 · 流程规范打分', icon: Icons.school, color: AppTheme.appColors[3], badge: '新上线', page: const TrainingPage()),
    _AppInfo(title: 'AI 外卖追溯', desc: '扫码查订单 · 录像回溯出餐流程', icon: Icons.delivery_dining, color: AppTheme.appColors[2], badge: '热更新', page: const DeliveryPage()),
    _AppInfo(title: 'AI 智能选址', desc: '业态参数分析 · 竞品客流 · 营收预估', icon: Icons.location_on, color: AppTheme.appColors[1], badge: '推荐', page: const LocationPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('应用中心')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 顶部 Banner（保持渐变，这是装饰不是卡片）
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accentLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22)),
                const SizedBox(width: 12),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('云盯AI 智能应用', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text('四大AI引擎，助力智慧餐饮管理', style: TextStyle(fontSize: 13, color: Colors.white70)),
                ]),
              ]),
            ]),
          ),
          const SizedBox(height: AppTheme.sectionGap),

          const Text('AI 智能应用', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          ...List.generate((_apps.length / 2).ceil(), (row) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(children: [
              Expanded(child: _card(context, _apps[row * 2])),
              if (row * 2 + 1 < _apps.length) ...[const SizedBox(width: 12), Expanded(child: _card(context, _apps[row * 2 + 1]))],
            ]),
          )),
          const SizedBox(height: AppTheme.sectionGap),

          const Text('其他工具', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _tool(Icons.qr_code_scanner, '扫码巡检', '扫描设备二维码', () {})),
            const SizedBox(width: 12),
            Expanded(child: _tool(Icons.bar_chart, '数据报表', '巡检查看统计', () {})),
          ]),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _card(BuildContext context, _AppInfo app) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => app.page)),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: AppTheme.cardDecoration,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: app.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(app.icon, color: app.color, size: 22)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: app.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(app.badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: app.color))),
          ]),
          const SizedBox(height: 14),
          Text(app.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(app.desc, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(children: [Text('进入应用', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: app.color)), const SizedBox(width: 4), Icon(Icons.arrow_forward, size: 14, color: app.color)]),
        ]),
      ),
    );
  }

  Widget _tool(IconData icon, String title, String desc, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.appColors[3].withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppTheme.appColors[3], size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), const SizedBox(height: 2), Text(desc, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))])),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18, color: AppTheme.textSecondary),
        ]),
      ),
    );
  }
}

class _AppInfo {
  final String title, desc, badge;
  final IconData icon;
  final Color color;
  final Widget page;
  const _AppInfo({required this.title, required this.desc, required this.icon, required this.color, required this.badge, required this.page});
}
