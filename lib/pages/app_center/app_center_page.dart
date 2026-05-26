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
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('应用中心')),
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

          Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome, color: AppTheme.primary, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('智能应用', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),

          ...List.generate((_apps.length / 2).ceil(), (row) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(children: [
              Expanded(child: _card(context, _apps[row * 2])),
              if (row * 2 + 1 < _apps.length) ...[const SizedBox(width: 12), Expanded(child: _card(context, _apps[row * 2 + 1]))],
            ]),
          )),
          const SizedBox(height: AppTheme.sectionGap),

          // ── 5 个业务应用模块 ──
          _moduleSection('经营管理', Icons.analytics, Color(0xFF6366F1), [
            _ToolItem('数据总览', '营收/成本/利润总览', Icons.dashboard),
            _ToolItem('订单查询', '搜索门店全量订单', Icons.search),
            _ToolItem('报表导出', '一键导出运营报表', Icons.file_download),
            _ToolItem('销售分析', 'Top菜品与滞销分析', Icons.restaurant_menu),
            _ToolItem('异常跟踪', '销售异常自动预警', Icons.warning_amber),
          ]),
          _moduleSection('选址拓店', Icons.add_business, Color(0xFF0EA2B8), [
            _ToolItem('进度总览', '拓展门店推进状态', Icons.map),
            _ToolItem('新增门店', '录入新店选址信息', Icons.add_location),
            _ToolItem('商圈地图', '可视化商圈热力图', Icons.public),
            _ToolItem('档案管理', '全量门店基础档案', Icons.folder),
            _ToolItem('效果复盘', '已开店经营数据对照', Icons.replay),
          ]),
          _moduleSection('客流分析', Icons.traffic, Color(0xFF10B981), [
            _ToolItem('数据总览', '到店人次/转化率', Icons.insights),
            _ToolItem('客流监控', '各门店实时进店数', Icons.monitor),
            _ToolItem('翻台监测', '翻台效率实时分析', Icons.autorenew),
            _ToolItem('时段分析', '高峰低谷时段分布', Icons.schedule),
            _ToolItem('转化分析', '复购率与拉新效果', Icons.trending_up),
          ]),
          _moduleSection('巡检合规', Icons.verified_user, Color(0xFFE3811A), [
            _ToolItem('合规总览', '整改率/合规率统计', Icons.checklist),
            _ToolItem('发起巡检', '新建巡检任务', Icons.playlist_add),
            _ToolItem('待我整改', '我的待整改问题列表', Icons.build),
            _ToolItem('统计分析', '问题分类与趋势', Icons.pie_chart),
            _ToolItem('证照管理', '员工健康证到期提醒', Icons.health_and_safety),
          ]),
          _moduleSection('培训学习', Icons.menu_book, Color(0xFF8B5CF6), [
            _ToolItem('进度总览', '全员培训完成率', Icons.donut_large),
            _ToolItem('我的课程', '待学习课程列表', Icons.play_circle),
            _ToolItem('考试中心', '在线考核与评分', Icons.quiz),
            _ToolItem('学习进度', '按人按岗跟踪', Icons.person_search),
            _ToolItem('成绩统计', '通过率与排名', Icons.grading),
          ]),
          const SizedBox(height: AppTheme.sectionGap),

          Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.build_outlined, color: AppTheme.accent, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('其他工具', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
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
          Text(app.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(app.desc, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(children: [Icon(Icons.keyboard_arrow_right, size: 16, color: app.color)]),
        ]),
      ),
    );
  }

  Widget _tool(IconData icon, String title, String desc, VoidCallback onTap, {Color color = const Color(0xFFE3811A)}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration,
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2), Text(desc, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18, color: Color(0xFFD0D0D0)),
        ]),
      ),
    );
  }

  Widget _moduleSection(String title, IconData icon, Color color, List<_ToolItem> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 4),
      Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ]),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration,
        child: Column(children: [
          _toolRow(items[0], color, full: true),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _toolRow(items[1], color)), const SizedBox(width: 10), Expanded(child: _toolRow(items[2], color))]),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: _toolRow(items[3], color)), const SizedBox(width: 10), Expanded(child: _toolRow(items[4], color))]),
        ]),
      ),
      const SizedBox(height: 16),
    ]);
  }

  Widget _toolRow(_ToolItem item, Color color, {bool full = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: full ? color.withValues(alpha: 0.06) : color.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Icon(item.icon, color: color, size: 18)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2), Text(item.desc, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFFD0D0D0)),
      ]),
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

class _SubItem {
  final String title, desc;
  final IconData icon;
  const _SubItem(this.title, this.desc, this.icon);
}

class _ToolItem {
  final String title, desc;
  final IconData icon;
  const _ToolItem(this.title, this.desc, this.icon);
}
