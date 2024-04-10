import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Constant/colors.dart';

class HistorySelectable extends StatefulWidget {
  final Function(TransactionEnum)? onSelect;
  const HistorySelectable({Key? key, this.onSelect}) : super(key: key);

  @override
  State<HistorySelectable> createState() => _HistorySelectableState();
}

class _HistorySelectableState extends State<HistorySelectable> {
  TransactionEnum? selectedValue;
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: TransactionEnum.values.map((e) => selectableView(e)).toList(),
    );
  }

  Widget selectableView(TransactionEnum value) {
    return InkWell(
      onTap: () {
        widget.onSelect!(value);
        setState(() {
          selectedValue = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
            child: Text(
              getEnumName(value),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: selectedValue == value
                      ? EPColors.appWhiteColor
                      : EPColors.appBlackColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            ),
          )),
          decoration: BoxDecoration(
              color: selectedValue == value
                  ? EPColors.appMainColor
                  : EPColors.appWhiteColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 0.5,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}
