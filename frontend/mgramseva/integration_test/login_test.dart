import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// TODO 5: Import the app that you want to test
import 'package:mgramseva/main.dart' as app;
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/widgets/LanguageCard.dart';
import 'search_Connection_test.dart' as search_Connection;
import 'create_consumer_test.dart' as create_consumer;
import 'update_Consumer_Test.dart' as update_consumer;


void main() {
  group('App Test', () {
    ///  Add the IntegrationTestWidgetsFlutterBinding and .ensureInitialized
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    /// Create your test case
    testWidgets("full app test", (tester) async {
      /// execute the app.main() function
      app.main();
      /// Wait until the app has settled
      await tester.pumpAndSettle(Duration(milliseconds: 1000));

      ///Language Selection Testing starts
      final selectLanguage = find.byType(LanguageCard).at(2);
      final selectLanButton = find.byKey(Keys.language.LANGUAGE_PAGE_CONTINUE_BTN);
      await tester.tap(selectLanguage);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.tap(selectLanButton);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      /// Login Testing starts
      final phoneNumber = find.byKey(Keys.login.LOGIN_PHONE_NUMBER_KEY);
      final password = find.byKey(Keys.login.LOGIN_PASSWORD_KEY);
      final login = find.byKey(Keys.login.LOGIN_BTN_KEY);
      await tester.enterText(phoneNumber, '9686151676');
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.ensureVisible(password);
      await tester.enterText(password, 'eGov@123');
      await tester.pumpAndSettle(Duration(milliseconds: 3000));
      await tester.ensureVisible(login);
      await tester.tap(login);
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

    });
    ///Search Connection Testing
    //search_Connection.main();

    ///Create Consumer Testing
    //create_consumer.main();

    ///Update Consumer Details Testing
    update_consumer.main();
  });
}