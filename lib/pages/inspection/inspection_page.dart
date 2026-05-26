import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/store.dart';

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});
  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  final _stores = Store.mockStores();
  final Set<String> _selectedTags = {};
  final Set<String> _selectedStoreIds = {};
  final List<_InspectionTask> _taskHistory = [
    _InspectionTask(title: '后厨工装巡检', date: DateTime.now().subtract(const Duration(hours: 1)), tagCount: 3, storeCount: 2, imageCount: 6, score: 91.5, tags: ['后厨操作区', '正门监控', '收银台'], status: _TaskStatus.done),
    _InspectionTask(title: '清洁卫生巡检', date: DateTime.now().subtract(const Duration(hours: 2)), tagCount: 2, storeCount: 1, imageCount: 4, score: 0, tags: ['垃圾处理区', '洗碗间'], status: _TaskStatus.running),
    _InspectionTask(title: '消防安全检查', date: DateTime.now().subtract(const Duration(days: 1)), tagCount: 5, storeCount: 3, imageCount: 9, score: 84.8, tags: ['消防通道', '仓库', '员工通道'], status: _TaskStatus.done),
    _InspectionTask(title: '正门监控巡检', date: DateTime.now().subtract(const Duration(hours: 4)), tagCount: 1, storeCount: 1, imageCount: 2, score: 0, tags: ['正门监控'], status: _TaskStatus.pending),
  ];

  static const _tags = [
    ('正门监控',    Color(0xFF0EA2B8), 30, 30),
    ('后厨操作区',  Color(0xFF10B981), 30, 60),
    ('收银台',      Color(0xFFE3811A), 30, 30),
    ('冷藏库',      Color(0xFF6366F1), 26, 26),
    ('用餐区',      Color(0xFF8B5CF6), 30, 90),
    ('外卖取餐区',  Color(0xFF3B82F6), 22, 22),
    ('仓库',        Color(0xFFEF4444), 28, 28),
    ('消防通道',    Color(0xFFF59E0B), 30, 30),
    ('垃圾处理区',  Color(0xFF10B981), 30, 30),
    ('员工通道',    Color(0xFF6366F1), 29, 29),
    ('配料间',      Color(0xFF0EA2B8), 24, 24),
    ('洗碗间',      Color(0xFFE3811A), 26, 26),
    ('包间',        Color(0xFF8B5CF6), 18, 54),
    ('冷菜间',      Color(0xFF10B981), 12, 12),
    ('饮品吧台',    Color(0xFF3B82F6), 16, 16),
  ];

  void _startInspection() {
    if (_selectedTags.isEmpty && _selectedStoreIds.isEmpty) return;
    final tagList = _selectedTags.toList();
    final storeList = _selectedStoreIds.toList();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
      _SnapshotPage(
        tags: tagList,
        storeIds: storeList,
        onComplete: (captures) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
            _InspectionDialog(
              captures: captures,
              onStart: () {
                final title = _selectedTags.isNotEmpty ? '${_selectedTags.first}巡检' : '门店巡检';
                final tagList = _selectedTags.toList();
                final storeCount = _selectedStoreIds.length;
                final task = _InspectionTask(title: title, date: DateTime.now(), tagCount: tagList.length, storeCount: storeCount, imageCount: captures.length, score: 0, tags: tagList, status: _TaskStatus.running);
                setState(() {
                  _taskHistory.insert(0, task);
                  _selectedTags.clear();
                  _selectedStoreIds.clear();
                });
              },
              onComplete: (score, tags, stores, imgCount) {
                if (_taskHistory.isNotEmpty && _taskHistory.first.status == _TaskStatus.running) {
                  setState(() {
                    _taskHistory.first.score = score;
                    _taskHistory.first.status = _TaskStatus.done;
                  });
                }
              },
            ),
          ));
        },
      ),
    ));
  }

  void _toggleTag(String t) => setState(() => _selectedTags.contains(t) ? _selectedTags.remove(t) : _selectedTags.add(t));
  void _toggleStore(String id) => setState(() => _selectedStoreIds.contains(id) ? _selectedStoreIds.remove(id) : _selectedStoreIds.add(id));

  @override
  Widget build(BuildContext context) {
    final canStart = _selectedTags.isNotEmpty || _selectedStoreIds.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('AI 一键巡检')),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(children: [
            // 云盯AI一键巡检卡片
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]), borderRadius: BorderRadius.circular(16)),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(Icons.auto_awesome, color: Colors.white, size: 22), SizedBox(width: 12), Text('云盯AI一键巡检', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))]),
                SizedBox(height: 10),
                Text('选择标签和门店，抓取监控画面，AI智能分析', style: TextStyle(fontSize: 14, color: Colors.white70)),
              ]),
            ),
            const SizedBox(height: 16),
            _buildRecentTask(),
            const SizedBox(height: 14),
            _buildTagList(),
            const SizedBox(height: 14),
            _buildStoreSelector(),
          ]),
        )),
        if (canStart) _buildBottomBar(),
      ]),
    );
  }

  Widget _buildRecentTask() {
    final t = _taskHistory.first;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _TaskListPage(tasks: _taskHistory))),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.assignment, color: AppTheme.primary, size: 16), SizedBox(width: 6),
            Text('最近巡检任务', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.check_circle, color: AppTheme.primary, size: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_truncate(t.title), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text('${t.storeCount}家门店 · ${t.tagCount}标签 · ${t.imageCount}图 · ${t.score}分', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                Text('${t.date.month}月${t.date.day}日 ${t.date.hour}:${t.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ])),
              const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
            ]),
          ),
        ]),
      ),
    );
  }

  String _truncate(String s) => s.length > 6 ? '${s.substring(0, 6)}...' : s;

  Widget _buildTagList() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.label, color: AppTheme.accent, size: 16), const SizedBox(width: 6),
          const Text('设备标签巡检', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('已选${_selectedTags.length}', style: TextStyle(fontSize: 11, color: _selectedTags.isNotEmpty ? AppTheme.primary : AppTheme.textSecondary)),
        ]),
        const SizedBox(height: 10),
        ..._tags.take(4).map((t) => _tagRow(t)),
        Center(child: TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _AllTagsPage(tags: _tags, selected: _selectedTags, onToggle: _toggleTag))),
          child: const Text('查看更多标签', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        )),
      ]),
    );
  }

  Widget _tagRow((String, Color, int, int) t) {
    final (name, color, storeCount, camCount) = t;
    final sel = _selectedTags.contains(name);
    return GestureDetector(
      onTap: () => _toggleTag(name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: sel ? color.withValues(alpha: 0.06) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: sel ? color : AppTheme.divider, width: sel ? 1.5 : 0.5)),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.videocam, color: color, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: sel ? color : AppTheme.text)),
            const SizedBox(height: 4),
            Row(children: [
              _chip('$storeCount店', AppTheme.primary), const SizedBox(width: 6), _chip('$camCount个摄像头', AppTheme.accent),
            ]),
          ])),
          sel ? Icon(Icons.check_circle, color: color, size: 22) : Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.divider))),
        ]),
      ),
    );
  }

  Widget _chip(String t, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: c.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(4)), child: Text(t, style: TextStyle(fontSize: 10, color: c)));

  Widget _buildStoreSelector() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.store, color: AppTheme.primary, size: 16), const SizedBox(width: 6),
          const Text('选择巡检门店', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('已选${_selectedStoreIds.length}', style: TextStyle(fontSize: 11, color: _selectedStoreIds.isNotEmpty ? AppTheme.primary : AppTheme.textSecondary)),
        ]),
        const SizedBox(height: 10),
        ..._stores.take(8).map((s) {
          final sel = _selectedStoreIds.contains(s.id);
          return GestureDetector(
            onTap: () => _toggleStore(s.id),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: sel ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: sel ? AppTheme.primary : AppTheme.divider, width: sel ? 1.5 : 0.5)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: sel ? AppTheme.primary : AppTheme.text)),
                  if (s.tags.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(spacing: 4, runSpacing: 4, children: s.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: sel ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.accent.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(4)),
                      child: Text(t, style: TextStyle(fontSize: 10, color: sel ? AppTheme.primary : AppTheme.textSecondary)),
                    )).toList()),
                  ],
                ])),
                sel ? const Icon(Icons.check_circle, color: AppTheme.primary, size: 22) : Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.divider))),
              ]),
            ),
          );
        }),
        Center(child: TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _StoreListPage(stores: _stores, selectedIds: _selectedStoreIds, onToggle: _toggleStore))),
          child: const Text('查看更多门店', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        )),
      ]),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.divider))),
      child: SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: _startInspection,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppTheme.primary),
        child: Text('确认巡检 (${_selectedTags.length}标签 + ${_selectedStoreIds.length}门店)', style: const TextStyle(color: Colors.white, fontSize: 15)),
      )),
    );
  }

  static const _mockColors = [Color(0xFF0EA2B8), Color(0xFF10B981), Color(0xFFE3811A), Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFFEC4899)];
}

