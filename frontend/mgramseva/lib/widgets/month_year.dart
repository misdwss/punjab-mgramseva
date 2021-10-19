import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/custom_overlay/show_overlay.dart';

class MonthYear extends StatefulWidget {
  final ValueChanged<DatePeriod?> onSelectionOfDate;
  final List<YearWithMonths>? yearsWithMonths;
  final DatePeriod? selectedMonth;
  final double? left;
  final double? top;
  const MonthYear({Key? key, required this.onSelectionOfDate, this.left, this.top, this.yearsWithMonths, this.selectedMonth}) : super(key: key);

  @override
  State<MonthYear> createState() => _MonthYearState();
}

class _MonthYearState extends State<MonthYear> {

  late List<YearWithMonths> yearsWithMonths;
  DatePeriod? selectedMonth;

  @override
  void initState() {
    yearsWithMonths = CommonMethods.getFinancialYearList();

    if(widget.selectedMonth != null){
       DatePeriod? date;
      for(YearWithMonths yearWithMonth in yearsWithMonths){
        if(widget.selectedMonth == yearWithMonth.year){
          date = yearWithMonth.year;
        }
       for(var month in yearWithMonth.monthList){
         if(widget.selectedMonth == month){
           date = month;
         }
       }
      }
      selectedMonth = date ?? yearsWithMonths.first.year;
    }else{
      selectedMonth ??= yearsWithMonths.first.year;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    int colorDivider = -1;

    return Positioned(
        left: widget.left,
        top: widget.top,
        child: Material(
            color: Colors.transparent,
            child: Container(
                constraints: BoxConstraints(
                    maxHeight: (height - (widget.top ?? 0))),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      blurRadius: 20.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        yearsWithMonths.length, (index) {
                      var yearWithMonths = yearsWithMonths[index];
                      colorDivider++;
                      return Wrap(
                        direction: Axis.vertical,
                        children: [
                          Container(
                            width: 200,
                            decoration: index ==
                                yearWithMonths.monthList.length - 1
                                ? BoxDecoration(
                                color: index % 2 == 0
                                    ? Color.fromRGBO(238, 238, 238, 1)
                                    : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                ))
                                : BoxDecoration(
                              color: index % 2 == 0
                                  ? Color.fromRGBO(238, 238, 238, 1)
                                  : Color.fromRGBO(255, 255, 255, 1),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child:
                            Wrap(
                              spacing: 5,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => onSelectionOfExpansion(yearWithMonths),
                                  child: Text(
                                    '${DateFormats.getMonthAndYear(yearWithMonths.year, context)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: yearStatus(yearWithMonths)
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                                Radio(
                                    value: yearWithMonths.year,
                                    groupValue: selectedMonth,
                                    onChanged: onSelectionOfDate)
                              ],
                            ),
                          ),
                          Visibility(
                            visible: monthStatus(yearWithMonths),
                            child: Wrap(
                              direction: Axis.vertical,
                              children: List.generate(yearWithMonths.monthList.length, (monthIndex) {
                                var date = yearWithMonths.monthList[monthIndex];
                                colorDivider++;
                                  return InkWell(
                                    onTap: () => onSelectionOfDate(date),
                                    child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color:  (monthIndex + index) % 2 == 0
                                            ? Color.fromRGBO(255, 255, 255, 1) :
                                        Color.fromRGBO(238, 238, 238, 1)
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child:
                                      Container(
                                        width: 195,
                                        alignment: Alignment.centerRight,
                                        child: Wrap(
                                          spacing: 5,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          alignment: WrapAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${DateFormats.getMonthAndYear(date, context)}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: selectedMonth == date
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                            ),
                                            Radio(
                                                value: date,
                                                groupValue: selectedMonth,
                                                onChanged: onSelectionOfDate)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
    }
                              ).toList()
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ))));
  }

  void onSelectionOfDate(DatePeriod? datePeriod){
    if(datePeriod?.dateType != DateType.MONTH) yearsWithMonths.forEach((e) => e.isExpanded = false);
    CustomOVerlay.removeOverLay();
    widget.onSelectionOfDate(datePeriod);
  }

  void onSelectionOfExpansion(YearWithMonths yearWithMonths){
    yearsWithMonths.forEach((e) {if(e != yearWithMonths) e.isExpanded = false;});
    setState(() {
      yearWithMonths.isExpanded = !yearWithMonths.isExpanded;
    });
  }

  bool yearStatus(YearWithMonths yearWithMonths) => selectedMonth == yearWithMonths.year;

  bool monthStatus(YearWithMonths yearWithMonths) => yearWithMonths.monthList.contains(selectedMonth) || yearWithMonths.isExpanded;
}
