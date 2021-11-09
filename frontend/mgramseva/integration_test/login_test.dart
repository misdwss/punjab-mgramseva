import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// TODO 5: Import the app that you want to test
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/widgets/LanguageCard.dart';


void main() {
  group('App Test', () {
    // TODO 3: Add the IntegrationTestWidgetsFlutterBinding and .ensureInitialized
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    // TODO 4: Create your test case
    testWidgets("full app test", (tester) async {
      // TODO 6: execute the app.main() function
      app.main();
      // TODO 7: Wait until the app has settled
      await tester.pumpAndSettle(Duration(milliseconds: 1000));

      ///Language Selection Testing starts
      final selectLanguage = find.byType(LanguageCard).last;
      final selectLanButton = find.byKey(Key("language selected"));
      await tester.tap(selectLanguage);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(selectLanButton);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      /// Login Testing starts
      final phoneNumber = find.byKey(Key("PhoneNum"));
      final password = find.byKey(Key("Login Password"));
      final login = find.byKey(Key("Login"));
      await tester.enterText(phoneNumber, '9686151676');
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.enterText(password, 'eGov@123');
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.ensureVisible(login);
      await tester.tap(login);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      /*final clickSideBar = find.byKey(Key("SideBar"));
      final editProfile = find.byKey(Key("Edit Profile"));
      await tester.tap(clickSideBar);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(editProfile);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));*/
      /// Open Collect Payment Screen
      final collectPayment = find.byType(GridTile).at(1);
      await tester.tap(collectPayment);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      /// Search by Name
      final nameSearch = find.byKey(Key("nameSearch"));
      final phoneSearch = find.byKey(Key("phoneSearch"));
      final searchConnectionBtn = find.byKey(Key("Search Connection"));
      await tester.enterText(nameSearch, 'Na');
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.ensureVisible(searchConnectionBtn);
      await tester.tap(searchConnectionBtn);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

    });
  });
}