// ── 巡检对话框 ──
class _InspectionDialog extends StatefulWidget {
  final List<_Capture> captures;
  final VoidCallback onStart;
  final void Function(double score, int tags, int stores, int imgCount) onComplete;
  const _InspectionDialog({required this.captures, required this.onStart, required this.onComplete});

  @override
  State<_InspectionDialog> createState() => _InspectionDialogState();
}

class _InspectionDialogState extends State<_InspectionDialog> {
  final _promptCtrl = TextEditingController();
  final _promptFocus = FocusNode();
  bool _recording = false;

  Color get _inputBorderColor {
    if (_promptFocus.hasFocus) return AppTheme.primary;
    if (_promptCtrl.text.isNotEmpty) return AppTheme.primary.withValues(alpha: 0.4);
    return AppTheme.primary.withValues(alpha: 0.2);
  }

  Widget _voiceButton() {
    return GestureDetector(
      onLongPress: () => _startVoice(),
      onLongPressUp: () => _stopVoice(),
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: _recording ? AppTheme.error.withValues(alpha: 0.08) : AppTheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: _recording ? Border.all(color: AppTheme.error, width: 1.5) : null,
        ),
        child: Icon(_recording ? Icons.mic : Icons.mic_none, color: _recording ? AppTheme.error : AppTheme.primary, size: 22),
      ),
    );
  }

  void _startVoice() {
    setState(() => _recording = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _recording) {
        setState(() { _recording = false; _promptCtrl.text = '检查后厨卫生、设备运行状态、消防通道是否畅通'; });
      }
    });
  }

  void _stopVoice() {
    setState(() => _recording = false);
  }

  void _run() {
    if (_promptCtrl.text.trim().isEmpty) return;
    widget.onStart();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
      _AnalyzingPage(
        captures: widget.captures,
        onComplete: (score, total) {
          widget.onComplete(score, total.clamp(1, 5), total.clamp(1, 3), total);
        },
      ),
    ));
  }

  @override
  void dispose() { _promptCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI 巡检 (${widget.captures.length}张)')),
      body: Column(children: [
        // 上半：抓图列表
        Expanded(
          flex: 5,
          child: Container(
            color: AppTheme.bg,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.captures.length.clamp(0, 10),
              itemBuilder: (_, i) => _captureRow(widget.captures[i]),
            ),
          ),
        ),
        // 下半：输入
        Expanded(
          flex: 3,
          child: _buildInput(),
        ),
      ]),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.divider))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('输入巡检指令', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Expanded(child: Column(children: [
          Expanded(child: TextField(
            controller: _promptCtrl, focusNode: _promptFocus, maxLines: null, expands: true, textAlignVertical: TextAlignVertical.top,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '文字输入巡检指令...',
              hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.4)),
              border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: _inputBorderColor)),
              enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: _inputBorderColor)),
              focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
            ),
            style: const TextStyle(fontSize: 14, color: AppTheme.text),
          )),
          const SizedBox(height: 8),
          Row(children: [
            _voiceButton(),
            const SizedBox(width: 12),
            Expanded(child: SizedBox(height: 44, child: ElevatedButton.icon(
              onPressed: _promptCtrl.text.isEmpty ? null : _run, icon: const Icon(Icons.auto_awesome, size: 16),
              label: Text('开始AI巡检 (${widget.captures.length}图)'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, disabledBackgroundColor: AppTheme.primary.withValues(alpha: 0.3)),
            ))),
          ]),
        ])),
      ]),
    );
  }

  Widget _captureRow(_Capture c) {
    final colors = [Color(0xFF0EA2B8), Color(0xFF10B981), Color(0xFFE3811A), Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFFEC4899)];
    final color = colors[c.time.second % colors.length];
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
      child: Row(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.image, color: color, size: 30),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c.store, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)), child: Text(c.tag, style: const TextStyle(fontSize: 10, color: AppTheme.accent))),
            const SizedBox(width: 6),
            Text(c.timeStr, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ]),
        ])),
      ]),
    );
  }
}

