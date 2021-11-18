import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'Test Inputs/test_inputs.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';



void main() {
  testWidgets("Generate Bill Metered Test", (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    /// Open Collect Payment Screen
    final collectPayment = find.widgetWithText(GridTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate('CORE_COLLECT_PAYMENTS'));
    await tester.tap(collectPayment);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    ///Search Connection by Phone Number
    final phoneSearch = find.byKey(Keys.searchConnection.SEARCH_PHONE_NUMBER_KEY);
    final searchConnectionBtn = find.byKey(Keys.searchConnection.SEARCH_BTN_KEY);

    await tester.enterText(phoneSearch, TestInputs.generateBill.SEARCH_MOBILE_NUMBER);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(searchConnectionBtn);
    await tester.tap(searchConnectionBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    final viewConsumerDetailsBtn = find.widgetWithText(ShortButton,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.searchWaterConnection
            .HOUSE_DETAILS_VIEW)).first;
    await tester.ensureVisible(viewConsumerDetailsBtn);
    await tester.tap(viewConsumerDetailsBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 5000));

    final generateNewBillBtn = find.widgetWithText(ShortButton,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.generateBillDetails.GENERATE_NEW_BTN_LABEL)).first;
    await tester.ensureVisible(generateNewBillBtn);
    await tester.tap(generateNewBillBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 5000));

    final newMeterReading1 = find.byType(MeterReadingDigitTextFieldBox).at(5);
    final newMeterReading2 = find.byType(MeterReadingDigitTextFieldBox).at(6);
    final newMeterReading3 = find.byType(MeterReadingDigitTextFieldBox).at(7);
    final newMeterReading4 = find.byType(MeterReadingDigitTextFieldBox).at(8);
    final newMeterReading5 = find.byType(MeterReadingDigitTextFieldBox).at(9);

    /*await tester.ensureVisible(newMeterReading1);
    await tester.enterText(
        newMeterReading1, TestInputs.generateBill.NEW_METER_READING_BOX_1);
    await tester.pumpAndSettle(Duration(seconds: 1));
    await tester.enterText(
        newMeterReading2, TestInputs.generateBill.NEW_METER_READING_BOX_2);
    await tester.pumpAndSettle(Duration(seconds: 1));
    await tester.enterText(
        newMeterReading3, TestInputs.generateBill.NEW_METER_READING_BOX_3);
    await tester.pumpAndSettle(Duration(seconds: 1));
    await tester.enterText(
        newMeterReading4, TestInputs.generateBill.NEW_METER_READING_BOX_4);
    await tester.pumpAndSettle(Duration(seconds: 1));
    await tester.enterText(
        newMeterReading5, TestInputs.generateBill.NEW_METER_READING_BOX_5);
    await tester.pumpAndSettle(Duration(seconds: 1));*/

    final generateDemandBtn = find.byKey(Keys.bulkDemand.GENERATE_BILL_BTN);
    await tester.ensureVisible(generateDemandBtn);
    await tester.tap(generateDemandBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
  });
}