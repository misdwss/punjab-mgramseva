import 'package:flutter/material.dart';


class Keys{
  static LanguagePageKeys language = const LanguagePageKeys();
  static ForgotPasswordKeys forgotPassword = const ForgotPasswordKeys();
  static LoginKeys login = const LoginKeys();
  static EditProfileKeys editProfile = const EditProfileKeys();
  static ChangePasswordKeys changePassword = const ChangePasswordKeys();
  static CreateConsumerKeys createConsumer = const CreateConsumerKeys();
  static SearchConncetionKeys searchConnection = const SearchConncetionKeys();
  static GenerateBulkDemandKeys bulkDemand = const GenerateBulkDemandKeys();
  static GenerateBillMeteredKeys generateBill = const GenerateBillMeteredKeys();
}

class LanguagePageKeys{
  const LanguagePageKeys();
  Key get LANGUAGE_PAGE_CONTINUE_BTN => Key("language selected continue button");
}

class ForgotPasswordKeys{
  const ForgotPasswordKeys();
  Key get FORGOT_PASSWORD_BUTTON => Key("forgot Password Button");
  Key get FORGOT_PASSWORD_MOBILE_NO => Key("forgot Password Mobile");
  Key get FORGOT_PASSWORD_CONTINUE_BTN => Key("forgot Password Continue button");
}

class LoginKeys {
  const LoginKeys();
  Key get LOGIN_PHONE_NUMBER_KEY => Key("PhoneNum");
  Key get LOGIN_PASSWORD_KEY => Key("Login Password");
  Key get LOGIN_BTN_KEY => Key("Login");
}

class EditProfileKeys {
  const EditProfileKeys();
  Key get SIDE_BAR_EDIT_PROFILE_TILE_KEY => Key("Edit Profile Side Bar");
  Key get EDIT_PROFILE_NAME_KEY => Key("Edit Profile Name");
  Key get EDIT_PROFILE_E_MAIL_KEY => Key("Edit Profile e-mail");
  Key get EDIT_PROFILE_SAVE_BTN_KEY => Key("Edit Profile Save");
}

class ChangePasswordKeys {
  const ChangePasswordKeys();
  Key get SIDE_BAR_CHANGE_PASSWORD_TILE_KEY => Key("Change Password Side Bar");
  Key get CURRENT_PASSWORD_KEY => Key("Current Password Key");
  Key get NEW_PASSWORD_KEY => Key("New Password Key");
  Key get CONFIRM_PASSWORD_KEY => Key("Confirm Password Key");
  Key get CHANGE_PASSWORD_BTN_KEY => Key("Change Password Button Key");
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
  Key get CONSUMER_LAST_BILLED_CYCLE => Key("consumerLastBilledCycle");
  Key get CONSUMER_PREVIOUS_READING_DATE_KEY => Key("consumerPreviousReadingDatePicker");
  Key get CONSUMER_METER_NUMBER_KEY => Key("consumerMeterNumber");
  Key get CONSUMER_ARREARS_KEY => Key("consumerArrears");
  Key get CREATE_CONSUMER_BTN_KEY => Key("createConsumerBtn");
}

class SearchConncetionKeys {
  const SearchConncetionKeys();
  Key get SEARCH_PHONE_NUMBER_KEY => Key("phoneSearch");
  Key get SEARCH_NAME_KEY => Key("nameSearch");
  Key get SEARCH_OLD_ID_KEY => Key("old Connection  Search");
  Key get SEARCH_NEW_ID_KEY => Key("new Connection Search");
  Key get SHOW_MORE_BTN => Key("Show more");
  Key get SEARCH_BTN_KEY => Key("Search Connection Btn");
}

class GenerateBulkDemandKeys{
  const GenerateBulkDemandKeys();
  Key get BULK_DEMAND_BILLING_YEAR => Key('Bulk Demand billingYear');
  Key get BULK_DEMAND_BILLING_CYCLE => Key('Bulk Demand billingCycle');
  Key get GENERATE_BILL_BTN => Key('Generate Bill button');
}

class GenerateBillMeteredKeys{
  const GenerateBillMeteredKeys();
}