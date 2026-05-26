import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterBar extends StatefulWidget {
  final String period;
  final String store;
  final ValueChanged<String> onPeriod;
  final ValueChanged<String> onStore;

  static const periods = ['今日', '昨日', '近7天', '近30天'];

  static const treeData = [
    _TreeItem(name: '华中大区', children: [
      _TreeItem(name: '长沙商圈', children: [
        _TreeItem(name: '茶颜悦色·太平街店'),
        _TreeItem(name: '茶颜悦色·五一广场店'),
        _TreeItem(name: '茶颜悦色·解放西路店'),
      ]),
      _TreeItem(name: '武汉商圈', children: [
        _TreeItem(name: '茶颜悦色·江汉路店'),
        _TreeItem(name: '茶颜悦色·光谷店'),
      ]),
    ]),
    _TreeItem(name: '华东大区', children: [
      _TreeItem(name: '南京商圈', children: [
        _TreeItem(name: '茶颜悦色·新街口店'),
      ]),
      _TreeItem(name: '杭州商圈', children: [
        _TreeItem(name: '茶颜悦色·湖滨银泰店'),
        _TreeItem(name: '茶颜悦色·步行街店'),
      ]),
    ]),
    _TreeItem(name: '华南大区', children: [
      _TreeItem(name: '深圳商圈', children: [
        _TreeItem(name: '茶颜悦色·华强北店'),
        _TreeItem(name: '茶颜悦色·福田店'),
      ]),
    ]),
    _TreeItem(name: '华北大区', children: [
      _TreeItem(name: '北京商圈', children: [
        _TreeItem(name: '茶颜悦色·三里屯店'),
      ]),
    ]),
    _TreeItem(name: '西南大区', children: [
      _TreeItem(name: '成都商圈', children: [
        _TreeItem(name: '茶颜悦色·春熙路店'),
      ]),
    ]),
  ];

  const FilterBar({super.key, required this.period, required this.store, required this.onPeriod, required this.onStore});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  void _showStorePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _StoreTree(
        current: widget.store,
        onSelected: (s) {
          widget.onStore(s);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppTheme.divider))),
      child: LayoutBuilder(builder: (ctx, c) {
        final one = (c.maxWidth - 32 - 3 * 8 - 80) / 4;
        return Row(children: [
          ...FilterBar.periods.map((t) {
            final sel = widget.period == t;
            return GestureDetector(
              onTap: () => widget.onPeriod(t),
              child: Container(
                width: one,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: sel ? AppTheme.primary : AppTheme.bg, borderRadius: BorderRadius.circular(18)),
                alignment: Alignment.center,
                child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: sel ? Colors.white : AppTheme.textSecondary)),
              ),
            );
          }),
          const Spacer(),
          GestureDetector(
            onTap: _showStorePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.divider)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(widget.store.length > 8 ? '${widget.store.substring(0, 7)}…' : widget.store, style: const TextStyle(fontSize: 12, color: AppTheme.text)),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.textSecondary),
              ]),
            ),
          ),
        ]);
      }),
    );
  }
}

class _StoreTree extends StatefulWidget {
  final String current;
  final ValueChanged<String> onSelected;
  const _StoreTree({required this.current, required this.onSelected});
  @override
  State<_StoreTree> createState() => _StoreTreeState();
}

class _StoreTreeState extends State<_StoreTree> {
  // 展开/折叠状态
  final Set<String> _expanded = {};
  // 层级标识: 0=全部, 1=大区, 2=商圈, 3=门店
  String _level = '';

  @override
  Widget build(BuildContext context) {
    final allSelected = widget.current == '全部门店';
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('选择门店', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        const Text('四级维度：全部 · 大区 · 商圈 · 门店', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 16),
        // 全部
        _node(Icons.public, '全部门店', allSelected, () => widget.onSelected('全部门店'), level: 0),
        const Divider(height: 20),
        Expanded(child: ListView(children: [
          ...FilterBar.treeData.map((region) => _buildRegion(region)),
        ])),
      ]),
    );
  }

  Widget _buildRegion(_TreeItem region) {
    final sel = widget.current == region.name;
    final exp = _expanded.contains(region.name);
    return Column(children: [
      _node(Icons.place, region.name, sel, () {
        setState(() => _expanded.contains(region.name) ? _expanded.remove(region.name) : _expanded.add(region.name));
      }, trailing: AnimatedRotation(turns: exp ? 0.25 : 0, duration: const Duration(milliseconds: 200), child: const Icon(Icons.chevron_right, size: 20, color: AppTheme.textSecondary)), level: 1),
      if (exp) ...region.children.map((biz) => _buildBiz(biz, region.name)),
    ]);
  }

  Widget _buildBiz(_TreeItem biz, String regionName) {
    final exp = _expanded.contains('$regionName/${biz.name}');
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 24),
        child: _node(Icons.business, biz.name, false, () {
          setState(() => exp ? _expanded.remove('$regionName/${biz.name}') : _expanded.add('$regionName/${biz.name}'));
        }, trailing: AnimatedRotation(turns: exp ? 0.25 : 0, duration: const Duration(milliseconds: 200), child: const Icon(Icons.chevron_right, size: 18, color: AppTheme.textSecondary)), level: 2),
      ),
      if (exp) ...biz.children.map((store) {
        final ssel = widget.current == store.name;
        return Padding(
          padding: const EdgeInsets.only(left: 48),
          child: _node(Icons.store, store.name, ssel, () => widget.onSelected(store.name), level: 3),
        );
      }),
    ]);
  }

  Widget _node(IconData icon, String name, bool sel, VoidCallback onTap, {Widget? trailing, int level = 0}) {
    final colors = [AppTheme.primary, Color(0xFF0EA2B8), Color(0xFFE3811A), AppTheme.success];
    final color = colors[level.clamp(0, 3)];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(color: sel ? color.withValues(alpha: 0.06) : null, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Icon(icon, color: sel ? color : AppTheme.textSecondary, size: level == 3 ? 16 : 18),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: TextStyle(fontSize: level == 3 ? 13 : 14, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, color: sel ? color : AppTheme.text))),
          if (trailing != null) trailing,
          if (sel && trailing == null) const Icon(Icons.check, color: AppTheme.primary, size: 18),
        ]),
      ),
    );
  }
}

class _TreeItem {
  final String name;
  final List<_TreeItem> children;
  const _TreeItem({required this.name, this.children = const []});
}
