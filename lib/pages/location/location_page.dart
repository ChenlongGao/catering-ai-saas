import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _cuisineCtrl = TextEditingController(text: '新式茶饮');
  final _spendCtrl   = TextEditingController(text: '25');
  final _seatingCtrl = TextEditingController(text: '40');
  final _addressCtrl = TextEditingController(text: '长沙市天心区解放西路88号');
  final _remarkCtrl  = TextEditingController(text: '靠近地铁口，日均客流约3万人次');
  bool _isAnalyzing = false;
  bool _analysisDone = false;
  int _analysisStep = 0;
  final List<String> _steps = ['查询周边客流数据', '扫描竞品门店分布', '测算预估营收模型', '评估风险因素', '生成选址报告'];
  final List<String> _streetPhotos = [];

  final List<_LocationItem> _history = _generateData();
  List<_LocationItem> get _favorites => _history.where((h) => h.favorited).toList();

  static List<_LocationItem> _generateData() {
    final rng = Random(42);
    return List.generate(8, (i) => _LocationItem(
      id: 'H${i + 1}',
      name: ['解放西路店', '太平街口店', '坡子街店', '五一广场店', '黄兴广场店', '芙蓉广场店', '万家丽店', '梅溪湖店'][i],
      address: ['天心区解放西路88号', '天心区太平街128号', '天心区坡子街56号', '芙蓉区五一大道668号', '天心区黄兴南路260号', '芙蓉区芙蓉中路188号', '雨花区万家丽路99号', '岳麓区梅溪湖路36号'][i],
      score: 70 + rng.nextInt(21),
      date: DateTime.now().subtract(Duration(days: i * 4 + 1)),
      favorited: i % 2 == 0,
    ));
  }

  @override
  void dispose() {
    _cuisineCtrl.dispose(); _spendCtrl.dispose(); _seatingCtrl.dispose(); _addressCtrl.dispose(); _remarkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAnalyzing) return _buildAnalyzing();
    return Scaffold(
      appBar: AppBar(title: const Text('AI 智能选址')),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 顶部卡片
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.map, color: Colors.white, size: 22)), const SizedBox(width: 12), const Text('云盯AI智能选址', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))]),
              const SizedBox(height: 10), const Text('填入参数 · AI分析客流竞品 · 科学选址', style: TextStyle(fontSize: 14, color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 16),
          // 历史 + 收藏
          Row(children: [
            Expanded(child: _moduleCard(Icons.history, 'AI选址历史', '${_history.length}条', Color(0xFF6366F1), () => _openList(context, 'AI选址历史', _history))),
            const SizedBox(width: 10),
            Expanded(child: _moduleCard(Icons.bookmark, 'AI选址收藏', '${_favorites.length}条', Color(0xFFE3811A), () => _openList(context, 'AI选址收藏', _favorites))),
          ]),
          const SizedBox(height: 20),
          // 拍照打卡扫街
          Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.camera_alt, color: AppTheme.accent, size: 18), const SizedBox(width: 8),
              const Text('拍照打卡扫街', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (_streetPhotos.length >= 12) return;
                  setState(() => _streetPhotos.add('photo_${DateTime.now().millisecondsSinceEpoch}'));
                  // 模拟解析地址填入
                  if (_streetPhotos.length == 1) _addressCtrl.text = '长沙市天心区解放西路88号（照片定位）';
                },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.camera, color: AppTheme.accent, size: 14), const SizedBox(width: 4),
                  Text('拍照 ${_streetPhotos.length}/12', style: const TextStyle(fontSize: 12, color: AppTheme.accent, fontWeight: FontWeight.w500)),
                ])),
              ),
            ]),
            const SizedBox(height: 12),
            if (_streetPhotos.isEmpty)
              Row(children: [
                _photoSlot('店招环境'), const SizedBox(width: 10),
                _photoSlot('人流动线'), const SizedBox(width: 10),
                _photoSlot('竞品门店'),
              ])
            else
              Wrap(spacing: 8, runSpacing: 8, children: _streetPhotos.map((p) => Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Center(child: Icon(Icons.image, color: AppTheme.accent, size: 32)))).toList()),
          ])),
          const SizedBox(height: 20),
          // 餐饮业态参数
          Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Icon(Icons.tune, color: AppTheme.primary, size: 18), SizedBox(width: 8), Text('餐饮业态参数', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]),
            const SizedBox(height: 16),
            _field('餐饮品类', _cuisineCtrl, '如：火锅、茶饮、快餐'),
            _field('人均消费(元)', _spendCtrl, '预计客单价', kt: TextInputType.number),
            _field('座位数', _seatingCtrl, '预估座位数量', kt: TextInputType.number),
            _field('目标地址', _addressCtrl, '详细地址或商圈名称', suffix: GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _MapViewPage(address: _addressCtrl.text))), child: const Icon(Icons.map, color: AppTheme.primary, size: 20))),
            _field('补充说明', _remarkCtrl, '可填写周边商圈特征、竞争情况等（100字内）', maxLines: 3, maxLen: 100),
          ])),
          const SizedBox(height: 80),
        ]))),
        // 固定底部按钮
        Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.divider))), child: SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(
          onPressed: () { setState(() { _isAnalyzing = true; _analysisDone = false; _analysisStep = 0; }); _simulateAnalysis(); },
          icon: const Icon(Icons.auto_awesome), label: const Text('AI 分析选址', style: TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        ))),
      ]),
    );
  }

  void _openList(BuildContext ctx, String title, List<_LocationItem> items) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => _LocationListPage(title: title, items: items)));
  }

  Widget _moduleCard(IconData icon, String title, String sub, Color color, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.15))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 6), Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)))]),
      const SizedBox(height: 6), Text(sub, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
    ])));
  }

  Widget _field(String label, TextEditingController ctrl, String hint, {TextInputType? kt, Widget? suffix, int maxLines = 1, int? maxLen}) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextField(controller: ctrl, keyboardType: kt, maxLines: maxLines, maxLength: maxLen, style: const TextStyle(fontSize: 14), decoration: InputDecoration(
        hintText: hint, hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.all(10), child: suffix) : null,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: AppTheme.divider)),
        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: AppTheme.divider)),
        filled: true, fillColor: AppTheme.bg,
        counterText: '',
      )),
    ]));
  }

  Widget _photoSlot(String label) {
    return Expanded(child: Container(height: 100, decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.divider)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.add_a_photo, color: AppTheme.textSecondary.withValues(alpha: 0.5), size: 24),
      const SizedBox(height: 6), Text(label, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
    ])));
  }

  void _simulateAnalysis() {
    for (int i = 0; i < _steps.length; i++) {
      Future.delayed(Duration(milliseconds: 600 * (i + 1)), () {
        if (!mounted) return;
        setState(() => _analysisStep = i + 1);
        if (i == _steps.length - 1) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            setState(() => _analysisDone = true);
          });
        }
      });
    }
  }

  Widget _buildAnalyzing() {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 分析中')),
      body: Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1), duration: const Duration(seconds: 1),
          builder: (_, v, child) => Transform.rotate(angle: v * 6.28, child: child),
          child: Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color(0xFF059669).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: const Center(child: Icon(Icons.hourglass_bottom, color: Color(0xFF059669), size: 40))),
        ),
        const SizedBox(height: 24), const Text('AI 分析中...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8), const Text('客流·竞品·营收模型测算中', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
        const SizedBox(height: 24),
        Container(margin: const EdgeInsets.symmetric(horizontal: 32), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.divider)), child: Column(children: _steps.asMap().entries.map((e) {
          final done = e.key < _analysisStep;
          final active = e.key == _analysisStep;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
            Icon(done ? Icons.check_circle : active ? Icons.hourglass_bottom : Icons.circle_outlined, size: 16, color: done ? AppTheme.success : active ? const Color(0xFF059669) : AppTheme.divider),
            const SizedBox(width: 10),
            Text(e.value, style: TextStyle(fontSize: 13, color: done ? AppTheme.success : active ? const Color(0xFF059669) : AppTheme.textSecondary)),
          ]));
        }).toList())),
        const SizedBox(height: 32),
        Row(children: [
          Expanded(child: ElevatedButton(
            onPressed: _analysisDone ? () => setState(() => _isAnalyzing = false) : null,
            style: ElevatedButton.styleFrom(backgroundColor: _analysisDone ? const Color(0xFF059669) : const Color(0xFF059669).withValues(alpha: 0.2), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), disabledBackgroundColor: const Color(0xFF059669).withValues(alpha: 0.15)),
            child: Text('查看分析报告', style: TextStyle(fontSize: 15, color: _analysisDone ? Colors.white : Colors.white70)),
          )),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton(
            onPressed: () => setState(() => _isAnalyzing = false),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: Color(0xFF059669))),
            child: const Text('返回应用页面', style: TextStyle(fontSize: 15, color: Color(0xFF059669))),
          )),
        ]),
      ]))),
    );
  }
}

