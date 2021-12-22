import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/dashboard/revenue_chart.dart';
import 'package:mgramseva/providers/common_provider.dart';
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
  int selectedIndex = 1;
  var revenueStreamController = StreamController.broadcast();
  var revenueDataHolder = RevenueDataHolder();


  @override
  void dispose() {
    revenueStreamController.close();
    super.dispose();
  }

  void loadGraphicalDashboard(BuildContext context) {
    loadRevenueTableDetails(context);
    loadRevenueTrendGraphDetails(context);
    /// Stacked Graph not implemented due to Backend API response finalization is pending
   // loadRevenueStackedGraphDetails(context);
  }

  Map requestQuery([bool isLineChart = false]){
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var dashBoardProvider = Provider.of<DashBoardProvider>(
        navigatorKey.currentContext!, listen: false);

      return {
        "aggregationRequestDto": {
          "visualizationType": "METRIC",
          "visualizationCode": isLineChart ? "revenueAndExpenditureTrendTwo" : "revenueAndExpenditureTrendOne",
          "queryType": "",
          "filters": {
            "tenantId": []
          },
          "moduleLevel": "",
          "aggregationFactors": null,
          "requestDate": {
            "startDate": dashBoardProvider.selectedMonth.startDate.millisecondsSinceEpoch,
            "endDate": dashBoardProvider.selectedMonth.endDate.millisecondsSinceEpoch,
            "interval": "month",
            "title": ""
          }
        },
        "headers": {
          "tenantId": commonProvider.userDetails?.selectedtenant?.code
        },
        "RequestInfo": {
          "apiId": "Rainmaker",
          "authToken": commonProvider.userDetails?.accessToken,
        }
      };
  }


  Future<void> loadRevenueTrendGraphDetails(BuildContext context) async {
    var dashBoardProvider = Provider.of<DashBoardProvider>(
        navigatorKey.currentContext!, listen: false);
    revenueDataHolder.trendLineLoader = true;
    notifyListeners();
    try {
      var res = await DashBoardRepository().getGraphicalDashboard(requestQuery(true));
      if (res != null) {
        revenueDataHolder.trendLine = res;
        revenueDataHolder.trendLine?.graphData = trendGraphDataBinding(res);
      }
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
    revenueDataHolder.trendLineLoader = false;
    notifyListeners();
  }
  /// Stacked Graph not implemented due to Backend API response finalization is pending
  // Future<void> loadRevenueStackedGraphDetails(BuildContext context) async {
  //   revenueDataHolder.stackLoader = true;
  //   revenueDataHolder.resetData();
  //   notifyListeners();
  //   try {
  //     var res = await DashBoardRepository().getGraphicalDashboard(requestQuery());
  //     if (res != null) {
  //       revenueDataHolder.stackedBar = res;
  //       revenueDataHolder.stackedBar?.graphData = stackedGraphDataBinding(res);
  //     }
  //   } catch (e, s) {
  //     ErrorHandler().allExceptionsHandler(context, e, s);
  //   }
  //   revenueDataHolder.stackLoader = false;
  //   notifyListeners();
  // }

  Future<void> loadRevenueTableDetails(BuildContext context) async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var dashBoardProvider = Provider.of<DashBoardProvider>(
          navigatorKey.currentContext!, listen: false);
      var query = {
        "tenantId" : commonProvider.userDetails?.selectedtenant?.code,
        "fromDate" : dashBoardProvider.selectedMonth.startDate.millisecondsSinceEpoch.toString(),
        "toDate" : dashBoardProvider.selectedMonth.endDate.millisecondsSinceEpoch.toString()
      };

      var res1 = await DashBoardRepository().fetchRevenueDetails(query);
      var res2 = await DashBoardRepository().fetchExpenseDetails(query);
      var filteredList = <TableDataRow>[];
      if (res1 != null && res1.isNotEmpty && res2 != null && res2.isNotEmpty) {
        for(int i =0 ; i < res1.length ; i++) {
          var collection = res1[i];
          var expense = res2[i];
          var surplus = int.parse(collection.pendingCollection ?? '0') - int.parse(expense.amountUnpaid ?? '0');
          filteredList.add(
              TableDataRow([
                TableData('${DateFormats.getMonth(
                    DateFormats.getFormattedDateToDateTime(
                        DateFormats.timeStampToDate(collection.month))!)}',
                    callBack: onTapOfMonth),
                TableData('${surplus.abs()}', style: TextStyle(color: surplus.isNegative ?
                Color.fromRGBO(255, 0, 0, 1) :
                Color.fromRGBO(0, 128, 0, 1))),
                TableData('${collection.demand ?? '-'}(${collection.arrears})'),
                TableData('${collection.pendingCollection ?? '-'}'),
                TableData('${collection.actualCollection ?? '-'}'),
                TableData('${expense.totalExpenditure ?? '-'}'),
                TableData('${expense.amountUnpaid ?? '-'}'),
                TableData('${expense.amountPaid ?? '-'}'),
              ]));
        }
      }
      revenueStreamController.add(filteredList);
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  void setSelectedTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<String> getTabs(BuildContext context) {
    return [
      /// Stacked Graph not implemented due to Backend API response finalization is pending
      //i18.dashboard.STACKED_BAR,
      i18.dashboard.TREND_LINE
    ];
  }

  List<TableHeader> get revenueHeaderList =>
      [
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
    var dashBoardProvider = Provider.of<DashBoardProvider>(
        navigatorKey.currentContext!, listen: false);

    var monthIndex = 0;
    var date = monthIndex >= 4
        ? dashBoardProvider.selectedMonth.startDate
        : dashBoardProvider.selectedMonth.endDate;
    dashBoardProvider.onChangeOfDate(DatePeriod(
        DateTime(date.year, monthIndex, 1),
        DateTime(date.year, monthIndex + 1, 0), DateType.MONTH),
        navigatorKey.currentContext!);
    dashBoardProvider.scrollController.jumpTo(0.0);
  }


  List<charts.Series<RevenueGraphModel, int>>? trendGraphDataBinding(
      RevenueGraph revenueGraph) {

    Map revenueData = {};
    Map expenseData = {};
    Map filteredData = {};
    var list = <charts.Series<RevenueGraphModel, int>>[];
    revenueGraph.data?.firstWhere((e) =>  e.headerName == "WaterService").plots?.forEach((e) {
      //var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
      revenueData[i18.dashboard.REVENUE] ??= {};
      revenueData[i18.dashboard.REVENUE][e.name] = e.value;
    });

    revenueGraph.data?.firstWhere((e) => e.headerName == "ExpenseService").plots?.forEach((e) {
      //var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
      expenseData[i18.dashboard.EXPENDITURE] ??= {};
      expenseData[i18.dashboard.EXPENDITURE][e.name] = e.value;
    });

    revenueData.forEach((key, value) {
      var data = <RevenueGraphModel>[];
      var index = 0;
      value.forEach((month, value) {
        data.add(RevenueGraphModel(month : index, trend : value));
        index++;
      });
      list.add(charts.Series<RevenueGraphModel, int>(
        id: 'Trend1',
         //colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (RevenueGraphModel sales, _) => sales.month,
        measureFn: (RevenueGraphModel sales, _) => sales.trend,
        data: data,
      ));
    });

    expenseData.forEach((key, value) {
      var data = <RevenueGraphModel>[];
      var index = 0;
      value.forEach((month, value) {
        data.add(RevenueGraphModel(month : index, trend : value));
        index++;
      });
      list.add(charts.Series<RevenueGraphModel, int>(
        id: 'Trend2',
        //colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (RevenueGraphModel sales, _) => sales.month,
        measureFn: (RevenueGraphModel sales, _) => sales.trend,
        data: data,
      ));
    });

    return list;
  }

