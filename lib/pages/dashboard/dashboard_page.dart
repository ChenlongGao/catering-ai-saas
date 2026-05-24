import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/store.dart';
import 'dart:math';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stores = Store.mockStores();
    final avgScore = stores.map((s) => s.healthScore).reduce((a, b) => a + b) / stores.length;
    final totalDevices = stores.fold<int>(0, (sum, s) => sum + s.deviceCount);
    final todayInspections = Random().nextInt(3);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.dashboard, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text('数据看板'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎卡片
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
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
                        child: const Icon(Icons.store, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('餐饮AI管家', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          Text('云盯科技 · 智能门店管理', style: TextStyle(fontSize: 13, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildStatItem('门店总数', '${stores.length}', Icons.store_mall_directory)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatItem('设备总数', '$totalDevices', Icons.videocam)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatItem('今日巡检', '$todayInspections', Icons.visibility)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 健康评分概览
            const Text('门店健康评分', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                children: [
                  // 平均分
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(avgScore.toStringAsFixed(1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.text)),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text('平均分', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                      ),
                      const Spacer(),
                      _buildScoreDistribution(stores),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 门店排行 Top 5
                  ...stores
                      .where((s) => s.healthScore >= 80)
                      .take(5)
                      .toList()
                      .asMap()
                      .entries
                      .map((e) => _buildStoreRank(e.key + 1, e.value)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 设备在线率
            const Text('设备状态', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.wifi, color: AppTheme.success, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text('$totalDevices', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text('在线设备', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.warning.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.report_problem, color: AppTheme.warning, size: 24),
                        ),
                        const SizedBox(height: 8),
                        const Text('0', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text('告警设备', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 最近活动
            const Text('最近巡检', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text)),
            const SizedBox(height: 12),
            ...stores.take(3).map((store) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.store, color: AppTheme.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            Text('上次巡检: ${store.lastInspection.month}月${store.lastInspection.day}日',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${store.healthScore.toInt()}分',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.success)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildScoreDistribution(List<Store> stores) {
    final excellent = stores.where((s) => s.healthScore >= 90).length;
    final good = stores.where((s) => s.healthScore >= 75 && s.healthScore < 90).length;
    final warn = stores.where((s) => s.healthScore < 75).length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDistDot(AppTheme.success, '$excellent 优秀'),
        const SizedBox(width: 8),
        _buildDistDot(AppTheme.warning, '$good 良好'),
        const SizedBox(width: 8),
        _buildDistDot(AppTheme.error, '$warn 待改进'),
      ],
    );
  }

  Widget _buildDistDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }

  Widget _buildStoreRank(int rank, Store store) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: rank <= 3 ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(store.name, style: const TextStyle(fontSize: 13))),
          Text(store.city, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          const SizedBox(width: 8),
          Text('${store.healthScore.toInt()}分',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: store.healthScore >= 90 ? AppTheme.success : AppTheme.warning,
              )),
        ],
      ),
    );
  }
}
