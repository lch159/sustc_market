import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sustc_market/main.dart';
import 'package:sustc_market/pages/Register.dart';

void main() {
//  Key registerNameKey =
  GlobalKey registerNameKey = new GlobalKey();
  GlobalKey registerPasswordKey = new GlobalKey();
  GlobalKey registerEmailKey = new GlobalKey();
  GlobalKey registerButton = new GlobalKey();
  GlobalKey registerCheck = new GlobalKey();

  testWidgets('my first widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return new MaterialApp(
            home: RegisterPage(
              registerNameKey: registerNameKey,
              registerPasswordKey: registerPasswordKey,
              registerEmailKey: registerEmailKey,
              registerButton: registerButton,
              registerCheck: registerCheck,
            ),
          );
        },
      ),
    );

//    print(registerNameKey.currentContext.findRenderObject().semanticBounds.size);
    await tester.enterText(find.byKey(registerNameKey), "");
    await tester.tap(find.byKey(registerButton));
//    print(registerNameKey.currentContext.findRenderObject().);
//    expect(find.byKey(registerCheck).toString(), equals(0.5));
  });
}
