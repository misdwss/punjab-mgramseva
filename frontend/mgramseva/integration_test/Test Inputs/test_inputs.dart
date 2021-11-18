import 'package:mgramseva/utils/constants.dart';

class TestInputs{
  static LoginInputs login = const LoginInputs();
  static ForgotPasswordInputs forgotPassword = const ForgotPasswordInputs();
  static EditProfileInputs editProfile = const EditProfileInputs();
  static ChangePasswordInputs changePassword = const ChangePasswordInputs();
  static SearchConnectionInputs searchConnection = const SearchConnectionInputs();
  static CreateConsumerInputs createConsumer = const CreateConsumerInputs();
  static UpdateConsumerInputs updateConsumer = const UpdateConsumerInputs();
  static GenerateBulkDemandInputs bulkDemand = const GenerateBulkDemandInputs();
  static GenerateBillMeteredInputs generateBill = const GenerateBillMeteredInputs();
}

class LoginInputs{
  const LoginInputs();
  String get LOGIN_MOBILE_NUMBER => '9686151676';
  String get LOGIN_PASSWORD => 'eGov@123';
}

class ForgotPasswordInputs{
  const ForgotPasswordInputs();
  String get FORGOT_PASSWORD_MOBILE_NUMBER => '9777522448';
}

class EditProfileInputs{
  const EditProfileInputs();
  String get EDIT_PROFILE_NAME => 'Naveen J';
  String get EDIT_PROFILE_GENDER => 'CORE_COMMON_GENDER_MALE';
  String get EDIT_PROFILE_EMAIL => 'naveen@egovernment.org';
}

class ChangePasswordInputs{
  const ChangePasswordInputs();
  String get CURRENT_PASSWORD => 'eGov@123';
  String get NEW_PASSWORD => 'eGov@123';
  String get CONFIRM_NEW_PASSWORD => 'eGov@123';
}

class SearchConnectionInputs {
  const SearchConnectionInputs();

  String get SEARCH_MOBILE_NUMBER => '8145632987';
  String get SEARCH_NAME => 'Na';
  String get SEARCH_OLD_CONNECTION_ID => 'WS-763-88463';
  String get SEARCH_NEW_CONNECTION_ID => 'WS/400/2021-22/0018';
}

class CreateConsumerInputs{
  const CreateConsumerInputs();
  String get CONSUMER_NAME => 'Ramesh';
  String get CONSUMER_GENDER => 'CORE_COMMON_GENDER_MALE'; // [CORE_COMMON_GENDER_MALE, CORE_COMMON_GENDER_FEMALE, CORE_COMMON_GENDER_TRANSGENDER]
  String get CONSUMER_SPOUSE_PARENT => 'Rajesh';
  String get CONSUMER_PHONE_NUMBER => '9859856321';
  String get CONSUMER_CATEGORY => 'APL'; // [APL, BPL]
  String get CONSUMER_SUB_CATEGORY => 'SC'; // [SC, ST, GENERAL]
  String get CONSUMER_PROPERTY => 'RESIDENTIAL'; // [RESIDENTIAL, COMMERCIAL]
  String get CONSUMER_SERVICE => 'Metered'; // [Metered, Non_Metered]
  String get CONSUMER_OLD_ID => 'WS-986-456';
  String get CONSUMER_PREVIOUS_READING_DATE => '01/10/2021';
  String get CONSUMER_METER_NUMBER => 'ID745LO';
  String get CONSUMER_ARREARS => '100';
  String get DATEPICKER_OK_BUTTON => 'OK';
  String get METER_READING_BOX_1 => '1';
  String get METER_READING_BOX_2 => '2';
  String get METER_READING_BOX_3 => '1';
  String get METER_READING_BOX_4 => '0';
  String get METER_READING_BOX_5 => '1';
  String get LAST_BILLED_CYCLE_YEAR => '2021';
  String get LAST_BILLED_CYCLE_MONTH => Constants.MONTHS[10 - 1];
  //If selected Month is October, then Constants.MONTHS[10 - 1]
}

class UpdateConsumerInputs {
  const UpdateConsumerInputs();

  String get SEARCH_MOBILE_NUMBER => '8145632987';

  String get CONSUMER_PROPERTY => 'COMMERCIAL'; // [RESIDENTIAL, COMMERCIAL]
  String get MARK_CONNECTION_INACTIVE => 'No'; // Make Connection inactive by passing 'Yes'
}

class GenerateBulkDemandInputs{
  const GenerateBulkDemandInputs();

  String get BILLING_YEAR => '2021-22';
  String get BILLING_CYCLE => Constants.MONTHS[10 - 1];
// If selected Month is October, then Constants.MONTHS[10 - 1]
// If selected Month is November, then Constants.MONTHS[11 - 1]
}

class GenerateBillMeteredInputs{
  const GenerateBillMeteredInputs();

  String get SEARCH_MOBILE_NUMBER => '9513848423';
  String get NEW_METER_READING_BOX_1 => '1';
  String get NEW_METER_READING_BOX_2 => '0';
  String get NEW_METER_READING_BOX_3 => '0';
  String get NEW_METER_READING_BOX_4 => '0';
  String get NEW_METER_READING_BOX_5 => '6';
}