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

  @JsonKey(ignore: true)
  List<charts.Series<RevenueGraphModel, int>>? graphData;

  RevenueGraph();

  factory RevenueGraph.fromJson(Map<String, dynamic> json) =>
      _$RevenueGraphFromJson(json);
}


@JsonSerializable()
class RevenueWaterService {
  @JsonKey(name: "buckets")
  List<Bucket>? buckets;

  @JsonKey(ignore: true)
  DateTime? trendMonthDate;

  @JsonKey(ignore: true)
  int? trendMonthCount = 1;

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

  InternalBucket();

  factory InternalBucket.fromJson(Map<String, dynamic> json) =>
      _$InternalBucketFromJson(json);
}