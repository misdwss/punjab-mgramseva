

import 'package:mgramseva/model/dashboard/revenue_dashboard.dart';
import 'package:mgramseva/model/dashboard/revenue_graph.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RevenueDataHolder {

  List<charts.Series<RevenueGraphModel, int>>? stackedBar;
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
  final int year;
  final int trend;
  RevenueGraphModel(this.year, this.trend);
}