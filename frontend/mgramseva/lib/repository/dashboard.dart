
import 'package:mgramseva/model/dashboard/revenue_dashboard.dart';
import 'package:mgramseva/model/dashboard/revenue_graph.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/services/urls.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class DashBoardRepository extends BaseService {

  Future<Map?> getMetricInformation(bool isExpenditure, Map<String, dynamic> query) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    Map? metricInformation;

    var res = await makeRequest(
        url: isExpenditure ? Url.EXPENDITURE_METRIC : Url.REVENUE_METRIC,
        method: RequestType.POST,
        queryParameters: query,
        body: {},
        requestInfo:  RequestInfo(
            APIConstants.API_MODULE_NAME,
            APIConstants.API_VERSION,
            APIConstants.API_TS,
            "",
            APIConstants.API_DID,
            APIConstants.API_KEY,
            APIConstants.API_MESSAGE_ID,
            commonProvider.userDetails?.accessToken,
            commonProvider.userDetails?.userRequest?.toJson()
        ));

    if (res != null) {
      metricInformation = res[isExpenditure ? 'ExpenseDashboard' : 'RevenueDashboard'];
    }
    return metricInformation;
  }

  Future<Map?> getUsersFeedBackByMonth(Map<String, dynamic> query) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    Map? feedBack;

    var res = await makeRequest(
        url: Url.GET_USERS_PAYMENT_FEEDBACK,
        method: RequestType.POST,
        queryParameters: query,
        body: {},
        requestInfo:  RequestInfo(
          APIConstants.API_MODULE_NAME,
          APIConstants.API_VERSION,
          APIConstants.API_TS,
          "_search",
          APIConstants.API_DID,
          APIConstants.API_KEY,
          APIConstants.API_MESSAGE_ID,
          commonProvider.userDetails!.accessToken,
        ));

    if (res != null) {
      feedBack = res['feedback'];
    }
    return feedBack;
  }

  Future<List<Revenue>?> fetchRevenueDetails() async {
    var response = a['responseData']
        .map<Revenue>((e) => Revenue.fromJson(e))
        .toList();
    return response;
  }

  Future<RevenueGraph?> getGraphicalDashboard(Map<String, dynamic> query) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    RevenueGraph? revenueGraph;

    // var res = await makeRequest(
    //     url: Url.GET_USERS_PAYMENT_FEEDBACK,
    //     method: RequestType.POST,
    //     queryParameters: query,
    //     body: {},
    //     requestInfo:  RequestInfo(
    //       APIConstants.API_MODULE_NAME,
    //       APIConstants.API_VERSION,
    //       APIConstants.API_TS,
    //       "_search",
    //       APIConstants.API_DID,
    //       APIConstants.API_KEY,
    //       APIConstants.API_MESSAGE_ID,
    //       commonProvider.userDetails!.accessToken,
    //     ));

    await Future.delayed(Duration(seconds: 2));
    if (b != null) {
      revenueGraph = RevenueGraph.fromJson(b['aggregations']['AGGR']);
    }
    return revenueGraph;
  }


  dynamic b = {
    "took" : 6,
    "timed_out" : false,
    "_shards" : {
      "total" : 5,
      "successful" : 5,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : 26,
      "max_score" : 0.0,
      "hits" : [ ]
    },
    "aggregations" : {
      "AGGR" : {
        "doc_count" : 26,
        "WaterService" : {
          "buckets" : [
            {
              "key" : 1609439400000,
              "doc_count" : 26,
              "Property Type" : {
                "doc_count_error_upper_bound" : 0,
                "sum_other_doc_count" : 0,
                "buckets" : [
                  {
                    "key" : "RESIDENTIAL",
                    "doc_count" : 16,
                    "Count" : {
                      "value" : 350.0
                    }
                  },
                  {
                    "key" : "COMMERCIAL",
                    "doc_count" : 1,
                    "Count" : {
                      "value" : 100.0
                    }
                  }
                ]
              }
            },
            {
              "key" : 1614191400000,
              "doc_count" : 26,
              "Property Type" : {
                "doc_count_error_upper_bound" : 0,
                "sum_other_doc_count" : 0,
                "buckets" : [
                  {
                    "key" : "RESIDENTIAL",
                    "doc_count" : 30,
                    "Count" : {
                      "value" : 350.0
                    }
                  },
                  {
                    "key" : "COMMERCIAL",
                    "doc_count" : 10,
                    "Count" : {
                      "value" : 100.0
                    }
                  }
                ]
              }
            },
            {
              "key" : 1621881000000,
              "doc_count" : 26,
              "Property Type" : {
                "doc_count_error_upper_bound" : 0,
                "sum_other_doc_count" : 0,
                "buckets" : [
                  {
                    "key" : "RESIDENTIAL",
                    "doc_count" : 30,
                    "Count" : {
                      "value" : 350.0
                    }
                  },
                  {
                    "key" : "COMMERCIAL",
                    "doc_count" : 5,
                    "Count" : {
                      "value" : 100.0
                    }
                  }
                ]
              }
            },
            {
              "key" : 1624559400000,
              "doc_count" : 26,
              "Property Type" : {
                "doc_count_error_upper_bound" : 0,
                "sum_other_doc_count" : 0,
                "buckets" : [
                  {
                    "key" : "RESIDENTIAL",
                    "doc_count" : 30,
                    "Count" : {
                      "value" : 350.0
                    }
                  },
                  {
                    "key" : "COMMERCIAL",
                    "doc_count" : 5,
                    "Count" : {
                      "value" : 100.0
                    }
                  }
                ]
              }
            },
            {
              "key" : 1627151400000,
              "doc_count" : 26,
              "Property Type" : {
                "doc_count_error_upper_bound" : 0,
                "sum_other_doc_count" : 0,
                "buckets" : [
                  {
                    "key" : "RESIDENTIAL",
                    "doc_count" : 30,
                    "Count" : {
                      "value" : 350.0
                    }
                  },
                  {
                    "key" : "COMMERCIAL",
                    "doc_count" : 5,
                    "Count" : {
                      "value" : 100.0
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    }
  };

  dynamic a = {
    "statusInfo": {
      "statusCode": 200,
      "statusMessage": "success",
      "errorMessage": ""
    },
    "responseData" : [
      {
        "month" : "August",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "September",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "October",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "November",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "December",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "January",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "February",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "March",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "April",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "May",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "June",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "July",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },

    ]
  };
}