// ── 选址列表页（时间轴）──
class _LocationListPage extends StatelessWidget {
  final String title;
  final List<_LocationItem> items;
  const _LocationListPage({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final sorted = List<_LocationItem>.from(items)..sort((a, b) => b.date.compareTo(a.date));
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sorted.length,
        itemBuilder: (_, i) {
          final item = sorted[i];
          final showDate = i == 0 || sorted[i].date.day != sorted[i - 1].date.day || sorted[i].date.month != sorted[i - 1].date.month;
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (showDate) ...[
              const SizedBox(height: 4),
              Text('${item.date.month}月${item.date.day}日', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.text)),
              const SizedBox(height: 8),
            ],
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _LocationReportPage(item: item))),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
                decoration: AppTheme.cardDecoration,
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      if (item.favorited) ...[const SizedBox(width: 6), const Icon(Icons.star, color: Color(0xFFE3811A), size: 16)],
                    ]),
                    const SizedBox(height: 4), Text(item.address, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${item.score}分', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF059669))),
                  ]),
                ]),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

// ── 选址报告页（核心）──
class _LocationReportPage extends StatefulWidget {
  final _LocationItem item;
  const _LocationReportPage({required this.item});
  @override
  State<_LocationReportPage> createState() => _LocationReportPageState();
}

