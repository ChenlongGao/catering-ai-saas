import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});
  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final List<_TraceRecord> _history = [
    _TraceRecord(id: 'TR26052501', date: DateTime.now().subtract(const Duration(hours: 1)), platform: '美团', orderId: 'MT2605251201', amount: 68.50, status: '已追溯'),
    _TraceRecord(id: 'TR26052502', date: DateTime.now().subtract(const Duration(hours: 3)), platform: '饿了么', orderId: 'ELM2605251030', amount: 42.00, status: '已追溯'),
    _TraceRecord(id: 'TR26052403', date: DateTime.now().subtract(const Duration(days: 1)), platform: '美团', orderId: 'MT2605241830', amount: 89.90, status: '已追溯'),
    _TraceRecord(id: 'TR26052404', date: DateTime.now().subtract(const Duration(days: 1)), platform: '美团', orderId: 'MT2605241400', amount: 35.00, status: '已追溯'),
    _TraceRecord(id: 'TR26052305', date: DateTime.now().subtract(const Duration(days: 2)), platform: '饿了么', orderId: 'ELM2605231200', amount: 55.60, status: '已追溯'),
    _TraceRecord(id: 'TR26052306', date: DateTime.now().subtract(const Duration(days: 2)), platform: '美团', orderId: 'MT2605231945', amount: 73.20, status: '已追溯'),
    _TraceRecord(id: 'TR26052207', date: DateTime.now().subtract(const Duration(days: 3)), platform: '美团', orderId: 'MT2605221215', amount: 46.80, status: '已追溯'),
    _TraceRecord(id: 'TR26052208', date: DateTime.now().subtract(const Duration(days: 3)), platform: '饿了么', orderId: 'ELM2605221820', amount: 92.30, status: '已追溯'),
    _TraceRecord(id: 'TR26052109', date: DateTime.now().subtract(const Duration(days: 4)), platform: '美团', orderId: 'MT2605211130', amount: 28.00, status: '已追溯'),
    _TraceRecord(id: 'TR26052110', date: DateTime.now().subtract(const Duration(days: 4)), platform: '美团', orderId: 'MT2605211750', amount: 61.50, status: '已追溯'),
    _TraceRecord(id: 'TR26052011', date: DateTime.now().subtract(const Duration(days: 5)), platform: '饿了么', orderId: 'ELM2605200930', amount: 38.90, status: '已追溯'),
    _TraceRecord(id: 'TR26052012', date: DateTime.now().subtract(const Duration(days: 5)), platform: '美团', orderId: 'MT2605202000', amount: 105.00, status: '已追溯'),
    _TraceRecord(id: 'TR26051913', date: DateTime.now().subtract(const Duration(days: 6)), platform: '美团', orderId: 'MT2605191310', amount: 52.40, status: '已追溯'),
    _TraceRecord(id: 'TR26051914', date: DateTime.now().subtract(const Duration(days: 6)), platform: '饿了么', orderId: 'ELM2605191630', amount: 79.00, status: '已追溯'),
    _TraceRecord(id: 'TR26051815', date: DateTime.now().subtract(const Duration(days: 7)), platform: '美团', orderId: 'MT2605181100', amount: 44.20, status: '已追溯'),
    _TraceRecord(id: 'TR26051716', date: DateTime.now().subtract(const Duration(days: 8)), platform: '饿了么', orderId: 'ELM2605171415', amount: 66.70, status: '已追溯'),
    _TraceRecord(id: 'TR26051617', date: DateTime.now().subtract(const Duration(days: 9)), platform: '美团', orderId: 'MT2605161200', amount: 33.50, status: '已追溯'),
    _TraceRecord(id: 'TR26051518', date: DateTime.now().subtract(const Duration(days: 10)), platform: '美团', orderId: 'MT2605151830', amount: 88.90, status: '已追溯'),
    _TraceRecord(id: 'TR26051419', date: DateTime.now().subtract(const Duration(days: 11)), platform: '饿了么', orderId: 'ELM2605141030', amount: 25.00, status: '已追溯'),
    _TraceRecord(id: 'TR26051320', date: DateTime.now().subtract(const Duration(days: 12)), platform: '美团', orderId: 'MT2605131500', amount: 71.30, status: '已追溯'),
  ];

  List<_TraceRecord> get _latest => _history.take(5).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 外卖追溯')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF97316), AppTheme.primary]), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22)), const SizedBox(width: 12), const Text('云盯AI外卖追溯', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))]),
              const SizedBox(height: 10),
              const Text('扫描外卖小票识别订单→关联厨房录像照片→AI智能追溯', style: TextStyle(fontSize: 14, color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _ScanPage(onTrace: (r) => setState(() => _history.insert(0, r))))),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)),
              child: Column(children: [
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primary.withValues(alpha: 0.1)), child: const Icon(Icons.qr_code_scanner, color: AppTheme.primary, size: 36)),
                const SizedBox(height: 10), const Text('扫描外卖小票', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4), const Text('调起摄像头识别小票订单信息', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Row(children: [
            const Icon(Icons.history, color: AppTheme.accent, size: 18), const SizedBox(width: 6),
            const Text('最近追溯', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const Spacer(),
            if (_history.length > 2) TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _TraceListPage(history: _history))), child: const Text('查看更多', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
          ]),
          const SizedBox(height: 10),
          if (_history.isEmpty) Container(padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)), child: const Center(child: Text('暂无追溯记录', style: TextStyle(color: AppTheme.textSecondary))))
          else ..._latest.map((r) => _traceCard(r)),
        ]),
      ),
    );
  }

  Widget _traceCard(_TraceRecord r) {
    final colors = [Color(0xFFF97316), Color(0xFF0EA2B8), Color(0xFF6366F1), Color(0xFF10B981)];
    final c = colors[r.id.hashCode.abs() % colors.length];
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _TraceDetailPage(record: r))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration,
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.receipt_long, color: c, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text(r.platform, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c)), const SizedBox(width: 6), Text(r.orderId, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))]),
            const SizedBox(height: 3),
            Text('¥${r.amount.toStringAsFixed(2)} · ${r.date.month}月${r.date.day}日 ${r.date.hour}:${r.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Text('已追溯', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500))),
          const SizedBox(width: 4), const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ]),
      ),
    );
  }
}

