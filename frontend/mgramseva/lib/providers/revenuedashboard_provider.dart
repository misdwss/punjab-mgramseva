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

  void loadGraphicalDashboard(BuildContext context) {
    loadRevenueDetails(context);
    loadRevenueGraphDetails(context);
    loadRevenueStackedGraphDetails(context);
  }


  Future<void> loadRevenueGraphDetails(BuildContext context) async {
    revenueDataHolder.trendLineLoader = true;
    notifyListeners();
    try {
      var res = await DashBoardRepository().getGraphicalDashboard({});
      if (res != null) {
        revenueDataHolder.trendLine = res;
        revenueDataHolder.trendLine?.graphData = trendGraphInfo(res);
      }
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
    revenueDataHolder.trendLineLoader = false;
    notifyListeners();
  }

  Future<void> loadRevenueStackedGraphDetails(BuildContext context) async {
    revenueDataHolder.stackLoader = true;
    revenueDataHolder.resetData();
    notifyListeners();
    try {
      var res = await DashBoardRepository().getGraphicalDashboard({});
      if (res != null) {
        revenueDataHolder.stackedBar = res;
        revenueDataHolder.stackedBar?.graphData = stackedGraphInfo(res);
      }
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
    revenueDataHolder.stackLoader = false;
    notifyListeners();
  }

  Future<void> loadRevenueDetails(BuildContext context) async {
    try {
      var res = await DashBoardRepository().fetchRevenueDetails();
      var filteredList = <TableDataRow>[];
      if (res != null && res.isNotEmpty) {
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
      i18.dashboard.STACKED_BAR,
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


  List<charts.Series<RevenueGraphModel, int>>? trendGraphInfo(
      RevenueGraph revenueGraph) {
    Map filteredData = {};
    var list = <charts.Series<RevenueGraphModel, int>>[];
    revenueGraph.waterService?.buckets?.forEach((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
      filteredData[i18.dashboard.RESIDENTIAL] ??= {};
      filteredData[i18.dashboard.RESIDENTIAL][date.month] = e.docCount;
    });

    revenueGraph.expense?.buckets?.forEach((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
      filteredData[i18.dashboard.EXPENDITURE] ??= {};
      filteredData[i18.dashboard.EXPENDITURE][date.month] = e.docCount;
    });

    filteredData.forEach((key, value) {
      var data = <RevenueGraphModel>[];
      var index = 0;
      value.forEach((key, value) {
        data.add(RevenueGraphModel(month : index, trend : value));
        index++;
      });
      list.add(charts.Series<RevenueGraphModel, int>(
        id: key,
        // colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (RevenueGraphModel sales, _) => sales.month,
        measureFn: (RevenueGraphModel sales, _) => sales.trend,
        data: data,
      ));
    });
    return list;
  }


  List<charts.Series<RevenueGraphModel, String>>? stackedGraphInfo(
      RevenueGraph revenueGraph) {
    Map revenueData = {};
    Map expenseData = {};

    var color = {
      'RESIDENTIAL' :  '#4069bb',
      'COMMERCIAL' : '#bcd3ff',
      'SALARY' : '#2fc5e5',
      "OM" : '#fbc02d',
      "ELECTRICITY_BILL" : '#13d8cc'
    };

    var list = <charts.Series<RevenueGraphModel, String>>[];

    revenueGraph.waterService?.buckets?.forEach((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
      e.propertyType?.bucket?.forEach((bucket) {
        revenueData[bucket.key] ??= {};
        revenueData[bucket.key][date.year] = bucket.count?['value'] ?? '';
      });
    });

    revenueData.forEach((key, value) {
      var data = <RevenueGraphModel>[];
      value.forEach((year, value) {
        var legendColor = charts.Color.fromHex(code: color[key] ?? '#4069bb');
        revenueDataHolder.revenueLabels.add(Legend(key, color[key] ?? '#4069bb'));
        data.add(RevenueGraphModel(year : year.toString(), trend : value.toInt(), color: legendColor));
      });
      list.add(charts.Series<RevenueGraphModel, String>(
        id: 'Tablet A',
        seriesCategory: 'Revenue',
        domainFn: (RevenueGraphModel sales, _) => sales.year,
        measureFn: (RevenueGraphModel sales, _) => sales.trend,
        colorFn: (RevenueGraphModel sales, _) => sales.color ??  charts.MaterialPalette.yellow.shadeDefault,
        data: data,
      ));
    });

    revenueGraph.expense?.buckets?.forEach((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.key ?? 0);
      e.expenseType?.bucket?.forEach((bucket) {
        expenseData[bucket.key] ??= {};
        expenseData[bucket.key][date.year] = bucket.count?['value'] ?? '';
      });
    });

    expenseData.forEach((key, value) {
      var data = <RevenueGraphModel>[];
      value.forEach((year, value) {
        var legendColor = charts.Color.fromHex(code: color[key] ?? '#4069bb');
        revenueDataHolder.expenseLabels.add(Legend(key,  color[key] ?? '#4069bb'));
        data.add(RevenueGraphModel(year : year.toString(), trend : value.toInt(), color: legendColor));
      });
      list.add(charts.Series<RevenueGraphModel, String>(
        id: 'Tablet B',
        seriesCategory: 'expense',
        domainFn: (RevenueGraphModel sales, _) => sales.year,
        measureFn: (RevenueGraphModel sales, _) => sales.trend,
        colorFn: (RevenueGraphModel sales, _) => sales.color ??  charts.MaterialPalette.red.shadeDefault,
        data: data,
      ));
    });

    return list;
  }
}