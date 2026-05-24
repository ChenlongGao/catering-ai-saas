import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/store.dart';
import '../../models/inspection_report.dart';
import '../../services/mock_ai_service.dart';

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  Store? _selectedStore;
  bool _isInspecting = false;
  InspectionReport? _report;

  final List<Store> _stores = Store.mockStores();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text('AI 一键巡检'),
          ],
        ),
      ),
      body: _isInspecting ? _buildInspecting() : _buildNormal(),
    );
  }

  /// 正常界面：门店列表 + 巡检按钮
  Widget _buildNormal() {
    return Column(
      children: [
        // 门店选择区域
        Container(
          margin: const EdgeInsets.all(16),
          child: _buildStoreSelector(),
        ),

        // 已选门店的设备预览
        if (_selectedStore != null) _buildDevicePreview(),

        const Spacer(),

        // 一键巡检按钮
        if (_selectedStore != null) _buildInspectButton(),
      ],
    );
  }

  Widget _buildStoreSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.store, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                '选择巡检门店',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.text,
                ),
              ),
              const Spacer(),
              Text(
                '共 ${_stores.length} 家',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 地区筛选
          ...['华中区', '华东区', '华南区'].map((region) {
            final regionStores = _stores.where((s) => s.region == region).toList();
            if (regionStores.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    region,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...regionStores.map((store) => _buildStoreItem(store)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStoreItem(Store store) {
    final isSelected = _selectedStore?.id == store.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedStore = store),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.08) : AppTheme.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppTheme.primary : AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${store.city} · ${store.deviceCount}台设备 · 上次${store.lastInspection.day}日巡检',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            _buildHealthBadge(store.healthScore),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthBadge(double score) {
    Color color;
    if (score >= 90) {
      color = AppTheme.success;
    } else if (score >= 75) {
      color = AppTheme.warning;
    } else {
      color = AppTheme.error;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${score.toInt()}分',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDevicePreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.videocam, color: AppTheme.accent, size: 18),
              const SizedBox(width: 8),
              const Text(
                '设备预览',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.text,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '全部在线',
                  style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...Device.mockDevices(_selectedStore!.id).take(4).map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                _deviceTypeIcon(d.type),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(d.location, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                ...d.tags.take(3).map((tag) => Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(tag, style: const TextStyle(fontSize: 10, color: AppTheme.accent)),
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _deviceTypeIcon(DeviceType type) {
    IconData icon;
    switch (type) {
      case DeviceType.camera:
        icon = Icons.videocam;
      case DeviceType.nvr:
        icon = Icons.dvr;
      case DeviceType.aiBox:
        icon = Icons.memory;
    }
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: AppTheme.textSecondary),
    );
  }

  Widget _buildInspectButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: _startInspection,
        icon: const Icon(Icons.bolt, size: 22),
        label: const Text('一键巡检'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _startInspection() {
    setState(() => _isInspecting = true);
  }

  /// 巡检中动画
  Widget _buildInspecting() {
    // 模拟巡检过程
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        MockAiService().quickInspect(_selectedStore!.name).then((report) {
          setState(() {
            _isInspecting = false;
            _report = report;
          });
        });
      }
    });

    // 如果有报告，显示报告
    if (_report != null) {
      return _buildReport(_report!);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withValues(alpha: 0.1),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'AI 巡检中...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.text),
          ),
          const SizedBox(height: 8),
          Text(
            '正在调用 ${_selectedStore!.name} 的摄像头进行抓图分析',
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          _buildInspectProgress(),
        ],
      ),
    );
  }

  Widget _buildInspectProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          _buildProgressStep('调起摄像头', true),
          const Divider(height: 1, indent: 28),
          _buildProgressStep('AI设备标签检查', true),
          const Divider(height: 1, indent: 28),
          _buildProgressStep('实时抓图', true),
          const Divider(height: 1, indent: 28),
          _buildProgressStep('AI分析中', false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String text, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.hourglass_top,
            size: 18,
            color: done ? AppTheme.success : AppTheme.primary,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: done ? AppTheme.text : AppTheme.primary,
              fontWeight: done ? FontWeight.normal : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 巡检报告
  Widget _buildReport(InspectionReport report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 报告头部
          _buildReportHeader(report),
          const SizedBox(height: 16),

          // 设备抓图
          _buildSnapshots(report),
          const SizedBox(height: 16),

          // 检查项详情
          _buildCheckItems(report),
          const SizedBox(height: 16),

          // AI总结
          _buildAiSummary(report),
          const SizedBox(height: 24),

          // 重新巡检按钮
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _report = null),
              icon: const Icon(Icons.refresh),
              label: const Text('重新巡检'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportHeader(InspectionReport report) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '巡检报告',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '云盯AI',
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            report.overallScore.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            '综合评分',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            report.storeName,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          Text(
            '巡检时间：${report.inspectTime.toString().substring(11, 16)}',
            style: const TextStyle(fontSize: 12, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshots(InspectionReport report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.camera_alt, color: AppTheme.accent, size: 18),
              SizedBox(width: 8),
              Text(
                'AI 抓图分析',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...report.snapshots.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: const Icon(Icons.image, color: AppTheme.textSecondary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(s.deviceName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Text(s.timestamp, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(s.location, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 2),
                      Text(s.aiTag, style: const TextStyle(fontSize: 12, color: AppTheme.success)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCheckItems(InspectionReport report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist, color: AppTheme.accent, size: 18),
              SizedBox(width: 8),
              Text(
                '检查项详情',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...report.items.map((item) => _buildCheckItem(item)),
        ],
      ),
    );
  }

  Widget _buildCheckItem(CheckItem item) {
    Color statusColor;
    IconData statusIcon;
    switch (item.status) {
      case CheckStatus.pass:
        statusColor = AppTheme.success;
        statusIcon = Icons.check_circle;
      case CheckStatus.warning:
        statusColor = AppTheme.warning;
        statusIcon = Icons.warning_amber;
      case CheckStatus.fail:
        statusColor = AppTheme.error;
        statusIcon = Icons.cancel;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, size: 16, color: statusColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.score}分',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(item.details, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildAiSummary(InspectionReport report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accent.withValues(alpha: 0.05), AppTheme.accent.withValues(alpha: 0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.auto_awesome, color: AppTheme.accent, size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'AI 总结建议',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            report.aiSummary,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.text,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
