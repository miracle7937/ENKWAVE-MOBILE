import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/selector_widget/selector_data_model.dart';
import 'package:enk_pay_project/UILayer/utils/cable_tv_enum.dart';
import 'package:flutter/material.dart';

class CableTVSelector extends StatefulWidget {
  final Function(CableEnum value) onSelect;
  final CableEnum? initialSelection;

  const CableTVSelector({
    super.key,
    required this.onSelect,
    this.initialSelection,
  });

  @override
  State<CableTVSelector> createState() => _CableTVSelectorState();
}

class _CableTVSelectorState extends State<CableTVSelector> {
  int selectedIndex = -1;

  static final List<SelectorDataModel> _providers = [
    SelectorDataModel(
      image: EPImages.dsTv,
      color: EPColors.dsTv,
      selector: CableEnum.dsTv,
    ),
    SelectorDataModel(
      image: EPImages.goTV,
      color: EPColors.appMainColor,
      selector: CableEnum.goTv,
    ),
    SelectorDataModel(
      image: EPImages.starTime,
      color: EPColors.appWarning,
      selector: CableEnum.startTimes,
    ),
    SelectorDataModel(
      image: EPImages.showMax,
      color: EPColors.appMainDark,
      selector: CableEnum.showMax,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      selectedIndex = _providers.indexWhere(
        (p) => p.selector == widget.initialSelection,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(_providers.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 4,
                right: index == _providers.length - 1 ? 0 : 4,
              ),
              child: _CableTile(
                model: _providers[index],
                selected: selectedIndex == index,
                onTap: () {
                  widget.onSelect(_providers[index].selector!);
                  setState(() => selectedIndex = index);
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CableTile extends StatelessWidget {
  final SelectorDataModel model;
  final bool selected;
  final VoidCallback onTap;

  const _CableTile({
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
          aspectRatio: 0.85,
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
                  color: (model.color ?? EPColors.appMainColor)
                      .withValues(alpha: context.isDarkMode ? 0.18 : 0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(model.image!, fit: BoxFit.contain),
                ),
              ),
              if (selected)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: context.cardFill,
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
