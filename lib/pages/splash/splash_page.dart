import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 28),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 12),
    ]).animate(_ctrl);
    _ctrl.forward();
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: AnimatedBuilder(
        animation: _opacity,
        builder: (_, child) => Opacity(opacity: _opacity.value, child: child),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),
            // Logo 独立悬浮卡片
            Center(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Color(0x140EA2B8), blurRadius: 32, offset: Offset(0, 6))],
                ),
                child: Image.asset('assets/images/logo.png', width: 120, height: 120),
              ),
            ),
            const SizedBox(height: 24),
            // 品牌名
            const Text('云盯360', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.text, letterSpacing: 1)),
            const Spacer(),
            // 底部副标题
            const Text('智能门店管理专家', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.text)),
            const SizedBox(height: 8),
            const Text('AI驱动数字化经营管理', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
