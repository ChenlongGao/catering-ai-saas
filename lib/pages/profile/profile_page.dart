import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人中心')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // 用户信息卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.cardDecoration,
            child: Column(children: [
              Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]), borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Icon(Icons.person, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 12),
              const Text('餐饮管理者', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('admin@catering-ai.com', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.shield, color: AppTheme.primary, size: 14),
                  SizedBox(width: 6),
                  Text('企业版', style: TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w500)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: AppTheme.sectionGap),

          // 账号与绑定
          _Section(text: '账号与绑定', color: AppTheme.primary),
          const SizedBox(height: 8),
          _item(Icons.phone_android, '手机号', subtitle: '138****8888', color: AppTheme.info),
          _item(Icons.email, '邮箱', subtitle: 'admin@catering-ai.com', color: AppTheme.success),
          _item(Icons.link, '云盯科技账号绑定', subtitle: '已绑定 · YD-2024-0888', color: AppTheme.accent, trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: const Text('已连接', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500)),
          )),
          const SizedBox(height: AppTheme.sectionGap),

          // 设置
          _Section(text: '设置', color: AppTheme.accent),
          const SizedBox(height: 8),
          _item(Icons.notifications, '消息通知', subtitle: '巡检报告推送 · 告警通知', color: AppTheme.appColors[3]),
          _item(Icons.cloud_sync, '数据同步', subtitle: '自动同步 · 每15分钟', color: AppTheme.appColors[5]),
          _item(Icons.language, '语言', subtitle: '简体中文', color: AppTheme.info),
          const SizedBox(height: AppTheme.sectionGap),

          // 关于
          _Section(text: '关于', color: AppTheme.success),
          const SizedBox(height: 8),
          _item(Icons.description, '用户协议', color: AppTheme.textSecondary),
          _item(Icons.privacy_tip, '隐私政策', color: AppTheme.textSecondary),
          _item(Icons.system_update, '版本', subtitle: 'V 1.0.0 (Demo)', color: AppTheme.textSecondary),
          const SizedBox(height: 28),

          // 退出登录 - 卡片化
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text('退出登录', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.error)),
            ),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _item(IconData icon, String title, {String? subtitle, Widget? trailing, Color color = AppTheme.primary}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppTheme.cardDecoration,
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))],
          ])),
          trailing ?? const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 18),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String text;
  final Color color;
  const _Section({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 0),
      child: Row(children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.text)),
      ]),
    );
  }
}