class _Capture {
  final String tag;
  final String store;
  final DateTime time;
  const _Capture({required this.tag, required this.store, required this.time});
  String get timeStr => '${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
}

// ── 巡检任务 ──
enum _TaskStatus { pending, running, done }

class _InspectionTask {
  final String title;
  DateTime date; final int tagCount, storeCount, imageCount; double score;
  final List<String> tags;
  _TaskStatus status;
  _InspectionTask({required this.title, required this.date, required this.tagCount, required this.storeCount, required this.imageCount, required this.score, this.tags = const [], this.status = _TaskStatus.done});
}

// ── 抓图等候页 ──
class _SnapshotPage extends StatefulWidget {
  final List<String> tags;
  final List<String> storeIds;
  final void Function(List<_Capture> captures) onComplete;
  const _SnapshotPage({required this.tags, required this.storeIds, required this.onComplete});

  @override
  State<_SnapshotPage> createState() => _SnapshotPageState();
}

class _SnapshotPageState extends State<_SnapshotPage> {
  final List<_Capture> _allCaptures = [];
  final Set<int> _selected = {};
  bool _loading = true;
  int _loaded = 0;
  late final int _total;

  @override
  void initState() {
    super.initState();
    _total = (widget.tags.length + widget.storeIds.length).clamp(1, 10);
    _loadImages();
  }

