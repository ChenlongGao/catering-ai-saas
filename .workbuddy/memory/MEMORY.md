# 云盯AI360 - 项目规范 V2

## 品牌规范
- 主色: `#0EA2B8` (青蓝), 辅色: `#E3811A` (金橙)
- 背景: `#F5F9FA`, 卡片: `#FFFFFF` 圆角14px, 阴影 `0x08000000 blur 8`
- 文字: 主 `#1A2E33`, 次 `#5B7278`, 分隔 `#DDE7EA`
- **严禁 emoji**，统一 Material Icons
- 卡片比例一致，高度对齐，不溢出

## 技术栈
- Flutter 3.x + Dart, Material 3
- 纯前端，无后台，Mock 数据
- Android APK (51MB), Web via Chrome
- 构建: `flutter build apk --release`, 安装: `adb install -r`
- macOS 沙盒: 需 `/tmp/flutter_sdk` 副本 + `DART_FLUTTER_TELEMETRY_ENABLED=false`

## 页面架构 (4 Tab)
| Tab | 页面 | 核心功能 |
|---|---|---|
| 数据 | Dashboard | 客流/营收/订单 KPI, 时段/门店筛选, 默认近30天 |
| 应用 | AppCenter | 6大AI引擎卡片（巡检/选址/外卖/陪练/视频/客流） |
| 视频 | VideoCenter | KPI卡片+门店选择+直播/AI抓拍/回放 |
| 我的 | Profile | 模型配置(API Key)| 应用提示词配置 |

## 子模块明细

### AI巡检 (Inspection)
- 标签筛选: 10个内置标签(Wrap布局, 展开/收起)
- 门店选择: 搜索+标签筛选, 点击进入详情
- 单店: 设备标签筛选+视频列表+直播查看

### AI选址 (Location)
- 拍照打卡: 三分区(店招/人流动线/竞品), 每区≤4张, 1:1缩略图
- 分析报告: 评分≥80绿渐变自动收藏, <80黄渐变
- 报告图片: 3行×4张1:1, 点击全屏查看
- 底部: 收藏+分享按钮

### AI陪练 (Training)
- 三Tab: 日打卡(4项)/周打卡(5项)/月打卡(6项)
- 中间页: 打卡说明+上传≤4图+1视频+AI评阅
- 报告: 综合评分+分项评分+AI评论

### AI外卖追溯 (Delivery)
- 20条Mock记录按日期倒序
- 详情页: 小票信息+关联录像+抽帧照片(4列1:1)+AI分析

### 视频中心 (Video)
- 顶部KPI卡片(门店/设备/标签)
- 门店列表: 搜索+设备标签筛选
- 单店: 设备标签筛选+视频列表+直播播放页

## UI组件规范
- 卡片: `AppTheme.cardDecoration` (白底14px圆角阴影)
- 标签: 8px圆角, 选中填充主题色
- 列表项: 统一padding 14, 间距8
- 按钮: 14px圆角, 主题色/语义色

## 数据Mock规范
- 门店: 24家茶颜悦色(Store模型)
- 设备: 每店6设备(camera/nvr/aiBox)
- 动态标签: 每店≤3个标签(客流升降+巡检状态)

## 需求清单 (待做)
1. 后台服务搭建 (Node.js + Express + SQLite)
2. 真实数据对接替换Mock
3. MediaPipe人体姿态检测 (暂缓, Google算法)
4. 推送通知集成
5. 数据看板图表(ECharts替代CustomPaint)
