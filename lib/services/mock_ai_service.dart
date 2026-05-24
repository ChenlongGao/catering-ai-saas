import 'dart:async';
import 'dart:math';

import '../models/inspection_report.dart';

/// AI 大模型 Mock 服务 - 所有 demo 数据都从这里返回
class MockAiService {
  static final MockAiService _instance = MockAiService._();
  factory MockAiService() => _instance;
  MockAiService._();

  final Random _rng = Random();

  // ────────────────────────────────────────────
  // 1. AI 选址
  // ────────────────────────────────────────────

  /// 返回选址分析结果
  Future<LocationAnalysis> analyzeLocation({
    required String cuisineType,
    required double avgSpend,
    required int seating,
    required String address,
  }) async {
    await _simulateAiDelay();
    return LocationAnalysis.mock(cuisineType, address);
  }

  // ────────────────────────────────────────────
  // 2. AI 陪练
  // ────────────────────────────────────────────

  /// 返回培训打分结果
  Future<TrainingResult> analyzeTraining({
    required String subject,
    required String mediaType,
  }) async {
    await _simulateAiDelay(ms: 2000);
    return TrainingResult.mock(subject);
  }

  // ────────────────────────────────────────────
  // 3. AI 外卖
  // ────────────────────────────────────────────

  /// OCR 识别外卖单
  Future<DeliveryOrder> scanDeliveryOrder() async {
    await _simulateAiDelay();
    return DeliveryOrder.mock();
  }

  /// 查询订单关联录像
  Future<DeliveryVideoClip> getOrderVideo(String orderId) async {
    await _simulateAiDelay(ms: 1500);
    return DeliveryVideoClip.mock(orderId);
  }

  // ────────────────────────────────────────────
  // 4. AI 一键巡检
  // ────────────────────────────────────────────

  /// 一键巡检
  Future<InspectionReport> quickInspect(String storeName) async {
    await _simulateAiDelay(ms: 2500);
    return InspectionReport.mock(storeName);
  }

  // ────────────────────────────────────────────
  // 工具
  // ────────────────────────────────────────────

  Future<void> _simulateAiDelay({int ms = 1200}) async {
    await Future.delayed(
      Duration(
        milliseconds: ms + _rng.nextInt(800),
      ),
    );
  }
}

// ────────────────────────────────────────────
// 选址分析模型
// ────────────────────────────────────────────

class LocationAnalysis {
  final String cuisineType;
  final String address;
  final double score;
  final int monthlyPassengers;
  final int competitors;
  final int estimatedMonthlyRevenue;
  final int estimatedPaybackMonths;
  final List<CompetitorInfo> nearbyCompetitors;
  final List<RiskFactor> risks;
  final String aiAdvice;

  const LocationAnalysis({
    required this.cuisineType,
    required this.address,
    required this.score,
    required this.monthlyPassengers,
    required this.competitors,
    required this.estimatedMonthlyRevenue,
    required this.estimatedPaybackMonths,
    required this.nearbyCompetitors,
    required this.risks,
    required this.aiAdvice,
  });

  factory LocationAnalysis.mock(String cuisineType, String address) {
    return LocationAnalysis(
      cuisineType: cuisineType,
      address: address,
      score: (60 + Random().nextInt(32)).toDouble(),
      monthlyPassengers: 8000 + Random().nextInt(12000),
      competitors: 3 + Random().nextInt(8),
      estimatedMonthlyRevenue: 80000 + Random().nextInt(120000),
      estimatedPaybackMonths: 6 + Random().nextInt(12),
      nearbyCompetitors: [
        CompetitorInfo(name: '隔壁老王火锅', distance: 120, rating: 4.2, monthlySales: 150000),
        CompetitorInfo(name: '湘味人家', distance: 300, rating: 4.5, monthlySales: 200000),
        CompetitorInfo(name: '小龙坎火锅', distance: 500, rating: 4.0, monthlySales: 280000),
      ],
      risks: [
        RiskFactor(factor: '同品类竞争激烈', level: RiskLevel.high, detail: '500米内有3家同类餐饮'),
        RiskFactor(factor: '停车位不足', level: RiskLevel.medium, detail: '周边公共停车位约15个'),
        RiskFactor(factor: '租金上涨风险', level: RiskLevel.low, detail: '近3年租金年涨幅约5%'),
      ],
      aiAdvice: '该点位客流量充足，周边餐饮生态成熟，适合$cuisineType品类。建议重点关注差异化竞争策略，利用线上营销引流。预估6-8个月可回本。',
    );
  }
}

class CompetitorInfo {
  final String name;
  final int distance; // 米
  final double rating;
  final int monthlySales;

  const CompetitorInfo({
    required this.name,
    required this.distance,
    required this.rating,
    required this.monthlySales,
  });
}

