
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// TODO 5: Import the app that you want to test
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/global_variables.dart';


void main() {

    testWidgets("add expense app test", (tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      final addExpense = find.byType(GridTile).at(3);
      await tester.tap(addExpense);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      final phoneNumber = find.byKey(Keys.expense.VENDOR_MOBILE_NUMBER);
      final vendorName = find.byKey(Keys.expense.VENDOR_NAME);
      final expenseAmount = find.byKey(Keys.expense.EXPENSE_AMOUNT);
      final expenseBillDate = find.byKey(Keys.expense.EXPENSE_BILL_DATE);
      final addExpenseBtn = find.byKey(Keys.expense.EXPENSE_SUBMIT);
      final backBtn = find.byKey(Keys.expense.BACK_BTN);
      final expenseType = find.byKey(Keys.expense.EXPENSE_TYPE);
      final selectExpenseType = find.widgetWithText(ListTile, ApplicationLocalizations.of(navigatorKey.currentContext!).translate('ELECTRICITY_BILL'));

      /// selecting expense type
      await tester.ensureVisible(expenseType);
      await tester.tap(expenseType);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(selectExpenseType);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      await tester.enterText(vendorName, 'player');
      await tester.enterText(expenseAmount, '123');
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      await tester.enterText(phoneNumber, '7893104355');
      await tester.pumpAndSettle(Duration(milliseconds: 2000));

      final findDatePicker = find.byKey(Keys.expense.EXPENSE_BILL_DATE);
      final findEditDateIcon = find.byIcon(Icons.edit);
      final findDateTextField = find.widgetWithText(TextField, DateFormats.getFilteredDate(
          DateTime.now().toLocal().toString(),
          dateFormat: "dd/MM/yyyy") );
      final findOKButtonInDate = find.text('OK');
      await tester.ensureVisible(findDatePicker);
      await tester.tap(findDatePicker);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(findEditDateIcon);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.enterText(findDateTextField, '01/10/2021');
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(findOKButtonInDate);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      await tester.ensureVisible(addExpenseBtn);
      await tester.tap(addExpenseBtn);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      // await tester.ensureVisible(backBtn);
      // await tester.tap(backBtn);

    });
}