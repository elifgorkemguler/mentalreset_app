import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project484/app.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MindFlowApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
