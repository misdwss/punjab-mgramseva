
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// TODO 5: Import the app that you want to test
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';


void main() {

  testWidgets("update expense app test", (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(milliseconds: 2000));
    final updateExpense = find.byType(GridTile).at(4);
    await tester.tap(updateExpense);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));


    final vendorName = find.byKey(Keys.expense.SEARCH_VENDOR_NAME);
    final updateExpenditure = find.widgetWithText(ShortButton, ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.UPDATE_EXPENDITURE)).first;
    final checkBox = find.byType(Checkbox);
    final submitButton = find.widgetWithText(BottomButtonBar, ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.common.SUBMIT));
    final expenseType = find.byKey(Keys.expense.SEARCH_EXPENSE_TYPE);
    final selectExpenseType = find.widgetWithText(ListTile, ApplicationLocalizations.of(navigatorKey.currentContext!).translate('ELECTRICITY_BILL'));

    /// selecting expense type
    await tester.ensureVisible(expenseType);
    await tester.tap(expenseType);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));
    await tester.tap(selectExpenseType);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    // await tester.enterText(vendorName, 'Raja');
    // await tester.pumpAndSettle(Duration(milliseconds: 2000));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(Duration(seconds: 5));

    /// picking the first expense from the result
    await tester.ensureVisible(updateExpenditure);
    await tester.pumpAndSettle(Duration(milliseconds: 2000));
    await tester.tap(updateExpenditure);
    await tester.pumpAndSettle(Duration(seconds: 5));

    await tester.ensureVisible(checkBox);
    await tester.pumpAndSettle(Duration(milliseconds: 2000));
    await tester.tap(checkBox);
    await tester.pumpAndSettle(Duration(seconds: 3));

    await tester.ensureVisible(submitButton);
    await tester.pumpAndSettle(Duration(milliseconds: 2000));
    await tester.tap(submitButton);
    await tester.pumpAndSettle(Duration(seconds: 8));

    final backHome = find.widgetWithText(BottomButtonBar, ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.common.BACK_HOME));
    await tester.tap(backHome);
    await tester.pumpAndSettle(Duration(seconds: 5));
  });
}