  Future<void> _loadImages() async {
    final stores = Store.mockStores();
    final _storeNames = ['太平街店', '新街口店', '华强北店', '江汉路店', '五一广场店', '解放西路店', '湖滨银泰店', '光谷店', '步行街店', '芙蓉广场店'];
    final allTags = [...widget.tags];
    final allStoreIds = [...widget.storeIds];
    for (int i = 0; i < _total; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      final isTag = i < allTags.length;
      final tag = isTag ? allTags[i] : '门店巡检';
      final storeIdx = i % _storeNames.length;
      setState(() {
        _allCaptures.add(_Capture(
          tag: tag,
          store: '茶颜悦色·${_storeNames[storeIdx]}',
          time: DateTime.now().subtract(Duration(seconds: _total - i)),
        ));
        _loaded = _allCaptures.length;
        if (_loaded == _total) {
          _loading = false;
          _selected.addAll(List.generate(_total, (i) => i));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = _selected.length;
    return Scaffold(
      appBar: AppBar(title: Text(_loading ? '正在抓图...' : '确认抓图 ($count/${_total})')),
      body: Column(children: [
        // 固定顶部加载区
        if (_loading)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            color: AppTheme.bg,
            child: Column(children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.camera_alt, color: AppTheme.primary, size: 32),
              ),
              const SizedBox(height: 12),
              const Text('摄像头抓图中...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('$_loaded / $_total', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: LinearProgressIndicator(value: _total > 0 ? _loaded / _total : 0, backgroundColor: AppTheme.divider, color: AppTheme.primary),
              ),
            ]),
          ),
        // 下方列表滚动区
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _allCaptures.length,
          itemBuilder: (_, i) {
            final c = _allCaptures[i];
            final sel = _selected.contains(i);
            final colors = [Color(0xFF0EA2B8), Color(0xFF10B981), Color(0xFFE3811A), Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFFEC4899)];
            final color = colors[i % colors.length];
            return GestureDetector(
              onTap: () => setState(() => sel ? _selected.remove(i) : _selected.add(i)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: sel ? AppTheme.primary.withValues(alpha: 0.04) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: sel ? AppTheme.primary : AppTheme.divider, width: sel ? 1.5 : 0.5)),
                child: Row(children: [
                  sel
                    ? Container(margin: const EdgeInsets.only(right: 10), width: 22, height: 22, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.primary), child: const Icon(Icons.check, color: Colors.white, size: 14))
                    : Container(margin: const EdgeInsets.only(right: 10), width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.divider))),
                  Container(width: 64, height: 64, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.image, color: color, size: 30)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c.store, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Row(children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)), child: Text(c.tag, style: const TextStyle(fontSize: 10, color: AppTheme.accent))),
                      const SizedBox(width: 6),
                      Text(c.timeStr, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    ]),
                  ])),
                ]),
              ),
            );
          },
        )),
        if (!_loading)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.divider))),
            child: SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: _selected.isEmpty ? null : () {
                final selected = <_Capture>[];
                for (final i in _selected.toList()..sort()) {
                  selected.add(_allCaptures[i]);
                }
                widget.onComplete(selected);
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppTheme.primary),
              child: Text('确认 (${_selected.length}张)', style: const TextStyle(color: Colors.white, fontSize: 15)),
            )),
          ),
      ]),
    );
  }
}

// ── 确认抓图页结束 ──

// ── 任务列表页 ──
class _TaskListPage extends StatelessWidget {
  final List<_InspectionTask> tasks;
  const _TaskListPage({required this.tasks});

