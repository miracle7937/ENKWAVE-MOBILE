import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/controllers/transfer_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/bottom_dialog.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/pin_verification_dialog.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_success_sheet.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_form_section.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_ui.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_recipient_widgets.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_wallet_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../CustomWidget/ScaffoldsWidget/page_state.dart';
import '../../utils/loader_widget.dart';
import '../../utils/money_formatter.dart';
import '../../utils/naira_amount_formatter.dart';
import '../../utils/screen_navigation.dart';
import '../../utils/status_screen.dart';

class TransferToOtherBank extends StatefulWidget {
  const TransferToOtherBank({super.key});

  @override
  State<TransferToOtherBank> createState() => _TransferToOtherBankState();
}

class _TransferToOtherBankState extends State<TransferToOtherBank>
    with OnBankTransfer {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  TransferController? _transferController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransferController>(context, listen: false).getLocation();
    });
  }

  @override
  void dispose() {
    _transferController?.disposeAll();
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransferController>(
      builder: (context, controller, _) {
        _transferController = controller
          ..onSetTransferView = this
          ..getListOFBank();

        final loading = controller.pageState == PageState.loading &&
            controller.listOfBank.isEmpty;
        final scheme = Theme.of(context).colorScheme;
        final hasTotal = isNotEmpty(controller.getTotal());

        return EPScaffold(
          appBar: EPAppBar(
            title: const Text('Bank Transfer'),
          ),
          builder: (_) {
            if (loading) {
              return const Center(child: LoaderWidget());
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
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: scheme.primary.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.account_balance_rounded,
                                  color: scheme.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Send to any Nigerian bank instantly',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        height: 1.35,
                                        color: scheme.onSurface
                                            .withValues(alpha: 0.9),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const TransferSectionHeader(
                          step: 1,
                          title: 'Pay from',
                          subtitle: 'Select wallet for this transfer',
                        ),
                        TransferWalletPicker(
                          wallets: controller.userWallet,
                          selected: controller.selectedUserWallet,
                          onSelected: (w) => controller.selectWallet = w,
                        ),
                        const SizedBox(height: 22),
                        TransferSectionHeader(
                          step: 2,
                          title: 'Recipient',
                          subtitle: 'Bank account details',
                          trailing: TextButton(
                            onPressed: () => _pickBeneficiary(controller),
                            style: TextButton.styleFrom(
                              foregroundColor: EPColors.appMainColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  EPImages.beneficiary,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Saved',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TransferFormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Bank',
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
                              BankSelectorField(
                                selectedBank: controller.selectedBank,
                                banks: controller.listOfBank,
                                onSelected: (b) => controller.setBank = b,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Account number',
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TransferInputField(
                                      controller: _accountController,
                                      hintText: '10-digit account',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onChanged: (v) {
                                        controller.selectAccount = v;
                                        if (v.length < 10) {
                                          controller.clearVerifyFeedback();
                                        } else if (v.length == 10) {
                                          controller.bankAccountVerification();
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    height: 48,
                                    width: 88,
                                    child: FilledButton(
                                      onPressed: controller.isVerifyingAccount
                                          ? null
                                          : () => controller
                                              .bankAccountVerification(
                                              showDialogOnError: true,
                                            ),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: EPColors.appMainColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: controller.isVerifyingAccount
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Verify',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              if (isNotEmpty(controller.verifyError) &&
                                  !controller.isVerifyingAccount) ...[
                                const SizedBox(height: 10),
                                Text(
                                  controller.verifyError!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: EPColors.appDanger,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              if (isNotEmpty(controller.accountName)) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: EPColors.appSuccess
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.verified_rounded,
                                        color: EPColors.appSuccess,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          controller.accountName ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: EPColors.appSuccess,
                                            height: 1.25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Save beneficiary',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 12),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      activeTrackColor: EPColors.appMainColor,
                                      value: controller.bankTransferModel
                                              .beneficiary ??
                                          false,
                                      onChanged: (v) =>
                                          controller.setBeneficiary = v,
                                    ),
                                  ),
                                ],
                              ),
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
                                controller: _amountController,
                                hintText: '0',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  NairaAmountInputFormatter(),
                                ],
                                onChanged: (v) => controller.selectAmount = v,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Narration',
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
                                onChanged: (v) => controller.setNarration = v,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Transfer fee: ${amountFormatter(controller.getTransferCharge().toString())}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: context.mutedText,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (hasTotal) ...[
                          const SizedBox(height: 16),
                          TransferSummaryCard(
                            label: 'Total debit',
                            amount: amountFormatter(controller.getTotal()),
                            feeLabel:
                                'Includes ${amountFormatter(controller.getTransferCharge().toString())} fee',
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
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: context.borderColor),
                    ),
                  ),
                  child: EPButton(
                    loading: controller.pageState == PageState.loading &&
                        !controller.isVerifyingAccount,
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

  void _pickBeneficiary(TransferController controller) {
    showBeneficiaryList(context, controller.getBeneficary, (beneficiary) {
      controller.bankTransferModel.bankCode = beneficiary.bankCode;
      controller.bankTransferModel.accountNumber = beneficiary.acctNo;
      controller.setBank = controller.listOfBank.firstWhere(
        (b) => b.bankCbnCode == beneficiary.bankCode,
      );
      _accountController.text = beneficiary.acctNo.toString();
      controller.bankAccountVerification(showDialogOnError: true);
      setState(() {});
    });
  }

  @override
  void onError(String message) {
    showEPStatusDialog(context, success: false, message: message, callback: () {
      Navigator.pop(context);
    });
  }

  @override
  void onSuccess(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatusScreen(title: message, onTap: () {}),
      ),
    );
  }

  @override
  void onTransferPinVerification() {
    showPinDialog(context, onVerification: (status, message, pin) async {
      Navigator.pop(context);
      if (status == true) {
        _transferController?.setPin = pin;
        onTransfer();
      } else {
        onError(message);
      }
    });
  }

  @override
  void onTransferSuccess(String message) {
    final controller = _transferController!;
    showBankTransferSuccessSheet(
      context,
      message: message,
      transfer: controller.bankTransferModel,
      refTransId: controller.lastTransferRefId,
      onDone: () => popToHome(context),
    );
  }

  @override
  void onTransfer() {
    _transferController?.bankTransfer();
  }

  @override
  void onPreview(String message) {}
}
