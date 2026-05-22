import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constant/color.dart';
import '../../data_layer/eod_controller.dart';
import '../../data_layer/manager/controller_manager.dart';
import '../../reuseable_widget/buttons.dart';
import '../../reuseable_widget/custom_drop_down/ka_dropdown.dart';
import '../../reuseable_widget/custom_scaffold.dart';
import '../../reuseable_widget/custom_snack_bar.dart';
import '../../reuseable_widget/date_form.dart';
import '../../utils/eod_enum.dart';
import '../../utils/route.dart';

class EODScreen extends ConsumerStatefulWidget {
  final String userID;
  final String baseUrl;
  const EODScreen({Key? key, required this.userID, required this.baseUrl})
      : super(key: key);

  @override
  ConsumerState<EODScreen> createState() => _EODScreenState();
}

class _EODScreenState extends ConsumerState<EODScreen> with EODView {
  EODController? controller;

  @override
  void initState() {
    super.initState();
    HttpRoute.getInstance().setBaseURL(widget.baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    controller = ref.watch(eodController)?..setView(this);
    return CustomScaffold(
      pageState: controller?.pageState,
      appBar: AppBar(
        backgroundColor: EPColors.appMainColor,
        title: const Text("End of Day Report"),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            EPDropdownButton<EODEnum>(
                itemsListTitle: "Select type",
                iconSize: 22,
                value: controller?.eodEnum,
                hint: const Text(""),
                isExpanded: true,
                underline: const Divider(),
                searchMatcher: (item, text) {
                  return item.name.toLowerCase().contains(text.toLowerCase());
                },
                onChanged: (v) {
                  controller?.setEODEnum(v);
                },
                items: EODEnum.values
                    .map(
                      (e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Text(
                                getEODValue(e),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: EPColors.appBlackColor),
                              ),
                              const Spacer(),
                            ],
                          )),
                    )
                    .toList()),
            EPDateForm(
              hintText: "Date",
              onChange: (v) {
                print(v);
                controller?.setSelectedData(v);
              },
            ),
            const Spacer(),
            EPButton(
              onTap: () {
                controller?.validateRegistrationPersonalForm();
              },
              title: "Continue",
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  onError(String message) {
    customSnackBar(context, message: message);
  }

  @override
  onSuccess() {}

  @override
  onFormValidation() {
    if (controller?.eodEnum == EODEnum.fullReport) {
      controller?.fetchFullEOD(widget.userID);
    } else {
      // controller?.fetchSummaryEOD();
    }
  }
}