  Color _statusColor(_TaskStatus s) {
    switch (s) { case _TaskStatus.done: return AppTheme.success; case _TaskStatus.running: return AppTheme.primary; case _TaskStatus.pending: return AppTheme.textSecondary; }
  }

  String _statusLabel(_TaskStatus s) {
    switch (s) { case _TaskStatus.done: return '已结束'; case _TaskStatus.running: return '巡检中'; case _TaskStatus.pending: return '未开始'; }
  }

  void _showRestartDialog(BuildContext ctx, _InspectionTask t) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: Text(t.title), content: const Text('该任务已被取消，是否重新发起巡检？'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
        ElevatedButton(onPressed: () {
          Navigator.pop(ctx);
          // Re-add as running
          t.status = _TaskStatus.running;
          t.date = DateTime.now();
          (ctx as Element).markNeedsBuild();
        }, child: const Text('重新发起')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('巡检任务列表')),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: tasks.length, itemBuilder: (_, i) {
        final t = tasks[i];
        final isRunning = t.status == _TaskStatus.running;
        final isPending = t.status == _TaskStatus.pending;
        return GestureDetector(
          onTap: () {
            if (t.status == _TaskStatus.done) {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => _TaskReportPage(task: t)));
            } else if (isRunning) {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => _RunningPage(task: t)));
            }
            // pending: show restart dialog
            if (isPending) _showRestartDialog(context, t);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration,
            child: Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.check_circle, color: AppTheme.primary, size: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.title.length > 6 ? '${t.title.substring(0, 6)}...' : t.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text('${t.storeCount}家门店 · ${t.tagCount}个标签 · ${t.imageCount}张图片', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                Text('${t.date.month}月${t.date.day}日 ${t.date.hour}:${t.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: _statusColor(t.status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(_statusLabel(t.status), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor(t.status)))),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
            ]),
          ),
        );
      }),
    );
  }
}

// ── 任务报告页 ──
class _TaskReportPage extends StatelessWidget {
  final _InspectionTask task;
  const _TaskReportPage({required this.task});

  static final _allItems = {
    '后厨操作区': [('后厨卫生', '严重', Color(0xFFEF4444), ['垃圾桶盖未闭合，废弃食材堆积超4小时', '存在蝇虫滋生风险，环境卫生不合格'], 2)],
    '正门监控':   [('入口秩序', '正常', Color(0xFF10B981), ['门口整洁无杂物，迎宾区域保持良好', '引导标识清晰可见，无障碍物'], 1)],
    '收银台':     [('收银规范', '轻微', Color(0xFFF59E0B), ['收银台物品摆放杂乱，需整理', '备用零钱未及时补充'], 2)],
    '垃圾处理区': [('清洁卫生', '严重', Color(0xFFEF4444), ['垃圾桶未盖，异味较重', '地面有明显污渍，需深度清洁', '存在蝇虫滋生风险'], 3)],
    '洗碗间':     [('消毒记录', '轻微', Color(0xFFF59E0B), ['当日消毒记录缺失，需要立即补登', '消毒液配比不符合标准要求'], 2)],
    '消防通道':   [('消防安全', '严重', Color(0xFFEF4444), ['通道堆放纸箱杂物，严重堵塞', '灭火器过期未更换，需立即处理', '应急灯损坏不亮'], 3)],
    '仓库':       [('仓储管理', '轻微', Color(0xFFF59E0B), ['货架物品摆放不齐，存在倾倒风险', '温湿度记录缺失，需补录'], 2)],
    '员工通道':   [('出入管理', '正常', Color(0xFF10B981), ['通道畅通无阻，门禁系统运作正常', '监控设备运行良好'], 1)],
    '默认':       [('综合巡检', '正常', Color(0xFF10B981), ['巡检完成，各项指标均在标准范围内', '整体运行状况良好，无明显异常'], 1)],
  };

  List<(String, String, Color, List<String?>, int)> _getItems() {
    final items = <(String, String, Color, List<String?>, int)>[];
    for (final tag in task.tags) {
      if (_allItems.containsKey(tag)) {
        items.addAll(_allItems[tag]!);
      }
    }
    if (items.isEmpty) items.addAll(_allItems['默认']!);
    return items;
  }

