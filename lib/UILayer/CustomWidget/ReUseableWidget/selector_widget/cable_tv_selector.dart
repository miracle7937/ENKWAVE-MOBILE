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
          (index) => getSelectableWidget(cableTvDATA[index], index)),
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
    SelectorDataModel(
        image: EPImages.showMax,
        color: EPColors.appWhiteColor,
        selector: CableEnum.showMax),
  ];

  Widget getSelectableWidget(SelectorDataModel value, int index) {
    return InkWell(
      onTap: () {
        widget.onSelect(value.selector!);
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.21,
              height: MediaQuery.of(context).size.width * 0.25,
              // color: Colors.red,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: selectedIndex == index
                        ? Border.all(width: 2, color: EPColors.appMainColor)
                        : Border.all(width: 2, color: EPColors.appGreyColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              value.image!,
                            ),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: MediaQuery.of(context).size.width * 0.14,
                      height: MediaQuery.of(context).size.width * 0.14,
                    ),
                  ),
                ),
              ),
            ),
            selectedIndex == index
                ? Positioned(
                    top: 8,
                    right: 1,
                    child: Image.asset(EPImages.selectableIcon),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