class _LocationReportPageState extends State<_LocationReportPage> {
  late bool _fav;

  @override
  void initState() {
    super.initState();
    _fav = widget.item.favorited;
  }

  @override
  Widget build(BuildContext context) {
    final rng = Random(widget.item.id.hashCode);
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 评分卡
        Container(
          width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]), borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            const Text('选址综合评分', style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 8), Text('${widget.item.score}', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(widget.item.address, style: const TextStyle(fontSize: 13, color: Colors.white60)),
          ]),
        ),
        const SizedBox(height: 20),
        // 亮点分析
        _highlightsCard(rng),
        const SizedBox(height: 16),
        // 拍照打卡
        _photosCard(),
        const SizedBox(height: 16),
        // 报告卡片
        _reportCard('商圈分析', Icons.storefront, Color(0xFF059669), '日均客流', '${8000 + rng.nextInt(4000)}人次', '辐射商圈', '${1 + rng.nextInt(3)}个', '该区域位于核心商圈辐射范围，周边商业密度较高。日均客流量稳定在8000-12000人次，周末可达15000+。但需关注附近在建商业体的分流风险。', _chartData(['周一','周二','周三','周四','周五','周六','周日'], List.generate(7, (_) => 6000.0 + rng.nextInt(8000).toDouble()), color: Color(0xFF059669))),
        _reportCard('商场分析', Icons.business, Color(0xFF0EA2B8), '入驻率', '${85 + rng.nextInt(10)}%', '坪效预估', '¥${120 + rng.nextInt(60)}/㎡', '周边商场以中端餐饮为主，品类覆盖茶饮、快餐、火锅等。该商场餐饮坪效在中位数以上，新茶饮品类竞争适中，有切入空间。', _chartData(['茶饮','快餐','火锅','西餐','烘焙','咖啡'], List.generate(6, (_) => 3.0 + rng.nextInt(12).toDouble()), color: Color(0xFF0EA2B8))),
        _reportCard('竞对洞察', Icons.groups, Color(0xFF6366F1), '直接竞品', '${2 + rng.nextInt(4)}家', '品类竞争', '中高强度', '周边500米内已开业3家茶饮品牌，包括茶百道（120m）、喜茶（200m）。但消费群体存在差异化，本品牌主打新式国风茶饮，客群不直接冲突。', _chartData(['茶百道','喜茶','蜜雪','古茗','瑞幸','星巴克'], List.generate(6, (_) => 50.0 + rng.nextInt(450).toDouble()), color: Color(0xFF6366F1))),
        _reportCard('客流画像', Icons.person_pin, Color(0xFFE3811A), '主力客群', '18-35岁', '消费力', '¥20-35/客', '核心客群为18-35岁年轻女性，占比约65%。消费习惯偏社交分享型，线上种草转化率高。周末家庭客群占比提升至25%。', _chartData(['18-25','25-30','30-35','35-40','40+'], [40, 25, 15, 12, 8].map((e) => e.toDouble()).toList(), color: Color(0xFFE3811A))),
        _reportCard('周边人口', Icons.people, Color(0xFF8B5CF6), '常住人口', '${15 + rng.nextInt(10)}万', '写字楼密度', '${8 + rng.nextInt(7)}栋', '周边1公里范围内常住人口约18-25万，写字楼从业人口约12万。住宅与办公混合区域，全天候客流保障度高。', _chartData(['住宅','办公','商业','学校','医疗','其他'], List.generate(6, (_) => 5.0 + rng.nextInt(25).toDouble()), color: Color(0xFF8B5CF6))),
        _reportCard('周边交通', Icons.train, Color(0xFFEF4444), '地铁站', '${rng.nextInt(2) + 1}个', '公交线路', '${8 + rng.nextInt(12)}条', '距离最近地铁站约200米，步行3分钟可达。周边公交覆盖密集，停车位充足。交通便利度评分8.5/10。', _chartData(['地铁','公交','骑行','步行','驾车','出租'], List.generate(6, (_) => 10.0 + rng.nextInt(60).toDouble()), color: Color(0xFFEF4444))),
        const SizedBox(height: 20),
        // 底部操作
        Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Row(children: [
          GestureDetector(
            onTap: () => setState(() => _fav = !_fav),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: (_fav ? const Color(0xFFE3811A) : AppTheme.bg).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: _fav ? const Color(0xFFE3811A) : AppTheme.divider)), child: Row(children: [
              Icon(_fav ? Icons.star : Icons.star_border, color: _fav ? const Color(0xFFE3811A) : AppTheme.textSecondary, size: 20),
              const SizedBox(width: 4),
              Text(_fav ? '已收藏' : '收藏', style: TextStyle(fontSize: 13, color: _fav ? const Color(0xFFE3811A) : AppTheme.textSecondary)),
            ])),
          ),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.divider)), child: const Row(children: [
            Icon(Icons.share, color: AppTheme.textSecondary, size: 18),
            SizedBox(width: 4),
            Text('分享情报', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ])),
        ])),
        const SizedBox(height: 40),
      ])),
    );
  }

  Widget _highlightsCard(Random rng) {
    final highlights = ['客流量充足，高峰时段人流量可达目标值1.5倍', '周边商业氛围浓厚，综合体引流效应明显', '交通便利，地铁+公交覆盖率高', '客群消费力匹配，客单价预期达标'];
    final lows = ['竞品密度偏高，需差异化定位突破', '在建商业体可能分流，需监测进度', '租金成本略高，需精细控制运营成本'];
    return Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.auto_awesome, color: Color(0xFF059669), size: 18), SizedBox(width: 6), Text('亮点分析', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF059669)))]),
        const SizedBox(height: 10),
        const Row(children: [Icon(Icons.thumb_up, color: AppTheme.success, size: 14), SizedBox(width: 4), Text('亮点', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.success))]),
        const SizedBox(height: 6),
        ...highlights.asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 3), child: Text('${e.key + 1}. ${e.value}', style: const TextStyle(fontSize: 12, color: AppTheme.text, height: 1.5)))),
        const SizedBox(height: 10),
        const Row(children: [Icon(Icons.thumb_down, color: AppTheme.error, size: 14), SizedBox(width: 4), Text('糟点', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.error))]),
        const SizedBox(height: 6),
        ...lows.asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 3), child: Text('${e.key + 1}. ${e.value}', style: const TextStyle(fontSize: 12, color: AppTheme.text, height: 1.5)))),
      ]),
    );
  }

  Widget _photosCard() {
    final cats = [('店招环境', Color(0xFF059669)), ('人流动线', Color(0xFF0EA2B8)), ('竞品门店', Color(0xFF6366F1))];
    return Container(padding: const EdgeInsets.all(16), decoration: AppTheme.cardDecoration, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Icon(Icons.camera_alt, color: AppTheme.accent, size: 18), SizedBox(width: 6), Text('拍照打卡', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
      const SizedBox(height: 12),
      ...cats.map((cat) {
        final (name, color) = cat;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.folder, color: color, size: 16), const SizedBox(width: 4), Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)), const Spacer(), Text('3张', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))]),
          const SizedBox(height: 8),
          Row(children: List.generate(3, (i) => Container(margin: const EdgeInsets.only(right: 8), width: 100, height: 75, decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.15))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.image, color: color, size: 24),
            const SizedBox(height: 2),
            Text('${name.split('').first}${i + 1}', style: TextStyle(fontSize: 10, color: color)),
          ])))),
          const SizedBox(height: 16),
        ]);
      }),
    ]));
  }

  Widget _reportCard(String title, IconData icon, Color color, String m1Label, String m1Val, String m2Label, String m2Val, String aiText, List<_ChartPoint> chartData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.divider)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: color, size: 18), const SizedBox(width: 6), Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color))]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: color.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(10)), child: Column(children: [Text(m1Val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)), const SizedBox(height: 2), Text(m1Label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))]))),
          const SizedBox(width: 10),
          Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: color.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(10)), child: Column(children: [Text(m2Val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)), const SizedBox(height: 2), Text(m2Label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))]))),
        ]),
        const SizedBox(height: 10),
        // ECharts 风格图表
        SizedBox(height: 120, child: CustomPaint(painter: _SimpleBarChart(chartData, color), size: Size.infinite)),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(8)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.auto_awesome, color: color, size: 14), const SizedBox(width: 6), Expanded(child: Text(aiText, style: const TextStyle(fontSize: 12, color: AppTheme.text, height: 1.5)))])),
      ]),
    );
  }
}