  void _showImageViewer(BuildContext context, String name, Color color, List<String?> descs, int imgCount, int currentIdx) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      final colors = [Color(0xFF0EA2B8), Color(0xFFE3811A), Color(0xFF6366F1), Color(0xFF10B981), Color(0xFF8B5CF6), Color(0xFF3B82F6)];
      return Scaffold(
        appBar: AppBar(title: const Text('抓帧详情')),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: imgCount,
          itemBuilder: (_, i) {
            final c = colors[(currentIdx + i) % colors.length];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.divider)),
              child: Column(children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Stack(children: [
                    Center(child: Icon(Icons.image, color: c, size: 60)),
                    Positioned(top: 10, right: 10, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(4)),
                      child: const Text('问题点', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                    )),
                    Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), color: Colors.black.withValues(alpha: 0.4), child: Text('${task.date.month}月${task.date.day}日 抓帧${i + 1}', style: const TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center))),
                  ]),
                ),
                const SizedBox(height: 10),
                if (descs[i] != null) Text(descs[i]!, style: const TextStyle(fontSize: 14, color: AppTheme.text, height: 1.6)),
                if (descs[i] != null) ...[
                  const SizedBox(height: 6),
                  Text('第${i + 1}处问题', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
                ],
              ]),
            );
          },
        ),
      );
    }));
  }

  void _handleAction(BuildContext context, String action) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>
      Scaffold(
        appBar: AppBar(title: const Text('操作结果')),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: action == '整改' ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Icon(action == '整改' ? Icons.send : Icons.check_circle, color: action == '整改' ? AppTheme.primary : AppTheme.success, size: 36),
          ),
          const SizedBox(height: 20),
          Text(action == '整改' ? '整改通知已发送' : '已忽略', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(action == '整改' ? '整改通知已推送至相关门店店长及区域经理' : '该次巡检报告已存档，暂不处理', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('返回首页')),
        ])),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]), borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                Text(task.score.toStringAsFixed(1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('综合评分', style: TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 10),
                Text('${task.storeCount}家门店 · ${task.tagCount}个标签 · ${task.imageCount}张图片', style: const TextStyle(fontSize: 13, color: Colors.white)),
              ]),
            ),
            const SizedBox(height: 16),
            ..._getItems().asMap().entries.map((e) => _buildItem(context, e.key, e.value)),
          ]),
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.divider))),
          child: Row(children: [
            Expanded(child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () => _handleAction(context, '忽略'),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), side: BorderSide(color: AppTheme.textSecondary)),
                child: const Text('暂时忽略', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
              ),
            )),
            const SizedBox(width: 14),
            Expanded(child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _handleAction(context, '整改'),
                icon: const Icon(Icons.send, size: 20),
                label: const Text('发送整改', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              ),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _buildItem(BuildContext context, int index, (String, String, Color, List<String?>, int) item) {
    final (name, level, color, descs, imgCount) = item;
    final isAbnormal = level != '正常';
    final colors = [Color(0xFF0EA2B8), Color(0xFFE3811A), Color(0xFF6366F1), Color(0xFF10B981), Color(0xFF8B5CF6), Color(0xFF3B82F6)];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isAbnormal ? color.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isAbnormal ? color.withValues(alpha: 0.15) : AppTheme.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 标题
        Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Icon(isAbnormal ? Icons.warning_amber : Icons.check_circle, color: color, size: 16)),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(level, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color))),
          if (isAbnormal) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(6)), child: const Text('需整改', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)))],
        ]),
        const SizedBox(height: 12),
        // 图片+文字（每个描述一张图）
        ...List.generate(imgCount, (i) {
          final imageColor = colors[(index + i) % colors.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // 左图（可点击查看大图）
              GestureDetector(
                onTap: () => _showImageViewer(context, name, color, descs, imgCount, index),
                child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: imageColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Stack(children: [
                  Center(child: Icon(Icons.image, color: imageColor, size: 28)),
                  if (isAbnormal)
                    Positioned(top: 4, right: 4, child: Container(
                      width: 16, height: 16,
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(3)),
                      child: const Text('×', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    )),
                ]),
              )),
              const SizedBox(width: 10),
              // 右文字
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (descs[i] != null) Text(descs[i]!, style: const TextStyle(fontSize: 13, color: AppTheme.text, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('${task.date.month}月${task.date.day}日 抓帧${i + 1}', style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
              ])),
            ]),
          );
        }),
      ]),
    );
  }
}

