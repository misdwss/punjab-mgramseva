class TestInputs{
  static LoginInputs login = const LoginInputs();
  static SearchConnectionInputs searchConnection = const SearchConnectionInputs();
  static CreateConsumerInputs createConsumer = const CreateConsumerInputs();
  static Expense expense = const Expense();
}

class LoginInputs{
  const LoginInputs();
  String get LOGIN_MOBILE_NUMBER => '9686151676';
  String get LOGIN_PASSWORD => 'eGov@123';
}

class SearchConnectionInputs {
  const SearchConnectionInputs();

  String get SEARCH_MOBILE_NUMBER => '8145632987';
  String get SEARCH_NAME => 'Na';
}

class CreateConsumerInputs{
  const CreateConsumerInputs();
  String get CONSUMER_NAME => 'Ramesh';
  String get CONSUMER_SPOUSE_PARENT => 'Rajesh';
  String get CONSUMER_PHONE_NUMBER => '9859856321';
  String get CONSUMER_OLD_ID => 'WS-986-456';
  String get CONSUMER_PREVIOUS_READING_DATE => '01/10/2021';
  String get CONSUMER_METER_NUMBER => 'ID745LO';
  String get CONSUMER_ARREARS => '100';
}

class Expense {
  const Expense();
  String get VENDOR_NAME => 'hara';
  String get VENDOR_NUMBER => 'Ramesh';
  String get VENDOR_AMOUNT => 'Ramesh';
}