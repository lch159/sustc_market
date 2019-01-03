


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sustc_market/main.dart';

void main() {
  testWidgets('my first widget test', (WidgetTester tester) async {
    var sliderKey = new UniqueKey();
    var value = 0.0;
    await tester.pumpWidget(
      new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return new MainPage();
        },
      ),
    );
    expect(value, equals(0.0));
    await tester.tap(find.byKey(sliderKey));

    expect(value, equals(0.5));
  });
}