class RiskFactor {
  final String factor;
  final RiskLevel level;
  final String detail;

  const RiskFactor({
    required this.factor,
    required this.level,
    required this.detail,
  });
}

enum RiskLevel { high, medium, low }

// ────────────────────────────────────────────
// 陪练分析模型
// ────────────────────────────────────────────

class TrainingResult {
  final String subject;
  final double overallScore;
  final List<TrainingItem> items;
  final String aiComment;

  const TrainingResult({
    required this.subject,
    required this.overallScore,
    required this.items,
    required this.aiComment,
  });

  factory TrainingResult.mock(String subject) {
    final rng = Random();
    return TrainingResult(
      subject: subject,
      overallScore: 65 + rng.nextInt(30).toDouble(),
      items: [
        TrainingItem(name: '仪容仪表', score: 70 + rng.nextInt(30), comment: '工服整洁，帽子佩戴规范'),
        TrainingItem(name: '服务流程', score: 60 + rng.nextInt(35), comment: '点单流程基本正确，缺少推荐话术'),
        TrainingItem(name: '操作规范', score: 65 + rng.nextInt(30), comment: '食材处理基本规范，刀具使用需注意'),
        TrainingItem(name: '卫生习惯', score: 75 + rng.nextInt(25), comment: '洗手频次达标，操作台及时清理'),
        TrainingItem(name: '沟通话术', score: 55 + rng.nextInt(40), comment: '礼貌用语使用不足，建议加强培训'),
      ],
      aiComment: '整体表现及格，仪容仪表和卫生习惯较好。主要薄弱点在沟通话术和服务流程，建议进行情景模拟训练，提升顾客体验。',
    );
  }
}

class TrainingItem {
  final String name;
  final int score;
  final String comment;

  const TrainingItem({
    required this.name,
    required this.score,
    required this.comment,
  });
}

// ────────────────────────────────────────────
// 外卖模型
// ────────────────────────────────────────────

class DeliveryOrder {
  final String orderId;
  final String platform;
  final String customer;
  final List<String> items;
  final double amount;
  final DateTime orderTime;
  final DeliveryStatus status;
  final List<DeliveryTimeline> timeline;

  const DeliveryOrder({
    required this.orderId,
    required this.platform,
    required this.customer,
    required this.items,
    required this.amount,
    required this.orderTime,
    required this.status,
    required this.timeline,
  });

  factory DeliveryOrder.mock() {
    final now = DateTime.now();
    return DeliveryOrder(
      orderId: 'MT${now.millisecondsSinceEpoch.toString().substring(5)}',
      platform: '美团外卖',
      customer: '张***',
      items: ['招牌奶茶 x2', '芝士奶盖 x1', '抹茶拿铁 x1'],
      amount: 86.0,
      orderTime: now.subtract(const Duration(minutes: 25)),
      status: DeliveryStatus.completed,
      timeline: [
        DeliveryTimeline(
          time: now.subtract(const Duration(minutes: 25)),
          event: '订单接收',
          camera: '出餐口',
        ),
        DeliveryTimeline(
          time: now.subtract(const Duration(minutes: 22)),
          event: '开始制作',
          camera: '厨房全景',
        ),
        DeliveryTimeline(
          time: now.subtract(const Duration(minutes: 12)),
          event: '制作完成',
          camera: '出餐口',
        ),
        DeliveryTimeline(
          time: now.subtract(const Duration(minutes: 10)),
          event: '打包完成',
          camera: '出餐口',
        ),
        DeliveryTimeline(
          time: now.subtract(const Duration(minutes: 8)),
          event: '骑手取餐',
          camera: '出餐口',
        ),
      ],
    );
  }
}

class DeliveryTimeline {
  final DateTime time;
  final String event;
  final String camera;

  const DeliveryTimeline({
    required this.time,
    required this.event,
    required this.camera,
  });
}

enum DeliveryStatus { completed, delivering, preparing }

class DeliveryVideoClip {
  final String orderId;
  final String videoTitle;
  final String startTime;
  final String endTime;
  final String aiTag;

  const DeliveryVideoClip({
    required this.orderId,
    required this.videoTitle,
    required this.startTime,
    required this.endTime,
    required this.aiTag,
  });

  factory DeliveryVideoClip.mock(String orderId) {
    final now = DateTime.now();
    return DeliveryVideoClip(
      orderId: orderId,
      videoTitle: '出餐口录像 - 订单 $orderId',
      startTime: now.subtract(const Duration(minutes: 25)).toIso8601String().substring(11, 19),
      endTime: now.subtract(const Duration(minutes: 8)).toIso8601String().substring(11, 19),
      aiTag: '出餐用时12分钟（标准15分钟），打包操作规范，骑手取餐无异常。',
    );
  }
}
