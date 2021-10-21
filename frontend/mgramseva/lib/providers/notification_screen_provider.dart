import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/Events/events_List.dart';

import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';
import 'common_provider.dart';

///Notification Screen Provider
class NotificationScreenProvider with ChangeNotifier {
  var enableNotification = false;
  var streamController = StreamController.broadcast();
  int offset = 1;
  int limit = 10;
  List<Events> notifications = [];

  ///Notification Screen
  void getNotifications(int offSet, int limit) async {
    var totalCount = 200;
    this.limit = limit;
    this.offset = offSet;
    notifyListeners();
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    try {
      var notifications1 = await CoreRepository().fetchNotifications({
        "tenantId": commonProvider.userDetails?.selectedtenant?.code!,
        "eventType": "SYSTEMGENERATED",
        "recepients": commonProvider.userDetails?.userRequest?.uuid,
        "status": "READ,ACTIVE",
        "offset": '${offset - 1}',
        "limit": '$limit'
      });
      var notifications2 = await CoreRepository().fetchNotifications({
        "tenantId": commonProvider.userDetails?.selectedtenant?.code!,
        "eventType": "SYSTEMGENERATED",
        "roles": commonProvider.userDetails?.userRequest?.roles!
            .map((e) => e.code.toString())
            .join(',')
            .toString(),
        "status": "READ,ACTIVE",
        "offset": '${offset - 1}',
        "limit": '$limit'
      });
      notifications
        ..addAll(notifications2!.events!)
        ..addAll(notifications1!.events!);
      if (notifications != null && notifications.length > 0) {
        final jsonList = notifications.map((item) => jsonEncode(item)).toList();
        final uniqueJsonList = jsonList.toSet().toList();
        var result = new EventsList.fromJson({
          "events": uniqueJsonList.map((item) => jsonDecode(item)).toList()
        });
        if (((offSet + limit) > totalCount ? totalCount : (offSet + limit)) <=
            (200)) {
          streamController.add(result.events!.sublist(
              offSet - 1,
              ((offset + limit) - 1) > totalCount
                  ? totalCount
                  : (offset + limit) - 1));
          return;
        }
        enableNotification = true;
      } else {
        streamController.add(notifications.sublist(
            offSet - 1,
            ((offset + limit) - 1) > totalCount
                ? totalCount
                : (offset + limit) - 1));
      }
    } catch (e) {
      print(e);
    }
  }

  void onChangeOfPageLimit(PaginationResponse response) {
    try {
      getNotifications(response.offset, response.limit);
    } catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e);
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }
}
