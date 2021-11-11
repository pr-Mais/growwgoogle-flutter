// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_test;

import 'package:fun_cat_responses/main.dart';
import 'package:network_image_mock/network_image_mock.dart';

Future<http.Response> _mockResponse(http.Request req) async {
  switch (req.url.toString()) {
    case 'https://google.com':
      return http.Response('Success', 200);
    default:
      return http.Response('Error: not found', 404);
  }
}

void main() {
  setUp(() {
    CatsAPI.instance.setClient(http_test.MockClient(_mockResponse));
  });

  group('$CatsAPI', () {
    test('200 response', () async {
      final res = await CatsAPI.instance.checkStatusCode('google.com');

      expect(res, '200');
    });
    test('404 response', () async {
      final res = await CatsAPI.instance.checkStatusCode('none.com');

      expect(res, '404');
    });
  });
  group('$Home', () {
    testWidgets('200 shows cat image', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MyApp());

        await tester.enterText(find.byType(TextField), 'google.com');

        await tester.pump();

        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('cat')), findsOneWidget);
      });
    });
  });
}
