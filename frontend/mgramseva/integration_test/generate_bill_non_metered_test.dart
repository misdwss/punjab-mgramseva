import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'Test Inputs/test_inputs.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';



void main() {
  testWidgets("Generate Demand Non-Metered", (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    final generateBulkDemand = find.widgetWithText(GridTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate('CORE_GENERATE_DEMAND'));
    await tester.tap(generateBulkDemand);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    final findBillingYearField = find.byKey(Keys.bulkDemand.BULK_DEMAND_BILLING_YEAR);
    final selectBillingYear = find.widgetWithText(ListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!).translate(TestInputs.bulkDemand.BILLING_YEAR));

    final findBillingCycleField = find.byKey(Keys.bulkDemand.BULK_DEMAND_BILLING_CYCLE);
    final selectBillingCycle = find.widgetWithText(ListTile,
        ApplicationLocalizations.of(navigatorKey.currentContext!)
            .translate(TestInputs.bulkDemand.BILLING_CYCLE) +
            " - " +
            TestInputs.bulkDemand.BILLING_YEAR.substring(0,4));
    final generateDemandBtn = find.byKey(Keys.bulkDemand.GENERATE_BILL_BTN);
    final backHome = find.widgetWithText(BottomButtonBar, ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.common.BACK_HOME));

    await tester.ensureVisible(findBillingYearField);
    await tester.tap(findBillingYearField);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(selectBillingYear);
    await tester.tap(selectBillingYear);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(findBillingCycleField);
    await tester.enterText(findBillingCycleField, TestInputs.bulkDemand.BILLING_CYCLE);    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.ensureVisible(selectBillingCycle);
    await tester.tap(selectBillingCycle);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.ensureVisible(generateDemandBtn);
    await tester.tap(generateDemandBtn);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    await tester.tap(backHome);
    await tester.pumpAndSettle(Duration(seconds: 5));

  });
}