// ── 扫描页（调起摄像头→OCR→手动修正）──
class _ScanPage extends StatefulWidget {
  final void Function(_TraceRecord) onTrace;
  const _ScanPage({required this.onTrace});
  @override
  State<_ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<_ScanPage> {
  int _step = 0; // 0=camera 1=ocr 2=confirm 3=linking 4=analyze 5=done
  final _orderCtrl = TextEditingController(text: 'MT202405211234');
  bool _editing = false;

  @override
  void dispose() { _orderCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (_step == 0) {
      Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _step = 1); });
      return Scaffold(
        appBar: AppBar(title: const Text('扫描小票')),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 220, height: 280, decoration: BoxDecoration(border: Border.all(color: AppTheme.primary, width: 2), borderRadius: BorderRadius.circular(16)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.camera_alt, size: 60, color: AppTheme.primary),
            SizedBox(height: 12), Text('对准小票拍照', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            SizedBox(height: 16),
            Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.primary, width: 2)), child: const Icon(Icons.photo_camera, color: AppTheme.primary, size: 30)),
          ])),
          const SizedBox(height: 20), const Text('云盯AI OCR识别中...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ])),
      );
    }

    if (_step == 1) {
      return Scaffold(
        appBar: AppBar(title: const Text('识别结果')),
        body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.accent.withValues(alpha: 0.12))),
            child: Column(children: [
              Row(children: [const Icon(Icons.qr_code, color: AppTheme.accent, size: 24), const SizedBox(width: 10), const Text('OCR 识别成功', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Text('匹配成功', style: TextStyle(fontSize: 11, color: AppTheme.success)))]),
              const SizedBox(height: 16),
              _ocrRow('平台', '美团外卖'),
              _ocrRow('订单号', _editing ? '可修改' : 'MT202405211234'),
              _ocrRow('金额', '¥68.50'),
              _ocrRow('时间', '2024-05-21 12:34'),
              const SizedBox(height: 12),
              if (_editing) ...[
                TextField(controller: _orderCtrl, decoration: const InputDecoration(labelText: '修改订单号', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)), style: const TextStyle(fontSize: 14, fontFamily: 'monospace')),
                const SizedBox(height: 10),
              ],
              Row(children: [
                TextButton.icon(onPressed: () => setState(() { _editing = !_editing; if (_editing) _orderCtrl.text = 'MT202405211234'; }), icon: Icon(_editing ? Icons.close : Icons.edit, size: 16), label: Text(_editing ? '取消修改' : '手动修正'), style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary)),
                const Spacer(),
                ElevatedButton(onPressed: () => setState(() => _step = 2), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14)), child: const Text('确认追溯', style: TextStyle(fontSize: 15))),
              ]),
            ]),
          ),
        ])),
      );
    }

    // 关联录像和照片步骤略，直接进入分析
    if (_step == 2) { Future.delayed(const Duration(seconds: 1), () { if (mounted) setState(() => _step = 3); }); }
    if (_step == 3) { Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _step = 4); }); }
    if (_step == 4) { Future.delayed(const Duration(seconds: 3), () { if (mounted) setState(() => _step = 5); }); }
    if (_step >= 2 && _step <= 4) {
      return Scaffold(
        appBar: AppBar(title: Text(_step == 2 ? '关联录像' : _step == 3 ? '抽帧图片' : 'AI分析中')),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)), child: Icon(_step == 4 ? Icons.auto_awesome : Icons.link, color: AppTheme.primary, size: 32)),
          const SizedBox(height: 16),
          Text(_step == 2 ? '关联厨房工位录像...' : _step == 3 ? '视频帧抽取中...' : 'AI追溯分析中...', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          if (_step == 4) ...[
            const SizedBox(height: 8),
            SizedBox(width: 200, child: LinearProgressIndicator(backgroundColor: AppTheme.divider, color: AppTheme.primary)),
          ],
        ])),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('追溯完成')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.verified, color: AppTheme.success, size: 40)),
        const SizedBox(height: 16), const Text('追溯完成', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.success)),
        const SizedBox(height: 8), const Text('未发现异常 · 出餐流程规范', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: () { widget.onTrace(_TraceRecord(id: 'TR${DateTime.now().millisecondsSinceEpoch}', date: DateTime.now(), platform: '美团', orderId: _orderCtrl.text, amount: 68.50, status: '已追溯')); Navigator.of(context).pop(); }, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('完成追溯', style: TextStyle(fontSize: 15, color: Colors.white))),
      ])),
    );
  }

  Widget _ocrRow(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
      SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
      Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'monospace')),
    ]));
  }
}

