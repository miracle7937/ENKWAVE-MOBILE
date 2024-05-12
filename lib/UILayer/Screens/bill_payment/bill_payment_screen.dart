import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:enk_pay_project/DataLayer/controllers/bill_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/model/bill_categories.dart';
import '../../../DataLayer/model/bill_form_response.dart';
import '../../../DataLayer/model/biller_response.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_drop_down/ka_dropdown.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/ep_button.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/linear_progress_bar.dart';
import '../transfers/widget/pin_verification_dialog.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({Key? key}) : super(key: key);

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen>
    with OnBillPaymentView {
  late BillPaymentController billPaymentController;

  @override
  void dispose() {
    billPaymentController.clearResponse();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    billPaymentController = Provider.of<BillPaymentController>(context)
      ..setView = this
      ..initialize();
    return EPScaffold(
      appBar: EPAppBar(
          title: const Text(
        "Bills Payment",
      )),
      builder: (_) => Column(
        children: [
          EPLinearProgressBar(
            loading: billPaymentController.pageState == PageState.loading,
          ),
          EPDropdownButton<CategoryData>(
              itemsListTitle: "Please select bills categories",
              iconSize: 22,
              value: billPaymentController.selectedCategory,
              hint: const Text(""),
              isExpanded: true,
              underline: const Divider(),
              searchMatcher: (item, text) {
                return item.name!.toLowerCase().contains(text.toLowerCase());
              },
              onChanged: (v) {
                billPaymentController.setSelectedCategory = v;
              },
              items: (billPaymentController.categoryData ?? [])
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: EPColors.appBlackColor)),
                    ),
                  )
                  .toList()),
          (billPaymentController.selectedCategory != null)
              ? EPDropdownButton<Bill>(
                  itemsListTitle: "Please select bills",
                  iconSize: 22,
                  value: billPaymentController.selectedBill,
                  hint: const Text(""),
                  isExpanded: true,
                  underline: const Divider(),
                  searchMatcher: (item, text) {
                    return item.name!
                        .toLowerCase()
                        .contains(text.toLowerCase());
                  },
                  onChanged: (v) {
                    billPaymentController.setSelectedBill = v;
                  },
                  items: (billPaymentController.billResponse.data ?? [])
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: EPColors.appBlackColor)),
                        ),
                      )
                      .toList())
              : Container(),
          Expanded(
              child: BillFormBuilder(
            data: billPaymentController.billFormResponse.data ?? [],
            billPaymentController: billPaymentController,
          )),
          EPButton(
            active: billPaymentController.billPaymentModel.validForm,
            loading: PageState.loading == billPaymentController.pageState,
            title: "Proceed",
            onTap: () {
              print(billPaymentController.billPaymentModel.toJson());
              billPaymentController.searchLook();
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
        ],
      ),
    );
  }

  @override
  onBuyBill() {
    billPaymentController.onBuyBill();
  }

  @override
  onPInVerify() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        onBuyBill();
      } else {
        onError(message);
      }
    });
  }

  @override
  onError(String message) {
    if (mounted) {
      showEPStatusDialog(context, success: false, message: message,
          callback: () {
        Navigator.pop(context);
      });
    }
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  onBillValidate(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.LEFTSLIDE,
      title: 'VALIDATION',
      desc: message,
      descTextStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      btnOkColor: EPColors.appMainColor,
      btnOkOnPress: () {
        onPInVerify();
      },
    ).show();
  }
}

class BillFormBuilder extends StatelessWidget {
  const BillFormBuilder(
      {Key? key, required this.data, required this.billPaymentController})
      : super(key: key);
  final List<FormData> data;
  final BillPaymentController billPaymentController;
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container();
    }
    return ListView.builder(
        itemCount: data.length ?? 0,
        itemBuilder: (_, index) {
          if ((data[index].items == null)) {
            return EPForm(
              inputFormatters: [
                if (["customerPhone", "amount"].contains(data[index].fieldName))
                  FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: data[index].fieldDescription,
              enabledBorderColor: EPColors.appGreyColor,
              keyboardType: TextInputType.phone,
              onChange: (v) {
                billPaymentController.setDynamicData(data[index].fieldName!, v);
              },
            );
          }
          return EPDropdownButton<Items>(
              itemsListTitle: data[index].fieldDescription,
              iconSize: 22,
              hint: const Text(""),
              isExpanded: true,
              underline: const Divider(),
              value:
                  billPaymentController.getDynamicData(data[index].fieldName!),
              searchMatcher: (item, text) {
                return item.itemName!
                    .toLowerCase()
                    .contains(text.toLowerCase());
              },
              onChanged: (v) {
                billPaymentController.setDynamicItem(data[index].fieldName!, v);
              },
              items: (data[index].items ?? [])
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.itemName.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: EPColors.appBlackColor)),
                    ),
                  )
                  .toList());
        });
  }
}
