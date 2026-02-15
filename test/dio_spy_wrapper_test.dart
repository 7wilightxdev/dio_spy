import 'package:dio_spy/dio_spy.dart';
import 'package:dio_spy/src/core/dio_spy_storage.dart';
import 'package:dio_spy/src/ui/call_list/call_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DioSpy inspectorVisible', () {
    late DioSpy dioSpy;

    setUp(() {
      dioSpy = DioSpy(showOnShake: false, maxCalls: 100);
    });

    tearDown(() {
      dioSpy.dispose();
    });

    test('should be false initially', () {
      expect(dioSpy.inspectorVisible.value, isFalse);
    });

    test('show() should set inspectorVisible to true', () {
      dioSpy.showInspector();
      expect(dioSpy.inspectorVisible.value, isTrue);
    });

    test('hideInspector() should set inspectorVisible to false', () {
      dioSpy.showInspector();
      expect(dioSpy.inspectorVisible.value, isTrue);

      dioSpy.hideInspector();
      expect(dioSpy.inspectorVisible.value, isFalse);
    });

    test('show() when already visible should be a no-op (no extra notify)', () {
      var notifyCount = 0;
      dioSpy.inspectorVisible.addListener(() => notifyCount++);

      dioSpy.showInspector();
      dioSpy.showInspector(); // same value — ValueNotifier does not notify

      expect(notifyCount, 1);
    });
  });

  group('DioSpyWrapper', () {
    late DioSpy dioSpy;

    setUp(() {
      dioSpy = DioSpy(showOnShake: false, maxCalls: 100);
    });

    tearDown(() {
      dioSpy.dispose();
    });

    Widget buildTestApp({Widget? home}) {
      return MaterialApp(
        builder: (context, child) => DioSpyWrapper(
          dioSpy: dioSpy,
          child: child!,
        ),
        home: home ?? const Scaffold(body: Text('App Content')),
      );
    }

    testWidgets('should render child content normally', (tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.text('App Content'), findsOneWidget);
    });

    testWidgets('should not show inspector initially', (tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(CallListScreen), findsNothing);
    });

    testWidgets('should show inspector when dioSpy.show() is called', (tester) async {
      await tester.pumpWidget(buildTestApp());

      dioSpy.showInspector();
      await tester.pumpAndSettle();

      expect(find.byType(CallListScreen), findsOneWidget);
    });

    testWidgets('should show close button in inspector AppBar', (tester) async {
      await tester.pumpWidget(buildTestApp());

      dioSpy.showInspector();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should hide inspector when close button is tapped', (tester) async {
      await tester.pumpWidget(buildTestApp());

      dioSpy.showInspector();
      await tester.pumpAndSettle();

      expect(find.byType(CallListScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(CallListScreen), findsNothing);
      expect(find.text('App Content'), findsOneWidget);
      expect(dioSpy.inspectorVisible.value, isFalse);
    });

    testWidgets('should hide inspector when hideInspector() is called', (tester) async {
      await tester.pumpWidget(buildTestApp());

      dioSpy.showInspector();
      await tester.pumpAndSettle();
      expect(find.byType(CallListScreen), findsOneWidget);

      dioSpy.hideInspector();
      await tester.pumpAndSettle();

      expect(find.byType(CallListScreen), findsNothing);
    });

    testWidgets('should not open inspector twice', (tester) async {
      await tester.pumpWidget(buildTestApp());

      dioSpy.showInspector();
      await tester.pumpAndSettle();

      dioSpy.showInspector();
      await tester.pumpAndSettle();

      expect(find.byType(CallListScreen), findsOneWidget);
    });

    testWidgets('should allow reopening inspector after closing', (tester) async {
      await tester.pumpWidget(buildTestApp());

      // Open
      dioSpy.showInspector();
      await tester.pumpAndSettle();
      expect(find.byType(CallListScreen), findsOneWidget);

      // Close
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(CallListScreen), findsNothing);

      // Re-open
      dioSpy.showInspector();
      await tester.pumpAndSettle();
      expect(find.byType(CallListScreen), findsOneWidget);
    });

    testWidgets('should work with DioSpyWrapper widget directly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => DioSpyWrapper(
            dioSpy: dioSpy,
            child: child!,
          ),
          home: const Scaffold(body: Text('Direct Wrapper')),
        ),
      );

      expect(find.text('Direct Wrapper'), findsOneWidget);

      dioSpy.showInspector();
      await tester.pumpAndSettle();

      expect(find.byType(CallListScreen), findsOneWidget);
    });
  });

  group('CallListScreen onClose', () {
    testWidgets('should not show close button when onClose is null', (tester) async {
      final storage = DioSpyStorage(maxCalls: 100);

      await tester.pumpWidget(
        MaterialApp(
          home: CallListScreen(storage: storage),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('should show close button when onClose is provided', (tester) async {
      final storage = DioSpyStorage(maxCalls: 100);
      var closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: CallListScreen(
            storage: storage,
            onBack: () => closed = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, isTrue);
    });
  });
}
