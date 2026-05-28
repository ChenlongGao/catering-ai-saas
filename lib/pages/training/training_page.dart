import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});
  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  static const _subjects = [
    ('后厨操作规范', Icons.restaurant, '食材处理、烹饪流程、卫生安全检查'),
    ('前厅服务流程', Icons.room_service, '迎宾礼仪、点单确认、上菜节奏'),
    ('清洁卫生标准', Icons.cleaning_services, '台面清洁、地面消毒、垃圾分类'),
    ('消防安全操作', Icons.local_fire_department, '灭火器使用、燃气阀门检查'),
    ('食材验收流程', Icons.inventory, '验货标准、称重记录、入库标签'),
    ('客诉处理规范', Icons.support_agent, '投诉响应、退换菜流程、安抚话术'),
  ];

  String? _selectedSubject;
  bool _isAnalyzing = false;
  TrainingResult? _result;
  int _tabIndex = 0; // 0=日 1=周 2=月

  // 不同周期的打卡事项
  static const _dailyItems = ['着装规范', '设备检查', '食材验收', '晨会签到'];
  static const _weeklyItems = ['消防巡检', '卫生深度清洁', '菜单更新', '库存盘点', '员工培训'];
  static const _monthlyItems = ['消防演练', '厨房深度保养', '业绩复盘', '供应商评估', '安全考核', '健康证检查'];

  @override
  Widget build(BuildContext context) {
    if (_result != null) return _buildReport(_result!);
    if (_isAnalyzing) return _buildAnalyzing();
    return Scaffold(
      appBar: AppBar(title: const Text('AI 陪练打卡')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accentLight]), borderRadius: BorderRadius.circular(16)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.auto_awesome, color: Colors.white, size: 22), SizedBox(width: 12), Text('云盯AI陪练打卡', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))]),
              SizedBox(height: 10),
              Text('选择陪练科目，完成操作规范打卡', style: TextStyle(fontSize: 14, color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('陪练科目', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          // TAB切换：日/周/月
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              _tabBtn('日打卡', 0), _tabBtn('周打卡', 1), _tabBtn('月打卡', 2),
            ]),
          ),
          const SizedBox(height: 12),
          ..._buildTabItems(),
        ]),
      ),
    );
  }

  Widget _tabBtn(String text, int idx) {
    final sel = _tabIndex == idx;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _tabIndex = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: sel ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(text, style: TextStyle(fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, color: sel ? AppTheme.primary : AppTheme.textSecondary))),
      ),
    ));
  }

  List<Widget> _buildTabItems() {
    final items = _tabIndex == 0 ? _dailyItems : _tabIndex == 1 ? _weeklyItems : _monthlyItems;
    return items.map((item) {
      final rng = DateTime.now().millisecondsSinceEpoch + item.hashCode;
      final pending = rng % 3 != 0 ? rng % 4 + 1 : 0;
      final done = rng % 2 == 0 ? rng % 3 + 1 : 0;
      return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _CheckinPage(item: item, tabLabel: _tabIndex == 0 ? '日打卡' : _tabIndex == 1 ? '周打卡' : '月打卡', onComplete: (r) => setState(() { _result = r; _isAnalyzing = false; })))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.checklist, color: AppTheme.accent, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(_tabIndex == 0 ? '每日必做' : _tabIndex == 1 ? '每周任务' : '每月任务', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 6),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppTheme.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text('未打卡$pending', style: const TextStyle(fontSize: 10, color: AppTheme.error, fontWeight: FontWeight.w500))),
                const SizedBox(width: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text('已完成$done', style: const TextStyle(fontSize: 10, color: AppTheme.success, fontWeight: FontWeight.w500))),
              ]),
            ])),
            const Icon(Icons.chevron_right, color: Color(0xFFD0D0D0)),
          ]),
        ),
      );
    }).toList();
  }

  Widget _buildAnalyzing() {
    return Scaffold(appBar: AppBar(title: const Text('AI 陪练分析中')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 3, color: AppTheme.accent))),
      const SizedBox(height: 24), const Text('AI 分析中...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    ])));
  }

  Widget _buildReport(TrainingResult r) {
    return Scaffold(appBar: AppBar(title: const Text('陪练报告')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accentLight]), borderRadius: BorderRadius.circular(16)), child: Column(children: [const Text('综合评分', style: TextStyle(fontSize: 14, color: Colors.white70)), const SizedBox(height: 8), Text('${r.overallScore.toInt()}', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)), Text('科目：${r.subject}', style: const TextStyle(fontSize: 13, color: Colors.white60))])),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.divider)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.assignment, color: AppTheme.accent, size: 18), SizedBox(width: 8), Text('逐项评分', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]), const SizedBox(height: 14), ...r.items.map((item) => _buildScoreItem(item))])),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.accent.withValues(alpha: 0.15))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.auto_awesome, color: AppTheme.accent, size: 16), const SizedBox(width: 8), const Text('AI 点评', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]), const SizedBox(height: 10), Text(r.aiComment, style: const TextStyle(fontSize: 14, height: 1.6, color: AppTheme.text))])),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => setState(() => _result = null), icon: const Icon(Icons.refresh), label: const Text('返回'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
    ])));
  }

  Widget _buildScoreItem(TrainingItem item) {
    final c = item.score >= 80 ? AppTheme.success : item.score >= 60 ? AppTheme.warning : AppTheme.error;
    return Container(margin: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), Text('${item.score}分', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c))]), const SizedBox(height: 6), ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: item.score / 100, backgroundColor: AppTheme.divider, color: c, minHeight: 6)), const SizedBox(height: 4), Text(item.comment, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))]));
  }

  static List<_CoachTask> _mockTasks(String subject) {
    final rng = Random(subject.hashCode);
    final tasks = <_CoachTask>[];
    final now = DateTime.now();
    for (int d = 0; d < 7; d++) {
      final day = now.subtract(Duration(days: d));
      final date = DateTime(day.year, day.month, day.day, 8 + rng.nextInt(14));
      int pending = 1 + rng.nextInt(3);
      int running = 1 + rng.nextInt(3);
      int done = 1 + rng.nextInt(3);
      for (int i = 0; i < pending; i++) {
        tasks.add(_CoachTask(id: '${subject}_${d}_p$i', title: subject, desc: subject, date: DateTime(date.year, date.month, date.day, 8 + i), status: _TaskStatus.pending, score: 0));
      }
      for (int i = 0; i < running; i++) {
        tasks.add(_CoachTask(id: '${subject}_${d}_r$i', title: subject, desc: subject, date: DateTime(date.year, date.month, date.day, 10 + i), status: _TaskStatus.running, score: 0));
      }
      for (int i = 0; i < done; i++) {
        tasks.add(_CoachTask(id: '${subject}_${d}_d$i', title: subject, desc: subject, date: DateTime(date.year, date.month, date.day, 14 + i), status: _TaskStatus.done, score: 75 + rng.nextInt(21)));
      }
    }
    // 日期倒序，同日期内：未打卡→进行中→已打卡
    tasks.sort((a, b) {
      int dc = b.date.compareTo(a.date);
      if (dc != 0) return dc;
      const order = {_TaskStatus.pending: 0, _TaskStatus.running: 1, _TaskStatus.done: 2};
      return order[a.status]!.compareTo(order[b.status]!);
    });
    return tasks;
  }
}

