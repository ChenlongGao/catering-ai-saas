import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text('个人中心'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 用户信息卡片
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text('餐饮管理者', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('admin@catering-ai.com', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield, color: AppTheme.primary, size: 14),
                        SizedBox(width: 6),
                        Text('企业版', style: TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 账号与绑定
            const _SectionTitle(title: '账号与绑定', icon: Icons.account_circle),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.phone_android,
              title: '手机号',
              subtitle: '138****8888',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.email,
              title: '邮箱',
              subtitle: 'admin@catering-ai.com',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.link,
              title: '云盯科技账号绑定',
              subtitle: '已绑定 · YD-2024-0888',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('已连接', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500)),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // 设置
            const _SectionTitle(title: '设置', icon: Icons.settings),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.notifications,
              title: '消息通知',
              subtitle: '巡检报告推送 · 告警通知',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.cloud_sync,
              title: '数据同步',
              subtitle: '自动同步 · 每15分钟',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: '语言',
              subtitle: '简体中文',
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // 关于
            const _SectionTitle(title: '关于', icon: Icons.info),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.description,
              title: '用户协议',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip,
              title: '隐私政策',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.system_update,
              title: '版本',
              subtitle: 'V 1.0.0 (Demo)',
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // 退出登录
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: const BorderSide(color: AppTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('退出登录'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.textSecondary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 16),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
