import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/mock_ai_service.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _cuisineController = TextEditingController(text: '新式茶饮');
  final _spendController = TextEditingController(text: '25');
  final _seatingController = TextEditingController(text: '40');
  final _addressController = TextEditingController(text: '长沙市天心区解放西路88号');

  bool _isAnalyzing = false;
  LocationAnalysis? _analysis;

  @override
  void dispose() {
    _cuisineController.dispose();
    _spendController.dispose();
    _seatingController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text('AI 智能选址'),
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
          // 顶部说明
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF059669), const Color(0xFF10B981)],
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
                      child: const Icon(Icons.map, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '云盯AI智能选址',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '填入餐饮业态参数，AI分析周边客流、竞品分布、预估营收，科学决策开店选址',
                  style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 业态参数表单
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
                    Icon(Icons.tune, color: AppTheme.primary, size: 18),
                    SizedBox(width: 8),
                    Text('餐饮业态参数', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('餐饮品类', _cuisineController, '如：火锅、茶饮、快餐'),
                _buildTextField('人均消费(元)', _spendController, '预计客单价', keyboardType: TextInputType.number),
                _buildTextField('座位数', _seatingController, '预估座位数量', keyboardType: TextInputType.number),
                _buildTextField('目标地址', _addressController, '详细地址或商圈名称'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 拍照扫街
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
                    Icon(Icons.camera_alt, color: AppTheme.accent, size: 18),
                    SizedBox(width: 8),
                    Text('拍照打卡扫街', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPhotoSlot('店招环境'),
                    const SizedBox(width: 10),
                    _buildPhotoSlot('人流动线'),
                    const SizedBox(width: 10),
                    _buildPhotoSlot('竞品门店'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 开始分析按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startAnalysis,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AI 分析选址'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 历史分析
          if (_analysis != null) ...[
            const SizedBox(height: 8),
            _buildAnalysisResult(_analysis!),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.text)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.primary),
              ),
              filled: true,
              fillColor: AppTheme.bg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSlot(String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.divider, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, color: AppTheme.textSecondary.withValues(alpha: 0.5), size: 24),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(fontSize: 11, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
            ],
          ),
        ),
      ),
    );
  }

  void _startAnalysis() {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        MockAiService()
            .analyzeLocation(
          cuisineType: _cuisineController.text,
          avgSpend: double.tryParse(_spendController.text) ?? 0,
          seating: int.tryParse(_seatingController.text) ?? 0,
          address: _addressController.text,
        )
            .then((analysis) {
          setState(() {
            _isAnalyzing = false;
            _analysis = analysis;
          });
        });
      }
    });
  }

  Widget _buildAnalyzing() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF059669).withValues(alpha: 0.1),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF059669)),
            ),
          ),
          const SizedBox(height: 24),
          const Text('AI 分析中...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text(
            '正在分析周边客流、竞品分布及营收预估',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          _buildAnalyzingSteps([
            '查询周边客流数据',
            '扫描竞品门店分布',
            '测算预估营收模型',
            '评估风险因素',
            '生成选址报告',
          ]),
        ],
      ),
    );
  }

  Widget _buildAnalyzingSteps(List<String> steps) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: steps.asMap().entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.hourglass_top, size: 16, color: AppTheme.success),
                const SizedBox(width: 10),
                Text(e.value, style: const TextStyle(fontSize: 13, color: AppTheme.text)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnalysisResult(LocationAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF059669), const Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('选址分析报告', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('云盯AI', style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 评分
          Center(
            child: Column(
              children: [
                Text(
                  '${analysis.score}',
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text('选址综合评分', style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 关键指标 2x2
          Row(
            children: [
              Expanded(child: _buildMetricBox('月均客流', '${analysis.monthlyPassengers}人次')),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricBox('周边竞品', '${analysis.competitors}家')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildMetricBox('预估月营收', '¥${analysis.estimatedMonthlyRevenue}')),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricBox('预估回本', '${analysis.estimatedPaybackMonths}个月')),
            ],
          ),
          const SizedBox(height: 16),

          // 竞品分析
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('周边竞品', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 8),
                ...analysis.nearbyCompetitors.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text(c.name, style: const TextStyle(fontSize: 12, color: Colors.white))),
                      Text('${c.distance}m', style: const TextStyle(fontSize: 11, color: Colors.white60)),
                      const SizedBox(width: 8),
                      Icon(Icons.star, size: 12, color: Colors.yellow.withValues(alpha: 0.8)),
                      Text(' ${c.rating}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 风险因素
          ...analysis.risks.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  r.level == RiskLevel.high ? Icons.error : r.level == RiskLevel.medium ? Icons.warning_amber : Icons.info_outline,
                  size: 16,
                  color: r.level == RiskLevel.high ? Colors.red.shade200 : r.level == RiskLevel.medium ? Colors.amber : Colors.white60,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${r.factor}：${r.detail}',
                      style: const TextStyle(fontSize: 12, color: Colors.white70)),
                ),
              ],
            ),
          )),
          const SizedBox(height: 12),

          // AI建议
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    analysis.aiAdvice,
                    style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60)),
        ],
      ),
    );
  }
}
