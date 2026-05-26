import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static void _showLlmConfig(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _LlmConfigPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('个人中心')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // 用户信息卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.cardDecoration,
            child: Column(children: [
              Container(
                width: 72, height: 72,
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]), borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Icon(Icons.person, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 12),
              const Text('餐饮管理者', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('admin@catering-ai.com', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.shield, color: AppTheme.primary, size: 14),
                  SizedBox(width: 6),
                  Text('企业版', style: TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w500)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: AppTheme.sectionGap),

          // 账号与绑定
          _Section(text: '账号管理', icon: Icons.manage_accounts, color: AppTheme.primary),
          const SizedBox(height: 8),
          _item(Icons.phone_android, '手机号', subtitle: '138****8888', color: AppTheme.info),
          _item(Icons.email, '邮箱', subtitle: 'admin@catering-ai.com', color: AppTheme.success),
          _item(Icons.lock, '密码', subtitle: '修改登录密码', color: AppTheme.warning),
          const SizedBox(height: AppTheme.sectionGap),

        // 设置
        _Section(text: '系统设置', icon: Icons.settings, color: AppTheme.accent),
        const SizedBox(height: 8),
        _item(Icons.notifications, '消息通知', subtitle: '巡检报告推送 · 告警通知', color: AppTheme.appColors[3]),
        _item(Icons.cloud_sync, '数据同步', subtitle: '自动同步 · 每15分钟', color: AppTheme.appColors[5]),
        _item(Icons.language, '应用语言', subtitle: '简体中文', color: AppTheme.info),
        _item(Icons.psychology, '模型配置', subtitle: 'API Key · 模型参数 · 巡检提示词', color: AppTheme.primary, onTap: () => _showLlmConfig(context)),
        _item(Icons.launch, '启动页面', subtitle: '查看App启动动画效果', color: AppTheme.accent, onTap: () => Navigator.of(context).pushNamed('/')),
        const SizedBox(height: AppTheme.sectionGap),

        // 关于
        _Section(text: '关于我们', icon: Icons.info_outline, color: AppTheme.success),
        const SizedBox(height: 8),
        _item(Icons.description, '用户协议', color: AppTheme.textSecondary, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _PolicyPage(title: '云盯科技用户协议', content: _userAgreement)))),
        _item(Icons.privacy_tip, '隐私政策', color: AppTheme.textSecondary, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _PolicyPage(title: '云盯科技隐私政策', content: _privacyPolicy)))),
        _item(Icons.system_update, '版本更新', subtitle: 'V 1.0.0 (Demo)', color: AppTheme.textSecondary),
          const SizedBox(height: 28),

          // 退出登录 - 卡片化
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text('退出登录', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.error)),
            ),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _item(IconData icon, String title, {String? subtitle, Widget? trailing, Color color = AppTheme.primary, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppTheme.cardDecoration,
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary))],
          ])),
          trailing ?? const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 18),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _Section({required this.text, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 0),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text)),
      ]),
    );
  }
}

// ── 大模型配置页 ──
class _LlmConfigPage extends StatefulWidget {
  const _LlmConfigPage();
  @override
  State<_LlmConfigPage> createState() => _LlmConfigPageState();
}

class _LlmConfigPageState extends State<_LlmConfigPage> {
  final _apiCtrl = TextEditingController(text: 'https://api.openai.com/v1/chat/completions');
  final _keyCtrl = TextEditingController(text: 'sk-•••••••••••••••••••••••••••');
  final _modelCtrl = TextEditingController(text: 'gpt-4o');
  final _tempCtrl = TextEditingController(text: '0.7');
  final _maxTokensCtrl = TextEditingController(text: '4096');
  bool _saved = false;
  bool _showKey = false;
  bool _showEndpoint = false;

  static const _apps = [
    ('AI 一键巡检', Icons.auto_awesome, Color(0xFF6366F1), '配置巡检分析的系统提示词和检测规则'),
    ('AI 外卖追溯', Icons.delivery_dining, Color(0xFF0EA2B8), '配置外卖数据分析与运营建议提示词'),
    ('AI 陪练打卡', Icons.school, Color(0xFF10B981), '配置员工陪练话术与考评标准'),
    ('AI 智能选址', Icons.location_on, Color(0xFFE3811A), '配置选址评估模型的地域偏好和参数'),
  ];

