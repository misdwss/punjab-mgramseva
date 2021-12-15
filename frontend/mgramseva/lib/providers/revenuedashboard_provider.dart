import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/dashboard/revenue_graph.dart';
import 'package:mgramseva/repository/dashboard.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/dashboard/revenue_dashboard/revenue.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

import 'dashboard_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RevenueDashboard with ChangeNotifier {
  int selectedIndex = 0;
  var revenueStreamController = StreamController.broadcast();
  var revenueDataHolder = RevenueDataHolder();


  @override
  void dispose() {
    revenueStreamController.close();
    super.dispose();
  }

  void loadGraphicalDashboard(BuildContext context){
    loadRevenueDetails(context);
    loadRevenueGraphDetails();
  }


  Future<void> loadRevenueGraphDetails() async {
    revenueDataHolder.trendLineLoader = true;
    notifyListeners();
    try {
      var res = await DashBoardRepository().getGraphicalDashboard({});
      if (res != null) {
        revenueDataHolder.trendLineLoader = false;
        revenueDataHolder.trendLine = res;
        revenueDataHolder.trendLine?.graphData = trendGraphInfo(res);
      }
    }catch(e,s){
      revenueDataHolder.trendLineLoader = false;
    }
    notifyListeners();
  }

  Future<void> loadRevenueDetails(BuildContext context) async {
    try{
     var res = await DashBoardRepository().fetchRevenueDetails();
     var filteredList = <TableDataRow>[];
     if(res != null && res.isNotEmpty){
       filteredList = res.map((e) =>
       TableDataRow([
         TableData('${e.month ?? '-'}', callBack: onTapOfMonth),
         TableData('${e.surplus ?? '-'}'),
         TableData('${e.demand ?? '-'}(${e.arrears})'),
         TableData('${e.pendingCollections ?? '-'}'),
         TableData('${e.actualCollections ?? '-'}'),
         TableData('${e.expenditure ?? '-'}'),
         TableData('${e.pendingExpenditure ?? '-'}'),
         TableData('${e.actualPayment ?? '-'}'),
       ])
       ).toList();
     }
     revenueStreamController.add(filteredList);
    }catch(e,s){
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  void setSelectedTab(int index){
    selectedIndex = index;
    notifyListeners();
  }

  List<String> getTabs(BuildContext context) {
    return [
      i18.dashboard.STACKED_BAR,
      i18.dashboard.TREND_LINE
    ];
  }

  List<TableHeader> get revenueHeaderList => [
    TableHeader(i18.common.MONTH),
    TableHeader(i18.dashboard.SURPLUS_DEFICIT),
    TableHeader(i18.dashboard.DEMAND_ARREARS),
    TableHeader(i18.dashboard.PENIDNG_COLLECTIONS),
    TableHeader(i18.dashboard.ACTUAL_COLLECTIONS),
    TableHeader(i18.dashboard.EXPENDITURE),
    TableHeader(i18.dashboard.PENDING_EXPENDITURE),
    TableHeader(i18.dashboard.ACTUAL_PAYMENT),
  ];

  void onTapOfMonth(TableData tableData) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(navigatorKey.currentContext!, listen: false);

    var monthIndex = 0;
    var date = monthIndex >= 4 ? dashBoardProvider.selectedMonth.startDate : dashBoardProvider.selectedMonth.endDate;
    dashBoardProvider.onChangeOfDate(DatePeriod(DateTime(date.year, monthIndex, 1), DateTime(date.year, monthIndex + 1, 0), DateType.MONTH), navigatorKey.currentContext!);
    dashBoardProvider.scrollController.jumpTo(0.0);
  }


  List<charts.Series<RevenueGraphModel, int>>? trendGraphInfo(RevenueGraph revenueGraph) {
   Map filteredData = {};
   var list = <charts.Series<RevenueGraphModel, int>>[];
   revenueGraph.waterService?.buckets?.forEach((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
      e.propertyType?.bucket?.forEach((bucket)
      {
        filteredData[bucket.key] ??= {};
        filteredData[bucket.key][date.month] = bucket.docCount;

        if(revenueGraph.waterService?.trendMonthDate == null){
          revenueGraph.waterService?.trendMonthDate = date;
        }else{
          if(revenueGraph.waterService!.trendMonthDate!.isBefore(date)){

          }
        }
      });
    });

    filteredData.forEach((key, value) {
      var data = <RevenueGraphModel>[];
      var index = 0;
      value.forEach((key, value) {
        data.add(RevenueGraphModel(index, value));
        index++;
      });
        list.add(charts.Series<RevenueGraphModel, int>(
          id: key,
          // colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (RevenueGraphModel sales, _) => sales.year,
          measureFn: (RevenueGraphModel sales, _) => sales.trend,
          data: data,
        ));
   });
   return list;
  }
}