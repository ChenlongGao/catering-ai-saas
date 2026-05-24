/// 门店模型 - 复用茶颜悦色门店架构树逻辑
class Store {
  final String id;
  final String name;
  final String region; // 区域
  final String province; // 省份
  final String city; // 城市
  final String address;
  final int deviceCount; // 设备数量
  final DateTime lastInspection; // 上次巡检时间
  final double healthScore; // 健康评分 0-100

  const Store({
    required this.id,
    required this.name,
    required this.region,
    required this.province,
    required this.city,
    required this.address,
    required this.deviceCount,
    required this.lastInspection,
    required this.healthScore,
  });

  /// Mock 数据
  static List<Store> mockStores() {
    return [
      Store(
        id: 'CS001',
        name: '茶颜悦色·太平街店',
        region: '华中区',
        province: '湖南',
        city: '长沙',
        address: '长沙市天心区太平街128号',
        deviceCount: 6,
        lastInspection: DateTime.now().subtract(const Duration(days: 1)),
        healthScore: 92,
      ),
      Store(
        id: 'CS002',
        name: '茶颜悦色·五一广场店',
        region: '华中区',
        province: '湖南',
        city: '长沙',
        address: '长沙市芙蓉区五一大道188号',
        deviceCount: 8,
        lastInspection: DateTime.now().subtract(const Duration(days: 3)),
        healthScore: 85,
      ),
      Store(
        id: 'CS003',
        name: '茶颜悦色·解放西路店',
        region: '华中区',
        province: '湖南',
        city: '长沙',
        address: '长沙市天心区解放西路66号',
        deviceCount: 5,
        lastInspection: DateTime.now().subtract(const Duration(days: 7)),
        healthScore: 78,
      ),
      Store(
        id: 'WH001',
        name: '茶颜悦色·江汉路店',
        region: '华中区',
        province: '湖北',
        city: '武汉',
        address: '武汉市江汉区江汉路99号',
        deviceCount: 7,
        lastInspection: DateTime.now().subtract(const Duration(days: 2)),
        healthScore: 90,
      ),
      Store(
        id: 'WH002',
        name: '茶颜悦色·光谷店',
        region: '华中区',
        province: '湖北',
        city: '武汉',
        address: '武汉市洪山区光谷广场1号',
        deviceCount: 6,
        lastInspection: DateTime.now().subtract(const Duration(days: 5)),
        healthScore: 72,
      ),
      Store(
        id: 'NJ001',
        name: '茶颜悦色·新街口店',
        region: '华东区',
        province: '江苏',
        city: '南京',
        address: '南京市秦淮区中山南路100号',
        deviceCount: 8,
        lastInspection: DateTime.now().subtract(const Duration(days: 1)),
        healthScore: 95,
      ),
      Store(
        id: 'HZ001',
        name: '茶颜悦色·湖滨银泰店',
        region: '华东区',
        province: '浙江',
        city: '杭州',
        address: '杭州市上城区湖滨路88号',
        deviceCount: 6,
        lastInspection: DateTime.now().subtract(const Duration(days: 4)),
        healthScore: 88,
      ),
      Store(
        id: 'SZ001',
        name: '茶颜悦色·华强北店',
        region: '华南区',
        province: '广东',
        city: '深圳',
        address: '深圳市福田区华强北路1号',
        deviceCount: 5,
        lastInspection: DateTime.now().subtract(const Duration(days: 2)),
        healthScore: 91,
      ),
    ];
  }
}

/// 设备模型
class Device {
  final String id;
  final String name;
  final DeviceType type;
  final String location; // 安装位置
  final bool isOnline;
  final String? snapshotUrl;
  final List<String> tags; // AI标签

  const Device({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.isOnline,
    this.snapshotUrl,
    this.tags = const [],
  });

  static List<Device> mockDevices(String storeId) {
    return [
      Device(
        id: '${storeId}_CAM01',
        name: '厨房全景',
        type: DeviceType.camera,
        location: '后厨门口',
        isOnline: true,
        tags: ['厨师帽', '口罩', '围裙'],
      ),
      Device(
        id: '${storeId}_CAM02',
        name: '烹饪区近景',
        type: DeviceType.camera,
        location: '炉灶上方',
        isOnline: true,
        tags: ['明火', '油烟', '操作规范'],
      ),
      Device(
        id: '${storeId}_CAM03',
        name: '出餐口',
        type: DeviceType.camera,
        location: '出餐台对面',
        isOnline: true,
        tags: ['出餐速度', '打包规范'],
      ),
      Device(
        id: '${storeId}_CAM04',
        name: '就餐区全景',
        type: DeviceType.camera,
        location: '大厅天花板',
        isOnline: true,
        tags: ['翻台率', '卫生', '客流'],
      ),
      Device(
        id: '${storeId}_NVR01',
        name: '8路NVR主机',
        type: DeviceType.nvr,
        location: '机房',
        isOnline: true,
        tags: ['录像存储', 'AI分析'],
      ),
      Device(
        id: '${storeId}_AI01',
        name: '云盯AI盒子',
        type: DeviceType.aiBox,
        location: '机房',
        isOnline: true,
        tags: ['行为分析', '口罩检测', '鼠患检测'],
      ),
    ];
  }
}

enum DeviceType {
  camera('摄像头'),
  nvr('NVR'),
  aiBox('AI盒子');

  final String label;
  const DeviceType(this.label);
}
