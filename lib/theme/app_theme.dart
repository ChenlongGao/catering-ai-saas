import 'package:flutter/material.dart';

class AppTheme {
  // 品牌色 - 基于云盯logo：青蓝色+金橙色
  static const Color primary = Color(0xFF0EA2B8);
  static const Color primaryLight = Color(0xFF3BBED4);
  static const Color primaryDark = Color(0xFF088294);
  static const Color accent = Color(0xFFE3811A);
  static const Color accentLight = Color(0xFFF5A84A);

  // 语义色
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA2B8);

  // 中性色
  static const Color bg = Color(0xFFF5F9FA);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1A2E33);
  static const Color textSecondary = Color(0xFF5B7278);
  static const Color divider = Color(0xFFDDE7EA);

  // 统一卡片阴影 (Whale style)
  static BoxDecoration get cardDecoration => const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(14)),
    boxShadow: [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
  );

  // 版块间距
  static const double sectionGap = 24;

  // 应用模块专属色
  static const List<Color> appColors = [
    Color(0xFF0EA2B8),  // 青蓝 - 巡检
    Color(0xFF10B981),  // 绿色 - 培训
    Color(0xFFE3811A),  // 金橙 - 选址
    Color(0xFF6366F1),  // 紫色 - 外卖
    Color(0xFF8B5CF6),  // 紫 - 其他工具
    Color(0xFF3B82F6),  // 蓝 - AI客流
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: accent,
        surface: card,
      ),
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
