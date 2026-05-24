import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            // Logo with accent ring
            _LogoWidget(),
            Spacer(),
            // Brand text
            _BrandText(),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Accent ring
        Container(
          width: 172,
          height: 172,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.12), width: 2),
          ),
          child: Center(
            child: Container(
              width: 136,
              height: 136,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withValues(alpha: 0.06),
              ),
              child: const Center(
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandText extends StatelessWidget {
  const _BrandText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '云盯360',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.text,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 32,
          height: 3,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '智能AI餐饮',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            letterSpacing: 8,
          ),
        ),
      ],
    );
  }
}
