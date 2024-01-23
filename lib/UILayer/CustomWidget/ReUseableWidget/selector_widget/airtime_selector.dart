import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/selector_data_model.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/material.dart';

class AirtimeSelector extends StatefulWidget {
  final Function(NetworkSelector value) onSelect;
  const AirtimeSelector({Key? key, required this.onSelect}) : super(key: key);

  @override
  _AirtimeSelectedState createState() => _AirtimeSelectedState();
}

class _AirtimeSelectedState extends State<AirtimeSelector> {
  late int selectedNetwork = 10;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(imageIcon.length,
            (index) => getSelectableWidget(imageIcon[index], index)),
      ),
    );
  }

  List<SelectorDataModel> imageIcon = [
    SelectorDataModel(
        image: EPImages.mtnIcon,
        color: EPColors.mtnColor,
        selector: NetworkSelector.mtn),
    SelectorDataModel(
        image: EPImages.gloIcon,
        color: EPColors.gloColor,
        selector: NetworkSelector.glo),
    SelectorDataModel(
        image: EPImages.airtelIcon,
        color: EPColors.airtelColor,
        selector: NetworkSelector.airtel),
    SelectorDataModel(
        image: EPImages.i9mobileIcon,
        color: EPColors.i9mobile,
        selector: NetworkSelector.n9Mobile),
  ];

  Widget getSelectableWidget(SelectorDataModel value, int index) {
    return InkWell(
      onTap: () {
        widget.onSelect(value.selector!);
        setState(() {
          selectedNetwork = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.width * 0.25,
              // color: Colors.red,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: selectedNetwork == index
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
            selectedNetwork == index
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

    // return InkWell(
    //   onTap: () {
    //     widget.onSelect(value.selector!);
    //     setState(() {
    //       selectedNetwork = index;
    //     });
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.all(4),
    //     child: SizedBox(
    //       child: Container(
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //                 image: AssetImage(
    //                   value.image!,
    //                 ),
    //                 fit: BoxFit.contain),
    //             border: Border.all(
    //                 color: selectedNetwork == index
    //                     ? EPColors.appMainColor
    //                     : EPColors.appGreyColor.withOpacity(0.2),
    //                 width: 6),
    //             color: value.color,
    //             shape: BoxShape.circle),
    //       ),
    //       height: 70,
    //       width: 70,
    //     ),
    //   ),
    // );
  }
}
