import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/global_variables.dart';

import 'Test Inputs/test_inputs.dart';


void main() {

  testWidgets("search Connection Test", (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    /// Open Collect Payment Screen
    final collectPayment = find.widgetWithText(GridTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate('CORE_COLLECT_PAYMENTS'));
    await tester.tap(collectPayment);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    /// Search by Name
    final nameSearch = find.byKey(Keys.searchConnection.SEARCH_NAME_KEY);
    final phoneSearch = find.byKey(Keys.searchConnection.SEARCH_PHONE_NUMBER_KEY);
    final searchConnectionBtn = find.byKey(Keys.searchConnection.SEARCH_BTN_KEY);
    await tester.ensureVisible(nameSearch);
    await tester.enterText(nameSearch, TestInputs.searchConnection.SEARCH_NAME);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(searchConnectionBtn);
    await tester.tap(searchConnectionBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.tap(find.byIcon(Icons.arrow_left));
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.tap(find.byIcon(Icons.arrow_left));
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.tap(collectPayment);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.enterText(phoneSearch, TestInputs.searchConnection.SEARCH_MOBILE_NUMBER);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(searchConnectionBtn);
    await tester.tap(searchConnectionBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.tap(find.byIcon(Icons.arrow_left));
    await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.tap(find.byIcon(Icons.arrow_left));
    await tester.pumpAndSettle(Duration(seconds: 5));
  });
}