// File: test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:privatetutor/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PrivateTutorApp());

    // Verify app starts with home page
    expect(find.text('Welcome to PrivateTutor'), findsOneWidget);
    expect(find.text('Phase 1 Foundation Complete'), findsOneWidget);
  });

  testWidgets('Navigation works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PrivateTutorApp());

    // Tap on Browse Courses button
    await tester.tap(find.text('Browse Courses'));
    await tester.pumpAndSettle();

    // Verify navigation to courses page
    expect(find.text('Courses Page - Coming Soon'), findsOneWidget);
  });
}
