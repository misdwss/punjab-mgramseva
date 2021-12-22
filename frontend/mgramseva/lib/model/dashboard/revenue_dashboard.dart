import 'package:json_annotation/json_annotation.dart';

part 'revenue_dashboard.g.dart';

@JsonSerializable()
class Revenue {
  @JsonKey(name: "month")
  int? month;

  @JsonKey(name: "demand")
  String? demand;

  @JsonKey(name: "pendingCollection")
  String? pendingCollection;

  @JsonKey(name: "arrears")
  String? arrears;

  @JsonKey(name: "actualCollection")
  String? actualCollection;

  Revenue();

  factory Revenue.fromJson(Map<String, dynamic> json) =>
      _$RevenueFromJson(json);
}

@JsonSerializable()
class Expense {
  @JsonKey(name: "month")
  int? month;

  @JsonKey(name: "totalExpenditure")
  String? totalExpenditure;

  @JsonKey(name: "amountUnpaid")
  String? amountUnpaid;

  @JsonKey(name: "amountPaid")
  String?  amountPaid;

  Expense();

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
