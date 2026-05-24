import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../inspection/inspection_page.dart';
import '../training/training_page.dart';
import '../delivery/delivery_page.dart';
import '../location/location_page.dart';

class AppCenterPage extends StatelessWidget {
  const AppCenterPage({super.key});

  static const _apps = [
    {
      'title': 'AI 一键巡检',
      'desc': '门店设备巡检 · AI抓图 · 智能评分',
      'icon': Icons.visibility,
      'color': Color(0xFFFF6B35),
      'badge': '核心功能',
      'page': InspectionPage(),
    },
    {
      'title': 'AI 陪练打卡',
      'desc': '拍照录像分析 · 流程规范打分',
      'icon': Icons.school,
      'color': Color(0xFF6366F1),
      'badge': '新上线',
      'page': TrainingPage(),
    },
    {
      'title': 'AI 外卖追溯',
      'desc': '扫码查订单 · 录像回溯出餐流程',
      'icon': Icons.delivery_dining,
      'color': Color(0xFFF97316),
      'badge': '热更新',
      'page': DeliveryPage(),
    },
    {
      'title': 'AI 智能选址',
      'desc': '业态参数分析 · 竞品客流 · 营收预估',
      'icon': Icons.location_on,
      'color': Color(0xFF10B981),
      'badge': '推荐',
      'page': LocationPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.apps, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text('应用中心'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部 Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accent, AppTheme.accentLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('云盯AI 智能应用', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          Text('四大AI引擎，助力智慧餐饮管理', style: TextStyle(fontSize: 13, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('AI 智能应用', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text)),
            const SizedBox(height: 12),

            // 四个应用卡片 2x2
            ...List.generate(
              (_apps.length / 2).ceil(),
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildAppCard(context, _apps[row * 2]),
                    ),
                    if (row * 2 + 1 < _apps.length) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAppCard(context, _apps[row * 2 + 1]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 其他工具
            const Text('其他工具', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildToolCard(
                    icon: Icons.qr_code_scanner,
                    title: '扫码巡检',
                    desc: '扫描设备二维码',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToolCard(
                    icon: Icons.bar_chart,
                    title: '数据报表',
                    desc: '巡检查看统计',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAppCard(BuildContext context, Map<String, dynamic> app) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => app['page'] as Widget,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (app['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(app['icon'] as IconData, color: app['color'] as Color, size: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (app['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    app['badge'] as String,
                    style: TextStyle(fontSize: 10, color: app['color'] as Color, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              app['title'] as String,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.text),
            ),
            const SizedBox(height: 6),
            Text(
              app['desc'] as String,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('进入应用', style: TextStyle(fontSize: 12, color: app['color'] as Color, fontWeight: FontWeight.w500)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14, color: app['color'] as Color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.textSecondary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(desc, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
