import 'package:flutter_test/flutter_test.dart';

import 'package:catering_ai_saas/main.dart';

void main() {
  testWidgets('App renders three bottom tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const CateringAiSaasApp());

    expect(find.text('数据看板'), findsWidgets);
    expect(find.text('应用中心'), findsWidgets);
    expect(find.text('个人中心'), findsWidgets);
  });

  testWidgets('Default tab is app center with four apps', (WidgetTester tester) async {
    await tester.pumpWidget(const CateringAiSaasApp());

    expect(find.text('AI 一键巡检'), findsWidgets);
    expect(find.text('AI 陪练打卡'), findsWidgets);
    expect(find.text('AI 外卖追溯'), findsWidgets);
    expect(find.text('AI 智能选址'), findsWidgets);
  });
}
