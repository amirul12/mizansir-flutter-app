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
    expect(find.text('Phase 2 Authentication Complete'), findsOneWidget);

    // Verify navigation buttons exist
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('Home page UI is correct', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PrivateTutorApp());

    // Verify app title
    expect(find.text('PrivateTutor'), findsOneWidget);

    // Verify main welcome message
    expect(find.text('Welcome to PrivateTutor'), findsOneWidget);
    expect(find.text('Phase 2 Authentication Complete'), findsOneWidget);

    // Verify both authentication buttons are present
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
