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
        const SizedBox(height: 16),
        // 数据指标卡片
        Row(children: [
          Expanded(child: _kpiCard('门店数量', '24', Icons.store, Color(0xFF6366F1))),
          const SizedBox(width: 10),
          Expanded(child: _kpiCard('设备数量', '168', Icons.videocam, Color(0xFF10B981))),
          const SizedBox(width: 10),
          Expanded(child: _kpiCard('AI标签', '42', Icons.label, Color(0xFFE3811A))),
        ]),
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

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
      child: Column(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2), Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ]),
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

// ── 门店列表页（搜索+标签筛选）──
class _StoreListPage extends StatefulWidget {
  @override
  State<_StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<_StoreListPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  final Set<String> _activeTags = {};

  static const _stores = ['茶颜悦色·太平街店', '茶颜悦色·五一广场店', '茶颜悦色·解放西路店', '茶颜悦色·江汉路店', '茶颜悦色·光谷店', '茶颜悦色·新街口店', '茶颜悦色·湖滨银泰店', '茶颜悦色·步行街店', '茶颜悦色·华强北店', '茶颜悦色·福田店', '茶颜悦色·三里屯店', '茶颜悦色·春熙路店'];

  static const _tags = ['后厨', '出餐口', '用餐区', '收银台', '仓库', '出入口'];

  List<String> get _filtered {
    var list = _stores;
    if (_query.isNotEmpty) list = list.where((s) => s.contains(_query)).toList();
    return list;
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('全部门店')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(14, 14, 14, 0), child: TextField(
          controller: _searchCtrl, onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(hintText: '搜索门店名称...', prefixIcon: Icon(Icons.search, size: 20), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), isDense: true),
        )),
        Container(padding: const EdgeInsets.fromLTRB(14, 8, 14, 8), child: Wrap(spacing: 6, runSpacing: 6, children: _tags.map((t) {
          final active = _activeTags.contains(t);
          return GestureDetector(
            onTap: () => setState(() => active ? _activeTags.remove(t) : _activeTags.add(t)),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: active ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: active ? AppTheme.primary : AppTheme.divider)), child: Text(t, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? AppTheme.primary : AppTheme.textSecondary))),
          );
        }).toList())),
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(14, 4, 14, 14), children: _filtered.map((s) => GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _StoreDetailPage(name: s))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.store, color: AppTheme.accent, size: 20)),
              const SizedBox(width: 12), Expanded(child: Text(s, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
              const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
            ]),
          ),
        )).toList())),
      ]),
    );
  }
}

