import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/demand/demand_list.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/fetch_bill_provider.dart';
import 'package:mgramseva/providers/household_details_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ButtonGroup.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

import '../../widgets/CustomDetails.dart';

class NewConsumerBill extends StatefulWidget {
  final String? mode;
  final WaterConnection? waterConnection;
  final List<Demands> demandList;

  const NewConsumerBill(this.mode, this.waterConnection, this.demandList);
  @override
  State<StatefulWidget> createState() {
    return NewConsumerBillState();
  }
}

class NewConsumerBillState extends State<NewConsumerBill> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<FetchBillProvider>(context, listen: false)
      ..fetchBill(widget.waterConnection, context);
  }

  _getLabeltext(label, value, context, {subLabel = ''}) {
    return Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: (Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(right: 16),
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ApplicationLocalizations.of(context).translate(label),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                      subLabel?.trim?.toString() != ''
                          ? Text( subLabel,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ) : Text('')
                    ])),
            Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
          ],
        )));
  }

  getDueDatePenalty(dueDate){
    late String localizationText;
    localizationText = '${ApplicationLocalizations.of(context).translate(i18.billDetails.CORE_PAID_AFTER)}';
    localizationText = localizationText.replaceFirst(
        '{dueDate}', dueDate);
    return localizationText;
  }

  @override
  Widget build(BuildContext context) {
    var billpaymentsProvider =
        Provider.of<FetchBillProvider>(context, listen: false);
    return StreamBuilder(
        stream: billpaymentsProvider.streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buidBillview(snapshot.data);
          } else if (snapshot.hasError) {
            return Notifiers.networkErrorPage(context, () {});
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loaders.CircularLoader();
              case ConnectionState.active:
                return Loaders.CircularLoader();
              default:
                return Container();
            }
          }
        });
  }

  buidBillview(BillList billList) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    // if (billList.bill!.isNotEmpty)
    //   billList.bill?.first.billDetails!.forEach((element) {
    //     res.add(element.amount);
    //   });

    return LayoutBuilder(builder: (context, constraints) {
      var houseHoldProvider =
          Provider.of<HouseHoldProvider>(context, listen: false);
      return billList.bill!.isEmpty
          ?
      Text("")
          :
      !(widget.demandList.first.demandDetails?.first.taxHeadMasterCode == 'WS_ADVANCE_CARRYFORWARD')
              ?
      houseHoldProvider.isfirstdemand == false &&
                      widget.mode != 'collect'
                  ? Text("")
                  : Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top: 16, bottom: 8),
                            child: ListLabelText(i18
                                .billDetails.NEW_CONSUMERGENERATE_BILL_LABEL)),
                        Card(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible:
                                            houseHoldProvider.isfirstdemand ==
                                                    true
                                                ? true
                                                : false,
                                        child: TextButton.icon(
                                          onPressed: () => commonProvider
                                              .getFileFromPDFBillService(
                                                  {
                                                "Bill": [billList.bill?.first]
                                              },
                                                  {
                                                "key": widget.waterConnection
                                                            ?.connectionType ==
                                                        'Metered'
                                                    ? "ws-bill"
                                                    : "ws-bill-nm",
                                                "tenantId": commonProvider
                                                    .userDetails
                                                    ?.selectedtenant
                                                    ?.code,
                                              },
                                                  billList
                                                      .bill!.first.mobileNumber,
                                                  billList.bill?.first,
                                                  "Download"),
                                          icon: Icon(Icons.download_sharp),
                                          label: Text(
                                            ApplicationLocalizations.of(context)
                                                .translate(
                                                    i18.common.BILL_DOWNLOAD),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                      houseHoldProvider.isfirstdemand == true
                                          ? _getLabeltext(
                                              i18.generateBillDetails
                                                  .LAST_BILL_GENERATION_DATE,
                                              DateFormats.timeStampToDate(
                                                      billList
                                                          .bill!.first.billDate,
                                                      format: "dd/MM/yyyy")
                                                  .toString(),
                                              context)
                                          : Text(""),
                                      _getLabeltext(
                                          houseHoldProvider.isfirstdemand ==
                                                  true
                                              ? i18.billDetails.CURRENT_BILL
                                              : i18.billDetails.ARRERS_DUES,
                                          ('₹' +
                                              widget.demandList.first.demandDetails!
                                                  .first.taxAmount
                                                  .toString()),
                                          context),
                                      houseHoldProvider.isfirstdemand == true
                                          ? _getLabeltext(
                                              i18.billDetails.ARRERS_DUES,
                                              ('₹' + CommonProvider.getArrearsAmount(widget.demandList).toString()),
                                              context)
                                          : Text(""),
                                      _getLabeltext(
                                          i18.billDetails.TOTAL_AMOUNT,
                                          ('₹' +
                                              getTotalBillAmount()),
                                          context),
                                      _getLabeltext(
                                          i18.common.CORE_ADVANCE_ADJUSTED,
                                          ('₹' +
                                              (CommonProvider.getAdvanceAdjustedAmount(widget.demandList))
                                                  .toString()),
                                          context),
                                      _getLabeltext(
                                          i18.common.CORE_NET_DUE_AMOUNT,
                                          ('₹' +
                                              ((billList.bill?.first.totalAmount ?? 0) >= 0 ? billList.bill?.first.totalAmount : 0)
                                                  .toString()),
                                          context),
                                      if(false) CustomDetailsCard(
                                          Column(
                                            children: [
                                              _getLabeltext(
                                                  i18.billDetails.CORE_PENALTY,
                                                  ('₹' +
                                                      (billList.bill?.first.penalty ?? 0)
                                                          .toString()),
                                                  context,
                                                  subLabel: getDueDatePenalty('dueDate')),
                                              _getLabeltext(
                                                  i18.billDetails.CORE_NET_DUE_AMOUNT_WITH_PENALTY,
                                                  ('₹' +
                                                      (billList.bill?.first.netAmountDueWithPenalty ?? 0)
                                                          .toString()),
                                                  context,
                                                  subLabel: getDueDatePenalty('dueDate'))

                                            ],
                                          )
                                      ),
                                      widget.mode == 'collect'
                                          ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: houseHoldProvider
                                                          .isfirstdemand ==
                                                      true
                                                  /*&&
                                             houseHoldProvider.waterConnection!
                                                      .connectionType !=
                                                  'Metered'*/
                                                  ? ButtonGroup(
                                                      i18.billDetails
                                                          .COLLECT_PAYMENT,
                                                      () =>
                                                          commonProvider
                                                              .getFileFromPDFBillService(
                                                                  {
                                                                "Bill": [
                                                                  billList.bill!
                                                                      .first
                                                                ]
                                                              },
                                                                  {
                                                                "key": widget
                                                                            .waterConnection
                                                                            ?.connectionType ==
                                                                        'Metered'
                                                                    ? 'ws-bill'
                                                                    : 'ws-bill-nm',
                                                                "tenantId": commonProvider
                                                                    .userDetails!
                                                                    .selectedtenant!
                                                                    .code,
                                                              },
                                                                  billList
                                                                      .bill!
                                                                      .first
                                                                      .mobileNumber,
                                                                  billList.bill!
                                                                      .first,
                                                                  "Share"),
                                                      () =>
                                                          onClickOfCollectPayment(
                                                              billList
                                                                  .bill!,
                                                              context))
                                                  : ShortButton(
                                                      i18.billDetails
                                                          .COLLECT_PAYMENT,
                                                      () =>
                                                          onClickOfCollectPayment(
                                                              billList
                                                                  .bill!,
                                                              context)))
                                          : houseHoldProvider.isfirstdemand ==
                                                  true
                                              ? Container(
                                                  width: constraints.maxWidth >
                                                          760
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          3
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1.12,
                                                  child: OutlinedButton.icon(
                                                    onPressed: () => commonProvider
                                                        .getFileFromPDFBillService(
                                                      {
                                                        "Bill": [
                                                          billList.bill!.first
                                                        ]
                                                      },
                                                      {
                                                        "key": widget
                                                                    .waterConnection
                                                                    ?.connectionType ==
                                                                'Metered'
                                                            ? 'ws-bill'
                                                            : 'ws-bill-nm',
                                                        "tenantId":
                                                            commonProvider
                                                                .userDetails!
                                                                .selectedtenant!
                                                                .code,
                                                      },
                                                      billList.bill!.first
                                                          .mobileNumber,
                                                      billList.bill!.first,
                                                      "Share",
                                                    ),
                                                    style: ButtonStyle(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0)),
                                                      shape: MaterialStateProperty
                                                          .all(
                                                              RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 2,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                      )),
                                                    ),
                                                    icon: (Image.asset(
                                                        'assets/png/whats_app.png')),
                                                    label: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                          ApplicationLocalizations
                                                                  .of(context)
                                                              .translate(i18
                                                                  .common
                                                                  .SHARE_BILL),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16,
                                                          )),
                                                    ),
                                                  ),
                                                )
                                              : Text(""),
                                    ])))
                      ],
                    )
              : Text("");
    });
  }

  void onClickOfCollectPayment(List<Bill> bill, BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    Map<String, dynamic> query = {
      'consumerCode': bill.first.consumerCode,
      'businessService': bill.first.businessService,
      'tenantId': commonProvider.userDetails?.selectedtenant?.code,
      'demandList' : widget.demandList,
      'fetchBill' : bill
    };
    Navigator.pushNamed(context, Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT,
        arguments: query);
  }

  String getTotalBillAmount() {
    return ((widget.demandList.first.demandDetails?.first.taxAmount ?? 0) + CommonProvider.getArrearsAmount(widget.demandList)).toString();
  }

}
