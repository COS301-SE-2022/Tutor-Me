// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_me/src/app.dart';

void main() {
  group('App dart', () {
    testWidgets('should display a string of text', (WidgetTester tester) async {
      // Define a Widget
      const myWidget = MaterialApp(
        home: Scaffold(
          body: Text('Hello'),
        ),
      );

      // Build myWidget and trigger a frame.
      await tester.pumpWidget(myWidget);

      // Verify myWidget shows some text
      expect(find.byType(Text), findsOneWidget);
    });
  });

  testWidgets('should display a  Title string', (WidgetTester tester) async {
    //  MaterialApp( await tester.pumpWidget(AppBar());
    await tester.pumpWidget(DefaultTabController(
        length: 3,
        child: MaterialApp(
            home: Scaffold(
                appBar: AppBar(
          title: const Text(
            'Tutor Me',
          ),
        )))));
    final titleFinder = find.text('Tutor Me');
    expect(titleFinder, findsOneWidget);
  });

  testWidgets('should display a  Chat Tab ', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    //Tabs
    const tabChat = 'Chat';
    await tester.pumpAndSettle();

    //  Ensuring visibility before Tab
    await tester.ensureVisible(find.text(tabChat));

    await tester.tap(find.text(tabChat));
    await tester.pumpAndSettle();

    expect(find.text(tabChat), findsOneWidget);
  });

  testWidgets('should display a  Request Tab ', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    //Tabs
    const tabRequest = 'Request';
    await tester.pumpAndSettle();

    //  Ensuring visibility before Tab
    await tester.ensureVisible(find.text(tabRequest));

    await tester.tap(find.text(tabRequest));
    await tester.pumpAndSettle();

    expect(find.text(tabRequest), findsOneWidget);
  });

  testWidgets('should display a  Calls Tab ', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    //Tabs
    const tabCalls = 'Calls';
    await tester.pumpAndSettle();

    //  Ensuring visibility before Tab
    await tester.ensureVisible(find.text(tabCalls));

    await tester.tap(find.text(tabCalls));
    await tester.pumpAndSettle();

    expect(find.text(tabCalls), findsOneWidget);
  });



  testWidgets(
    'should display users widget',
    (WidgetTester tester) async {
      // Write your test here
      await tester.pumpWidget(const MyApp()); //_cardBuilder());

      expect(find.text('Kuda Chivunga'), findsOneWidget);
       expect(find.text('Farai Chivunga'), findsOneWidget);
        expect(find.text('Simphiwe Ndlovu'), findsOneWidget);
         expect(find.text('Musa Mabasa'), findsOneWidget);
    },
  );
}
