/// 门店模型
class Store {
  final String id;
  final String name;
  final String region;
  final String province;
  final String city;
  final String address;
  final int deviceCount;
  final DateTime lastInspection;
  final double healthScore;
  final List<String> tags; // 动态标签

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
    this.tags = const [],
  });

  static const _tagOptions = ['客流下降', '客流上升', '巡检问题', '巡检合格', '食安预警', '待整改', '已达标', '新开业'];

  /// Generate dynamic tags based on store state
  static List<String> _genTags(double health, DateTime last, int id) {
    final r = id.hashCode;
    final tags = <String>[];
    if (r % 3 == 0) tags.add('近7日客流下降');
    if (r % 3 == 1) tags.add('近7日客流上升');
    if (health < 80) tags.add('食安周巡检问题');
    if (health >= 80) tags.add('食安周巡检合格');
    if (tags.length > 3) tags.removeRange(3, tags.length);
    return tags;
  }

  /// Mock 数据（含动态标签）
  static List<Store> mockStores() {
    final raw = [
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
      Store(id: 'SZ002', name: '茶颜悦色·南山店', region: '华南区', province: '广东', city: '深圳', address: '深圳市南山区科技园路2号', deviceCount: 6, lastInspection: DateTime.now().subtract(const Duration(days: 3)), healthScore: 87),
      Store(id: 'GZ001', name: '茶颜悦色·天河店', region: '华南区', province: '广东', city: '广州', address: '广州市天河区天河路3号', deviceCount: 7, lastInspection: DateTime.now().subtract(const Duration(days: 1)), healthScore: 93),
      Store(id: 'GZ002', name: '茶颜悦色·越秀店', region: '华南区', province: '广东', city: '广州', address: '广州市越秀区北京路8号', deviceCount: 5, lastInspection: DateTime.now().subtract(const Duration(days: 6)), healthScore: 76),
      Store(id: 'BJ001', name: '茶颜悦色·三里屯店', region: '华北区', province: '北京', city: '北京', address: '北京市朝阳区三里屯路19号', deviceCount: 8, lastInspection: DateTime.now().subtract(const Duration(days: 2)), healthScore: 94),
      Store(id: 'BJ002', name: '茶颜悦色·国贸店', region: '华北区', province: '北京', city: '北京', address: '北京市朝阳区建国路1号', deviceCount: 7, lastInspection: DateTime.now().subtract(const Duration(days: 4)), healthScore: 82),
      Store(id: 'BJ003', name: '茶颜悦色·西单店', region: '华北区', province: '北京', city: '北京', address: '北京市西城区西单北大街120号', deviceCount: 6, lastInspection: DateTime.now().subtract(const Duration(days: 1)), healthScore: 89),
      Store(id: 'TJ001', name: '茶颜悦色·滨江道店', region: '华北区', province: '天津', city: '天津', address: '天津市和平区滨江道168号', deviceCount: 5, lastInspection: DateTime.now().subtract(const Duration(days: 5)), healthScore: 74),
      Store(id: 'CD001', name: '茶颜悦色·春熙路店', region: '西南区', province: '四川', city: '成都', address: '成都市锦江区春熙路88号', deviceCount: 8, lastInspection: DateTime.now().subtract(const Duration(days: 1)), healthScore: 96),
      Store(id: 'CD002', name: '茶颜悦色·太古里店', region: '西南区', province: '四川', city: '成都', address: '成都市锦江区中纱帽街8号', deviceCount: 6, lastInspection: DateTime.now().subtract(const Duration(days: 3)), healthScore: 86),
      Store(id: 'CD003', name: '茶颜悦色·宽窄巷子店', region: '西南区', province: '四川', city: '成都', address: '成都市青羊区宽窄巷子1号', deviceCount: 5, lastInspection: DateTime.now().subtract(const Duration(days: 2)), healthScore: 90),
      Store(id: 'CQ001', name: '茶颜悦色·解放碑店', region: '西南区', province: '重庆', city: '重庆', address: '重庆市渝中区解放碑步行街1号', deviceCount: 7, lastInspection: DateTime.now().subtract(const Duration(days: 4)), healthScore: 83),
      Store(id: 'KM001', name: '茶颜悦色·南屏街店', region: '西南区', province: '云南', city: '昆明', address: '昆明市五华区南屏街66号', deviceCount: 5, lastInspection: DateTime.now().subtract(const Duration(days: 7)), healthScore: 71),
      Store(id: 'XA001', name: '茶颜悦色·钟楼店', region: '西北区', province: '陕西', city: '西安', address: '西安市碑林区东大街1号', deviceCount: 6, lastInspection: DateTime.now().subtract(const Duration(days: 2)), healthScore: 88),
      Store(id: 'XA002', name: '茶颜悦色·大唐不夜城店', region: '西北区', province: '陕西', city: '西安', address: '西安市雁塔区大唐不夜城1号', deviceCount: 8, lastInspection: DateTime.now().subtract(const Duration(days: 1)), healthScore: 93),
      Store(id: 'XA003', name: '茶颜悦色·高新店', region: '西北区', province: '陕西', city: '西安', address: '西安市高新区科技路8号', deviceCount: 5, lastInspection: DateTime.now().subtract(const Duration(days: 6)), healthScore: 77),
      Store(id: 'LZ001', name: '茶颜悦色·张掖路店', region: '西北区', province: '甘肃', city: '兰州', address: '兰州市城关区张掖路88号', deviceCount: 4, lastInspection: DateTime.now().subtract(const Duration(days: 5)), healthScore: 69),
      Store(id: 'NJ002', name: '茶颜悦色·夫子庙店', region: '华东区', province: '江苏', city: '南京', address: '南京市秦淮区贡院西街8号', deviceCount: 6, lastInspection: DateTime.now().subtract(const Duration(days: 1)), healthScore: 91),
      Store(id: 'SH001', name: '茶颜悦色·南京东路店', region: '华东区', province: '上海', city: '上海', address: '上海市黄浦区南京东路199号', deviceCount: 8, lastInspection: DateTime.now().subtract(const Duration(days: 2)), healthScore: 95),
      Store(id: 'SH002', name: '茶颜悦色·陆家嘴店', region: '华东区', province: '上海', city: '上海', address: '上海市浦东新区陆家嘴环路1号', deviceCount: 7, lastInspection: DateTime.now().subtract(const Duration(days: 3)), healthScore: 84),
      Store(id: 'HZ002', name: '茶颜悦色·西溪店', region: '华东区', province: '浙江', city: '杭州', address: '杭州市西湖区文二西路8号', deviceCount: 5, lastInspection: DateTime.now().subtract(const Duration(days: 4)), healthScore: 73),
    ];
    return raw.map((s) => Store(
      id: s.id, name: s.name, region: s.region, province: s.province,
      city: s.city, address: s.address, deviceCount: s.deviceCount,
      lastInspection: s.lastInspection, healthScore: s.healthScore,
      tags: Store._genTags(s.healthScore, s.lastInspection, s.id.hashCode),
    )).toList();
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
