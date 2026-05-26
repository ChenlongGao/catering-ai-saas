import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class VideoCenterPage extends StatelessWidget {
  const VideoCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('视频中心')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)]), borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.videocam, color: Colors.white, size: 22)), const SizedBox(width: 12), const Text('云盯AI视频中心', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))]),
            const SizedBox(height: 10), const Text('门店实时监控 · 录像回放 · AI异常抓拍', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 20),
        // 门店选择卡片
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _StoreListPage())),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.store, color: AppTheme.primary, size: 20)),
              const SizedBox(width: 12),
              const Expanded(child: Text('全部门店', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
              const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        _section('实时监控', Icons.live_tv, [
          _videoItem('后厨操作区', '在线 · 3路摄像头', Color(0xFF059669)),
          _videoItem('出餐口', '在线 · 2路摄像头', Color(0xFF0EA2B8)),
          _videoItem('用餐区', '在线 · 4路摄像头', Color(0xFF6366F1)),
          _videoItem('收银台', '在线 · 1路摄像头', Color(0xFFE3811A)),
        ]),
        const SizedBox(height: 20),
        _section('AI抓拍', Icons.flash_on, [
          _snapItem('后厨垃圾桶未盖 · 12:34', Color(0xFFEF4444)),
          _snapItem('出餐员未戴手套 · 11:20', Color(0xFFF59E0B)),
          _snapItem('备菜区生熟混放 · 10:15', Color(0xFFEF4444)),
          _snapItem('地面油渍未清理 · 09:40', Color(0xFFF59E0B)),
        ]),
        const SizedBox(height: 20),
        _section('录像回放', Icons.replay, [
          _replayItem('5月24日 · 后厨操作区 · 12:30', '00:15:30', Color(0xFF059669)),
          _replayItem('5月24日 · 出餐口 · 14:20', '00:08:45', Color(0xFF0EA2B8)),
          _replayItem('5月23日 · 用餐区 · 18:00', '00:22:10', Color(0xFF6366F1)),
        ]),
        const SizedBox(height: 40),
      ])),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppTheme.primary, size: 18)),
        const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ]),
      const SizedBox(height: 12), ...children,
    ]);
  }

  Widget _videoItem(String name, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
      child: Row(children: [
        Container(width: 72, height: 48, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)), child: const Center(child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 28))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2), Text(status, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ])),
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4), Text('直播中', style: TextStyle(fontSize: 11, color: color)),
      ]),
    );
  }

  Widget _snapItem(String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
      child: Row(children: [
        Container(width: 72, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Center(child: Icon(Icons.image, color: color, size: 28))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(desc, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2), const Text('AI识别 · 待处理', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ])),
        const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
      ]),
    );
  }

  Widget _replayItem(String name, String duration, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
      child: Row(children: [
        Container(width: 72, height: 48, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)), child: const Center(child: Icon(Icons.play_arrow, color: Colors.white70, size: 28))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2), Text('时长 $duration', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ])),
        const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
      ]),
    );
  }
}

class _StoreListPage extends StatelessWidget {
  final stores = ['茶颜悦色·太平街店', '茶颜悦色·五一广场店', '茶颜悦色·解放西路店', '茶颜悦色·江汉路店', '茶颜悦色·光谷店', '茶颜悦色·新街口店', '茶颜悦色·湖滨银泰店', '茶颜悦色·步行街店', '茶颜悦色·华强北店', '茶颜悦色·福田店', '茶颜悦色·三里屯店', '茶颜悦色·春熙路店'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('全部门店')),
      body: ListView(padding: const EdgeInsets.all(16), children: stores.map((s) => Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.store, color: AppTheme.accent, size: 20)),
          const SizedBox(width: 12), Expanded(child: Text(s, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
        ]),
      )).toList()),
    );
  }
}