// ── 追溯列表页 ──
class _TraceListPage extends StatelessWidget {
  final List<_TraceRecord> history;
  const _TraceListPage({required this.history});
  @override
  Widget build(BuildContext context) {
    final sorted = List<_TraceRecord>.from(history)..sort((a, b) => b.date.compareTo(a.date));
    return Scaffold(
      appBar: AppBar(title: const Text('追溯记录')),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: sorted.length, itemBuilder: (_, i) {
        final r = sorted[i]; final colors = [Color(0xFFF97316), Color(0xFF0EA2B8), Color(0xFF6366F1), Color(0xFF10B981)]; final c = colors[r.id.hashCode.abs() % colors.length];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _TraceDetailPage(record: r))),
          child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14), decoration: AppTheme.cardDecoration, child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.receipt_long, color: c, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text(r.platform, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c)), const SizedBox(width: 6), Text(r.orderId, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))]),
              const SizedBox(height: 3),
              Text('¥${r.amount.toStringAsFixed(2)} · ${r.date.month}月${r.date.day}日 ${r.date.hour}:${r.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Text('已追溯', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500))),
            const SizedBox(width: 4), const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ])),
        );
      }),
    );
  }
}

// ── 追溯详情页 ──
class _TraceDetailPage extends StatelessWidget {
  final _TraceRecord record;
  const _TraceDetailPage({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('追溯详情')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 小票信息
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: Color(0xFFF97316).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.receipt_long, color: Color(0xFFF97316), size: 20)), const SizedBox(width: 10), const Text('外卖小票', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Text('已追溯', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500)))]),
          const Divider(height: 24),
          _row('平台', record.platform), _row('订单号', record.orderId), _row('金额', '¥${record.amount.toStringAsFixed(2)}'), _row('时间', '${record.date.month}月${record.date.day}日 ${record.date.hour}:${record.date.minute.toString().padLeft(2, '0')}'),
        ])),
        const SizedBox(height: 14),

        // 关联录像
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.videocam, color: AppTheme.accent, size: 18), SizedBox(width: 6), Text('关联录像', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 10),
          _videoItem(context, AppTheme.primary, '后厨操作区', '12:34:00 - 12:35:30', 90, '点击回放 · 自动定位 12:34:00'),
          const SizedBox(height: 8),
          _videoItem(context, AppTheme.info, '出餐口', '12:35:30 - 12:36:20', 50, '点击回放 · 自动定位 12:35:30'),
        ])),
        const SizedBox(height: 14),

        // 关联照片（抽帧 10 张）
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.photo_library, color: AppTheme.primary, size: 18), SizedBox(width: 6), Text('关联照片', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), Spacer(), Text('视频抽帧 · 10张', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary))]),
          const SizedBox(height: 10),
          // 宽屏适配：2列大图
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.0),
            itemCount: 10,
            itemBuilder: (_, i) {
              final colors = [Color(0xFF0EA2B8), Color(0xFF10B981), Color(0xFF6366F1), Color(0xFFE3811A), Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFFF97316)];
              final c = colors[i % colors.length];
              return Container(
                decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Stack(children: [
                  Center(child: Icon(Icons.image, color: c, size: 28)),
                  Positioned(bottom: 4, right: 6, child: Text('${12 + i ~/ 2}:${30 + (i % 2) * 5}', style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w500))),
                ]),
              );
            },
          ),
        ])),
        const SizedBox(height: 14),

        // AI追溯分析
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.accent.withValues(alpha: 0.12))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.auto_awesome, color: AppTheme.accent, size: 16), SizedBox(width: 6), Text('AI 追溯分析', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          _analysisSection('严重', AppTheme.error, ['后厨垃圾桶盖未闭合，废弃食材堆积超4小时', '出餐口地面有油渍，存在滑倒风险']),
          const SizedBox(height: 10),
          _analysisSection('轻微', AppTheme.warning, ['备菜区砧板未按生熟分离标识使用', '出餐员未佩戴手套直接接触食物']),
          const SizedBox(height: 10),
          _analysisSection('达标', AppTheme.success, ['烹饪间明火操作规范，油烟净化正常', '出餐打包完整，无遗漏菜品', '冷藏设备温度记录正常']),
        ])),
      ])),
    );
  }

  Widget _row(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
      SizedBox(width: 50, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    ]));
  }

  Widget _videoItem(BuildContext context, Color color, String title, String time, int seconds, String hint) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _VideoPlayerPage(title: title, time: time, seconds: seconds, color: color))),
      child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.1))), child: Row(children: [
        Container(width: 48, height: 36, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)), child: const Center(child: Icon(Icons.play_arrow, color: Colors.white70, size: 22))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)), const SizedBox(width: 6), Text(time, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontFamily: 'monospace'))]),
          const SizedBox(height: 2), Text(hint, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ])),
        Text('${seconds}s', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      ])),
    );
  }

  Widget _analysisSection(String level, Color color, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.1))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(level == '达标' ? Icons.check_circle : Icons.warning_amber, color: color, size: 16),
          const SizedBox(width: 6),
          Text('$level项', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ]),
        const SizedBox(height: 8),
        ...items.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${level}${e.key + 1}: ', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
            Expanded(child: Text(e.value, style: const TextStyle(fontSize: 12, color: AppTheme.text, height: 1.4))),
          ]),
        )),
      ]),
    );
  }
}

