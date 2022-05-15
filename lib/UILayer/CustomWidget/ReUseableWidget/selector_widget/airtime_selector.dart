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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(imageIcon.length,
          (index) => getCircleWidget(imageIcon[index], index)),
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

  Widget getCircleWidget(SelectorDataModel value, int index) {
    return InkWell(
      onTap: () {
        widget.onSelect(value.selector!);
        setState(() {
          selectedNetwork = index;
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
                    color: selectedNetwork == index
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