// ── 单店详情页（设备标签+视频列表）──
class _StoreDetailPage extends StatefulWidget {
  final String name;
  const _StoreDetailPage({required this.name});
  @override
  State<_StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<_StoreDetailPage> {
  final Set<String> _activeTags = {};

  static const _deviceTags = ['后厨', '出餐口', '用餐区', '收银台', '仓库', '出入口', '烹饪区', '备菜区'];
  final _videos = const [
    _Vid(name: '后厨操作区', tag: '后厨', online: true, count: 3),
    _Vid(name: '烹饪区近景', tag: '烹饪区', online: true, count: 1),
    _Vid(name: '出餐口全景', tag: '出餐口', online: true, count: 2),
    _Vid(name: '用餐区A区', tag: '用餐区', online: true, count: 2),
    _Vid(name: '用餐区B区', tag: '用餐区', online: false, count: 1),
    _Vid(name: '收银台监控', tag: '收银台', online: true, count: 1),
    _Vid(name: '仓库通道', tag: '仓库', online: true, count: 1),
    _Vid(name: '出入口1号', tag: '出入口', online: true, count: 1),
    _Vid(name: '出入口2号', tag: '出入口', online: false, count: 1),
    _Vid(name: '备菜区操作', tag: '备菜区', online: true, count: 1),
  ];

  List<_Vid> get _filtered {
    if (_activeTags.isEmpty) return _videos;
    return _videos.where((v) => _activeTags.contains(v.tag)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final online = _videos.where((v) => v.online).length;
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Column(children: [
        Container(padding: const EdgeInsets.all(16), color: Colors.white, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _stat('总设备', '${_videos.length}', Icons.devices, Color(0xFF6366F1)),
          _stat('在线', '$online', Icons.wifi, Color(0xFF10B981)),
          _stat('标签', '${_deviceTags.length}', Icons.label, Color(0xFFE3811A)),
        ])),
        Container(padding: const EdgeInsets.fromLTRB(14, 0, 14, 8), child: Wrap(spacing: 6, runSpacing: 6, children: _deviceTags.map((t) {
          final active = _activeTags.contains(t);
          final color = active ? AppTheme.primary : Colors.white;
          final textColor = active ? Colors.white : AppTheme.textSecondary;
          return GestureDetector(
            onTap: () => setState(() => active ? _activeTags.remove(t) : _activeTags.add(t)),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: active ? AppTheme.primary : AppTheme.bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: active ? AppTheme.primary : AppTheme.divider)), child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: active ? Colors.white : AppTheme.textSecondary))),
          );
        }).toList())),
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(14, 4, 14, 14), children: _filtered.map((v) => GestureDetector(
          onTap: v.online ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _LiveViewPage(name: v.name))) : null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
            child: Row(children: [
              Container(width: 80, height: 56, decoration: BoxDecoration(color: v.online ? Colors.black : AppTheme.bg, borderRadius: BorderRadius.circular(8)), child: Center(child: Icon(v.online ? Icons.play_circle_fill : Icons.videocam_off, color: v.online ? Colors.white70 : AppTheme.textSecondary, size: 28))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(v.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(3)), child: Text(v.tag, style: const TextStyle(fontSize: 10, color: AppTheme.primary))),
                  const SizedBox(width: 6),
                  Text('${v.count}路', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ]),
              ])),
              Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: v.online ? Color(0xFF10B981) : AppTheme.textSecondary)),
              const SizedBox(width: 4),
              Text(v.online ? '在线' : '离线', style: TextStyle(fontSize: 11, color: v.online ? Color(0xFF10B981) : AppTheme.textSecondary)),
              const SizedBox(width: 4), const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
            ]),
          ),
        )).toList())),
      ]),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Column(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
    ]);
  }
}

// ── 直播查看页 ──
class _LiveViewPage extends StatefulWidget {
  final String name;
  const _LiveViewPage({required this.name});
  @override
  State<_LiveViewPage> createState() => _LiveViewPageState();
}

class _LiveViewPageState extends State<_LiveViewPage> {
  bool _playing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.name, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _playing = !_playing),
            child: Stack(children: [
              Container(color: Colors.black),
              if (!_playing) Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.play_circle_fill, color: Colors.white.withValues(alpha: 0.6), size: 80), const SizedBox(height: 12), Text('点击播放', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14))])),
              if (_playing) Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.live_tv, color: Colors.red.withValues(alpha: 0.4), size: 80), const SizedBox(height: 12), Text('实时直播中...', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14))])),
              Positioned(top: 16, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)), child: Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)), const SizedBox(width: 6), const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'monospace'))]))),
              Positioned(bottom: 16, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)), child: const Text('云盯AI · 实时分析中', style: TextStyle(color: Colors.white70, fontSize: 11)))),
            ]),
          ),
        ),
        Container(padding: const EdgeInsets.all(16), color: const Color(0xFF1A1A1A), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _liveBtn(Icons.screenshot, '截图'),
          _liveBtn(Icons.mic, '对讲'),
          _liveBtn(Icons.fullscreen, '全屏'),
          _liveBtn(Icons.hd, '高清'),
          _liveBtn(Icons.camera, '抓图'),
        ])),
      ]),
    );
  }

  Widget _liveBtn(IconData icon, String label) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white70, size: 22),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
    ]);
  }
}

class _Vid {
  final String name, tag;
  final bool online;
  final int count;
  const _Vid({required this.name, required this.tag, required this.online, required this.count});
}