// ── 科目任务列表页 ──
class _SubjectTaskPage extends StatelessWidget {
  final String subject;
  final IconData icon;
  const _SubjectTaskPage({required this.subject, required this.icon});

  @override
  Widget build(BuildContext context) {
    final tasks = _TrainingPageState._mockTasks(subject);
    // 按日期分组
    final grouped = <String, List<_CoachTask>>{};
    for (final t in tasks) {
      final key = '${t.date.month}月${t.date.day}日';
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final dates = grouped.keys.toList()
      ..sort((a, b) {
        final aNum = int.parse(a.replaceAll(RegExp(r'[^0-9]'), ''));
        final bNum = int.parse(b.replaceAll(RegExp(r'[^0-9]'), ''));
        return bNum.compareTo(aNum);
      });

    return Scaffold(
      appBar: AppBar(title: Text(subject)),
      body: CustomScrollView(slivers: [
        ...dates.map((date) {
          final dateTasks = grouped[date]!;
          return SliverPersistentHeader(
            pinned: true,
            delegate: _DateHeaderDelegate(date: date, count: dateTasks.length),
          );
        }),
        ...dates.map((date) {
          final dateTasks = grouped[date]!;
          return SliverList(delegate: SliverChildBuilderDelegate(
            (_, i) {
              final t = dateTasks[i];
              return _taskItem(context, t, icon);
            },
            childCount: dateTasks.length,
          ));
        }),
      ]),
    );
  }

  Widget _taskItem(BuildContext context, _CoachTask t, IconData icon) {
    final isPending = t.status == _TaskStatus.pending;
    final isRunning = t.status == _TaskStatus.running;
    final isDone = t.status == _TaskStatus.done;
    return GestureDetector(
      onTap: () {
        if (isPending) Navigator.of(context).push(MaterialPageRoute(builder: (_) => _TaskDetailPage(subject: subject, task: t)));
        if (isDone) Navigator.of(context).push(MaterialPageRoute(builder: (_) => _TaskResultPage(subject: subject, task: t)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: (isPending ? AppTheme.error : isRunning ? AppTheme.primary : AppTheme.success).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: isPending ? AppTheme.error : isRunning ? AppTheme.primary : AppTheme.success, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.desc, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 3),
            Text('${t.date.hour}:${t.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          _statusBadge(t.status),
          const SizedBox(width: 4), const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ]),
      ),
    );
  }
}

class _DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String date;
  final int count;
  const _DateHeaderDelegate({required this.date, required this.count});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.bg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(children: [
        Container(width: 4, height: 16, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.text)),
        const SizedBox(width: 6),
        Text('$count项任务', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ]),
    );
  }

  @override
  double get maxExtent => 42;
  @override
  double get minExtent => 42;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

