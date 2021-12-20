import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/screeens/dashboard/revenue_dashboard/revenue.dart';
import 'package:charts_flutter/flutter.dart' as charts;

part 'revenue_chart.g.dart';

@JsonSerializable()
class RevenueGraph {
  @JsonKey(name: "chartType")
  String? chartType;

  @JsonKey(name: "visualizationCode")
  String? visualizationCode;

  @JsonKey(name: "data")
  RevenueGraphData? data;


  RevenueGraph();

  factory RevenueGraph.fromJson(Map<String, dynamic> json) =>
      _$RevenueGraphFromJson(json);
}


@JsonSerializable()
class RevenueGraphData {
  @JsonKey(name: "headerName")
  String? headerName;

  @JsonKey(name: "headerValue")
  num? headerValue;

  @JsonKey(name: "headerSymbol")
  String? headerSymbol;

  @JsonKey(name: "plots")
  RevenuePlot? plots;

  RevenueGraphData();

  factory RevenueGraphData.fromJson(Map<String, dynamic> json) =>
      _$RevenueGraphDataFromJson(json);
}


@JsonSerializable()
class RevenuePlot {
  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "value")
  num? value;

  @JsonKey(name: "number")
  String? number;

  RevenuePlot();

  factory RevenuePlot.fromJson(Map<String, dynamic> json) =>
      _$RevenuePlotFromJson(json);
}