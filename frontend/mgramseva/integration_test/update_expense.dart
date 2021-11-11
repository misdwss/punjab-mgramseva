
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// TODO 5: Import the app that you want to test
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';


void main() {

  testWidgets("update expense app test", (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(milliseconds: 2000));
    final updateExpense = find.byType(GridTile).at(4);
    await tester.tap(updateExpense);
    await tester.pumpAndSettle(Duration(milliseconds: 3000));

    /// Searching by vendor name
    final vendorName = find.byKey(Keys.expense.SEARCH_VENDOR_NAME);
    final updateExpenditure = find.byKey(Keys.expense.UPDATE_EXPNEDITURE);

    await tester.enterText(vendorName, 'Singer');
    await tester.pumpAndSettle(Duration(milliseconds: 2000));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(Duration(seconds: 5));

    /// picking the first expense from the result
    await tester.ensureVisible(updateExpenditure);
    await tester.tap(updateExpenditure);
    await tester.pumpAndSettle(Duration(seconds: 5));

  });
}