  @override
  void dispose() {
    _apiCtrl.dispose(); _keyCtrl.dispose(); _modelCtrl.dispose();
    _tempCtrl.dispose(); _maxTokensCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('模型配置')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.psychology, color: AppTheme.primary, size: 18), SizedBox(width: 6), Text('模型参数', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]),
              const SizedBox(height: 14),
              _field('API Endpoint', _apiCtrl, hint: 'https://api.openai.com/v1/chat/completions', obscure: _showEndpoint, suffix: GestureDetector(onTap: () => setState(() => _showEndpoint = !_showEndpoint), child: Icon(_showEndpoint ? Icons.visibility_off : Icons.visibility, size: 20, color: AppTheme.textSecondary))),
              const SizedBox(height: 10),
              _field('API Key', _keyCtrl, hint: 'sk-...', obscure: !_showKey, suffix: GestureDetector(onTap: () => setState(() => _showKey = !_showKey), child: Icon(_showKey ? Icons.visibility_off : Icons.visibility, size: 20, color: AppTheme.textSecondary))),
              const SizedBox(height: 10),
              _field('Model', _modelCtrl, hint: 'gpt-4o / gpt-4-turbo'),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: _field('Temperature', _tempCtrl, hint: '0.0 - 2.0')), const SizedBox(width: 10), Expanded(child: _field('Max Tokens', _maxTokensCtrl, hint: '1024-8192'))]),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: () => setState(() => _saved = true),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: _saved ? AppTheme.success : AppTheme.primary),
                child: Text(_saved ? '已保存' : '保存模型参数', style: const TextStyle(fontSize: 15, color: Colors.white)),
              )),
            ]),
          ),
          const SizedBox(height: AppTheme.sectionGap),
          const Row(children: [Icon(Icons.edit_note, color: AppTheme.accent, size: 18), SizedBox(width: 6), Text('为智能AI应用配置提示词', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          ..._apps.map((app) => _appCard(app)),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {String? hint, bool obscure = false, Widget? suffix}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      const SizedBox(height: 4),
      TextField(controller: ctrl, obscureText: obscure, decoration: InputDecoration(hintText: hint, suffixIcon: suffix, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), isDense: true), style: const TextStyle(fontSize: 14)),
    ]);
  }

  Widget _appCard((String, IconData, Color, String) app) {
    final (name, icon, color, desc) = app;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PromptConfigPage(name: name, color: color))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration,
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 3),
            Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ]),
      ),
    );
  }
}

// ── 提示词配置页 ──
class _PromptConfigPage extends StatefulWidget {
  final String name;
  final Color color;
  const _PromptConfigPage({required this.name, required this.color});
  @override
  State<_PromptConfigPage> createState() => _PromptConfigPageState();
}

class _PromptConfigPageState extends State<_PromptConfigPage> {
  late final TextEditingController _promptCtrl;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _promptCtrl = TextEditingController(text: _defaultPrompt(widget.name));
  }

  String _defaultPrompt(String name) {
    switch (name) {
      case 'AI 一键巡检': return '你是一个专业的餐饮门店AI巡检助手。请根据提供的门店监控抓图，分析门店卫生、安全、操作规范等方面的问题。给出具体的评分和建议。';
      case 'AI 外卖追溯': return '你是一个资深的外卖运营数据分析师。请根据门店外卖订单数据、用户评价和竞品分析，提供运营优化建议。';
      case 'AI 陪练打卡': return '你是一个餐饮服务培训专家。请根据岗位职责和服务标准，模拟真实服务场景，对员工进行话术训练和礼仪考核。';
      case 'AI 智能选址': return '你是一个商业地产选址分析师。请根据提供的商圈数据、人口画像、竞争密度和交通便利度等信息，评估选址的可行性和预期收益。';
      default: return '';
    }
  }

  @override
  void dispose() { _promptCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text('${widget.name}提示词')),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [Icon(Icons.auto_awesome, color: widget.color, size: 18), const SizedBox(width: 8), Text('System Prompt 配置', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: widget.color))]),
            ),
            const SizedBox(height: 12),
            TextField(controller: _promptCtrl, maxLines: null, minLines: 8, decoration: const InputDecoration(hintText: '输入系统提示词...', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), contentPadding: EdgeInsets.all(14)), style: TextStyle(fontSize: 14, color: AppTheme.text, height: 1.6)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.accent.withValues(alpha: 0.12))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.tips_and_updates, color: AppTheme.accent, size: 16), SizedBox(width: 6), Text('可用变量', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
                const SizedBox(height: 8),
                Text(_variablesText(widget.name), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.6)),
              ]),
            ),
          ]),
        )),
        Container(
          padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppTheme.divider))),
          child: SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
            onPressed: () => setState(() => _saved = true),
            style: ElevatedButton.styleFrom(backgroundColor: _saved ? AppTheme.success : widget.color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: Text(_saved ? '已保存' : '保存提示词', style: const TextStyle(fontSize: 16, color: Colors.white)),
          )),
        ),
      ]),
    );
  }

  String _variablesText(String name) {
    switch (name) {
      case 'AI 一键巡检': return '{device_tags} - 设备标签列表\n{store_info} - 门店信息\n{image_count} - 图片数量';
      case 'AI 外卖追溯': return '{store_data} - 门店经营数据\n{order_history} - 历史订单\n{competitor_data} - 竞品数据';
      case 'AI 陪练打卡': return '{role_type} - 岗位类型\n{scenario} - 培训场景\n{employee_level} - 员工级别';
      case 'AI 智能选址': return '{district_data} - 商圈数据\n{population_profile} - 人口画像\n{traffic_flow} - 人流量';
      default: return '';
    }
  }
}

