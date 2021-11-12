import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'Test Inputs/test_inputs.dart';


void main() {
  testWidgets("update Consumer Test", (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    final updateConsumer = find.widgetWithText(GridTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate('CORE_UPDATE_CONSUMER_DETAILS'));
    await tester.tap(updateConsumer);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    final phoneSearch = find.byKey(Keys.searchConnection.SEARCH_PHONE_NUMBER_KEY);
    final searchConnectionBtn = find.byKey(Keys.searchConnection.SEARCH_BTN_KEY);
    final editConsumerDetailsBtn = find.widgetWithText(ShortButton,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.
        searchWaterConnection.HOUSE_DETAILS_EDIT));

    await tester.enterText(phoneSearch, TestInputs.updateConsumer.SEARCH_MOBILE_NUMBER);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(searchConnectionBtn);
    await tester.tap(searchConnectionBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(editConsumerDetailsBtn);
    await tester.tap(editConsumerDetailsBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
  });
}