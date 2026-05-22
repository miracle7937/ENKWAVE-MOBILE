import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/internal_transfer_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/in_app_transfer_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_form_section.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_wallet_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/money_formatter.dart';
import 'inapp_preview_screen.dart';

class TransferInApp extends StatefulWidget {
  const TransferInApp({Key? key}) : super(key: key);

  @override
  _TransferInAppState createState() => _TransferInAppState();
}

class _TransferInAppState extends State<TransferInApp>
    with InternalTransferView {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    phoneNumberController.dispose();
    amountController.dispose();
    transferController?.clearAPP();
    super.dispose();
  }

  InAppTransferController? transferController;
  @override
  Widget build(BuildContext context) {
    return Consumer<InAppTransferController>(
      builder: (context, controller, _) {
        transferController = controller
          ..setView = this
          ..getWallet();

        final scheme = Theme.of(context).colorScheme;
        final wallets = controller.userWallets ?? [];
        final loadingWallets =
            controller.pageState == PageState.loading && wallets.isEmpty;
        final amount = amountController.text.trim();

        return EPScaffold(
          appBar: EPAppBar(
            title: const Text('In-App Transfer'),
          ),
          builder: (_) {
            if (loadingWallets) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                EPColors.appMainDark.withValues(alpha: 0.95),
                                EPColors.appMainColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: EPColors.appMainColor
                                    .withValues(alpha: 0.22),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.send_to_mobile_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Send to ENKPAY users',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Enter the recipient phone number, verify the name, then continue securely.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white
                                                .withValues(alpha: 0.78),
                                            fontSize: 12,
                                            height: 1.35,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        const TransferSectionHeader(
                          step: 1,
                          title: 'Pay from',
                          subtitle: 'Select wallet for this transfer',
                        ),
                        TransferWalletPicker(
                          wallets: wallets,
                          selected: controller.selectedUserWallet,
                          onSelected: (wallet) =>
                              controller.selectWallet = wallet,
                        ),
                        const SizedBox(height: 22),
                        const TransferSectionHeader(
                          step: 2,
                          title: 'Recipient',
                          subtitle: 'Verify the ENKPAY account before sending',
                        ),
                        TransferFormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Phone number',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: context.mutedText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              TransferInputField(
                                controller: phoneNumberController,
                                hintText: 'Recipient phone number',
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                suffix:
                                    controller.pageState == PageState.loading
                                        ? const Padding(
                                            padding: EdgeInsets.all(14),
                                            child: SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.person_search_rounded,
                                            color: context.mutedText,
                                          ),
                                onChanged: (value) {
                                  controller.phoneNumber = value;
                                  controller.verifyUserNumber(value);
                                },
                              ),
                              if (isNotEmpty(controller.searchName)) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: EPColors.appSuccess
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: EPColors.appSuccess
                                          .withValues(alpha: 0.18),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: EPColors.appSuccess
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.verified_rounded,
                                          color: EPColors.appSuccess,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Verified recipient',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: context.mutedText,
                                                    fontSize: 11,
                                                  ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              controller.searchName ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: EPColors.appSuccess,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const TransferSectionHeader(
                          step: 3,
                          title: 'Payment details',
                        ),
                        TransferFormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Amount',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: context.mutedText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              TransferInputField(
                                controller: amountController,
                                hintText: '0',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                                onChanged: (value) {
                                  controller.setAmount = value;
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Description',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: context.mutedText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              TransferInputField(
                                hintText: 'Payment description (optional)',
                                keyboardType: TextInputType.text,
                                onChanged: (value) =>
                                    controller.setDesc = value,
                              ),
                            ],
                          ),
                        ),
                        if (amount.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          TransferSummaryCard(
                            label: 'Amount to send',
                            amount: amountFormatter(amount),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    border: Border(
                      top: BorderSide(color: context.borderColor),
                    ),
                  ),
                  child: EPButton(
                    loading: controller.pageState == PageState.loading,
                    title: 'Continue',
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      controller.validateTransferForm();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
  onPinVerification() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        transferController?.setPin = pin;
        onTransfer();
      } else {
        onError(message);
      }
    });
  }

  @override
  onPreview() async {
    bool? isPop = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const InAppPreviewScreen()));
    if (isPop != null) {
      onPinVerification();
    }
  }

  @override
  onSuccess(String message) {
    showEPStatusDialog(context, success: true, message: message, callback: () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  onTransfer() {
    transferController!.transfer();
  }

  @override
  onFailNumberVerify(String message) {
    snackBar(context, message: message);
  }
}