// ── 内容页面（用户协议 / 隐私政策）──
class _PolicyPage extends StatelessWidget {
  final String title;
  final String content;
  const _PolicyPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(content, style: const TextStyle(fontSize: 14, color: AppTheme.text, height: 1.8)),
      ),
    );
  }
}

const String _userAgreement = '''云盯科技用户服务协议

更新日期：2025年1月1日
生效日期：2025年1月1日

欢迎使用云盯科技（以下简称"本公司"）提供的餐饮AI SaaS服务！

一、总则
1.1 本协议是用户（以下简称"您"）与云盯科技之间关于使用本公司提供的餐饮AI智能门店管理系统及相关服务所订立的协议。
1.2 您在注册或使用本服务前，请务必仔细阅读本协议的全部内容。如您不同意本协议的任何条款，请立即停止注册或使用本服务。

二、服务内容
2.1 本公司通过AI视觉智能技术，为餐饮门店提供包括但不限于AI选址、AI一键巡检、AI外卖追溯、AI陪练打卡等智能化管理服务。
2.2 本公司保留根据业务发展需要，随时变更、中断或终止部分或全部服务的权利。

三、用户义务
3.1 您应当对使用本服务过程中上传的数据、信息的真实性、合法性负责。
3.2 您不得利用本服务从事任何违法违规活动，包括但不限于侵犯他人隐私、传播违法信息等。

四、数据安全
4.1 本公司将采取合理的技术手段和管理措施，保护您的数据安全。
4.2 未经您的许可，本公司不会向任何第三方提供您的数据，法律法规另有规定除外。

五、免责声明
5.1 本公司提供的AI分析结果仅供决策参考，不构成任何形式的保证或承诺。
5.2 因不可抗力因素导致的服务中断，本公司不承担责任。

六、其他
6.1 本协议的解释、效力及争议解决均适用中华人民共和国法律。
6.2 如本协议任何条款被认定为无效，不影响其余条款的效力。

云盯科技有限公司
地址：深圳市南山区科技园
客服邮箱：support@cloudzhin.com''';

const String _privacyPolicy = '''云盯科技隐私政策

更新日期：2025年1月1日
生效日期：2025年1月1日

云盯科技（以下简称"我们"）深知个人信息对您的重要性，我们将按照法律法规要求，保护您的个人信息安全。

一、我们收集的信息
1.1 账号信息：手机号码、电子邮箱、企业名称等注册信息。
1.2 设备信息：门店监控设备编号、设备型号、安装位置等。
1.3 业务数据：门店巡检记录、监控抓图、AI分析结果、员工培训记录等。
1.4 日志信息：操作日志、访问记录、系统异常信息等。

二、信息使用目的
2.1 为您提供AI智能巡检、外卖追溯、陪练打卡等服务。
2.2 优化和改进我们的AI算法模型。
2.3 向您发送服务通知、系统告警和巡检报告。
2.4 履行法律法规规定的义务。

三、信息存储与保护
3.1 您的信息存储于中华人民共和国境内的服务器。
3.2 我们采用加密传输、访问控制、定期审计等措施保障信息安全。
3.3 我们制定了数据安全事件应急预案，一旦发生泄露将及时通知您。

四、信息共享
4.1 我们不会将您的个人信息出售给任何第三方。
4.2 以下情形除外：获得您的明确同意；法律法规要求；与合作伙伴共享（已签署保密协议）。

五、您的权利
5.1 您有权查询、更正、删除您的个人信息。
5.2 您有权撤回同意、注销账号。
5.3 您可以随时通过客服渠道行使上述权利。

六、隐私政策更新
6.1 我们可能适时更新本隐私政策，更新后将在应用内显著位置通知。
6.2 如您继续使用我们的服务，视为同意更新后的政策。

联系方式：
云盯科技数据安全部
邮箱：privacy@cloudzhin.com
电话：400-888-XXXX''';
