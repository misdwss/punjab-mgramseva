import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:mgramseva/model/common/fetch_bill.dart' as billDetails;
import 'package:mgramseva/model/common/fetch_bill.dart';
import 'package:mgramseva/providers/collect_payment.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/ConfirmationPopUp.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';
import '../../widgets/customAppbar.dart';

class ConnectionPaymentView extends StatefulWidget {
  final Map<String, dynamic> query;
  const ConnectionPaymentView({Key? key, required this.query})
      : super(key: key);

  @override
  _ConnectionPaymentViewState createState() => _ConnectionPaymentViewState();
}

class _ConnectionPaymentViewState extends State<ConnectionPaymentView> {
  final formKey = GlobalKey<FormState>();
  var autoValidation = false;

  @override
  void initState() {
    var consumerPaymentProvider =
        Provider.of<CollectPaymentProvider>(context, listen: false);
    consumerPaymentProvider.getBillDetails(context, widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var consumerPaymentProvider =
        Provider.of<CollectPaymentProvider>(context, listen: false);
    FetchBill? fetchBill;
    return FocusWatcher(
        child: Scaffold(
          drawer: DrawerWrapper(
            Drawer(child: SideBar()),
          ),
          appBar: CustomAppBar(),
          body: StreamBuilder(
          stream: consumerPaymentProvider.paymentStreamController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data is String) {
                return CommonWidgets.buildEmptyMessage(snapshot.data, context);
              }
              fetchBill = snapshot.data;
              return _buildView(snapshot.data);
            } else if (snapshot.hasError) {
              return Notifiers.networkErrorPage(
                  context,
                  () => consumerPaymentProvider.getBillDetails(
                      context, widget.query));
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
          }),
      bottomNavigationBar: Consumer<CollectPaymentProvider>(
        builder: (_, consumerPaymentProvider, child) => Visibility(
            visible: fetchBill != null,
            child: BottomButtonBar(
                '${ApplicationLocalizations.of(context).translate(i18.common.COLLECT_PAYMENT)}',
                () => showGeneralDialog(
                    barrierLabel: "Label",
                    barrierDismissible: false,
                    barrierColor: Colors.black.withOpacity(0.5),
                    context: context,
                    pageBuilder: (context, anim1, anim2) {
                      return Align(
                          alignment: Alignment.center,
                          child: ConfirmationPopUp(
                            textString: i18.payment.CORE_AMOUNT_CONFIRMATION,
                            subTextString: '₹ ${fetchBill?.customAmountCtrl.text}',
                            cancelLabel: i18.common.CORE_GO_BACK,
                            confirmLabel: i18.common.CORE_CONFIRM,
                            onConfirm: () => paymentInfo(fetchBill!, context),
                          ));
                    },))),
      ),
    ));
  }

  Widget _buildView(FetchBill fetchBill) {
    return SingleChildScrollView(
      child: FormWrapper(Form(
        key: formKey,
        autovalidateMode: autoValidation
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBack(),
              LayoutBuilder(
                builder: (_, constraints) => Column(
                  children: [
                    _buildCoonectionDetails(fetchBill, constraints),
                    _buildPaymentDetails(fetchBill, constraints)
                  ],
                ),
              )
            ]),
      )),
    );
  }

  Widget _buildCoonectionDetails(
      FetchBill fetchBill, BoxConstraints constraints) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelValue(
                        i18.common.CONNECTION_ID, '${fetchBill.consumerCode}'),
                    _buildLabelValue(
                        i18.common.CONSUMER_NAME, '${fetchBill.payerName}'),
                  ]))),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Consumer<CollectPaymentProvider>(
              builder: (_, consumerPaymentProvider, child) => Visibility(
                  visible: fetchBill.viewDetails,
                  child: _buildViewDetails(fetchBill)),
            ),
            _buildLabelValue(i18.common.TOTAL_DUE_AMOUNT,
                '₹ ${fetchBill.totalAmount}', FontWeight.w700),
            Consumer<CollectPaymentProvider>(
              builder: (_, consumerPaymentProvider, child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () => Provider.of<CollectPaymentProvider>(context,
                          listen: false)
                      .onClickOfViewOrHideDetails(fetchBill, context),
                  child: Text(
                    fetchBill.viewDetails
                        ? '${ApplicationLocalizations.of(context).translate(i18.payment.HIDE_DETAILS)}'
                        : '${ApplicationLocalizations.of(context).translate(i18.payment.VIEW_DETAILS)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            )
          ]),
        ),
      )
    ]);
  }

  Widget _buildPaymentDetails(FetchBill fetchBill, BoxConstraints constraints) {
    return Consumer<CollectPaymentProvider>(
      builder: (_, consumerPaymentProvider, child) => Card(
          child: Wrap(
        children: [
          ForceFocusWatcher(
              child:
              BuildTextField(
                i18.common.PAYMENT_AMOUNT,
                 fetchBill.customAmountCtrl,
                textInputType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                validator:
                    Validators.partialAmountValidatior,
                prefixText: '₹ ',
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${ApplicationLocalizations.of(context).translate(i18.payment.CORE_CHANGE_THE_AMOUNT)}',
            style: TextStyle(
              color: Colors.blueAccent
            ),
            ),
          ),
          RadioButtonFieldBuilder(
              context,
              i18.common.PAYMENT_METHOD,
              fetchBill.paymentMethod,
              '',
              '',
              true,
              consumerPaymentProvider.paymentModeList,
              (val) => consumerPaymentProvider.onChangeOfPaymentAmountOrMethod(
                  fetchBill, val))
        ],
      )),
    );
  }

  Widget _buildViewDetails(FetchBill fetchBill) {
    List res = [];
    num len = fetchBill.billDetails?.first.billAccountDetails?.length as num;
    if (fetchBill.billDetails!.isNotEmpty)
      fetchBill.billDetails?.forEach((element) {
        res.add(element.amount);
      });
    return LayoutBuilder(
      builder: (_, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              subTitle(i18.payment.BILL_DETAILS),
              _buildLabelValue(i18.common.BILL_ID, '${fetchBill.billNumber}'),
              _buildLabelValue(i18.payment.BILL_PERIOD,
                  '${DateFormats.getMonthWithDay(fetchBill.billDetails?.first.fromPeriod)} - ${DateFormats.getMonthWithDay(fetchBill.billDetails?.first.toPeriod)}'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                len > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            _buildLabelValue(
                                'WS_${fetchBill.billDetails?.first.billAccountDetails?.last.taxHeadCode}',
                                '₹ ${fetchBill.billDetails?.first.billAccountDetails?.last.amount}'),
                            (res.reduce((value, element) => value + element) -
                                        fetchBill.billDetails?.first
                                            .billAccountDetails?.last.amount) >
                                    0
                                ? _buildLabelValue(i18.billDetails.ARRERS_DUES,
                                    '₹ ${(res.reduce((value, element) => value + element) - fetchBill.billDetails?.first.billAccountDetails?.last.amount).toString()}')
                                : SizedBox(
                                    height: 0,
                                  )
                          ])
                    : _buildLabelValue(
                        'WS_${fetchBill.billDetails?.first.billAccountDetails?.last.taxHeadCode}',
                        '₹ ${fetchBill.billDetails?.first.billAccountDetails?.last.amount}'),
                // }),
                if (fetchBill.billDetails != null && res.length > 1)
                  _buildWaterCharges(fetchBill, constraints),
                _buildLabelValue(
                    i18.common.CORE_TOTAL_BILL_AMOUNT,
                    '₹ ${fetchBill.billDetails?.first.billAccountDetails?.last.amount}'),
                _buildLabelValue(
                    i18.common.CORE_ADVANCE_ADJUSTED,
                    '₹'),
                _buildLabelValue(
                    i18.common.CORE_NET_AMOUNT_DUE,
                    '₹'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWaterCharges(FetchBill bill, BoxConstraints constraints) {
    var style = TextStyle(
        fontSize: 14,
        color: Color.fromRGBO(80, 90, 95, 1),
        fontWeight: FontWeight.w400);

    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: constraints.maxWidth > 760
            ? Column(
                children: List.generate(bill.billDetails?.length ?? 0, (index) {
                if (index != 0) {
                  return Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 3,
                          padding: EdgeInsets.only(top: 18, bottom: 3),
                          child: new Align(
                              alignment: Alignment.centerLeft,
                              child: _buildDemandDetails(
                                  bill, bill.billDetails![index]))),
                      Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          padding: EdgeInsets.only(top: 18, bottom: 3),
                          child: Text('₹ ${bill.billDetails![index].amount}')),
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 0,
                  );
                }
              }))
            : Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List.generate(bill.billDetails?.length ?? 0, (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      TableCell(child: Text("")),
                      TableCell(child: Text(""))
                    ]);
                  } else {
                    return TableRow(children: [
                      TableCell(
                          child: _buildDemandDetails(
                              bill, bill.billDetails![index])),
                      TableCell(
                          child: Text('₹ ${bill.billDetails![index].amount}',
                          textAlign: TextAlign.center,))
                    ]);
                  }
                }).toList()));
  }

  Widget _buildDemandDetails(
      FetchBill bill, billDetails.BillDetails? billdemandDetails) {
    var style = TextStyle(fontSize: 14, color: Color.fromRGBO(80, 90, 95, 1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 3,
        children: [
          Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                  '${ApplicationLocalizations.of(context).translate('BL_${billdemandDetails?.billAccountDetails?.first.taxHeadCode}')}',
                  style: style)),
          Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                  '${DateFormats.getMonthWithDay(billdemandDetails?.fromPeriod)}-${DateFormats.getMonthWithDay(billdemandDetails?.toPeriod)}',
                  style: style)),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value,
      [FontWeight? fontWeight]) {
    return LayoutBuilder(
        builder: (_, constraints) => constraints.maxWidth > 760
            ? Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.only(top: 18, bottom: 3),
                      child: new Align(
                          alignment: Alignment.centerLeft,
                          child: subTitle('$label', 16))),
                  Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.only(top: 18, bottom: 3, left: 24),
                      child: Text('$value',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400))),
                ],
              )
            : Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                    TableRow(children: [
                      TableCell(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: subTitle('$label', 16))),
                      TableCell(
                          child: Text('$value',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)))
                    ])
                  ]));
  }

  paymentInfo(FetchBill fetchBill, BuildContext context) {
    var consumerPaymentProvider =
        Provider.of<CollectPaymentProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      autoValidation = false;
      consumerPaymentProvider.updatePaymentInformation(fetchBill, context);
    } else {
      setState(() {
        autoValidation = true;
      });
    }
  }

  Text subTitle(String label, [double? size]) =>
      Text('${ApplicationLocalizations.of(context).translate(label)}',
          style: TextStyle(fontSize: size ?? 24, fontWeight: FontWeight.w700));
}
