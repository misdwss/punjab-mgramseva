// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_graph.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenueGraph _$RevenueGraphFromJson(Map<String, dynamic> json) {
  return RevenueGraph()
    ..docCount = json['doc_count'] as int?
    ..waterService = json['WaterService'] == null
        ? null
        : RevenueWaterService.fromJson(
            json['WaterService'] as Map<String, dynamic>)
    ..expense = json['Expense'] == null
        ? null
        : RevenueWaterService.fromJson(json['Expense'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RevenueGraphToJson(RevenueGraph instance) =>
    <String, dynamic>{
      'doc_count': instance.docCount,
      'WaterService': instance.waterService,
      'Expense': instance.expense,
    };

RevenueWaterService _$RevenueWaterServiceFromJson(Map<String, dynamic> json) {
  return RevenueWaterService()
    ..buckets = (json['buckets'] as List<dynamic>?)
        ?.map((e) => Bucket.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$RevenueWaterServiceToJson(
        RevenueWaterService instance) =>
    <String, dynamic>{
      'buckets': instance.buckets,
    };

Bucket _$BucketFromJson(Map<String, dynamic> json) {
  return Bucket()
    ..key = json['key'] as int?
    ..docCount = json['doc_count'] as int?
    ..propertyType = json['Property Type'] == null
        ? null
        : PropertyType.fromJson(json['Property Type'] as Map<String, dynamic>)
    ..expenseType = json['ExpenseType'] == null
        ? null
        : PropertyType.fromJson(json['ExpenseType'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BucketToJson(Bucket instance) => <String, dynamic>{
      'key': instance.key,
      'doc_count': instance.docCount,
      'Property Type': instance.propertyType,
      'ExpenseType': instance.expenseType,
    };

PropertyType _$PropertyTypeFromJson(Map<String, dynamic> json) {
  return PropertyType()
    ..bucket = (json['buckets'] as List<dynamic>?)
        ?.map((e) => InternalBucket.fromJson(e as Map<String, dynamic>))
        .toList()
    ..docCount = json['doc_count'] as int?;
}

Map<String, dynamic> _$PropertyTypeToJson(PropertyType instance) =>
    <String, dynamic>{
      'buckets': instance.bucket,
      'doc_count': instance.docCount,
    };

InternalBucket _$InternalBucketFromJson(Map<String, dynamic> json) {
  return InternalBucket()
    ..key = json['key'] as String?
    ..docCount = json['doc_count'] as int?
    ..count = json['Count'] as Map<String, dynamic>?;
}

Map<String, dynamic> _$InternalBucketToJson(InternalBucket instance) =>
    <String, dynamic>{
      'key': instance.key,
      'doc_count': instance.docCount,
      'Count': instance.count,
    };