// ── 全部标签页 ──
class _AllTagsPage extends StatelessWidget {
  final List<(String, Color, int, int)> tags;
  final Set<String> selected;
  final void Function(String) onToggle;
  const _AllTagsPage({required this.tags, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设备标签巡检')),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: tags.length, itemBuilder: (_, i) {
        final (name, color, storeCount, camCount) = tags[i];
        final sel = selected.contains(name);
        return GestureDetector(
          onTap: () { onToggle(name); Navigator.pop(context); },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: sel ? color.withValues(alpha: 0.06) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: sel ? color : AppTheme.divider, width: sel ? 1.5 : 0.5)),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.videocam, color: color, size: 24)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: sel ? color : AppTheme.text)),
                const SizedBox(height: 3),
                Text('$storeCount家门店 · $camCount个摄像头', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ])),
              sel ? Icon(Icons.check_circle, color: color, size: 22) : Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.divider))),
            ]),
          ),
        );
      }),
    );
  }
}

// ── 门店搜索页 ──
class _StoreListPage extends StatefulWidget {
  final List<Store> stores;
  final Set<String> selectedIds;
  final void Function(String) onToggle;
  const _StoreListPage({required this.stores, required this.selectedIds, required this.onToggle});
  @override
  State<_StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<_StoreListPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  final Set<String> _activeTags = {};
  bool _showAllTags = false;

  // 10个内置筛选标签
  static const _presetTags = [
    '日客流下降15%', '近7日客流下降20%', '食安周巡检问题店',
    '日巡检低于70分', '近30天未巡', '设备离线>2台',
    '新开门店', '待整改门店', '高客流门店', '低翻台率',
  ];

  bool _matchTag(Store s, String tag) {
    switch (tag) {
      case '日客流下降15%':   return s.healthScore < 80 || s.deviceCount <= 5;
      case '近7日客流下降20%': return s.healthScore < 75;
      case '食安周巡检问题店': return s.healthScore < 80;
      case '日巡检低于70分':   return s.healthScore < 70;
      case '近30天未巡':      return s.lastInspection.isBefore(DateTime.now().subtract(const Duration(days: 30)));
      case '设备离线>2台':    return s.deviceCount > 7;
      case '新开门店':         return s.lastInspection.isAfter(DateTime.now().subtract(const Duration(days: 3)));
      case '待整改门店':       return s.healthScore < 85 && s.healthScore >= 70;
      case '高客流门店':       return s.deviceCount >= 7;
      case '低翻台率':         return s.deviceCount <= 5;
      default: return false;
    }
  }

  List<Store> get _filtered {
    var list = widget.stores;
    if (_activeTags.isNotEmpty) {
      list = list.where((s) => _activeTags.any((t) => _matchTag(s, t))).toList();
    }
    if (_query.isNotEmpty) {
      list = list.where((s) => s.name.contains(_query) || s.city.contains(_query) || s.region.contains(_query)).toList();
    }
    return list;
  }

  Map<String, List<Store>> get _grouped {
    final map = <String, List<Store>>{};
    for (final s in _filtered) { map.putIfAbsent(s.region, () => []).add(s); }
    return map;
  }

  void _toggleTag(String tag) => setState(() => _activeTags.contains(tag) ? _activeTags.remove(tag) : _activeTags.add(tag));

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final groups = _grouped;
    return Scaffold(
      appBar: AppBar(title: const Text('选择巡检门店')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(14), child: TextField(
          controller: _searchCtrl, onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(hintText: '搜索门店名称、城市、区域...', prefixIcon: Icon(Icons.search, size: 20), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 11), isDense: true),
        )),
        // 标签筛选卡片
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.cardDecoration,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.label_outline, color: AppTheme.primary, size: 16), SizedBox(width: 6), Text('标签筛选', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 6, children: [
                ...(_showAllTags ? _presetTags : _presetTags.take(6)).map((t) {
                  final active = _activeTags.contains(t);
                  final color = t.contains('下降') || t.contains('问题') || t.contains('低于') ? const Color(0xFFEF4444)
                      : t.contains('未巡') || t.contains('离线') ? const Color(0xFFF59E0B)
                      : t.contains('开门') || t.contains('高客流') ? const Color(0xFF10B981)
                      : const Color(0xFF6366F1);
                  return GestureDetector(
                    onTap: () => _toggleTag(t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: active ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: active ? color : color.withValues(alpha: 0.2))),
                      child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: active ? color : AppTheme.textSecondary)),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: () => setState(() => _showAllTags = !_showAllTags),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_showAllTags ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 14, color: AppTheme.primary),
                      const SizedBox(width: 2),
                      Text(_showAllTags ? '收起' : '更多标签', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primary)),
                    ]),
                  ),
                ),
              ]),
            ]),
          ),
        ),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), itemCount: groups.length, itemBuilder: (_, i) {
            final region = groups.keys.elementAt(i);
            final stores = groups[region]!;
            return Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(region, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
              const SizedBox(height: 6),
              ...stores.map((s) {
                final sel = widget.selectedIds.contains(s.id);
                return GestureDetector(
                  onTap: () { widget.onToggle(s.id); Navigator.pop(context); },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: sel ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: sel ? AppTheme.primary : AppTheme.divider, width: sel ? 1.5 : 0.5)),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: sel ? AppTheme.primary : AppTheme.text)),
                        const SizedBox(height: 2),
                        Text('${s.city} · ${s.deviceCount}台设备', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ])),
                      sel ? const Icon(Icons.check_circle, color: AppTheme.primary, size: 22) : Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.divider))),
                    ]),
                  ),
                );
              }),
            ]));
          },
        )),
      ]),
    );
  }
}

