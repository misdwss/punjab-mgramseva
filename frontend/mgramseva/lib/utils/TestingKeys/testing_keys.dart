import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
class Keys{
  static LanguagePageKeys language = const LanguagePageKeys();
  static LoginKeys login = const LoginKeys();
  static CreateConsumerKeys createConsumer = const CreateConsumerKeys();
  static ExpenseKeys expense = const ExpenseKeys();
}
class LanguagePageKeys{
  const LanguagePageKeys();
  Key get LANGUAGE_PAGE_CONTINUE_BTN => Key("language selected continue button");
}
class LoginKeys {
  const LoginKeys();
  Key get LOGIN_PHONE_NUMBER_KEY => Key("PhoneNum");
  Key get LOGIN_PASSWORD_KEY => Key("Login Password");
  Key get LOGIN_BTN_KEY => Key("Login");
}
class CreateConsumerKeys{
  const CreateConsumerKeys();
  Key get CONSUMER_NAME_KEY => Key("consumerName");
  Key get CONSUMER_SPOUSE_PARENT_KEY => Key("spouse parentName");
  Key get CONSUMER_PHONE_NUMBER_KEY => Key("consumerPhone");
  Key get CONSUMER_OLD_ID_KEY => Key("consumerOldID");
  Key get CONSUMER_CATEORY_KEY => Key("consumerCategory");
  Key get CONSUMER_SUB_CATEORY_KEY => Key("consumerSubCategory");
  Key get CONSUMER_PROPERTY_KEY => Key("consumerProperty");
  Key get CONSUMER_SERVICE_KEY => Key("consumerService");
  Key get CONSUMER_PREVIOUS_READING_DATE_KEY => Key("consumerPreviousReadingDatePicker");
}

class ExpenseKeys {
  const ExpenseKeys();
  Key get VENDOR_NAME => Key("expense_vendor_name");
  Key get VENDOR_MOBILE_NUMBER => Key("expense_mobile_number");
  Key get EXPENSE_TYPE => Key("expense_type");
  Key get EXPENSE_AMOUNT => Key("expense_amount");
  Key get EXPENSE_BILL_DATE => Key("expense_bill_date");
  Key get EXPENSE_SUBMIT => Key("expense_submit");
  Key get BACK_BTN => Key("back_home");

  Key get SEARCH_VENDOR_NAME => Key("search_vendor_name");
  Key get SEARCH_EXPENSES => Key("search_expenses_btn");
  Key get UPDATE_EXPNEDITURE => Key("update_expenditure");

}