Widget _statusBadge(_TaskStatus s) {
  switch (s) {
    case _TaskStatus.pending: return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Text('未打卡', style: TextStyle(fontSize: 11, color: AppTheme.error, fontWeight: FontWeight.w500)));
    case _TaskStatus.running: return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Text('进行中', style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w500)));
    case _TaskStatus.done: return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: const Text('已打卡', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500)));
  }
}

// ── 任务标准页 + 上传 ──
class _TaskDetailPage extends StatefulWidget {
  final String subject;
  final _CoachTask task;
  const _TaskDetailPage({required this.subject, required this.task});
  @override
  State<_TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<_TaskDetailPage> {

  @override
  Widget build(BuildContext context) {
    final items = ['着装检查：厨师帽、口罩、围裙到位', '操作规范：流程标准执行', '清洁消毒：区域卫生达标', '记录完整：日志填写规范'];
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.desc)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 时间信息
        Container(padding: const EdgeInsets.all(14), decoration: AppTheme.cardDecoration, child: Row(children: [
          const Icon(Icons.access_time, color: AppTheme.accent, size: 18), const SizedBox(width: 8),
          Text('${widget.task.date.month}月${widget.task.date.day}日 ${widget.task.date.hour}:${widget.task.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ])),
        const SizedBox(height: 14),
        // 任务列表
        Container(padding: const EdgeInsets.all(14), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.checklist, color: AppTheme.accent, size: 18), SizedBox(width: 8), Text('任务清单', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Center(child: Text('${e.key + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.accent)))),
            const SizedBox(width: 10), Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13))),
          ]))),
        ])),
        const SizedBox(height: 14),
        // 提交素材
        Container(padding: const EdgeInsets.all(14), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.photo_library, color: AppTheme.primary, size: 18), SizedBox(width: 8), Text('提交素材', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          Row(children: List.generate(4, (i) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 80, decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)), child: const Center(child: Icon(Icons.add_photo_alternate, color: AppTheme.textSecondary, size: 28)))))),
        ])),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.auto_awesome, size: 18), label: const Text('开始AI陪练'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))),
      ])),
    );
  }

}

// ── 已结束结果查看 ──
class _TaskResultPage extends StatelessWidget {
  final String subject;
  final _CoachTask task;
  const _TaskResultPage({required this.subject, required this.task});

