// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenueGraph _$RevenueGraphFromJson(Map<String, dynamic> json) {
  return RevenueGraph()
    ..chartType = json['chartType'] as String?
    ..visualizationCode = json['visualizationCode'] as String?
    ..data = json['data'] == null
        ? null
        : RevenueGraphData.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RevenueGraphToJson(RevenueGraph instance) =>
    <String, dynamic>{
      'chartType': instance.chartType,
      'visualizationCode': instance.visualizationCode,
      'data': instance.data,
    };

RevenueGraphData _$RevenueGraphDataFromJson(Map<String, dynamic> json) {
  return RevenueGraphData()
    ..headerName = json['headerName'] as String?
    ..headerValue = json['headerValue'] as num?
    ..headerSymbol = json['headerSymbol'] as String?
    ..plots = json['plots'] == null
        ? null
        : RevenuePlot.fromJson(json['plots'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RevenueGraphDataToJson(RevenueGraphData instance) =>
    <String, dynamic>{
      'headerName': instance.headerName,
      'headerValue': instance.headerValue,
      'headerSymbol': instance.headerSymbol,
      'plots': instance.plots,
    };

RevenuePlot _$RevenuePlotFromJson(Map<String, dynamic> json) {
  return RevenuePlot()
    ..name = json['name'] as String?
    ..value = json['value'] as num?
    ..number = json['number'] as String?;
}

Map<String, dynamic> _$RevenuePlotToJson(RevenuePlot instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'number': instance.number,
    };
