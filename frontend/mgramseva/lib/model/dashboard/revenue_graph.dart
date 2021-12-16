import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/screeens/dashboard/revenue_dashboard/revenue.dart';
import 'package:charts_flutter/flutter.dart' as charts;

part 'revenue_graph.g.dart';

@JsonSerializable()
class RevenueGraph {
  @JsonKey(name: "doc_count")
  int? docCount;

  @JsonKey(name: "WaterService")
  RevenueWaterService? waterService;

  @JsonKey(name: "Expense")
  RevenueWaterService? expense;

  @JsonKey(ignore: true)
  List<charts.Series<RevenueGraphModel, dynamic>>? graphData;

  RevenueGraph();

  factory RevenueGraph.fromJson(Map<String, dynamic> json) =>
      _$RevenueGraphFromJson(json);
}


@JsonSerializable()
class RevenueWaterService {
  @JsonKey(name: "buckets")
  List<Bucket>? buckets;

  RevenueWaterService();

  factory RevenueWaterService.fromJson(Map<String, dynamic> json) =>
      _$RevenueWaterServiceFromJson(json);
}

@JsonSerializable()
class Bucket {
  @JsonKey(name: "key")
  int? key;

  @JsonKey(name: "doc_count")
  int? docCount;

  @JsonKey(name: "Property Type")
  PropertyType? propertyType;

  @JsonKey(name: "ExpenseType")
  PropertyType? expenseType;

  Bucket();

  factory Bucket.fromJson(Map<String, dynamic> json) =>
      _$BucketFromJson(json);
}

@JsonSerializable()
class PropertyType {
  @JsonKey(name: "buckets")
  List<InternalBucket>? bucket;

  @JsonKey(name: "doc_count")
  int? docCount;

  PropertyType();

  factory PropertyType.fromJson(Map<String, dynamic> json) =>
      _$PropertyTypeFromJson(json);
}


@JsonSerializable()
class InternalBucket {
  @JsonKey(name: "key")
  String? key;

  @JsonKey(name: "doc_count")
  int? docCount;

  @JsonKey(name: "Count")
  Map? count;

  InternalBucket();

  factory InternalBucket.fromJson(Map<String, dynamic> json) =>
      _$InternalBucketFromJson(json);
}