  @override
  Widget build(BuildContext context) {
    final rng = Random(task.id.hashCode);
    final items = [
      ('着装规范', rng.nextInt(30) + 65, '帽子口罩围裙均到位'),
      ('操作流程', rng.nextInt(30) + 60, '步骤执行基本完整'),
      ('清洁消毒', rng.nextInt(35) + 60, '消毒记录有缺项'),
      ('时间把控', rng.nextInt(25) + 70, '整体耗时达标'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(task.desc)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 评分卡模块
        Container(
          width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.accent, AppTheme.accentLight]), borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            const Text('综合评分', style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 8),
            Text('${task.score}', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text('科目：$subject', style: const TextStyle(fontSize: 13, color: Colors.white60)),
            const SizedBox(height: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)), child: const Text('已打卡', style: TextStyle(fontSize: 12, color: Colors.white))),
          ]),
        ),
        const SizedBox(height: 16),
        // 任务标题模块
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.assignment, color: AppTheme.accent, size: 18), SizedBox(width: 8), Text('任务详情', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          _rr(context, '科目', subject),
          _rr(context, '日期', '${task.date.month}月${task.date.day}日 ${task.date.hour}:${task.date.minute.toString().padLeft(2, '0')}'),
          _rr(context, '状态', '已完成'),
          _rr(context, '评分', '${task.score}分'),
        ])),
        const SizedBox(height: 14),
        // 逐项评分
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.bar_chart, color: AppTheme.primary, size: 18), SizedBox(width: 8), Text('逐项评分', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 14),
          ...items.map((item) {
            final (name, score, comment) = item;
            final c = score >= 80 ? AppTheme.success : score >= 65 ? AppTheme.warning : AppTheme.error;
            return Container(margin: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)), Text('$score分', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c))]),
              const SizedBox(height: 6),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: score / 100, backgroundColor: AppTheme.divider, color: c, minHeight: 6)),
              const SizedBox(height: 4),
              Text(comment, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ]));
          }),
        ])),
        const SizedBox(height: 14),
        // 图片视频模块
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.photo_library, color: AppTheme.accent, size: 18), SizedBox(width: 8), Text('提交素材', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 10),
          const Text('图片 (5张)', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: List.generate(5, (i) {
            final colors = [Color(0xFF0EA2B8), Color(0xFF10B981), Color(0xFF6366F1), Color(0xFFE3811A), Color(0xFFEF4444)];
            return Container(width: 72, height: 72, decoration: BoxDecoration(color: colors[i].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Center(child: Icon(Icons.image, color: colors[i], size: 28)));
          })),
          const SizedBox(height: 16),
          const Text('视频 (1条)', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.accent.withValues(alpha: 0.1))),
            child: Row(children: [
              Container(width: 48, height: 36, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)), child: const Center(child: Icon(Icons.play_arrow, color: Colors.white70, size: 22))),
              const SizedBox(width: 10),
              const Expanded(child: Text('操作录像 · 00:15', style: TextStyle(fontSize: 13))),
            ]),
          ),
        ])),
        const SizedBox(height: 40),
      ])),
    );
  }

  Widget _rr(BuildContext context, String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
      SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    ]));
  }
}

