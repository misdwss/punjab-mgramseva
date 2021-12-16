

import 'package:mgramseva/model/dashboard/revenue_dashboard.dart';
import 'package:mgramseva/model/dashboard/revenue_graph.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RevenueDataHolder {

  RevenueGraph? stackedBar;
  RevenueGraph? trendLine;
  List<Revenue>? revenueTable;
  var stackLoader = false;
  var trendLineLoader = false;
  var tableLoader = false;

  resetData(){
    stackedBar = null;
    trendLine = null;
    revenueTable = null;
  }
}

class RevenueGraphModel {
  final int month;
  final int trend;
  final String year;
  RevenueGraphModel({this.month = 1, required this.trend, this.year = ''});
}