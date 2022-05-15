import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/selector_data_model.dart';
import 'package:enk_pay_project/UILayer/utils/cable_tv_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CableTVSelector extends StatefulWidget {
  final Function(CableEnum value) onSelect;
  const CableTVSelector({Key? key, required this.onSelect}) : super(key: key);

  @override
  _CableTVSelectorState createState() => _CableTVSelectorState();
}

class _CableTVSelectorState extends State<CableTVSelector> {
  int selectedIndex = 10;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(cableTvDATA.length,
          (index) => getCircleWidget(cableTvDATA[index], index)),
    );
  }

  List<SelectorDataModel> cableTvDATA = [
    SelectorDataModel(
        image: EPImages.dsTv,
        color: EPColors.appWhiteColor,
        selector: CableEnum.dsTv),
    SelectorDataModel(
        image: EPImages.goTV,
        color: EPColors.appWhiteColor,
        selector: CableEnum.goTv),
    SelectorDataModel(
        image: EPImages.starTime,
        color: EPColors.appWhiteColor,
        selector: CableEnum.startTimes),
  ];
  Widget getCircleWidget(SelectorDataModel value, int index) {
    return InkWell(
      onTap: () {
        widget.onSelect(value.selector!);
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      value.image!,
                    ),
                    fit: BoxFit.contain),
                border: Border.all(
                    color: selectedIndex == index
                        ? EPColors.appMainColor
                        : EPColors.appGreyColor.withOpacity(0.2),
                    width: 6),
                color: value.color,
                shape: BoxShape.circle),
          ),
          height: 70,
          width: 70,
        ),
      ),
    );
  }
}