// ── 打卡中间页 ──
class _CheckinPage extends StatefulWidget {
  final String item;
  final String tabLabel;
  final void Function(TrainingResult) onComplete;
  const _CheckinPage({required this.item, required this.tabLabel, required this.onComplete});
  @override
  State<_CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<_CheckinPage> {
  final List<String> _photos = [];
  final List<String> _videos = [];
  bool _submitting = false;

  void _addPhoto() { if (_photos.length < 4) setState(() => _photos.add('photo_${_photos.length + 1}')); }
  void _addVideo() { if (_videos.isEmpty) setState(() => _videos.add('video_1')); }

  void _submit() {
    setState(() => _submitting = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final rng = DateTime.now().millisecondsSinceEpoch;
      widget.onComplete(TrainingResult(
        overallScore: 75 + (rng % 21).toDouble(),
        subject: widget.item,
        items: [
          TrainingItem(name: '操作规范', score: rng % 30 + 65, comment: rng % 2 == 0 ? '流程执行完整，达标' : '个别步骤有遗漏，基本达标'),
          TrainingItem(name: '着装规范', score: rng % 25 + 70, comment: '帽子口罩围裙穿戴到位'),
          TrainingItem(name: '时间把控', score: rng % 20 + 75, comment: rng % 3 == 0 ? '整体耗时优秀' : '在标准范围内'),
          TrainingItem(name: '清洁卫生', score: rng % 35 + 60, comment: rng % 2 == 0 ? '台面清洁良好' : '部分区域需加强'),
        ],
        aiComment: '本次${widget.item}打卡完成度较好，建议持续保持规范操作。重点关注的细节已标记在评分明细中。',
      ));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.tabLabel} · ${widget.item}')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.description, color: AppTheme.accent, size: 18), SizedBox(width: 8), Text('打卡内容', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          Text(_desc(widget.item), style: const TextStyle(fontSize: 14, color: AppTheme.text, height: 1.6)),
        ])),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.photo_library, color: AppTheme.primary, size: 18), const SizedBox(width: 8),
            const Text('上传图片（最多4张）', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            GestureDetector(onTap: _addPhoto, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add, size: 14, color: AppTheme.primary), SizedBox(width: 2), Text('添加', style: TextStyle(fontSize: 12, color: AppTheme.primary))]))),
          ]),
          const SizedBox(height: 10),
          Row(children: _photos.isEmpty ? [Expanded(child: Container(height: 80, decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.divider)), child: const Center(child: Icon(Icons.add_photo_alternate, color: AppTheme.textSecondary, size: 32))))] : _photos.map((p) => Padding(padding: const EdgeInsets.only(right: 8), child: Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Center(child: Icon(Icons.image, color: AppTheme.primary, size: 32))))).toList()),
        ])),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.videocam, color: AppTheme.info, size: 18), const SizedBox(width: 8),
            const Text('上传视频（1个）', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            GestureDetector(onTap: _addVideo, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add, size: 14, color: AppTheme.info), SizedBox(width: 2), Text('添加', style: TextStyle(fontSize: 12, color: AppTheme.info))]))),
          ]),
          const SizedBox(height: 10),
          if (_videos.isEmpty)
            Container(height: 80, decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.divider)), child: const Center(child: Icon(Icons.videocam, color: AppTheme.textSecondary, size: 32)))
          else
            Container(width: 120, height: 80, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)), child: const Center(child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 32))),
        ])),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(
          onPressed: _submitting ? null : _submit,
          icon: _submitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.auto_awesome, size: 18),
          label: Text(_submitting ? 'AI分析中...' : '提交打卡 · AI评阅', style: const TextStyle(fontSize: 16, color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        )),
      ])),
    );
  }

  String _desc(String item) {
    switch (item) {
      case '着装规范': return '检查员工着装是否规范：厨师帽佩戴整齐、口罩遮住口鼻、围裙干净无污渍。对不符合规范的细节拍照记录。';
      case '设备检查': return '检查后厨设备运行状态：灶台点火正常、油烟净化器运转、冷藏设备温度达标（0-4℃）、消毒柜工作正常。';
      case '食材验收': return '验收当日到货食材：核对品种数量、检查新鲜度（色泽/气味/手感）、确认供应商资质、记录入库温度。';
      case '晨会签到': return '记录晨会签到情况：出勤人数、仪容仪表检查、当日重点工作布置、前日问题回顾。';
      case '消防巡检': return '检查消防设施：灭火器压力表正常、消防栓可正常开启、疏散通道畅通、应急灯测试正常、燃气阀门检查。';
      case '卫生深度清洁': return '执行每周深度清洁：排烟罩拆洗、地面沟渠清理、冷藏设备内部清洁、垃圾桶消毒、死角检查。';
      case '菜单更新': return '检查菜单更新情况：新品上架确认、沽清菜品下架、价格核对、推荐菜品打印更新、线上菜单同步。';
      case '库存盘点': return '执行库存盘点：原料实际数量与系统核对、效期检查（近效期标记）、损耗记录、补货清单生成。';
      case '员工培训': return '组织每周培训：食品安全知识、服务礼仪规范、新品操作流程、客诉处理技巧。拍照记录培训签到和现场。';
      case '消防演练': return '组织月度消防演练：疏散路线演练、灭火器实操、燃气泄漏应急处置、人员清点、演练总结记录。';
      case '厨房深度保养': return '月度厨房设备保养：灶台深度清洗、排烟管道检查、冷藏设备除霜、制冰机清洁消毒、设备运行记录。';
      case '业绩复盘': return '月度经营复盘：营收对比分析、成本率核查、客单价趋势、翻台率统计、利润分析。';
      case '供应商评估': return '月度供应商评估：到货准时率、品质合格率、价格竞争力、服务响应速度、供应商评分表。';
      case '安全考核': return '月度安全考核：食品安全知识测试、操作规范实操考核、消防知识问答、急救技能检查。';
      case '健康证检查': return '检查全员健康证有效期：到期提醒、新员工体检安排、健康证归档、过期人员停岗通知。';
      default: return '请按照规范要求完成本项打卡任务，拍照或录像记录关键环节。';
    }
  }
}

enum _TaskStatus { pending, running, done }

class _CoachTask {
  final String id, title, desc;
  final DateTime date;
  final _TaskStatus status;
  final int score;
  const _CoachTask({required this.id, required this.title, required this.desc, required this.date, required this.status, required this.score});
}

class _MediaItem {
  final String id; final _MediaType type; final String label; bool compressed; final String? duration;
  _MediaItem({required this.id, required this.type, required this.label, this.compressed = false, this.duration});
}

enum _MediaType { image, video }

class TrainingResult {
  final String subject; final double overallScore; final List<TrainingItem> items; final String aiComment;
  const TrainingResult({required this.subject, required this.overallScore, required this.items, required this.aiComment});
}

class TrainingItem {
  final String name; final int score; final String comment;
  const TrainingItem({required this.name, required this.score, required this.comment});
}