class _TraceRecord {
  final String id, platform, orderId, status;
  final DateTime date;
  final double amount;
  const _TraceRecord({required this.id, required this.date, required this.platform, required this.orderId, required this.amount, required this.status});
}

// ── 视频播放器页 ──
class _VideoPlayerPage extends StatefulWidget {
  final String title, time;
  final int seconds;
  final Color color;
  const _VideoPlayerPage({required this.title, required this.time, required this.seconds, required this.color});
  @override
  State<_VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<_VideoPlayerPage> {
  bool _playing = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _seekToTime();
  }

  void _seekToTime() {
    final parts = widget.time.split(' - ')[0].split(':');
    final secs = int.tryParse(parts[0]) ?? 0;
    final mins = secs * 60 + (int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0);
    setState(() => _progress = mins / 60.0);
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    if (_playing) {
      // Simulate playback progress
      for (int i = 0; i <= (1.0 - _progress) * 20; i++) {
        Future.delayed(Duration(milliseconds: 200 * i), () {
          if (mounted && _playing) setState(() => _progress = (_progress + 0.001).clamp(0.0, 1.0));
        });
      }
    }
  }

  String get _currentTime {
    final secs = (_progress * widget.seconds).toInt();
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${widget.time.split(' - ')[0]} + $m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.title, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(children: [
        // 视频画面区
        Expanded(
          child: GestureDetector(
            onTap: _togglePlay,
            child: Container(
              color: Colors.black,
              child: Stack(children: [
                Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_playing ? Icons.videocam : Icons.play_circle_fill, color: Colors.white.withValues(alpha: 0.6), size: 80),
                  const SizedBox(height: 12),
                  Text(_playing ? '播放中...' : '点击播放', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
                ])),
                // 时间戳水印
                Positioned(top: 16, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)), child: Text('${widget.title} | ${widget.time}', style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace')))),
                // 摄像头信息
                Positioned(bottom: 80, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(4)), child: Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 11)))),
              ]),
            ),
          ),
        ),
        // 控制栏
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF1A1A1A),
          child: Column(children: [
            // 进度条
            Row(children: [
              Text(_currentTime, style: const TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'monospace')),
              Expanded(child: SliderTheme(data: SliderThemeData(trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), activeTrackColor: widget.color, inactiveTrackColor: Colors.white24, thumbColor: widget.color, overlayColor: widget.color.withValues(alpha: 0.2)), child: Slider(value: _progress.clamp(0.0, 1.0), onChanged: (v) => setState(() => _progress = v)))),
              Text('${widget.seconds}s', style: const TextStyle(color: Colors.white60, fontSize: 11, fontFamily: 'monospace')),
            ]),
            const SizedBox(height: 8),
            // 控制按钮
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(icon: Icon(Icons.replay_5, color: Colors.white.withValues(alpha: 0.8)), onPressed: () => setState(() => _progress = (_progress - 0.05).clamp(0.0, 1.0))),
              const SizedBox(width: 20),
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
                child: IconButton(icon: Icon(_playing ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 30), onPressed: _togglePlay),
              ),
              const SizedBox(width: 20),
              IconButton(icon: Icon(Icons.forward_5, color: Colors.white.withValues(alpha: 0.8)), onPressed: () => setState(() => _progress = (_progress + 0.05).clamp(0.0, 1.0))),
            ]),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _controlBtn(Icons.speed, '1x', widget.color),
              _controlBtn(Icons.crop_free, '全屏', widget.color),
              _controlBtn(Icons.screenshot, '抓图', widget.color),
              _controlBtn(Icons.hd, '高清', widget.color),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _controlBtn(IconData icon, String label, Color color) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white70, size: 20),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
    ]);
  }
}
