import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/selector_data_model.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:flutter/material.dart';

class AirtimeSelector extends StatefulWidget {
  final Function(NetworkSelector value) onSelect;

  const AirtimeSelector({super.key, required this.onSelect});

  @override
  State<AirtimeSelector> createState() => _AirtimeSelectedState();
}

class _AirtimeSelectedState extends State<AirtimeSelector> {
  int selectedNetwork = -1;

  static final List<SelectorDataModel> _networks = [
    SelectorDataModel(
      image: EPImages.mtnIcon,
      color: EPColors.mtnColor,
      selector: NetworkSelector.mtn,
    ),
    SelectorDataModel(
      image: EPImages.gloIcon,
      color: EPColors.gloColor,
      selector: NetworkSelector.glo,
    ),
    SelectorDataModel(
      image: EPImages.airtelIcon,
      color: EPColors.airtelColor,
      selector: NetworkSelector.airtel,
    ),
    SelectorDataModel(
      image: EPImages.i9mobileIcon,
      color: EPColors.i9mobile,
      selector: NetworkSelector.n9Mobile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(_networks.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 4,
                right: index == _networks.length - 1 ? 0 : 4,
              ),
              child: _NetworkTile(
                model: _networks[index],
                selected: selectedNetwork == index,
                onTap: () {
                  widget.onSelect(_networks[index].selector!);
                  setState(() => selectedNetwork = index);
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NetworkTile extends StatelessWidget {
  final SelectorDataModel model;
  final bool selected;
  final VoidCallback onTap;

  const _NetworkTile({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 0.9,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: selected ? 2 : 1,
                    color: selected
                        ? EPColors.appMainColor
                        : context.borderColor,
                  ),
                  color: model.color?.withValues(alpha: 0.12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    model.image!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              if (selected)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: EPColors.appMainColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
