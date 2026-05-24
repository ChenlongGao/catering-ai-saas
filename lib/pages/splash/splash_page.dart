import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleSlide;
  late Animation<double> _progressWidth;

  final Random _rng = Random();
  List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _progressWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.95, curve: Curves.easeInOut),
      ),
    );

    _initParticles();

    _mainController.forward();

    // 2.8秒后跳转到主页
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        });
      }
    });
  }

  void _initParticles() {
    _particles = List.generate(60, (i) {
      return _Particle(
        x: _rng.nextDouble() * 400,
        y: _rng.nextDouble() * 800,
        radius: 1.5 + _rng.nextDouble() * 3,
        speed: 0.3 + _rng.nextDouble() * 0.8,
        opacity: 0.15 + _rng.nextDouble() * 0.35,
        color: i % 2 == 0 ? Colors.orange : Colors.deepPurple,
        angle: _rng.nextDouble() * 2 * pi,
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            painter: _ParticlePainter(
              particles: _particles,
              time: _particleController.value,
            ),
            child: child,
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F0C29),
                Color(0xFF1A1438),
                Color(0xFF24243E),
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, _) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Logo 区域
                    Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: _buildLogo(),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // 品牌名称
                    Opacity(
                      opacity: _titleOpacity.value,
                      child: Column(
                        children: [
                          const Text(
                            '餐饮AI管家',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 6,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Transform.translate(
                            offset: Offset(0, _subtitleSlide.value),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Text(
                                '云盯科技 · 智能门店管理',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white60,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),

                    // 底部
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                      child: Column(
                        children: [
                          // AI 标语
                          Opacity(
                            opacity: _titleOpacity.value,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.amber, size: 14),
                                SizedBox(width: 8),
                                Text(
                                  'AI驱动 · 智慧餐饮',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white38,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 进度条
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: SizedBox(
                              height: 2,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 200,
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: _progressWidth.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.primary,
                                            AppTheme.primaryLight,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.4),
            blurRadius: 60,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.05),
            blurRadius: 80,
            spreadRadius: -10,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B35),
            Color(0xFF6366F1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // AI 大脑图标
              CustomPaint(
                size: const Size(48, 48),
                painter: _AIBrainPainter(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// AI 大脑图标绘制
// ────────────────────────────────────────────
class _AIBrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 左侧神经元分支
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX - 14, centerY - 10),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX - 12, centerY + 8),
      paint,
    );

    // 右侧神经元分支
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + 14, centerY - 10),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX + 12, centerY + 8),
      paint,
    );

    // 顶部
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(centerX, centerY - 16),
      paint,
    );

    // 节点圆圈
    final dotPaint = Paint()..color = Colors.white;
    final dotPositions = [
      Offset(centerX - 14, centerY - 10),
      Offset(centerX - 12, centerY + 8),
      Offset(centerX + 14, centerY - 10),
      Offset(centerX + 12, centerY + 8),
      Offset(centerX, centerY - 16),
      Offset(centerX, centerY),
    ];

    for (final pos in dotPositions) {
      canvas.drawCircle(pos, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ────────────────────────────────────────────
// 粒子背景
// ────────────────────────────────────────────
class _Particle {
  double x, y;
  final double radius;
  final double speed;
  final double opacity;
  final Color color;
  final double angle;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.color,
    required this.angle,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;

  _ParticlePainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dx = p.x + sin(p.angle + time * 2) * 20;
      final dy = p.y + time * p.speed * 100;
      final wrappedY = dy % size.height;

      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(Offset(dx, wrappedY), p.radius, paint);

      // 画连线
      if (p.radius > 2.5) {
        for (final other in particles) {
          final dist = sqrt(pow(dx - other.x, 2) + pow(wrappedY - other.y, 2));
          if (dist < 60 && dist > 0) {
            final linePaint = Paint()
              ..color = p.color.withValues(alpha: 0.03)
              ..strokeWidth = 0.5;
            canvas.drawLine(
              Offset(dx, wrappedY),
              Offset(other.x, other.y),
              linePaint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