// ── 地图查看页 ──
class _MapViewPage extends StatelessWidget {
  final String address;
  const _MapViewPage({required this.address});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('实时地图')),
      body: Stack(children: [
        Container(color: const Color(0xFFE8F5E9), child: CustomPaint(painter: _MapGridPainter(), size: Size.infinite)),
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.location_on, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]), child: Text(address, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFF059669).withValues(alpha: 0.9), borderRadius: BorderRadius.circular(4)), child: const Text('高德地图 · 定位中', style: TextStyle(fontSize: 11, color: Colors.white))),
        ])),
        Positioned(bottom: 16, right: 16, child: Column(children: [_mapBtn(Icons.add), const SizedBox(height: 8), _mapBtn(Icons.remove), const SizedBox(height: 8), _mapBtn(Icons.my_location)])),
      ]),
    );
  }
  Widget _mapBtn(IconData icon) => Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]), child: Icon(icon, color: Colors.black54, size: 20));
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFC8E6C9)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    for (double y = 0; y < size.height; y += 40) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LocationItem {
  final String id, name, address;
  final int score;
  final DateTime date;
  final bool favorited;
  const _LocationItem({required this.id, required this.name, required this.address, required this.score, required this.date, this.favorited = false});
}

// ── 图表数据 ──
class _ChartPoint {
  final String label;
  final double value;
  const _ChartPoint(this.label, this.value);
}

List<_ChartPoint> _chartData(List<String> labels, List<double> values, {Color color = const Color(0xFF059669)}) {
  return List.generate(labels.length, (i) => _ChartPoint(labels[i], values[i]));
}

class _SimpleBarChart extends CustomPainter {
  final List<_ChartPoint> data;
  final Color color;
  _SimpleBarChart(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxVal = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final barW = (size.width - 30) / data.length - 6;
    final left = 28.0;
    final bottom = size.height - 20;

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final h = (data[i].value / maxVal) * (size.height - 28);
      final x = left + i * ((size.width - 30) / data.length) + 3;
      final rRect = RRect.fromLTRBR(x, bottom - h, x + barW, bottom, const Radius.circular(3));
      final paint = Paint()..shader = LinearGradient(colors: [color.withValues(alpha: 0.7), color]).createShader(Rect.fromLTWH(0, bottom - h, barW, h));
      canvas.drawRRect(rRect, paint);

      // Label
      final tp = TextPainter(text: TextSpan(text: data[i].label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 9)), textDirection: TextDirection.ltr)..layout(maxWidth: barW + 8);
      tp.paint(canvas, Offset(x + barW / 2 - tp.width / 2, bottom + 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
