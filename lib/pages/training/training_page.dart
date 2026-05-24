import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/mock_ai_service.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String? _selectedSubject;
  bool _isAnalyzing = false;
  TrainingResult? _result;

  final _subjects = [
    {'icon': Icons.restaurant, 'name': '后厨操作规范', 'desc': '食材处理、烹饪流程、卫生安全'},
    {'icon': Icons.room_service, 'name': '前厅服务流程', 'desc': '迎宾、点单、上菜、结账'},
    {'icon': Icons.cleaning_services, 'name': '清洁卫生标准', 'desc': '台面、地面、餐具、卫生间'},
    {'icon': Icons.local_fire_department, 'name': '消防安全操作', 'desc': '灭火器使用、燃气阀门检查'},
    {'icon': Icons.inventory, 'name': '食材验收流程', 'desc': '验货、称重、入库、标签'},
    {'icon': Icons.support_agent, 'name': '客诉处理规范', 'desc': '投诉响应、退换菜、安抚话术'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text('AI 陪练打卡'),
          ],
        ),
      ),
      body: _isAnalyzing ? _buildAnalyzing() : _buildNormal(),
    );
  }

  Widget _buildNormal() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部说明卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accent, AppTheme.accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '云盯AI陪练',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '拍照或录像上传，AI自动分析操作规范，逐项打分并提供改进建议',
                  style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            '选择培训科目',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text),
          ),
          const SizedBox(height: 12),

          // 培训科目网格
          ..._subjects.map((subject) {
            final isSelected = _selectedSubject == subject['name'];
            return GestureDetector(
              onTap: () => setState(() => _selectedSubject = subject['name'] as String),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accent.withValues(alpha: 0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.divider,
                    width: isSelected ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accent.withValues(alpha: 0.1)
                            : AppTheme.bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        subject['icon'] as IconData,
                        color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject['name'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? AppTheme.accent : AppTheme.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subject['desc'] as String,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: AppTheme.accent, size: 20),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // 拍照 / 录像 按钮
          if (_selectedSubject != null) ...[
            Row(
              children: [
                Expanded(
                  child: _buildMediaButton(
                    icon: Icons.camera_alt,
                    label: '拍照上传',
                    onTap: () => _startAnalysis('拍照'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMediaButton(
                    icon: Icons.videocam,
                    label: '录像上传',
                    onTap: () => _startAnalysis('录像'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _startAnalysis(String mediaType) {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        MockAiService()
            .analyzeTraining(subject: _selectedSubject!, mediaType: mediaType)
            .then((result) {
          setState(() {
            _isAnalyzing = false;
            _result = result;
          });
        });
      }
    });
  }

  Widget _buildAnalyzing() {
    if (_result != null) return _buildResult(_result!);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accent.withValues(alpha: 0.1),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(strokeWidth: 3, color: AppTheme.accent),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'AI 分析中...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '正在分析「$_selectedSubject」操作规范',
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(TrainingResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总分卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accent, AppTheme.accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('综合评分', style: TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  '${result.overallScore.toInt()}',
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '科目：${result.subject}',
                  style: const TextStyle(fontSize: 13, color: Colors.white60),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 逐项打分
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.assignment, color: AppTheme.accent, size: 18),
                    SizedBox(width: 8),
                    Text('逐项评分', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 14),
                ...result.items.map((item) => _buildScoreItem(item)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // AI点评
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accent.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppTheme.accent, size: 16),
                    const SizedBox(width: 8),
                    const Text('AI 点评', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(result.aiComment, style: const TextStyle(fontSize: 14, height: 1.6, color: AppTheme.text)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 重新训练
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _result = null),
              icon: const Icon(Icons.refresh),
              label: const Text('重新训练'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(TrainingItem item) {
    Color barColor;
    if (item.score >= 80) {
      barColor = AppTheme.success;
    } else if (item.score >= 60) {
      barColor = AppTheme.warning;
    } else {
      barColor = AppTheme.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(
                '${item.score}分',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: barColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.score / 100,
              backgroundColor: AppTheme.divider,
              color: barColor,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(item.comment, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