/// Stacked Graph not implemented due to Backend API response finalization is pending
  // List<charts.Series<RevenueGraphModel, String>>? stackedGraphDataBinding(
  //     RevenueGraph revenueGraph) {
  //   Map revenueData = {};
  //   Map expenseData = {};
  //
  //   var color = {
  //     'RESIDENTIAL' :  '#4069bb',
  //     'COMMERCIAL' : '#bcd3ff',
  //     'SALARY' : '#2fc5e5',
  //     "OM" : '#fbc02d',
  //     "ELECTRICITY_BILL" : '#13d8cc'
  //   };
  //
  //   var list = <charts.Series<RevenueGraphModel, String>>[];
  //
  //   revenueGraph.waterService?.buckets?.forEach((e) {
  //     var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
  //     e.propertyType?.bucket?.forEach((bucket) {
  //       revenueData[bucket.key] ??= {};
  //       revenueData[bucket.key][date.year] = bucket.count?['value'] ?? '';
  //     });
  //   });
  //
  //   revenueData.forEach((key, value) {
  //     var data = <RevenueGraphModel>[];
  //     value.forEach((year, value) {
  //       var legendColor = charts.Color.fromHex(code: color[key] ?? '#4069bb');
  //       revenueDataHolder.revenueLabels.add(Legend(key, color[key] ?? '#4069bb'));
  //       data.add(RevenueGraphModel(year : year.toString(), trend : value.toInt(), color: legendColor));
  //     });
  //     list.add(charts.Series<RevenueGraphModel, String>(
  //       id: 'Tablet A',
  //       seriesCategory: 'Revenue',
  //       domainFn: (RevenueGraphModel sales, _) => sales.year,
  //       measureFn: (RevenueGraphModel sales, _) => sales.trend,
  //       colorFn: (RevenueGraphModel sales, _) => sales.color ??  charts.MaterialPalette.yellow.shadeDefault,
  //       data: data,
  //     ));
  //   });
  //
  //   revenueGraph.expense?.buckets?.forEach((e) {
  //     var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
  //     e.expenseType?.bucket?.forEach((bucket) {
  //       expenseData[bucket.key] ??= {};
  //       expenseData[bucket.key][date.year] = bucket.count?['value'] ?? '';
  //     });
  //   });
  //
  //   expenseData.forEach((key, value) {
  //     var data = <RevenueGraphModel>[];
  //     value.forEach((year, value) {
  //       var legendColor = charts.Color.fromHex(code: color[key] ?? '#4069bb');
  //       revenueDataHolder.expenseLabels.add(Legend(key,  color[key] ?? '#4069bb'));
  //       data.add(RevenueGraphModel(year : year.toString(), trend : value.toInt(), color: legendColor));
  //     });
  //     list.add(charts.Series<RevenueGraphModel, String>(
  //       id: 'Tablet B',
  //       seriesCategory: 'expense',
  //       domainFn: (RevenueGraphModel sales, _) => sales.year,
  //       measureFn: (RevenueGraphModel sales, _) => sales.trend,
  //       colorFn: (RevenueGraphModel sales, _) => sales.color ??  charts.MaterialPalette.red.shadeDefault,
  //       data: data,
  //     ));
  //   });
  //
  //   return list;
  // }
}