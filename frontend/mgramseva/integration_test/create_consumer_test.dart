import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/screeens/GenerateBill/widgets/MeterReading.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/global_variables.dart';

import 'Test Inputs/test_inputs.dart';


void main() {

  testWidgets("create Consumer Test", (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    final createConsumer = find.widgetWithText(GridTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate('CORE_CONSUMER_CREATE'));
    await tester.tap(createConsumer);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    final consumerName = find.byKey(Keys.createConsumer.CONSUMER_NAME_KEY);
    final selectGender = find.widgetWithText(RadioListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(TestInputs.createConsumer.CONSUMER_GENDER));
    final consumerSpouseParent = find.byKey(Keys.createConsumer.CONSUMER_SPOUSE_PARENT_KEY);
    final consumerPhone = find.byKey(Keys.createConsumer.CONSUMER_PHONE_NUMBER_KEY);
    final consumerOldID = find.byKey(Keys.createConsumer.CONSUMER_OLD_ID_KEY);


    final findConsumerCategory = find.byKey(Keys.createConsumer.CONSUMER_CATEORY_KEY);
    final selectConsumerCategory = find.widgetWithText(ListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(TestInputs.createConsumer.CONSUMER_CATEGORY));

    final findConsumerSubCategory = find.byKey(Keys.createConsumer.CONSUMER_SUB_CATEORY_KEY);
    final selectConsumerSubCategory = find.widgetWithText(ListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(TestInputs.createConsumer.CONSUMER_SUB_CATEGORY));

    final findPropertyType = find.byKey(Keys.createConsumer.CONSUMER_PROPERTY_KEY);
    final selectPropertyType = find.widgetWithText(ListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(TestInputs.createConsumer.CONSUMER_PROPERTY));

    final findServiceType = find.byKey(Keys.createConsumer.CONSUMER_SERVICE_KEY);
    final selectServiceType = find.widgetWithText(ListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(TestInputs.createConsumer.CONSUMER_SERVICE));

    final findLastBilledCycle = find.byKey(Keys.createConsumer.CONSUMER_LAST_BILLED_CYCLE);
    final selectLastBilledCycle = find.widgetWithText(ListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!)
            .translate(TestInputs.createConsumer.LAST_BILLED_CYCLE_MONTH) +
            " - " +
            TestInputs.createConsumer.LAST_BILLED_CYCLE_YEAR);

    final findDatePicker = find.byKey(Keys.createConsumer.CONSUMER_PREVIOUS_READING_DATE_KEY);
    final findEditDateIcon = find.byIcon(Icons.edit);
    final findDateTextField = find.widgetWithText(TextField, DateFormats.getFilteredDate(
        DateTime.now().toLocal().toString(),
        dateFormat: "dd/MM/yyyy") );
    final findOKButtonInDate = find.text(ApplicationLocalizations.of(navigatorKey.currentContext!).
    translate(TestInputs.createConsumer.DATEPICKER_OK_BUTTON));

    final consumerMeterNumber = find.byKey(Keys.createConsumer.CONSUMER_METER_NUMBER_KEY);

    final meterReading1 = find.byType(MeterReadingDigitTextFieldBox).at(0);
    final meterReading2 = find.byType(MeterReadingDigitTextFieldBox).at(1);
    final meterReading3 = find.byType(MeterReadingDigitTextFieldBox).at(2);
    final meterReading4 = find.byType(MeterReadingDigitTextFieldBox).at(3);
    final meterReading5 = find.byType(MeterReadingDigitTextFieldBox).at(4);

    final consumerArrears = find.byKey(Keys.createConsumer.CONSUMER_ARREARS_KEY);

    final createConsumerBtn = find.byKey(Keys.createConsumer.CREATE_CONSUMER_BTN_KEY);

    await tester.enterText(consumerName, TestInputs.createConsumer.CONSUMER_NAME);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.tap(selectGender);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(consumerSpouseParent);
    await tester.enterText(consumerSpouseParent, TestInputs.createConsumer.CONSUMER_SPOUSE_PARENT);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(consumerPhone);
    await tester.enterText(consumerPhone, TestInputs.createConsumer.CONSUMER_PHONE_NUMBER);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(consumerOldID);
    await tester.enterText(consumerOldID, TestInputs.createConsumer.CONSUMER_OLD_ID);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(findConsumerCategory);
    await tester.tap(findConsumerCategory);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(selectConsumerCategory);
    await tester.tap(selectConsumerCategory);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(findConsumerSubCategory);
    await tester.tap(findConsumerSubCategory);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(selectConsumerSubCategory);
    await tester.tap(selectConsumerSubCategory);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(findPropertyType);
    await tester.tap(findPropertyType);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(selectPropertyType);
    await tester.tap(selectPropertyType);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(findServiceType);
    await tester.tap(findServiceType);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(selectServiceType);
    await tester.tap(selectServiceType);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    if(TestInputs.createConsumer.CONSUMER_SERVICE == 'Metered'){
      await tester.ensureVisible(findDatePicker);
      await tester.tap(findDatePicker);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(findEditDateIcon);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.enterText(findDateTextField,
          TestInputs.createConsumer.CONSUMER_PREVIOUS_READING_DATE);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(findOKButtonInDate);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      await tester.ensureVisible(consumerMeterNumber);
      await tester.enterText(
          consumerMeterNumber, TestInputs.createConsumer.CONSUMER_METER_NUMBER);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      await tester.ensureVisible(meterReading1);
      await tester.enterText(
          meterReading1, TestInputs.createConsumer.METER_READING_BOX_1);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(
          meterReading2, TestInputs.createConsumer.METER_READING_BOX_2);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(
          meterReading3, TestInputs.createConsumer.METER_READING_BOX_3);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(
          meterReading4, TestInputs.createConsumer.METER_READING_BOX_4);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.enterText(
          meterReading5, TestInputs.createConsumer.METER_READING_BOX_5);
      await tester.pumpAndSettle(Duration(seconds: 1));
    }
    else{
      await tester.ensureVisible(findLastBilledCycle);
      await tester.enterText(findLastBilledCycle, TestInputs.createConsumer.LAST_BILLED_CYCLE_MONTH);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(selectLastBilledCycle);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
    }

    await tester.enterText(consumerArrears, TestInputs.createConsumer.CONSUMER_ARREARS);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.tap(createConsumerBtn);
    await tester.pumpAndSettle(Duration(seconds: 3));

    await tester.ensureVisible(find.byIcon(Icons.arrow_left));
    await tester.pumpAndSettle(Duration(seconds: 3));
    await tester.tap(find.byIcon(Icons.arrow_left));
    await tester.pumpAndSettle(Duration(seconds: 3));
  });
}