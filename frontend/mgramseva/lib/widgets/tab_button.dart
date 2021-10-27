import 'package:flutter/material.dart';


class TabButton extends StatelessWidget {
  final String buttonLabel;
  final bool? isSelected;
  final bool? isMainTab;
  final Function()? onPressed;

  TabButton(this.buttonLabel, {this.isSelected, this.isMainTab, this.onPressed});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: (isMainTab ?? false) ? MediaQuery.of(context).size.width / 2.25 : null,
        height: (isMainTab ?? false) ? 50 : null,
        decoration: (isMainTab ?? false) ?  BoxDecoration(
            color: (isSelected ?? false) ? Colors.white : null,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(0.0)
        ) :  BoxDecoration(
            color: (isSelected ?? false) ? Colors.white : Color.fromRGBO(244, 119, 56, 0.12),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0)
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Text(buttonLabel,
          style: TextStyle(color: (isMainTab ?? false) && !(isSelected ?? false) ? Theme.of(context).primaryColorDark :
          Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,),
      ),
    );
  }
}