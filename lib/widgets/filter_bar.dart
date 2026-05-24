import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterBar extends StatefulWidget {
  final String period;
  final String store;
  final ValueChanged<String> onPeriod;
  final ValueChanged<String> onStore;

  static const periods = ['今日', '昨日', '近7天', '近30天'];
  static const regions = ['全部门店', '华中区', '华东区', '华南区', '华北区', '西南区'];
  static const stores = {
    '华中区': ['全选', '茶颜悦色·太平街店', '茶颜悦色·五一广场店', '茶颜悦色·解放西路店', '茶颜悦色·江汉路店', '茶颜悦色·光谷店'],
    '华东区': ['全选', '茶颜悦色·新街口店', '茶颜悦色·湖滨银泰店', '茶颜悦色·步行街店'],
    '华南区': ['全选', '茶颜悦色·华强北店', '茶颜悦色·福田店'],
    '华北区': ['全选', '茶颜悦色·三里屯店'],
    '西南区': ['全选', '茶颜悦色·春熙路店'],
  };

  const FilterBar({super.key, required this.period, required this.store, required this.onPeriod, required this.onStore});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  void _showStorePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _StorePicker(
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
                decoration: BoxDecoration(
                  color: sel ? AppTheme.primary : AppTheme.bg,
                  borderRadius: BorderRadius.circular(18),
                ),
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

class _StorePicker extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelected;
  const _StorePicker({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('选择门店', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Expanded(child: ListView(children: [
          // 全部门店
          _tile(context, '全部门店', current == '全部门店'),
          const SizedBox(height: 4),
          ...FilterBar.regions.skip(1).map((region) {
            final sel = current == region;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _tile(context, region, sel),
              if (sel) ...[
                const SizedBox(height: 4),
                ...?FilterBar.stores[region]?.map((s) {
                  final ssel = current == s;
                  return Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 2),
                    child: _tile(context, s, ssel, indent: true),
                  );
                }),
              ],
            ]);
          }),
        ])),
      ]),
    );
  }

  Widget _tile(BuildContext context, String name, bool sel, {bool indent = false}) {
    return GestureDetector(
      onTap: () => onSelected(name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: sel ? AppTheme.primary.withValues(alpha: 0.06) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          if (indent) const SizedBox(width: 8),
          Expanded(child: Text(name, style: TextStyle(fontSize: 14, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, color: sel ? AppTheme.primary : AppTheme.text))),
          if (sel) const Icon(Icons.check, color: AppTheme.primary, size: 18),
        ]),
      ),
    );
  }
}
