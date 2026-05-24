import 'dart:math';

/// 巡检报告
class InspectionReport {
  final String id;
  final String storeName;
  final DateTime inspectTime;
  final double overallScore;
  final List<CheckItem> items;
  final List<DeviceSnapshot> snapshots;
  final String aiSummary;

  const InspectionReport({
    required this.id,
    required this.storeName,
    required this.inspectTime,
    required this.overallScore,
    required this.items,
    required this.snapshots,
    required this.aiSummary,
  });

  static InspectionReport mock(String storeName) {
    final rng = Random();
    return InspectionReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      storeName: storeName,
      inspectTime: DateTime.now(),
      overallScore: 70 + rng.nextDouble() * 25,
      items: [
        CheckItem(
          name: '厨师着装规范',
          category: '卫生安全',
          score: 75 + rng.nextInt(25),
          details: '2名厨师均正确佩戴厨师帽和口罩，工作服整洁，符合规范要求。',
          status: CheckStatus.pass,
        ),
        CheckItem(
          name: '食材储存',
          category: '食品安全',
          score: 70 + rng.nextInt(20),
          details: '冷藏柜温度达标（4℃），食材分类存放，但有1份半成品未贴日期标签。',
          status: CheckStatus.warning,
        ),
        CheckItem(
          name: '后厨卫生',
          category: '卫生安全',
          score: 65 + rng.nextInt(30),
          details: '操作台面整洁，地面无积水，但垃圾桶未及时加盖，存在异味。',
          status: CheckStatus.warning,
        ),
        CheckItem(
          name: '明火操作',
          category: '消防安全',
          score: 80 + rng.nextInt(20),
          details: '燃气阀门正常，灭火器在有效期内，油烟管道清洁记录完整。',
          status: CheckStatus.pass,
        ),
        CheckItem(
          name: '出餐流程',
          category: '流程规范',
          score: 75 + rng.nextInt(25),
          details: '出餐流程顺畅，菜品摆盘规范，打包操作标准。',
          status: CheckStatus.pass,
        ),
        CheckItem(
          name: '员工健康证',
          category: '合规管理',
          score: 60 + rng.nextInt(40),
          details: '抽查3名员工，2人健康证在有效期内，1人健康证即将过期（剩余15天），需提醒更新。',
          status: CheckStatus.fail,
        ),
      ],
      snapshots: DeviceSnapshot.mockList(storeName),
      aiSummary: '本次巡检发现门店整体运营良好，主要问题集中在员工健康证管理和后厨卫生细节。建议48小时内完成整改：① 健康证到期员工尽快体检更新 ② 垃圾桶加盖管理 ③ 半成品标签规范。整体评分表现稳定。',
    );
  }
}

/// 检查项
class CheckItem {
  final String name;
  final String category;
  final int score;
  final String details;
  final CheckStatus status;

  const CheckItem({
    required this.name,
    required this.category,
    required this.score,
    required this.details,
    required this.status,
  });
}

/// 检查项状态
enum CheckStatus {
  pass('通过'),
  warning('提醒'),
  fail('不合格');

  final String label;
  const CheckStatus(this.label);
}

/// 设备抓图
class DeviceSnapshot {
  final String deviceName;
  final String location;
  final String timestamp;
  final String aiTag;

  const DeviceSnapshot({
    required this.deviceName,
    required this.location,
    required this.timestamp,
    required this.aiTag,
  });

  static List<DeviceSnapshot> mockList(String storeName) {
    return [
      DeviceSnapshot(
        deviceName: '厨房全景',
        location: '后厨门口',
        timestamp: DateTime.now().subtract(const Duration(seconds: 5)).toIso8601String().substring(11, 19),
        aiTag: '检测到3人在岗，着装规范正常',
      ),
      DeviceSnapshot(
        deviceName: '烹饪区近景',
        location: '炉灶上方',
        timestamp: DateTime.now().subtract(const Duration(seconds: 8)).toIso8601String().substring(11, 19),
        aiTag: '明火操作正常，油烟排放达标',
      ),
      DeviceSnapshot(
        deviceName: '出餐口',
        location: '出餐台对面',
        timestamp: DateTime.now().subtract(const Duration(seconds: 12)).toIso8601String().substring(11, 19),
        aiTag: '出餐流程规范，打包操作标准',
      ),
      DeviceSnapshot(
        deviceName: '就餐区全景',
        location: '大厅天花板',
        timestamp: DateTime.now().subtract(const Duration(seconds: 15)).toIso8601String().substring(11, 19),
        aiTag: '当前就餐人数12人，卫生状况良好',
      ),
    ];
  }
}