// ── AI 分析中页（中间页）──
class _AnalyzingPage extends StatefulWidget {
  final List<_Capture> captures;
  final void Function(double score, int total) onComplete;
  const _AnalyzingPage({required this.captures, required this.onComplete});
  @override
  State<_AnalyzingPage> createState() => _AnalyzingPageState();
}

class _AnalyzingPageState extends State<_AnalyzingPage> {
  final List<bool> _imgDone = [];
  bool _allDone = false;
  double _score = 0;

  @override
  void initState() {
    super.initState();
    _imgDone.addAll(List.filled(widget.captures.length, false));
    _startAnalyze();
  }

  void _startAnalyze() {
    final total = widget.captures.length;
    _score = 80.0 + Random().nextInt(15) + Random().nextDouble();
    for (int i = 0; i < total; i++) {
      Future.delayed(Duration(seconds: i + 1), () {
        if (!mounted) return;
        setState(() => _imgDone[i] = true);
        if (_imgDone.every((d) => d)) {
          setState(() => _allDone = true);
          widget.onComplete(_score, total);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final done = _imgDone.where((d) => d).length;
    final total = widget.captures.length;
    return Scaffold(
      appBar: AppBar(title: const Text('AI 巡检分析中'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.auto_awesome, color: AppTheme.primary, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('AI 巡检分析中...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('$done / $total 已完成', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: LinearProgressIndicator(value: total > 0 ? done / total : 0, backgroundColor: AppTheme.divider, color: AppTheme.primary),
          ),
          const SizedBox(height: 20),
          ...widget.captures.asMap().entries.map((e) {
            final ok = _imgDone[e.key];
            final colors = [Color(0xFF0EA2B8), Color(0xFF10B981), Color(0xFFE3811A), Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFFEC4899)];
            final c = colors[e.key % colors.length];
            return Container(
              padding: const EdgeInsets.only(left: 0),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(ok ? Icons.check_circle : Icons.hourglass_bottom, color: ok ? AppTheme.success : AppTheme.textSecondary, size: 16),
                const SizedBox(width: 8),
                Text('${e.value.store} · ${e.value.tag}', style: TextStyle(fontSize: 12, color: ok ? AppTheme.text : AppTheme.textSecondary)),
              ]),
            );
          }),
        ])))),
        // 底部确认按钮
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.divider))),
          child: SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
            onPressed: _allDone ? () { Navigator.of(context).pop(); Navigator.of(context).pop(); } : null,
            style: ElevatedButton.styleFrom(backgroundColor: _allDone ? AppTheme.primary : AppTheme.primary.withValues(alpha: 0.3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: Text(_allDone ? '确认查看报告 (${_score.toStringAsFixed(1)}分)' : '请等待分析完成...', style: const TextStyle(fontSize: 16, color: Colors.white)),
          )),
        ),
      ]),
    );
  }
}

// ── 巡检中等待页 ──
class _RunningPage extends StatefulWidget {
  final _InspectionTask task;
  const _RunningPage({required this.task});
  @override
  State<_RunningPage> createState() => _RunningPageState();
}

class _RunningPageState extends State<_RunningPage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    Future.delayed(const Duration(seconds: 4), () { if (mounted) Navigator.pop(context); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.title)),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        AnimatedBuilder(animation: _ctrl, builder: (_, __) =>
          Transform.rotate(angle: _ctrl.value * 6.28, child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.hourglass_top, color: AppTheme.primary, size: 40),
          )),
        ),
        const SizedBox(height: 24),
        const Text('AI 巡检进行中...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('正在分析${widget.task.imageCount}张图片 · ${widget.task.tagCount}个标签', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
      ])),
    );
  }
}
