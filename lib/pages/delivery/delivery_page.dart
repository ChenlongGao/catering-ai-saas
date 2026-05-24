import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/mock_ai_service.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  bool _isScanning = false;
  DeliveryOrder? _order;
  DeliveryVideoClip? _videoClip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delivery_dining, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text('AI 外卖追溯'),
          ],
        ),
      ),
      body: _isScanning ? _buildScanning() : _buildNormal(),
    );
  }

  Widget _buildNormal() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部说明
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF97316), AppTheme.primary],
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
                      child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '云盯AI外卖追溯',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '扫描外卖小票或订单号，AI自动关联摄像头录像，追溯出餐全流程',
                  style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 历史订单
          if (_order != null) _buildOrderCard(_order!),

          if (_order != null && _videoClip != null) ...[
            const SizedBox(height: 12),
            _buildVideoCard(_videoClip!),
          ],

          if (_order == null) ...[
            const Text(
              '最近追溯',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text),
            ),
            const SizedBox(height: 12),
            _buildEmptyHistory(),
          ],

          const SizedBox(height: 20),

          // 扫描按钮
          GestureDetector(
            onTap: _startScan,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divider, width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primary.withValues(alpha: 0.1),
                    ),
                    child: const Icon(Icons.qr_code_scanner, color: AppTheme.primary, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '扫描外卖小票',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '支持美团、饿了么外卖小票OCR识别',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long, color: AppTheme.textSecondary.withValues(alpha: 0.3), size: 48),
          const SizedBox(height: 12),
          const Text(
            '暂无追溯记录',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          const Text(
            '扫描外卖小票开始追溯',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  void _startScan() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        MockAiService().scanDeliveryOrder().then((order) {
          setState(() {
            _isScanning = false;
            _order = order;
            _videoClip = null;
          });
        });
      }
    });
  }

  Widget _buildScanning() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_scanner, size: 60, color: AppTheme.primary),
                const SizedBox(height: 12),
                const Text('对准小票', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, AppTheme.primary, Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('正在扫描...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('云盯AI OCR识别中', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(DeliveryOrder order) {
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
              Image.network(
                'https://img.icons8.com/color/48/meituan.png',
                width: 24,
                height: 24,
                errorBuilder: (_, __, ___) => const Icon(Icons.delivery_dining, color: AppTheme.primary, size: 24),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('订单详情', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('已完成', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const Divider(height: 20),
          _buildInfoRow('平台', order.platform),
          _buildInfoRow('订单号', order.orderId),
          _buildInfoRow('顾客', order.customer),
          _buildInfoRow('金额', '¥${order.amount.toStringAsFixed(2)}'),
          _buildInfoRow('下单时间', '${order.orderTime.toString().substring(11, 16)}'),
          const Divider(height: 20),
          const Text('菜品', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 6),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 5, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(item, style: const TextStyle(fontSize: 14)),
              ],
            ),
          )),
          const SizedBox(height: 10),

          // 时间轴
          const Text('出餐时间轴', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          ...order.timeline.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    t.time.toString().substring(11, 16),
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'monospace'),
                  ),
                ),
                const Icon(Icons.fiber_manual_record, size: 6, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(t.event, style: const TextStyle(fontSize: 13)),
                const Spacer(),
                Text(t.camera, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          )),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                MockAiService().getOrderVideo(order.orderId).then((clip) {
                  setState(() => _videoClip = clip);
                });
              },
              icon: const Icon(Icons.videocam, size: 18),
              label: const Text('查看关联录像'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accent,
                side: const BorderSide(color: AppTheme.accent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildVideoCard(DeliveryVideoClip clip) {
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
              const Icon(Icons.video_library, color: AppTheme.accent, size: 18),
              const SizedBox(width: 8),
              const Text('关联录像', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${clip.startTime} - ${clip.endTime}',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 录像预览区
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white70, size: 40),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        clip.videoTitle,
                        style: const TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('出餐口', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppTheme.success, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(clip.aiTag, style: const TextStyle(fontSize: 13, color: AppTheme.text)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
